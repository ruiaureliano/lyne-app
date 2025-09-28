import Cocoa

extension GuideWindow {

	func handle(event: NSEvent) {
		guard let guideWindowView = self.contentView as? GuideWindowView else { return }
		let mouseInWindow = convertPoint(fromScreen: NSEvent.mouseLocation)
		if event.type == .mouseMoved {
			handleMouseMoved(event: event, guideWindowView: guideWindowView, mouseInWindow: mouseInWindow)
		} else if event.type == .leftMouseDown {
			handleLeftMouseDown(event: event, guideWindowView: guideWindowView, mouseInWindow: mouseInWindow)
		} else if event.type == .leftMouseUp {
			handleLeftMouseUp(event: event, guideWindowView: guideWindowView, mouseInWindow: mouseInWindow)
		} else if event.type == .leftMouseDragged {
			handleLeftMouseDragged(event: event, guideWindowView: guideWindowView, mouseInWindow: mouseInWindow)
		} else if event.type == .rightMouseDown {
			handleRightMouseDown(event: event, guideWindowView: guideWindowView, mouseInWindow: mouseInWindow)
		} else if event.type == .rightMouseUp {
			handleRightMouseUp(event: event, guideWindowView: guideWindowView, mouseInWindow: mouseInWindow)
		} else if event.type == .keyDown {
			handleKeyDown(event: event, guideWindowView: guideWindowView, mouseInWindow: mouseInWindow)
		} else if event.type == .keyUp {
			handleKeyUp(event: event, guideWindowView: guideWindowView, mouseInWindow: mouseInWindow)
		}
	}
}

extension GuideWindow {

	private func handleMouseMoved(event: NSEvent, guideWindowView: GuideWindowView, mouseInWindow: CGPoint) {
		if StatusBarRectangle.resizing {
			guideWindowView.selectedCrossHandler = nil
			(NSApp.delegate as? AppDelegate)?.setGuidesAcceptMouse(accept: true)
			NSCursor.cursorRectangle().set()
		} else if let crossHandler = guideWindowView.crossHandlerContains(point: mouseInWindow) {
			(NSApp.delegate as? AppDelegate)?.setGuidesAcceptMouse(accept: true)
			guideWindowView.selectedCrossHandler = crossHandler
			updateGuideView()
		} else {
			guideWindowView.selectedCrossHandler = nil
			let lines = Guide.shared.lines(screenIndex: screenIndex)
			if let guideHandler = guideWindowView.guideHandlerContains(point: mouseInWindow) {
				_ = lines.map { $0.hover = ($0.id == guideHandler.line.id) }
				self.acceptMouse(accept: true)
			} else {
				_ = lines.map { $0.hover = false }
				self.acceptMouse(accept: false)
			}

			isDynamicLeft = true
			isDynamicTop = true
			let mouseLocation = NSEvent.mouseLocation
			if let screen = screen, screen.frame.contains(mouseLocation) {
				isDynamicLeft = (mouseLocation.x < screen.frame.origin.x + screen.frame.width / 2)
				isDynamicTop = (mouseLocation.y > screen.frame.origin.y + screen.frame.height / 2)
			}
			updateGuideView()
		}
	}

	private func handleLeftMouseDown(event: NSEvent, guideWindowView: GuideWindowView, mouseInWindow: CGPoint) {
		if StatusBarRectangle.resizing {
			StatusBarRectangle.startPoint = NSEvent.mouseLocation
		} else {
			let guideHandler = guideWindowView.guideHandlerContains(point: mouseInWindow)
			guideWindowView.selectedGuideHandler = guideHandler
		}
		updateGuideView()
	}

