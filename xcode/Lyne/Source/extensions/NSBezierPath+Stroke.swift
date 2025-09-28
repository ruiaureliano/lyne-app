import Cocoa

extension NSBezierPath {

	func strokeInside(clipRect: NSRect? = nil) {
		guard let current = NSGraphicsContext.current else { return }
		current.saveGraphicsState()
		self.setClip()
		if let clipRect = clipRect {
			NSBezierPath.clip(clipRect)
		}
		self.lineWidth *= 2
		self.stroke()
		current.restoreGraphicsState()
		self.lineWidth /= 2
	}

	func strokeOutside(clipRect: NSRect? = nil) {
		guard let current = NSGraphicsContext.current else { return }
		current.saveGraphicsState()
		if let clipRect = clipRect {
			NSBezierPath.clip(clipRect)
		}
		self.lineWidth *= 2
		self.stroke()
		current.restoreGraphicsState()
		self.lineWidth /= 2
	}
}
