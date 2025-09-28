import Cocoa

extension NSImage {

	func representationWith(size: CGSize, scale: Int = 2) -> NSImage? {
		for representation in representations where representation.size == size {
			let w: Int = Int(size.width) * scale
			let h: Int = Int(size.height) * scale
			if representation.pixelsWide == w && representation.pixelsHigh == h {
				let image = NSImage(size: representation.size)
				image.addRepresentation(representation)
				return image
			}
		}
		return nil
	}
}
