import Cocoa

@IBDesignable class PreferencesAppearancePreviewBackground: NSView {

	@IBInspectable var showDesktop: Bool = false { didSet { self.needsDisplay = true } }
	@IBInspectable var image: NSImage? { didSet { self.needsDisplay = true } }

	override func awakeFromNib() {
		super.awakeFromNib()
		NotificationCenter.observe(self, selector: #selector(wallpapersDidChangedNotification(_:)), name: .wallpapersDidChanged)
	}

	@objc private func wallpapersDidChangedNotification(_ notification: Notification) {
		update()
	}

	override func draw(_ dirtyRect: NSRect) {
		super.draw(dirtyRect)
		let bezier = NSBezierPath(roundedRect: bounds, xRadius: 5, yRadius: 5)
		bezier.setClip()
		NSColor.labelColor.withAlphaComponent(0.1).setStroke()

		if showDesktop {
			if let screen = NSScreen.screenMouse, let wallpaper = AppDelegate.wallpapers[screen] {
				let width = bounds.width * 4
				let height = bounds.height * 4
				let rect = CGRect(x: (wallpaper.size.width - width) / 2, y: (wallpaper.size.height - height) / 2, width: width, height: height)
				wallpaper.draw(in: bounds, from: rect, operation: .sourceOver, fraction: 1)
			} else if let image = image {
				image.draw(in: bounds)
			}
		} else {
			NSColor.labelColor.withAlphaComponent(0.05).setFill()
			bezier.fill()
		}
		bezier.strokeInside()
	}

	func update() {
		needsDisplay = true
	}
}
