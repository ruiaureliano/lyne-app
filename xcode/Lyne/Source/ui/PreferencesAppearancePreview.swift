import Cocoa

private let kPreviewDefaultSpace: Int = 120

class PreferencesAppearancePreview: NSView {

	var minX: Int = 0
	var maxX: Int = kPreviewDefaultSpace
	var minY: Int = 0
	var maxY: Int = kPreviewDefaultSpace

	private var isDynamicLeft: Bool = true
	private var isDynamicTop: Bool = true

	override func awakeFromNib() {
		super.awakeFromNib()
		addTrackingArea(NSTrackingArea(rect: self.frame, options: [.mouseEnteredAndExited, .mouseMoved, .activeAlways, .inVisibleRect], owner: self, userInfo: nil))
	}

	override func draw(_ dirtyRect: NSRect) {
		super.draw(dirtyRect)

		let lineHorizontalHandler = Preferences.shared.lineHorizontalHandler
		let lineVerticalHandler = Preferences.shared.lineVerticalHandler
		let displayDimensions = Preferences.shared.displayDimensions
		let lineColor = Preferences.shared.lineColor
		let lineStroke = Preferences.shared.lineStroke
		let lineColorAlpha = Preferences.shared.lineColorAlpha
		let outsideInterceptions = Preferences.shared.outsideInterceptions
		let outsideInterceptionsAlpha = Preferences.shared.outsideInterceptionsAlpha
		let outsideInterceptionsStroke = Preferences.shared.outsideInterceptionsStroke

		let w = Int(bounds.width)
		let h = Int(bounds.height)
		minX = (w - kPreviewDefaultSpace) / 2
		maxX = (w + kPreviewDefaultSpace) / 2
		minY = (h - kPreviewDefaultSpace) / 2
		maxY = (h + kPreviewDefaultSpace) / 2

		let guidePath = NSBezierPath()
		guidePath.move(to: NSPoint(x: (w - kPreviewDefaultSpace) / 2, y: 0))
		guidePath.line(to: NSPoint(x: (w - kPreviewDefaultSpace) / 2, y: h))
		guidePath.move(to: NSPoint(x: (w + kPreviewDefaultSpace) / 2, y: 0))
		guidePath.line(to: NSPoint(x: (w + kPreviewDefaultSpace) / 2, y: h))
		guidePath.move(to: NSPoint(x: 0, y: (h - kPreviewDefaultSpace) / 2))
		guidePath.line(to: NSPoint(x: w, y: (h - kPreviewDefaultSpace) / 2))
		guidePath.move(to: NSPoint(x: 0, y: (h + kPreviewDefaultSpace) / 2))
		guidePath.line(to: NSPoint(x: w, y: (h + kPreviewDefaultSpace) / 2))

		switch outsideInterceptions {
		case .none:
			Line.color(for: lineColor).withAlphaComponent(lineColorAlpha).setStroke()
			switch lineStroke {
			case .solid:
				guidePath.setLineDash([0], count: 0, phase: 0.0)
			case .dashed:
				guidePath.setLineDash([3, 3], count: 2, phase: 0.0)
			case .dotted:
				guidePath.setLineDash([1, 1], count: 2, phase: 0.0)
			}
			guidePath.stroke()
		case .inside:

			let clipBezier = NSBezierPath(rect: NSRect(x: CGFloat(minX) - 0.5, y: CGFloat(minY) - 0.5, width: CGFloat(maxX - minX) + 1, height: CGFloat(maxY - minY) + 1))
			clipBezier.setClip()

			Line.color(for: lineColor).withAlphaComponent(lineColorAlpha).setStroke()
			switch lineStroke {
			case .solid:
				guidePath.setLineDash([0], count: 0, phase: 0.0)
			case .dashed:
				guidePath.setLineDash([3, 3], count: 2, phase: 0.0)
			case .dotted:
				guidePath.setLineDash([1, 1], count: 2, phase: 0.0)
			}
			guidePath.stroke()

			clipBezier.inverted(in: bounds).setClip()
			Line.color(for: lineColor).withAlphaComponent(outsideInterceptionsAlpha).setStroke()
			switch outsideInterceptionsStroke {
			case .solid:
				guidePath.setLineDash([0], count: 0, phase: 0.0)
			case .dashed:
				guidePath.setLineDash([3, 3], count: 2, phase: 0.0)
			case .dotted:
				guidePath.setLineDash([1, 1], count: 2, phase: 0.0)
			}
			guidePath.stroke()
		}

		NSBezierPath(rect: bounds).setClip()

		drawHorizontalValues(displayDimensions: displayDimensions, lineHorizontalHandler: lineHorizontalHandler)
		drawVerticalValues(displayDimensions: displayDimensions, lineVerticalHandler: lineVerticalHandler)
		drawHandlers(lineHorizontalHandler: lineHorizontalHandler, lineVerticalHandler: lineVerticalHandler)
	}

	func update() {
		needsDisplay = true
	}

	override func mouseMoved(with event: NSEvent) {
		super.mouseMoved(with: event)
		let point = convert(event.locationInWindow, from: nil)
		isDynamicLeft = (point.x < self.frame.width / 2)
		isDynamicTop = (point.y < self.frame.height / 2)
		update()
	}
}

extension PreferencesAppearancePreview {

