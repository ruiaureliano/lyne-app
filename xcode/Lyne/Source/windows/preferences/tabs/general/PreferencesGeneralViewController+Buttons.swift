import Cocoa

extension PreferencesGeneralViewController {

	@IBAction func startupValuePress(_ button: NSButton) {
		Preferences.shared.startLogin = (button.state == .on)
	}

	@IBAction func playSoundsValuePress(_ button: NSButton) {
		Preferences.shared.playSounds = (button.state == .on)
	}

	@IBAction func trackEventsValuePress(_ button: NSButton) {
		Preferences.shared.trackEvents = (button.state == .on)
	}

	@IBAction func resetPreferencesButtonPress(_ button: NSButton) {
		let alert = NSAlert()
		alert.messageText = "Reset Preferences"
		alert.informativeText = "Are you sure you want to reset app preferences?"
		alert.alertStyle = .informational
		alert.addButton(withTitle: "OK")
		alert.addButton(withTitle: "Cancel")

		if let window = NSApp.mainWindow {
			alert.beginSheetModal(for: window) { response in
				if response.rawValue == 1000 {
					Preferences.shared.reset()
					HotKeys.shared.reset()
					OnboardingWindowController.reset()
					NSApp.terminate(self)
				}
			}
		} else {
			let response = alert.runModal()
			if response.rawValue == 1000 {
				Preferences.shared.reset()
				HotKeys.shared.reset()
				OnboardingWindowController.reset()
				NSApp.terminate(self)
			}
		}
	}
}
