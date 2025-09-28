import Cocoa

extension AppDelegate {

	func getWallpapers() {
		if let windows = CGWindowListCopyWindowInfo(.optionOnScreenOnly, CGWindowID()) as? [[String: Any]] {
			let validWindows = windows.filter { $0["kCGWindowName"] != nil }
			for window in validWindows {
				if let windowNumber = window["kCGWindowNumber"] as? Int, let image = CGWindowListCreateImage(.zero, .optionIncludingWindow, CGWindowID(windowNumber), .nominalResolution) {
					for screen in NSScreen.screens {
						if image.width == Int(screen.frame.width) && image.height == Int(screen.frame.height) {
							if let cgColorSpace = image.colorSpace {
								if NSColorSpace(cgColorSpace: cgColorSpace) == screen.colorSpace {
									AppDelegate.wallpapers[screen] = NSImage(cgImage: image, size: NSSize(width: image.width, height: image.height))
								}
							}
						}
					}
				}
			}
		}
		NotificationCenter.notify(name: .wallpapersDidChanged)
	}
}
