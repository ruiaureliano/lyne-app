import Cocoa

extension NSBezierPath {

	func inverted(in bounds: CGRect) -> NSBezierPath {
		let bezierPath = NSBezierPath(rect: bounds)
		bezierPath.append(self.reversed)
		return bezierPath
	}
}