	private func handleLeftMouseUp(event: NSEvent, guideWindowView: GuideWindowView, mouseInWindow: CGPoint) {
		let guideHandler = guideWindowView.guideHandlerContains(point: mouseInWindow)
		if !isDragging {
			let lines = Guide.shared.lines(screenIndex: screenIndex)
			if let guideHandler = guideHandler {
				if event.modifierFlags.isCommand {
					guideHandler.line.selected.toggle()
				} else if event.modifierFlags.isShift {
					_ = Guide.shared.lines(screenIndex: screenIndex).filter { $0.orientation != guideHandler.line.orientation }.map { $0.selected = false }
					var selectedLines = Guide.shared.lines(screenIndex: screenIndex).filter { $0.selected && $0.orientation == guideHandler.line.orientation }

					if selectedLines.count == 1 {
						isShiftReversed = selectedLines[0].position > guideHandler.line.position
					}
					guideHandler.line.selected = true
					selectedLines = Guide.shared.lines(screenIndex: screenIndex).filter { $0.selected && $0.orientation == guideHandler.line.orientation }

					if var min = selectedLines.map({ $0.position }).min(), var max = selectedLines.map({ $0.position }).max() {
						let orientationLines = Guide.shared.lines(screenIndex: screenIndex).filter { $0.orientation == guideHandler.line.orientation }
						if isShiftReversed {
							if min < guideHandler.line.position {
								min = guideHandler.line.position
							}
							for line in orientationLines {
								line.selected = line.position >= min && line.position <= max
							}
						} else {
							if max > guideHandler.line.position {
								max = guideHandler.line.position
							}
							for line in orientationLines {
								line.selected = line.position >= min && line.position <= max
							}
						}
					}
				} else {
					for line in lines where line.id != guideHandler.line.id {
						line.selected = false
					}
					guideHandler.line.selected = true
				}
				let link = guideHandler.line.link
				_ = Guide.shared.lines(screenIndex: screenIndex).filter { $0.link == link && link != "" }.map { $0.selected = guideHandler.line.selected }
			} else {
				_ = lines.map { $0.selected = false }
			}
		}

		isDragging = false
		dragCount = 0
		isDuplicated = false

		let selectedLines = Guide.shared.lines(screenIndex: screenIndex).filter { $0.selected }
		_ = Guide.shared.lines(screenIndex: screenIndex).map { $0.deleteOutOfBounds(guideHandler: guideWindowView.selectedGuideHandler, selectedLines: selectedLines) }
		if selectedLines.count == 0 {
			isShiftReversed = false
		}

		if StatusBarRectangle.resizing {
			if let startPoint = StatusBarRectangle.startPoint, let endPoint = StatusBarRectangle.endPoint {
				_ = Guide.shared.addRectangle(startPoint: startPoint, endPoint: endPoint, verticalGuides: StatusBarRectangle.verticalGuides, horzontalGuideGuides: StatusBarRectangle.horzontalGuideGuides, screenIndex: screenIndex)
			}
		}
		StatusBarRectangle.reset()
		Guide.shared.save()
		updateGuideView()
		guideWindowView.selectedGuideHandler = nil
		guideWindowView.selectedCrossHandler = nil
		NSCursor.cursorStandard().set()
	}

