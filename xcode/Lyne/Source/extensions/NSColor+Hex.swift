import Cocoa

extension NSColor {

	convenience init(hex: String) {

		let hex: String = hex.trimmingCharacters(in: .whitespacesAndNewlines)
		let scanner = Scanner(string: hex)

		if hex.hasPrefix("#") {
			scanner.currentIndex = hex.index(hex.startIndex, offsetBy: 1)
		}

		var color: UInt64 = 0
		scanner.scanHexInt64(&color)

		let mask = 0x0000_00FF
		let r = Int(color >> 16) & mask
		let g = Int(color >> 8) & mask
		let b = Int(color) & mask

		let red = CGFloat(r) / 255.0
		let green = CGFloat(g) / 255.0
		let blue = CGFloat(b) / 255.0

		self.init(red: red, green: green, blue: blue, alpha: 1)
	}

	var hex: String {
		return String(format: "%.2lx%.2lx%.2lx", lroundf(Float(abs(self.redComponent) * 255)), lroundf(Float(abs(self.greenComponent) * 255)), lroundf(Float(abs(self.blueComponent) * 255)))
	}
}
