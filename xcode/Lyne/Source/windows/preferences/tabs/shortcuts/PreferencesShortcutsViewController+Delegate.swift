import Cocoa

extension PreferencesShortcutsViewController: PreferencesShortcutsViewCellRecorderDelegate {

	func shortcutRecorderStartRecording(identifier: HotKeyIdentifier) {
		self.recordingIdentifier = identifier
		(NSApp.delegate as? AppDelegate)?.unregisterHotKeys()
	}

	func shortcutRecorderEndRecording(identifier: HotKeyIdentifier) {
		self.recordingIdentifier = nil
		(NSApp.delegate as? AppDelegate)?.registerHotKeys()
	}

	func shortcutRecorderDidChangedFlags(flags: Int, code: Int) {
		if let recordingIdentifier = recordingIdentifier {
			if let used = HotKeys.shared.updateHotKey(id: recordingIdentifier, flags: flags, code: code) {
				DispatchQueue.main.async {
					let alert: NSAlert = NSAlert()
					alert.messageText = "We are sorry but you can't use this shortcut"
					alert.informativeText = "Reason: " + used.reason
					alert.alertStyle = .critical
					alert.addButton(withTitle: "OK")
					if used.state == .system {
						alert.addButton(withTitle: "More")
					}
					if let window = NSApp.mainWindow {
						alert.beginSheetModal(for: window) { response in
							if response.rawValue == 1001 && used.state == .system, let url = URL(string: HotKeyUsed.supportURL) {
								NSWorkspace.shared.open(url)
							}
						}
					} else {
						let response = alert.runModal()
						if response.rawValue == 1001 && used.state == .system, let url = URL(string: HotKeyUsed.supportURL) {
							NSWorkspace.shared.open(url)
						}
					}
				}
			} else {
				self.recordingIdentifier = nil
				self.reloadShortcuts()
			}
		}
	}
}
