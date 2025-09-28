import Cocoa

extension NSImage {

	func tint(color: NSColor) -> NSImage? {
		if let image = self.copy() as? NSImage {
			image.lockFocus()
			let imageRect = CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height)
			color.set()
			imageRect.fill(using: .sourceAtop)
			image.unlockFocus()
			return image
		}
		return nil
	}
}
