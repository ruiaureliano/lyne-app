import Cocoa

extension GuideWindow {

	func selectLines(lines: [Line]) {
		if lines.count > 0 {
			for line in lines {
				line.selected = true
			}
			NotificationCenter.notify(name: .guideLinesDidChanged)
		}
	}

	func deleteSelectedLines(lines: [Line]) {
		if lines.count > 0 {
			if Guide.shared.deleteLines(lines: lines) {
				NotificationCenter.notify(name: .guideLinesDidChanged)
			}
		}
	}

	func rotateSelectedLines(lines: [Line]) {
		if let screen = NSScreen.screenMouse {
			if lines.count > 0 {
				for line in lines {
					switch line.orientation {
					case .horizontal:
						line.orientation = .vertical
						line.position = Int(NSEvent.mouseLocation.x - screen.frame.origin.x)
					case .vertical:
						line.orientation = .horizontal
						line.position = Int(NSEvent.mouseLocation.y - screen.frame.origin.y)
					}
				}
				if isDragging {
					let hSelectedLines = lines.filter { $0.orientation == .horizontal && $0.selected }
					let vSelectedLines = lines.filter { $0.orientation == .vertical && $0.selected }
					if hSelectedLines.count > 0 || vSelectedLines.count > 0 {
						if hSelectedLines.count > 0 && vSelectedLines.count == 0 {
							NSCursor.cursorHorizontal().set()
						} else if hSelectedLines.count == 0 && vSelectedLines.count > 0 {
							NSCursor.cursorVertical().set()
						} else {
							NSCursor.cursorMultiple().set()
						}
					}
				}
				NotificationCenter.notify(name: .guideLinesDidChanged)
			}
		}
	}

	func linkSelectedLines(lines: [Line]) {
		if lines.count > 0 {
			let link = String.uuid
			for line in lines {
				line.link = link
				line.selected = false
			}
			Guide.shared.save()
			NotificationCenter.notify(name: .guideLinesDidChanged)
		}
	}

	func unlinkSelectedLines(lines: [Line], selected: Line?) {
		if lines.count > 0 {
			for line in lines {
				line.link = ""
				if line != selected {
					line.selected = false
				}
			}
			Guide.shared.save()
			NotificationCenter.notify(name: .guideLinesDidChanged)
		}
	}

	func distributeSelectedLines(hLines: [Line], vLines: [Line]) {
		distributeSelectedHLines(hLines: hLines)
		distributeSelectedVLines(vLines: vLines)
		Guide.shared.save()
		NotificationCenter.notify(name: .guideLinesDidChanged)
	}

	private func distributeSelectedHLines(hLines: [Line]) {
		if hLines.count > 2 {
			var groups: [String: (Int, Int)] = [:]
			if let hMin = hLines.map({ $0.position }).min(), let hMax = hLines.map({ $0.position }).max() {
				let uniqueLinks = Set(hLines.map { $0.link }.filter { $0.count > 0 })
				for uniqueLink in uniqueLinks {
					let linked = hLines.filter { $0.link == uniqueLink }
					if linked.count > 1, let linkedMin = linked.map({ $0.position }).min(), let linkedMax = linked.map({ $0.position }).max() {
						groups[uniqueLink] = (linkedMin, linkedMax)
					}
				}
				let notlinked = hLines.filter { $0.link == "" }
				var totalGroupSpace: Int = 0
				for (_, h) in groups {
					totalGroupSpace += (h.1 - h.0)
				}
				let totalEmptySpace: Int = hMax - hMin - totalGroupSpace
				let spaces = notlinked.count + uniqueLinks.count - 1
				if spaces > 1 {
					let spaceValue = totalEmptySpace / spaces
					var position = hMin
					var linkProcessed: [String] = []
					for line in hLines {
						if line.link.count > 1 {
							if !linkProcessed.contains(line.link) {
								let linkedHLines = hLines.filter { $0.link == line.link }
								if let group = groups[line.link] {
									let spc = (group.1 - group.0)
									let shift = position - (linkedHLines.first?.position ?? 0)
									for linkedHLine in linkedHLines {
										linkedHLine.position += shift
										linkedHLine.deleteOutOfBounds(guideHandler: nil, selectedLines: nil)
									}
									position += (spc + spaceValue)
								}
								linkProcessed.append(line.link)
							}
						} else {
							line.position = position
							line.deleteOutOfBounds(guideHandler: nil, selectedLines: nil)
							position += spaceValue
						}
					}
				}
			}
		}
	}

	private func distributeSelectedVLines(vLines: [Line]) {
		if vLines.count > 2 {
			var groups: [String: (Int, Int)] = [:]
			if let vMin = vLines.map({ $0.position }).min(), let vMax = vLines.map({ $0.position }).max() {
				let uniqueLinks = Set(vLines.map { $0.link }.filter { $0.count > 0 })
				for uniqueLink in uniqueLinks {
					let linked = vLines.filter { $0.link == uniqueLink }
					if linked.count > 1, let linkedMin = linked.map({ $0.position }).min(), let linkedMax = linked.map({ $0.position }).max() {
						groups[uniqueLink] = (linkedMin, linkedMax)
					}
				}
				let notlinked = vLines.filter { $0.link == "" }
				var totalGroupSpace: Int = 0
				for (_, v) in groups {
					totalGroupSpace += (v.1 - v.0)
				}
				let totalEmptySpace: Int = vMax - vMin - totalGroupSpace
				let spaces = notlinked.count + uniqueLinks.count - 1
				if spaces > 1 {
					let spaceValue = totalEmptySpace / spaces
					var position = vMin
					var linkProcessed: [String] = []
					for line in vLines {
						if line.link.count > 1 {
							if !linkProcessed.contains(line.link) {
								let linkedVLines = vLines.filter { $0.link == line.link }
								if let group = groups[line.link] {
									let spc = (group.1 - group.0)
									let shift = position - (linkedVLines.first?.position ?? 0)
									for linkedVLine in linkedVLines {
										linkedVLine.position += shift
										linkedVLine.deleteOutOfBounds(guideHandler: nil, selectedLines: nil)
									}
									position += (spc + spaceValue)
								}
								linkProcessed.append(line.link)
							}
						} else {
							line.position = position
							line.deleteOutOfBounds(guideHandler: nil, selectedLines: nil)
							position += spaceValue
						}
					}
				}
			}
		}
	}

	func duplicateSelectedLines(lines: [Line]) {
		if lines.count > 0 {
			for line in lines {
				let clone = line.clone
				if line.link.count > 0 {
					let link = String.uuid(with: line.link)
					clone.link = link
				}
				clone.position += kGuideLineThickSize
				Guide.shared.addLine(position: clone.position, orientation: clone.orientation, screenIndex: clone.screenIndex, link: clone.link)
			}
			Guide.shared.save()
			NotificationCenter.notify(name: .guideLinesDidChanged)
		}
	}

	func moveToScreenSelectedLines(lines: [Line], to index: Int) {
		if lines.count > 0 {
			for line in lines {
				line.link = ""
				line.screenIndex = index
			}
			Guide.shared.save()
			NotificationCenter.notify(name: .guideLinesDidChanged)
		}
	}

	func moveToLayoutSelectedLines(lines: [Line], to layout: String) {
		if lines.count > 0 {
			for line in lines {
				line.link = ""
				line.layout = layout
			}
			Guide.shared.save()
			NotificationCenter.notify(name: .guideLinesDidChanged)
		}
	}
}
