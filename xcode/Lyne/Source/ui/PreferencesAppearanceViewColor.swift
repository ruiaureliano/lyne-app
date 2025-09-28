import Cocoa

protocol PreferencesAppearanceColorViewDelegate: AnyObject {
	func didPressColorView(colorView: PreferencesAppearanceViewColor)
}

@IBDesignable class PreferencesAppearanceViewColor: NSView {

	@IBInspectable var enabled: Bool = true { didSet { self.needsDisplay = true } }
	@IBInspectable var selected: Bool = false { didSet { self.needsDisplay = true } }
	@IBInspectable var image: NSImage? { didSet { self.needsDisplay = true } }

	weak var delegate: PreferencesAppearanceColorViewDelegate?

	override func awakeFromNib() {
		super.awakeFromNib()
		self.needsDisplay = true
		self.addTrackingArea(NSTrackingArea(rect: self.frame, options: [.mouseEnteredAndExited, .mouseMoved, .activeAlways, .inVisibleRect], owner: self, userInfo: nil))
	}

	override func prepareForInterfaceBuilder() {
		super.prepareForInterfaceBuilder()
		self.needsDisplay = true
	}

	override func draw(_ dirtyRect: NSRect) {
		super.draw(dirtyRect)

		if let image = image {
			image.draw(in: bounds)
			if selected {
				let bezierCenter = NSBezierPath(ovalIn: NSRect(x: ((bounds.width - 6) / 2).rounded(), y: ((bounds.height - 6) / 2).rounded(), width: 6, height: 6))
				NSColor.white.setFill()
				bezierCenter.fill()
			}
		}
		self.alphaValue = enabled ? 1.0 : 0.5
	}

	override func mouseDown(with event: NSEvent) {
		super.mouseDown(with: event)
		if enabled {
			self.animator().alphaValue = 0.75
		}
	}

	override func mouseUp(with event: NSEvent) {
		super.mouseUp(with: event)
		if enabled {
			self.animator().alphaValue = 1
			delegate?.didPressColorView(colorView: self)
		}
	}

	override func mouseExited(with event: NSEvent) {
		super.mouseExited(with: event)
		if enabled {
			self.animator().alphaValue = 1
		}
	}
}
