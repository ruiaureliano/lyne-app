import Cocoa

class HotKeyUsed: NSObject, Codable {

	var reason: String = ""
	var shortcut: String = ""
	var state: HotKeyUsedState = .system

	static var supportURL: String {
		return "https://support.apple.com/en-us/HT201236"
	}

	init(reason: String, shortcut: String, state: HotKeyUsedState = .system) {
		self.reason = reason
		self.shortcut = shortcut
		self.state = state
	}

	static func isSystemUsed(flags: Int?, code: Int?, id: HotKeyIdentifier) -> HotKeyUsed? {
		if let flags = flags, let code = code {
			var used: [HotKeyUsed] = [
				HotKeyUsed(reason: "Close all windows in the current app", shortcut: "⌥⌘ W"),
				HotKeyUsed(reason: "Close the frontmost window", shortcut: "⌘ W"),
				HotKeyUsed(reason: "Copy the selected data to the Clipboard", shortcut: "⌘ C"),
				HotKeyUsed(reason: "Create a new document in the frontmost app", shortcut: "⌘ N"),
				HotKeyUsed(reason: "Display a dialog for choosing a document to open in the frontmost app", shortcut: "⌘ U"),
				HotKeyUsed(reason: "Display a window for specifying document parameters (Page Setup)", shortcut: "⇧⌘ P"),
				HotKeyUsed(reason: "Display a window for specifying document parameters (Page Setup)", shortcut: "⌘ P"),
				HotKeyUsed(reason: "Display an inspector window", shortcut: "⌘ I"),
				HotKeyUsed(reason: "Display an inspector window", shortcut: "⌥⌘ I"),
				HotKeyUsed(reason: "Display the Save As dialog or duplicate the current document", shortcut: "⇧⌘ S"),
				HotKeyUsed(reason: "Find the next occurrence of the selection", shortcut: "⌘G "),
				HotKeyUsed(reason: "Find the previous occurrence of the selection", shortcut: "⇧⌘ G"),
				HotKeyUsed(reason: "Find the previous occurrence of the selection", shortcut: "⌘ G"),
				HotKeyUsed(reason: "Hide the windows of all other running apps", shortcut: "⌥⌘ H"),
				HotKeyUsed(reason: "Hide the windows of the currently running app", shortcut: "⌘ H"),
				HotKeyUsed(reason: "Minimize all windows of the active app to the Dock", shortcut: "⌥⌘ M"),
				HotKeyUsed(reason: "Minimize the active window to the Dock", shortcut: "⌘ M"),
				HotKeyUsed(reason: "Move to the search field control", shortcut: "⌥⌘ F"),
				HotKeyUsed(reason: "Open a Find window or find text in a document", shortcut: "⌘ F"),
				HotKeyUsed(reason: "Place a copy of (paste) the Clipboard contents into the current document or app", shortcut: "⌘ V"),
				HotKeyUsed(reason: "Print the current document", shortcut: "⌘ P"),
				HotKeyUsed(reason: "Quit the frontmost app", shortcut: "⌘Q"),
				HotKeyUsed(reason: "Remove the selected item and place a copy on the Clipboard", shortcut: "⌘ X"),
				HotKeyUsed(reason: "Save the active document", shortcut: "⌘ S"),
				HotKeyUsed(reason: "Select all items or text in the frontmost window", shortcut: "⌘ A"),
				HotKeyUsed(reason: "Selects Don't Save in dialogs that contain a Delete or Don't Save button", shortcut: "⌘ ⌫"),
				HotKeyUsed(reason: "Selects the Desktop folder in Open and Save dialogs", shortcut: "⌘ D"),
				HotKeyUsed(reason: "Show or hide a toolbar", shortcut: "⌥⌘ T"),
				HotKeyUsed(reason: "Undo previous command (some apps allow for multiple Undos)", shortcut: "⌘ Z"),
				HotKeyUsed(reason: "Use the selection for a find", shortcut: "⌘ E"),
			]

			for hotkey in HotKeys.shared.hotKeys where hotkey.id != id {
				let shortcutSymbol = HotKeyCodeMap.shortcutSymbol(flags: NSEvent.ModifierFlags(rawValue: UInt(hotkey.flags)))
				let keySymbol = HotKeyCodeMap.keySymbol(for: hotkey.code)
				used.append(HotKeyUsed(reason: "This shortcut combination is already used in app (\(hotkey.name))", shortcut: "\(shortcutSymbol) \(keySymbol)", state: .app))
			}

			let shortcut = HotKeyCodeMap.shortcutSymbol(flags: NSEvent.ModifierFlags(rawValue: UInt(flags)), code: code)
			return used.first { $0.shortcut == shortcut }
		}
		return nil
	}
}
