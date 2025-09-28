import Foundation

extension String {

	func draw(at point: NSPoint, withAttributes attrs: [NSAttributedString.Key: Any]? = nil) {
		(self as NSString).draw(at: point, withAttributes: attrs)
	}

	func draw(in rect: NSRect, withAttributes attrs: [NSAttributedString.Key: Any]? = nil) {
		(self as NSString).draw(in: rect, withAttributes: attrs)
	}
}
