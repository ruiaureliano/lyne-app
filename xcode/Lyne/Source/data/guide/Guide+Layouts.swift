import Cocoa

extension Guide {

	static func uniqueLayout(for name: String) -> String {
		var unique = name
		var i = 1
		while Guide.shared.layouts.contains(unique) {
			unique = "\(name) (\(i))"
			i += 1
		}
		return unique
	}

	func allLayouts() -> [String] {
		var allLayouts: [String] = [kLineDefaultLayout]
		for layout in layouts.sorted() {
			allLayouts.append(layout)
		}
		return allLayouts
	}

	@discardableResult func addLayout(layout: String) -> Bool {
		if !layouts.contains(layout) && layout != kLineDefaultLayout {
			layouts.append(layout)
			return true
		}
		return false
	}

	@discardableResult func removeLayout(layout: String) -> Bool {
		if layouts.contains(layout) {
			_ = Guide.shared.lines.filter { $0.layout == layout }.map { $0.layout = kLineDefaultLayout }
			layouts.removeAll { $0 == layout }
			return true
		}
		return false
	}

	@discardableResult func rename(layout: String, to toLayout: String) -> Bool {
		_ = lines.filter { $0.layout == layout }.map { $0.layout = toLayout }
		if layouts.first(where: { $0 == layout }) != nil {
			layouts.removeAll { $0 == layout }
			layouts.append(toLayout)
			return true
		}
		return false
	}
}
