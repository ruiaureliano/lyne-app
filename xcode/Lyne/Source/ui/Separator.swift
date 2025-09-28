import Cocoa

@IBDesignable class Separator: NSView {

	@IBInspectable var alphaSeparatorValue: CGFloat = 1 {
		didSet {
			self.alphaValue = alphaSeparatorValue
			self.needsDisplay = true
		}
	}

	override func prepareForInterfaceBuilder() {
		super.prepareForInterfaceBuilder()
		self.needsDisplay = true
	}

	override func draw(_ dirtyRect: NSRect) {
		super.draw(dirtyRect)
		let path = NSBezierPath()
		path.move(to: NSPoint(x: 0, y: 0))
		path.line(to: NSPoint(x: bounds.width, y: 0))
		path.lineWidth = 1
		NSColor.quaternaryLabelColor.setStroke()
		path.stroke()
	}
}
