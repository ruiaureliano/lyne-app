import Cocoa

protocol PreferencesShortcutsViewCellRecorderDelegate: AnyObject {
	func shortcutRecorderStartRecording(identifier: HotKeyIdentifier)
	func shortcutRecorderEndRecording(identifier: HotKeyIdentifier)
	func shortcutRecorderDidChangedFlags(flags: Int, code: Int)
}

class PreferencesShortcutsViewCellRecorder: NSView {

	@IBOutlet weak var keyImg1: NSImageView!
	@IBOutlet weak var keyStr1: NSTextField!
	@IBOutlet weak var keyImg2: NSImageView!
	@IBOutlet weak var keyStr2: NSTextField!
	@IBOutlet weak var keyImg3: NSImageView!
	@IBOutlet weak var keyStr3: NSTextField!
	@IBOutlet weak var keyImg4: NSImageView!
	@IBOutlet weak var keyStr4: NSTextField!
	@IBOutlet weak var keyImg5: NSImageView!
	@IBOutlet weak var keyStr5: NSTextField!

	private var hotKey: HotKey?
	weak var delegate: PreferencesShortcutsViewCellRecorderDelegate?

	override var acceptsFirstResponder: Bool {
		return true
	}

	override func acceptsFirstMouse(for event: NSEvent?) -> Bool {
		return true
	}

	override func awakeFromNib() {
		super.awakeFromNib()
		addTrackingArea(NSTrackingArea(rect: self.frame, options: [.mouseEnteredAndExited, .mouseMoved, .activeAlways, .inVisibleRect], owner: self, userInfo: nil))
	}

	func setHotKey(hotKey: HotKey) {
		self.hotKey = hotKey
		self.alphaValue = hotKey.state == .enabled ? 1 : 0.3
		self.setFlags(flags: hotKey.flags, code: hotKey.code)
		self.setKeyVisible(visible: true)
	}

	func setFlags(flags: Int, code: Int) {
		keyImg1.isHidden = true
		keyStr1.isHidden = true
		keyImg2.isHidden = true
		keyStr2.isHidden = true
		keyImg3.isHidden = true
		keyStr3.isHidden = true
		keyImg4.isHidden = true
		keyStr4.isHidden = true
		keyImg5.isHidden = true
		keyStr5.isHidden = true

		let flagSymbol = HotKeyCodeMap.shortcutSymbol(flags: NSEvent.ModifierFlags(rawValue: UInt(flags)))
		let codeSymbol = HotKeyCodeMap.keySymbol(for: code)
		var shortcutString = "\(flagSymbol)"
		if code != -1000 {
			shortcutString.append(codeSymbol)
		}

		var index: Int = 1
		for ch in shortcutString.reversed() {
			switch index {
			case 1:
				keyImg5.isHidden = false
				keyStr5.isHidden = false
				keyStr5.stringValue = "\(ch)"
			case 2:
				keyImg4.isHidden = false
				keyStr4.isHidden = false
				keyStr4.stringValue = "\(ch)"
			case 3:
				keyImg3.isHidden = false
				keyStr3.isHidden = false
				keyStr3.stringValue = "\(ch)"
			case 4:
				keyImg2.isHidden = false
				keyStr2.isHidden = false
				keyStr2.stringValue = "\(ch)"
			case 5:
				keyImg1.isHidden = false
				keyStr1.isHidden = false
				keyStr1.stringValue = "\(ch)"
			default:
				break
			}
			index += 1
		}
	}

	func setKeyVisible(visible: Bool) {
		if visible {
			keyImg1.alphaValue = 1
			keyStr1.alphaValue = 1
			keyImg2.alphaValue = 1
			keyStr2.alphaValue = 1
			keyImg3.alphaValue = 1
			keyStr3.alphaValue = 1
			keyImg4.alphaValue = 1
			keyStr4.alphaValue = 1
			keyImg5.alphaValue = 1
			keyStr5.alphaValue = 1
		} else {
			keyImg1.alphaValue = 0
			keyStr1.alphaValue = 0
			keyImg2.alphaValue = 0
			keyStr2.alphaValue = 0
			keyImg3.alphaValue = 0
			keyStr3.alphaValue = 0
			keyImg4.alphaValue = 0
			keyStr4.alphaValue = 0
			keyImg5.alphaValue = 0
			keyStr5.alphaValue = 0
		}
	}
}

extension PreferencesShortcutsViewCellRecorder {

	override func mouseDown(with event: NSEvent) {
		super.mouseDown(with: event)
		guard let hotKey = hotKey else { return }
		if hotKey.state == .enabled && !hotKey.readonly {
			delegate?.shortcutRecorderStartRecording(identifier: hotKey.id)
		}
	}

	override func mouseExited(with event: NSEvent) {
		guard let hotKey = hotKey else { return }
		if hotKey.state == .enabled && !hotKey.readonly {
			delegate?.shortcutRecorderEndRecording(identifier: hotKey.id)
		}
	}
}