	func drawHorizontalValues(displayDimensions: Bool, lineHorizontalHandler: LineHorizontalHandler) {
		if displayDimensions {
			let boxSize = "\(kPreviewDefaultSpace)".size(font: kValueViewFont)
			let w = Int(boxSize.width + 2 * kValueViewPadding)
			let h = Int(boxSize.height + 2 * kValueViewPadding)
			let y = (Int(bounds.height) - h) / 2
			var x = Int(kValueViewMargin)

			switch lineHorizontalHandler {
			case .left:
				break
			case .right:
				x = Int(bounds.width - kValueViewMargin) - w
			case .dynamic:
				if !isDynamicLeft {
					x = Int(bounds.width - kValueViewMargin) - w
				}
			}
			NSColor.black.withAlphaComponent(0.5).setFill()
			NSBezierPath(roundedRect: NSRect(x: x, y: y, width: w, height: h), xRadius: kValueViewRadius, yRadius: kValueViewRadius).fill()
			"\(kPreviewDefaultSpace)".draw(in: NSRect(x: x, y: y - Int(kValueViewPadding), width: w, height: h), withAttributes: [.foregroundColor: NSColor.white, .font: kValueViewFont, .paragraphStyle: NSParagraphStyle.center])
		}
	}

	func drawVerticalValues(displayDimensions: Bool, lineVerticalHandler: LineVerticalHandler) {
		if displayDimensions {
			let boxSize = "\(kPreviewDefaultSpace)".size(font: kValueViewFont)
			let w = Int(boxSize.width + 2 * kValueViewPadding)
			let h = Int(boxSize.height + 2 * kValueViewPadding)
			var y = Int(kValueViewMargin)
			let x = (Int(bounds.width) - h) / 2
			switch lineVerticalHandler {
			case .top:
				y = Int(bounds.height - kValueViewMargin) - h
			case .bottom:
				break
			case .dynamic:
				if !isDynamicTop {
					y = Int(bounds.height - kValueViewMargin) - h
				}
			}
			NSColor.black.withAlphaComponent(0.5).setFill()
			NSBezierPath(roundedRect: NSRect(x: x, y: y, width: w, height: h), xRadius: kValueViewRadius, yRadius: kValueViewRadius).fill()
			"\(kPreviewDefaultSpace)".draw(in: NSRect(x: x, y: y - Int(kValueViewPadding), width: w, height: h), withAttributes: [.foregroundColor: NSColor.white, .font: kValueViewFont, .paragraphStyle: NSParagraphStyle.center])
		}
	}

	func drawHandlers(lineHorizontalHandler: LineHorizontalHandler, lineVerticalHandler: LineVerticalHandler) {
		NSColor.black.setFill()
		for x in [minX, maxX] {
			let px = CGFloat(x) - kGuideHandlerViewSize / 2
			var py: CGFloat = 0
			switch lineVerticalHandler {
			case .top:
				py = bounds.height - kGuideHandlerViewSize - kGuideHandlerViewMargin
			case .bottom:
				py = kGuideHandlerViewMargin
			case .dynamic:
				if !isDynamicTop {
					py = bounds.height - kGuideHandlerViewSize - kGuideHandlerViewMargin
				} else {
					py = kGuideHandlerViewMargin
				}
			}

			let bezier = NSBezierPath(roundedRect: NSRect(x: px, y: py, width: kGuideHandlerViewSize, height: kGuideHandlerViewSize), xRadius: kGuideHandlerViewRadius, yRadius: kGuideHandlerViewRadius)
			bezier.fill()
			NSImage.handlerMoveHorizontal.draw(
				at: NSPoint(x: px + (kGuideHandlerViewSize - kGuideHandlerViewIconSize) / 2, y: py + (kGuideHandlerViewSize - kGuideHandlerViewIconSize) / 2), from: NSRect(x: 0, y: 0, width: kGuideHandlerViewIconSize, height: kGuideHandlerViewIconSize), operation: .sourceOver,
				fraction: 1)
		}
		for y in [minY, maxY] {
			var px: CGFloat = 0
			switch lineHorizontalHandler {
			case .left:
				px = kGuideHandlerViewMargin
			case .right:
				px = bounds.width - kGuideHandlerViewSize - kGuideHandlerViewMargin
			case .dynamic:
				if !isDynamicLeft {
					px = bounds.width - kGuideHandlerViewSize - kGuideHandlerViewMargin
				} else {
					px = kGuideHandlerViewMargin
				}
			}
			let py = CGFloat(y) - kGuideHandlerViewSize / 2
			let bezier = NSBezierPath(roundedRect: NSRect(x: px, y: py, width: kGuideHandlerViewSize, height: kGuideHandlerViewSize), xRadius: kGuideHandlerViewRadius, yRadius: kGuideHandlerViewRadius)
			bezier.fill()
			NSImage.handlerMoveVertical.draw(
				at: NSPoint(x: px + (kGuideHandlerViewSize - kGuideHandlerViewIconSize) / 2, y: py + (kGuideHandlerViewSize - kGuideHandlerViewIconSize) / 2), from: NSRect(x: 0, y: 0, width: kGuideHandlerViewIconSize, height: kGuideHandlerViewIconSize), operation: .sourceOver,
				fraction: 1)
		}
	}
}
