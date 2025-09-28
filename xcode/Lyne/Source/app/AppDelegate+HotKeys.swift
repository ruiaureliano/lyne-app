import Cocoa

extension AppDelegate: HotKeysDelegate {

	func registerHotKeys() {
		HotKeys.shared.registerHotKeys()
		HotKeys.shared.delegate = self
	}

	func unregisterHotKeys() {
		HotKeys.shared.unregisterHotKeys()
	}

	func hotKeyDidPress(identifier: HotKeyIdentifier, shortcut: String) {
		if let screen = NSScreen.screenMouse {
			LyneAnalytics.trackEvent(name: .shortcut, with: ["identifier": "\(identifier)", "shortcut": shortcut, "operation": "press"])
			switch identifier {
			case .unknown:
				break
			case .toggleGuides:
				let screenIndex = screen.screenIndex
				let screenHidden = Settings.shared.screenIndexHiddenGuides.contains(screenIndex)
				if screenHidden {
					if Settings.shared.screenIndexHiddenGuides.contains(screenIndex) {
						Settings.shared.screenIndexHiddenGuides.removeAll { $0 == screenIndex }
						NotificationCenter.notify(name: .screenDidChanged)
					}
				} else {
					if !Settings.shared.screenIndexHiddenGuides.contains(screenIndex) {
						Settings.shared.screenIndexHiddenGuides.append(screenIndex)
						NotificationCenter.notify(name: .screenDidChanged)
					}
				}
			case .addHorizontalGuide:
				let screenIndex = screen.screenIndex
				if Guide.shared.addLine(position: Int(NSEvent.mouseLocation.y - screen.frame.origin.y), orientation: .horizontal, screenIndex: screenIndex) {
					NotificationCenter.notify(name: .guideLinesDidChanged)
				}
			case .addVerticalGuide:
				let screenIndex = screen.screenIndex
				if Guide.shared.addLine(position: Int(NSEvent.mouseLocation.x - screen.frame.origin.x), orientation: .vertical, screenIndex: screenIndex) {
					NotificationCenter.notify(name: .guideLinesDidChanged)
				}
			case .addRectangleGuide:
				StatusBarRectangle.resizing = true
				DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
					self.setGuidesAcceptMouse(accept: true)
					NSCursor.cursorRectangle().set()
				}
			}
		}
	}
}
