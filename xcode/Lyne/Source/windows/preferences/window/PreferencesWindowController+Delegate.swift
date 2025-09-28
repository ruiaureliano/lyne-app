import Cocoa

extension PreferencesWindowController: NSWindowDelegate {

	func windowWillClose(_ notification: Notification) {
		isOpen = false
	}
}
