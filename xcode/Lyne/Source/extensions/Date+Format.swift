import Foundation

extension Date {

	init?(date: String?, format: String = "yyyy-MM-dd HH:mm:ss", timeZone: TimeZone? = nil) {
		let formatter = DateFormatter()
		formatter.dateFormat = format
		if let timeZone = timeZone {
			formatter.timeZone = timeZone
		}
		self.init()
		if let date = date, let d = formatter.date(from: date) {
			self = d
		} else {
			return nil
		}
	}

	func string(with format: String) -> String {
		let formatter = DateFormatter()
		formatter.dateFormat = format
		formatter.timeZone = TimeZone(abbreviation: "UTC")
		return formatter.string(from: self)
	}
}
