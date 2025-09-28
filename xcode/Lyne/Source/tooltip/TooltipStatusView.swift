import Cocoa

enum TooltipStatusViewType: Int, Codable {
	case text
}

class TooltipStatusView: NSView {

	var text: String = ""
	var type: TooltipStatusViewType = .text
	var timer = Timer()

	var expectedWidth: CGFloat {
		switch type {
		case .text:
			return kTooltipStatusWindowPadding + text.widthWithConstrainedHeight(height: 20, font: kTooltipStatusWindowFont) + kTooltipStatusWindowPadding
		}
	}

	override func draw(_ dirtyRect: NSRect) {
		super.draw(dirtyRect)
		NSColor.black.setFill()
		let bezier = NSBezierPath(roundedRect: bounds, xRadius: kTooltipStatusWindowRadius, yRadius: kTooltipStatusWindowRadius)
		bezier.setClip()
		bezier.fill()

		switch type {
		case .text:
			let x: CGFloat = kTooltipStatusWindowPadding
			let rect = NSRect(x: x, y: 9, width: bounds.size.width - x, height: 15)
			(text as NSString).draw(in: rect, withAttributes: [.foregroundColor: NSColor.white, .font: kTooltipStatusWindowFont])
		}
	}

	func updateWith(text: String? = nil, type: TooltipStatusViewType) {
		self.text = text ?? ""
		self.type = type
		self.needsDisplay = true
	}
}
