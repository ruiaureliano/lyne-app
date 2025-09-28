import Cocoa

extension Array where Element: Equatable {

	@discardableResult mutating func moveToLast(element: Element) -> Bool {
		var result: Bool = false
		if let index = self.firstIndex(where: { e in e == element }) {
			self.remove(at: index)
			self.append(element)
			result = true
		}

		return result
	}
}
