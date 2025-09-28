import Cocoa

extension NSWindow.Level {
	static let gridLevel = NSWindow.Level(NSWindow.Level.screenSaver.rawValue)
	static let magnifierLevel = NSWindow.Level(NSWindow.Level.screenSaver.rawValue + 1)
	static let preferencesLevel = NSWindow.Level(NSWindow.Level.normal.rawValue)
	static let tooltipLevel = NSWindow.Level(NSWindow.Level.statusBar.rawValue)
}
