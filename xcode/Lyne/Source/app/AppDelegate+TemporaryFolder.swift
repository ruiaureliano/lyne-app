import Cocoa

extension AppDelegate {

	static var tmpFolder: String? {
		if let bundleIdentifier = AppDelegate.bundle {
			return "\(NSTemporaryDirectory())\(bundleIdentifier)"
		}
		return nil
	}
}
