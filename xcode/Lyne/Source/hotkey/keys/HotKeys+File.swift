import Cocoa

private let kUserDefaultsHotKeys = "UserDefaultsHotKeys"

extension HotKeys {

	private var _hotkeys: [HotKey] {
		return [
			HotKey(id: .toggleGuides, name: "Toggle Guides:", index: 1, flags: Int(NSEvent.ModifierFlags.control.rawValue | NSEvent.ModifierFlags.option.rawValue | NSEvent.ModifierFlags.command.rawValue), code: 17, group: .group),
			HotKey(id: .addHorizontalGuide, name: "Horizontal Guide:", index: 2, flags: Int(NSEvent.ModifierFlags.control.rawValue | NSEvent.ModifierFlags.option.rawValue | NSEvent.ModifierFlags.command.rawValue), code: 4, group: .group),
			HotKey(id: .addVerticalGuide, name: "Vertical Guide:", index: 3, flags: Int(NSEvent.ModifierFlags.control.rawValue | NSEvent.ModifierFlags.option.rawValue | NSEvent.ModifierFlags.command.rawValue), code: 9, group: .group),
			HotKey(id: .addRectangleGuide, name: "Rectangle:", index: 4, flags: Int(NSEvent.ModifierFlags.control.rawValue | NSEvent.ModifierFlags.option.rawValue | NSEvent.ModifierFlags.command.rawValue), code: 15, group: .group),
		]
	}

	func load() {
		if let data = UserDefaults.standard.object(forKey: kUserDefaultsHotKeys) as? Data, let hotKeys = try? JSONDecoder().decode([HotKey].self, from: data) {
			self.hotKeys = hotKeys
		} else {
			self.hotKeys = _hotkeys
		}
		NotificationCenter.notify(name: .shortcutsDidChanged)
	}

	func save() {
		if let data = try? JSONEncoder().encode(hotKeys) {
			UserDefaults.standard.setValue(data, forKey: kUserDefaultsHotKeys)
			UserDefaults.standard.synchronize()
			NotificationCenter.notify(name: .shortcutsDidChanged)
		}
	}

	func reset() {
		UserDefaults.standard.removeObject(forKey: kUserDefaultsHotKeys)
		UserDefaults.standard.synchronize()
		self.hotKeys = _hotkeys
		registerHotKeys()
		NotificationCenter.notify(name: .shortcutsDidChanged)
	}
}
