import Cocoa

extension AppDelegate {

	func registerNotifications() {
		NotificationCenter.observe(self, selector: #selector(didChangeScreenNotification(_:)), name: .screenDidChanged)
	}

	@objc private func didChangeScreenNotification(_ notification: Notification) {
		buildGuidesWindows()
		getWallpapers()
	}
}