	private func handleLeftMouseDragged(event: NSEvent, guideWindowView: GuideWindowView, mouseInWindow: CGPoint) {
		if StatusBarRectangle.resizing {
			StatusBarRectangle.endPoint = NSEvent.mouseLocation
			updateGuideView()
		} else if let selectedCrossHandler = guideWindowView.selectedCrossHandler {
			var crossLines = [selectedCrossHandler.hLine, selectedCrossHandler.vLine]
			let hLineLink = selectedCrossHandler.hLine.link
			let vLineLink = selectedCrossHandler.vLine.link
			// let deltaX = selectedCrossHandler.vLine.position - Int(NSEvent.mouseLocation.x)
			// let deltaY = selectedCrossHandler.hLine.position - Int(NSEvent.mouseLocation.y)
			for line in Guide.shared.lines(screenIndex: screenIndex).filter({ ($0.link == hLineLink && hLineLink != "") || ($0.link == vLineLink && vLineLink != "") }) where !crossLines.contains(line) {
				crossLines.append(line)
			}
			_ = Guide.shared.lines(screenIndex: screenIndex).map { $0.selected = crossLines.contains($0) }
			for line in crossLines {
				switch line.orientation {
				case .horizontal:
					/*if line == selectedCrossHandler.hLine {
						line.position = Int(NSEvent.mouseLocation.y)
					} else {
						line.position -= deltaY
					}*/
					line.position -= Int(event.deltaY)
					isDragging = true
				case .vertical:
					/*
					if line == selectedCrossHandler.vLine {
						line.position = Int(NSEvent.mouseLocation.x)
					} else {
						line.position -= deltaX
					}*/
					line.position += Int(event.deltaX)
					isDragging = true
				}
			}
			updateGuideView()
			dragCount += 1
		} else {
			let guideHandler = guideWindowView.selectedGuideHandler
			if let guideHandler = guideHandler {
				if !guideHandler.line.selected {
					_ = Guide.shared.lines(screenIndex: screenIndex).filter { $0 != guideHandler.line }.map { $0.selected = false }
					guideHandler.line.selected = true
				}
				let link = guideHandler.line.link
				_ = Guide.shared.lines(screenIndex: screenIndex).filter { $0.link == link && link != "" }.map { $0.selected = guideHandler.line.selected }

				if event.modifierFlags.isOption && !isDuplicated {
					Guide.shared.lines.insert(guideHandler.line.clone, at: 0)
					isDuplicated = true
				}
			}

			// if let guideHandler = guideHandler {
			// let deltaX = guideHandler.line.position - Int(NSEvent.mouseLocation.x)
			// let deltaY = guideHandler.line.position - Int(NSEvent.mouseLocation.y)
			let selectedLines = Guide.shared.lines(screenIndex: screenIndex).filter { $0.selected }
			for line in selectedLines {
				switch line.orientation {
				case .horizontal:
					/*
					if line == guideHandler.line {
						line.position = Int(NSEvent.mouseLocation.y)
					} else {
						line.position -= deltaY
					}*/
					line.position -= Int(event.deltaY)
					isDragging = true
				case .vertical:
					/*
					if line == guideHandler.line {
						line.position = Int(NSEvent.mouseLocation.x)
					} else {
						line.position -= deltaX
					}*/
					line.position += Int(event.deltaX)
					isDragging = true
				}
			}
			updateGuideView()
			dragCount += 1
			// }
		}
	}

	private func handleRightMouseDown(event: NSEvent, guideWindowView: GuideWindowView, mouseInWindow: CGPoint) {
		updateGuideView()
	}
	private func handleRightMouseUp(event: NSEvent, guideWindowView: GuideWindowView, mouseInWindow: CGPoint) {
		if let guideHandler = guideWindowView.guideHandlerContains(point: mouseInWindow) {
			guideHandler.line.selected = true
			let link = guideHandler.line.link
			_ = Guide.shared.lines(screenIndex: screenIndex).filter { $0.link == link && link != "" }.map { $0.selected = guideHandler.line.selected }

			updateGuideView()

			let menu = NSMenu()
			menu.delegate = self
			menu.popUp(positioning: nil, at: NSPoint(x: guideHandler.frame.origin.x + 23, y: guideHandler.frame.origin.y + 16), in: self.contentView)
		}
	}

