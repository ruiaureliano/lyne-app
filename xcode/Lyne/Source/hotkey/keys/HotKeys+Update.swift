import Cocoa

extension HotKeys {

	func updateHotKey(id: HotKeyIdentifier, name: String? = nil, index: Int? = nil, flags: Int? = nil, code: Int? = nil, state: HotKeyState? = nil, deleted: Bool? = nil, group: HotKeyGroupIdentifier? = nil) -> HotKeyUsed? {
		if let hotKeyUsed = HotKeyUsed.isSystemUsed(flags: flags, code: code, id: id) {
			return hotKeyUsed
		} else if let hotKey = hotKeys.first(where: { $0.id == id }) {
			if let name = name {
				hotKey.name = name
			}
			if let index = index {
				hotKey.index = index
			}
			if let flags = flags {
				hotKey.flags = flags
			}
			if let code = code {
				hotKey.code = code
			}
			if let state = state {
				hotKey.state = state
			}
			if let deleted = deleted {
				hotKey.deleted = deleted
			}
			if let group = group {
				hotKey.group = group
			}

			save()
			registerHotKeys()
			NotificationCenter.notify(name: .shortcutsDidChanged)

			LyneAnalytics.trackEvent(
				name: .shortcut,
				with: [
					"name": "\(hotKey.name)",
					"state": "\(hotKey.state)",
					"shortcut": HotKeyCodeMap.shortcutSymbol(flags: NSEvent.ModifierFlags(rawValue: UInt(hotKey.flags)), code: hotKey.code),
					"operation": "set",
				]
			)
		}
		return nil
	}
}
