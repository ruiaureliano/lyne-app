import Cocoa

extension PreferencesShortcutsViewController {

	@IBAction func resetButtonPress(_ button: NSButton) {
		let alert = NSAlert()
		alert.messageText = "Reset Shortcuts"
		alert.informativeText = "Are you sure you want to reset shortcuts?"
		alert.alertStyle = .informational
		alert.addButton(withTitle: "OK")
		alert.addButton(withTitle: "Cancel")

		if let window = NSApp.mainWindow {
			alert.beginSheetModal(for: window) { response in
				if response.rawValue == 1000 {
					HotKeys.shared.reset()
				}
			}
		} else {
			let response = alert.runModal()
			if response.rawValue == 1000 {
				HotKeys.shared.reset()
			}
		}
	}
}
