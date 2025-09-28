import Cocoa

extension HotKeys {

	func registerHotKeys() {
		hotKeyCenter.unregister()
		for hotKey in hotKeys where hotKey.state == .enabled {
			hotKeyCenter.register(flags: NSEvent.ModifierFlags(rawValue: UInt(hotKey.flags)), code: hotKey.code, identifier: hotKey.id)
		}
	}

	func unregisterHotKeys() {
		hotKeyCenter.unregister()
	}
}
