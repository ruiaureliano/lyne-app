import Foundation

extension HotKeys: HotKeysDelegate {

	func setDelegate() {
		hotKeyCenter.delegate = self
	}

	func hotKeyDidPress(identifier: HotKeyIdentifier, shortcut: String) {
		delegate?.hotKeyDidPress(identifier: identifier, shortcut: shortcut)
	}
}
