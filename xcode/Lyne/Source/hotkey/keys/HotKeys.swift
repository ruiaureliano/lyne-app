import Cocoa

private let kUserDefaultsHotKeys = "UserDefaultsHotKeys"

protocol HotKeysDelegate: AnyObject {
	func hotKeyDidPress(identifier: HotKeyIdentifier, shortcut: String)
}

class HotKeys: NSObject {

	static let shared: HotKeys = {
		let instance = HotKeys()
		instance.load()
		instance.setDelegate()
		return instance
	}()

	var hotKeyCenter: HotKeyCenter = HotKeyCenter()
	var hotKeys: [HotKey] = []
	weak var delegate: HotKeysDelegate?
}
