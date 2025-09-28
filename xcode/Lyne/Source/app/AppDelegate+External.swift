import Cocoa

extension AppDelegate {

	func application(_ sender: NSApplication, openFiles filenames: [String]) {
		LyneDocHandler.handle(filenames: filenames)
	}
}
