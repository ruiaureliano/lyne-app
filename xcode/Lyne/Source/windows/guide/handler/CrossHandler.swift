import Foundation

class CrossHandler: NSObject {

	var hLine: Line
	var vLine: Line
	var frame: NSRect

	init(hLine: Line, vLine: Line, frame: NSRect) {
		self.hLine = hLine
		self.vLine = vLine
		self.frame = frame
	}

	var id: String {
		return String.uuid(with: hLine.id + vLine.id)
	}
}
