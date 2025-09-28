import Cocoa

extension NSCursor {

	static func cursorStandard(fileID: String = #fileID, line: Int = #line, function: String = #function) -> NSCursor {
		return NSCursor.arrow
	}

	static func cursorHorizontal(fileID: String = #fileID, line: Int = #line, function: String = #function) -> NSCursor {
		let image = NSImage.cursorHorizontal

		return NSCursor(image: image, hotSpot: NSPoint(x: 10, y: 9))
	}

	static func cursorVertical(fileID: String = #fileID, line: Int = #line, function: String = #function) -> NSCursor {
		let image = NSImage.cursorVertical
		return NSCursor(image: image, hotSpot: NSPoint(x: 10, y: 9))
	}

	static func cursorRectangle(fileID: String = #fileID, line: Int = #line, function: String = #function) -> NSCursor {
		let image = NSImage.cursorRectangle
		return NSCursor(image: image, hotSpot: NSPoint(x: 9.5, y: 8.5))
	}

	static func cursorMultiple(fileID: String = #fileID, line: Int = #line, function: String = #function) -> NSCursor {
		let image = NSImage.cursorMultiple
		return NSCursor(image: image, hotSpot: NSPoint(x: 9, y: 9))
	}

	static func cursorCross(fileID: String = #fileID, line: Int = #line, function: String = #function) -> NSCursor {
		let image = NSImage.cursorCross
		return NSCursor(image: image, hotSpot: NSPoint(x: 12, y: 11))
	}

	static func cursorDeleteLeft(fileID: String = #fileID, line: Int = #line, function: String = #function) -> NSCursor {
		let image = NSImage.cursorDelete
		return NSCursor(image: image, hotSpot: NSPoint(x: 19, y: 9))
	}

	static func cursorDeleteTop(fileID: String = #fileID, line: Int = #line, function: String = #function) -> NSCursor {
		let image = NSImage.cursorDelete
		return NSCursor(image: image, hotSpot: NSPoint(x: 9, y: 19))
	}

	static func cursorDeleteRight(fileID: String = #fileID, line: Int = #line, function: String = #function) -> NSCursor {
		let image = NSImage.cursorDelete
		return NSCursor(image: image, hotSpot: NSPoint(x: 1, y: 9))
	}

	static func cursorDeleteBottom(fileID: String = #fileID, line: Int = #line, function: String = #function) -> NSCursor {
		let image = NSImage.cursorDelete
		return NSCursor(image: image, hotSpot: NSPoint(x: 9, y: 1))
	}
}
