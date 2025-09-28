import Cocoa

extension NSColor {

	static var random: NSColor {
		let red = Int.random(in: 0...255)
		let green = Int.random(in: 0...255)
		let blue = Int.random(in: 0...255)
		let color = NSColor(red: CGFloat(red) / 255, green: CGFloat(green) / 255, blue: CGFloat(blue) / 255, alpha: 1)
		return color
	}
}
