import Foundation

private let kUserDefaultsGuideLines = "UserDefaultsGuideLines"
private let kUserDefaultsGuideLayouts = "UserDefaultsGuideLayouts"
private let kUserDefaultsGuideLayout = "kUserDefaultsGuideLayout"

extension Guide {

	@discardableResult func load() -> Bool {
		var result = false
		if let data = UserDefaults.standard.object(forKey: kUserDefaultsGuideLines) as? Data, let lines = try? JSONDecoder().decode([Line].self, from: data) {
			self.lines = lines
			result = true
		}
		if let data = UserDefaults.standard.object(forKey: kUserDefaultsGuideLayouts) as? Data, let layouts = try? JSONDecoder().decode([String].self, from: data) {
			self.layouts = layouts
			result = true
		}
		if let data = UserDefaults.standard.object(forKey: kUserDefaultsGuideLayout) as? Data, let layout = try? JSONDecoder().decode(String.self, from: data) {
			self.layout = layout
			result = true
		}
		return result
	}

	@discardableResult func save() -> Bool {
		var result = false
		if let data = try? JSONEncoder().encode(lines) {
			UserDefaults.standard.setValue(data, forKey: kUserDefaultsGuideLines)
			result = true
		}
		if let data = try? JSONEncoder().encode(layouts) {
			UserDefaults.standard.setValue(data, forKey: kUserDefaultsGuideLayouts)
			result = true
		}
		if let data = try? JSONEncoder().encode(layout) {
			UserDefaults.standard.setValue(data, forKey: kUserDefaultsGuideLayout)
			result = true
		}
		if result {
			UserDefaults.standard.synchronize()
		}
		return result
	}

	func reset() {
		lines = []
		layouts = []
		layout = kLineDefaultLayout
		UserDefaults.standard.removeObject(forKey: kUserDefaultsGuideLines)
		UserDefaults.standard.removeObject(forKey: kUserDefaultsGuideLayouts)
		UserDefaults.standard.removeObject(forKey: kUserDefaultsGuideLayout)
		UserDefaults.standard.synchronize()
	}

	func resetLayouts() {
		layouts = []
		layout = kLineDefaultLayout
		UserDefaults.standard.removeObject(forKey: kUserDefaultsGuideLayouts)
		UserDefaults.standard.removeObject(forKey: kUserDefaultsGuideLayout)
		UserDefaults.standard.synchronize()
	}
}
