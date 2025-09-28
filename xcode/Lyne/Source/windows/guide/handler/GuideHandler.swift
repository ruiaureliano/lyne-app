import Foundation

class GuideHandler: NSObject {

	var line: Line
	var frame: NSRect

	init(line: Line, frame: NSRect) {
		self.line = line
		self.frame = frame
	}

	var id: String {
		return line.id
	}
}

extension GuideHandler {

	var backgroundAlpha: CGFloat {
		return line.hover || line.selected ? 1.0 : 0.8
	}
}