	private func handleKeyDown(event: NSEvent, guideWindowView: GuideWindowView, mouseInWindow: CGPoint) {
		if StatusBarRectangle.resizing, let key = HotKeyCode(rawValue: Int(event.keyCode)) {
			switch key {
			case .a:
				break
			case .d:
				break
			case .l:
				break
			case .r:
				break
			case .backspace:
				break
			case .left:
				if NSScreen.screen(at: screenIndex) == NSScreen.screenMouse && StatusBarRectangle.verticalGuides > 2 {
					StatusBarRectangle.verticalGuides -= 1
				}
			case .right:
				if NSScreen.screen(at: screenIndex) == NSScreen.screenMouse {
					StatusBarRectangle.verticalGuides += 1
				}
			case .down:
				if NSScreen.screen(at: screenIndex) == NSScreen.screenMouse && StatusBarRectangle.horzontalGuideGuides > 2 {
					StatusBarRectangle.horzontalGuideGuides -= 1
				}
			case .up:
				if NSScreen.screen(at: screenIndex) == NSScreen.screenMouse {
					StatusBarRectangle.horzontalGuideGuides += 1
				}
			case .esc:
				if NSScreen.screen(at: screenIndex) == NSScreen.screenMouse {
					StatusBarButton.reset()
					StatusBarRectangle.reset()
					NSCursor.cursorStandard().set()
					(NSApp.delegate as? AppDelegate)?.setGuidesAcceptMouse(accept: false)
				}
			}
			NotificationCenter.notify(name: .guideLinesDidChanged)
		} else if StatusBarButton.dragCount < kDragCountTolerance {
			let lines = Guide.shared.lines(screenIndex: screenIndex).filter { $0.selected }
			let hLines = lines.filter { $0.orientation == .horizontal }
			let vLines = lines.filter { $0.orientation == .vertical }
			let guideHandler = guideWindowView.guideHandlerContains(point: mouseInWindow)

			if let key = HotKeyCode(rawValue: Int(event.keyCode)), lines.count > 0 {
				LyneAnalytics.trackEvent(name: .shortcut, with: ["identifier": "\(key)", "shortcut": HotKeyCodeMap.shortcutSymbol(flags: event.modifierFlags, code: Int(event.keyCode)), "operation": "press"])
				switch key {
				case .a:
					if event.modifierFlags.isCommand {
						selectLines(lines: Guide.shared.lines(screenIndex: screenIndex))
					}
				case .d:
					if lines.count > 0 && event.modifierFlags.isShift {
						duplicateSelectedLines(lines: lines)
					} else if hLines.count > 2 || vLines.count > 2 {
						distributeSelectedLines(hLines: hLines, vLines: vLines)
					}
				case .l:
					let links = Set(lines.map { $0.link })
					if lines.count > 1 && (links.count > 1 || links.count == 1 && links.contains("")) {
						linkSelectedLines(lines: lines)
					} else if event.modifierFlags.isShift && !(links.count == 1 && links.contains("")) {
						unlinkSelectedLines(lines: lines, selected: guideHandler?.line)
					}
				case .r:
					if lines.count == 1 {
						rotateSelectedLines(lines: lines)
					}
				case .backspace:
					deleteSelectedLines(lines: lines)
				case .left:
					for line in lines where line.orientation == .vertical {
						line.position -= event.modifierFlags.isShift ? 10 : 1
						line.deleteOutOfBounds(guideHandler: guideHandler, selectedLines: lines)
					}
				case .right:
					for line in lines where line.orientation == .vertical {
						line.position += event.modifierFlags.isShift ? 10 : 1
						line.deleteOutOfBounds(guideHandler: guideHandler, selectedLines: lines)
					}
				case .down:
					for line in lines where line.orientation == .horizontal {
						line.position -= event.modifierFlags.isShift ? 10 : 1
						line.deleteOutOfBounds(guideHandler: guideHandler, selectedLines: lines)
					}
				case .up:
					for line in lines where line.orientation == .horizontal {
						line.position += event.modifierFlags.isShift ? 10 : 1
						line.deleteOutOfBounds(guideHandler: guideHandler, selectedLines: lines)
					}
				case .esc:
					break
				}
			}
			Guide.shared.save()
		}
	}

	private func handleKeyUp(event: NSEvent, guideWindowView: GuideWindowView, mouseInWindow: CGPoint) {
		Guide.shared.save()
		updateGuideView()
	}
}
