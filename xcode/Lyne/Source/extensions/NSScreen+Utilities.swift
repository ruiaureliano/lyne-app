import Cocoa

extension NSScreen {

	static var screenMouse: NSScreen? {
		for screen in NSScreen.screens where NSMouseInRect(NSEvent.mouseLocation, screen.frame, false) {
			return screen
		}
		return nil
	}

	var screenIndex: Int {
		return NSScreen.screens.firstIndex(of: self) ?? 0
	}

	static func screen(at index: Int) -> NSScreen? {
		if index < NSScreen.screens.count {
			return NSScreen.screens[index]
		}
		return nil
	}
}
