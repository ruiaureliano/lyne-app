import Foundation

extension String {

	subscript(i: Int) -> Character {
		return self[self.index(self.startIndex, offsetBy: i)]
	}

	subscript(i: Int) -> String {
		return String(self[i] as Character)
	}

	subscript(r: Range<Int>) -> String {
		let start = self.index(self.startIndex, offsetBy: r.lowerBound)
		let end = self.index(self.startIndex, offsetBy: r.upperBound)
		return String(self[start...end])
	}

	func substring(from: Int) -> String {
		return ((self as NSString).substring(from: from)) as String
	}

	func substring(to: Int) -> String {
		return ((self as NSString).substring(to: to)) as String
	}

	func substring(with range: NSRange) -> String {
		return ((self as NSString).substring(with: range)) as String
	}
}
