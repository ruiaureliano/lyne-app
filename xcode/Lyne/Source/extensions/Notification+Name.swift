import Cocoa

extension Notification.Name {
	static let screenDidChanged = NSApplication.didChangeScreenParametersNotification
}

extension Notification.Name {
	static let guideLinesDidChanged = Notification.Name("GuideLinesDidChanged")
}

extension Notification.Name {
	static let preferencesDidChanged = Notification.Name("PreferencesDidChanged")
}

extension Notification.Name {
	static let shortcutsDidChanged = Notification.Name("ShortcutsDidChanged")
}

extension Notification.Name {
	static let wallpapersDidChanged = Notification.Name("WallpapersDidChanged")
}
