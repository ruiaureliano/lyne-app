import Cocoa

let kGuideLineThickSize: Int = 100

extension Guide {

	@discardableResult func addLine(position: Int? = nil, orientation: LineOrientation = .horizontal, screenIndex: Int = 0, link: String = "", layout: String = kLineDefaultLayout) -> Bool {
		if let screen = NSScreen.screenMouse {
			switch orientation {
			case .horizontal:
				var value = Int(screen.frame.height / 2)
				if let position = position {
					value = position
				}
				let ticks = lines(orientation: .horizontal).map { $0.position }
				while ticks.contains(value) {
					value += kGuideLineThickSize
				}
				self.lines.append(Line(orientation: orientation, position: value, screenIndex: screenIndex, layout: layout))
			case .vertical:
				var value = Int(screen.frame.width / 2)
				if let position = position {
					value = position
				}
				let ticks = lines(orientation: .vertical).map { $0.position }
				while ticks.contains(value) {
					value += kGuideLineThickSize
				}
				self.lines.append(Line(orientation: orientation, position: value, screenIndex: screenIndex, layout: layout))
			}
		}
		self.save()
		return true
	}

	@discardableResult func addRectangle(startPoint: CGPoint, endPoint: CGPoint, verticalGuides: Int, horzontalGuideGuides: Int, screenIndex: Int = 0) -> Bool {
		var result: Bool = false
		let verticalGuides = StatusBarRectangle.verticalGuides
		let horzontalGuideGuides = StatusBarRectangle.horzontalGuideGuides

		let minX = Int(min(startPoint.x, endPoint.x))
		let maxX = Int(max(startPoint.x, endPoint.x))
		let deltaX = abs(maxX - minX) / (verticalGuides - 1)

		let minY = Int(min(startPoint.y, endPoint.y))
		let maxY = Int(max(startPoint.y, endPoint.y))
		let deltaY = abs(maxY - minY) / (horzontalGuideGuides - 1)

		var x = minX
		for _ in 0...verticalGuides - 1 where addLine(position: x, orientation: .vertical, screenIndex: screenIndex) {
			result = true
			x += deltaX
		}
		var y = minY
		for _ in 0...horzontalGuideGuides - 1 where addLine(position: y, orientation: .horizontal, screenIndex: screenIndex) {
			result = true
			y += deltaY
		}
		return result
	}

	@discardableResult func deleteLines(lines: [Line]) -> Bool {
		var result: Bool = false
		for line in lines where self.lines.map({ $0.id }).contains(line.id) {
			self.lines.removeAll { $0.id == line.id }
			result = true
		}
		self.save()
		return result
	}

	@discardableResult func deleteLines(for screenIndex: Int = 0) -> Bool {
		self.lines.removeAll { $0.screenIndex == screenIndex }
		self.save()
		return true
	}
}
