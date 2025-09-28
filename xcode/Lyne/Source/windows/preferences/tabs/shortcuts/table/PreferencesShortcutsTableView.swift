import Cocoa

class PreferencesShortcutsTableView: NSTableView {

	var recordingIdentifier: HotKeyIdentifier?
	weak var recorderDelegate: PreferencesShortcutsViewCellRecorderDelegate?

	override func performKeyEquivalent(with event: NSEvent) -> Bool {
		super.performKeyEquivalent(with: event)
		if event.type == .keyDown {
			if let recorderDelegate = recorderDelegate, recordingIdentifier != nil {
				recorderDelegate.shortcutRecorderDidChangedFlags(flags: Int(event.modifierFlags.rawValue), code: Int(event.keyCode))
				return true
			}
		}
		return false
	}
}
