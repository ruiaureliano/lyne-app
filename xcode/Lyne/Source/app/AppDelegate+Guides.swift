import Cocoa

extension AppDelegate {

	func buildGuidesWindows() {
		_ = guideWindows.map { $0.orderOut(self) }
		guideWindows.removeAll()
		var screenIndex: Int = 0
		for screen in NSScreen.screens {
			guideWindows.append(GuideWindow(contentRect: screen.frame, screenName: screen.localizedName, screenIndex: screenIndex))
			screenIndex += 1
		}

		for guideWindow in guideWindows where !Settings.shared.screenIndexHiddenGuides.contains(guideWindow.screenIndex) {
			guideWindow.makeKeyAndOrderFront(nil)
		}
	}

	func setGuidesAcceptMouse(accept: Bool) {
		_ = guideWindows.map { $0.acceptMouse(accept: accept) }
	}
}
