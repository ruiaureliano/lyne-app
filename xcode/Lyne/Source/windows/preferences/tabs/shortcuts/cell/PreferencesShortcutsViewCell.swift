import Cocoa

extension PreferencesShortcutsViewCell {

	static let identifier: NSUserInterfaceItemIdentifier = NSUserInterfaceItemIdentifier("PreferencesShortcutsViewCell")
}

class PreferencesShortcutsViewCell: NSTableCellView {

	@IBOutlet weak var shortcutCheck: NSButton!
	@IBOutlet weak var shortcutName: NSTextField!
	@IBOutlet weak var shortcutRecorderBackground: NSImageView!
	@IBOutlet weak var shortcutRecorderLabel: NSTextField!
	@IBOutlet weak var shortcutRecorder: PreferencesShortcutsViewCellRecorder!

	weak var delegate: PreferencesShortcutsViewCellRecorderDelegate?

	private var hotKey: HotKey?

	override func awakeFromNib() {
		super.awakeFromNib()
		shortcutRecorder.delegate = self
	}

	func setHotKey(hotKey: HotKey) {
		self.hotKey = hotKey
		shortcutName.stringValue = hotKey.name
		shortcutCheck.state = (hotKey.state == .enabled ? .on : .off)
		shortcutRecorderBackground.isHidden = true
		shortcutRecorderLabel.isHidden = true
		shortcutRecorder.setHotKey(hotKey: hotKey)
	}

	@IBAction func shortcutCheckPress(_ button: NSButton) {
		guard let hotKey = hotKey else { return }
		_ = HotKeys.shared.updateHotKey(id: hotKey.id, state: (button.state == .on ? .enabled : .disabled))
	}
}

extension PreferencesShortcutsViewCell: PreferencesShortcutsViewCellRecorderDelegate {

	func shortcutRecorderStartRecording(identifier: HotKeyIdentifier) {
		shortcutRecorderBackground.isHidden = false
		shortcutRecorderLabel.isHidden = false
		shortcutRecorder.setKeyVisible(visible: false)
		delegate?.shortcutRecorderStartRecording(identifier: identifier)
	}

	func shortcutRecorderEndRecording(identifier: HotKeyIdentifier) {
		shortcutRecorderBackground.isHidden = true
		shortcutRecorderLabel.isHidden = true
		shortcutRecorder.setKeyVisible(visible: true)
		delegate?.shortcutRecorderEndRecording(identifier: identifier)
	}

	func shortcutRecorderDidChangedFlags(flags: Int, code: Int) {
		delegate?.shortcutRecorderDidChangedFlags(flags: flags, code: code)
	}
}
