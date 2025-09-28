import Cocoa

let kGuideHandlerViewMargin: CGFloat = 5
let kGuideHandlerViewSize: CGFloat = 17
let kGuideHandlerViewSizeLink: CGFloat = 32
let kGuideHandlerViewIconSize: CGFloat = 13
let kGuideHandlerViewRadius: CGFloat = 5

let kCrossHandlerViewSize: CGFloat = 7

let kValueViewMargin: CGFloat = 5
let kValueViewPadding: CGFloat = 3
let kValueViewRadius: CGFloat = 5
let kValueViewFont: NSFont = NSFont.systemFont(ofSize: 11, weight: .medium)

class GuideWindowView: NSView {

	private var guideWindow: GuideWindow?
	var screenName: String = ""
	var screenIndex: Int = 0

	var guideHandlers: [GuideHandler] = []
	var selectedGuideHandler: GuideHandler?

	var crossHandlers: [CrossHandler] = []
	var selectedCrossHandler: CrossHandler?

	var topGap: CGFloat {
		if let screen = guideWindow?.screen {
			return screen.frame.size.height - screen.visibleFrame.size.height - bottomGap
		}
		return 0
	}

	var bottomGap: CGFloat {
		if let screen = guideWindow?.screen {
			return screen.visibleFrame.origin.y - screen.frame.origin.y
		}
		return 0
	}

	var isDragging: Bool = false

	var isDynamicLeft: Bool = true
	var isDynamicTop: Bool = true

	init() {
		super.init(frame: .zero)
	}

	required init?(coder: NSCoder) {
		super.init(coder: coder)
	}

	func update(guideWindow: GuideWindow?, screenName: String, screenIndex: Int) {
		self.guideWindow = guideWindow
		self.screenName = screenName
		self.screenIndex = screenIndex
		self.needsDisplay = true
	}

	override func draw(_ dirtyRect: NSRect) {
		super.draw(dirtyRect)
		guideHandlers.removeAll()
		crossHandlers.removeAll()

		let lineHorizontalHandler = Preferences.shared.lineHorizontalHandler
		let lineVerticalHandler = Preferences.shared.lineVerticalHandler
		let displayDimensions = Preferences.shared.displayDimensions
		let lineColor = Preferences.shared.lineColor
		let lineStroke = Preferences.shared.lineStroke
		let lineColorAlpha = Preferences.shared.lineColorAlpha * (StatusBarRectangle.resizing || StatusBarButton.point != nil ? 0.3 : 1)
		let outsideInterceptions = Preferences.shared.outsideInterceptions
		let outsideInterceptionsAlpha = Preferences.shared.outsideInterceptionsAlpha * (StatusBarRectangle.resizing || StatusBarButton.point != nil ? 0.3 : 1)
		let outsideInterceptionsStroke = Preferences.shared.outsideInterceptionsStroke

		let lines = Guide.shared.lines(screenIndex: screenIndex)
		let hLines = Guide.shared.lines(orientation: .horizontal, screenIndex: screenIndex)
		let vLines = Guide.shared.lines(orientation: .vertical, screenIndex: screenIndex)

		let guidePath: NSBezierPath = NSBezierPath()

		for line in lines {
			switch line.orientation {
			case .horizontal:
				let linePath = NSBezierPath()
				linePath.move(to: CGPoint(x: 0, y: line.position))
				linePath.line(to: CGPoint(x: Int(self.frame.width), y: line.position))
				guidePath.append(linePath)
				let w = (line.link.count == 0 ? kGuideHandlerViewSize : kGuideHandlerViewSizeLink)
				switch lineHorizontalHandler {
				case .left:
					let guideHandler = GuideHandler(line: line, frame: NSRect(x: kGuideHandlerViewMargin, y: CGFloat(line.position) - kGuideHandlerViewSize / 2, width: w, height: kGuideHandlerViewSize))
					guideHandlers.append(guideHandler)
				case .right:
					let guideHandler = GuideHandler(line: line, frame: NSRect(x: bounds.width - w - kGuideHandlerViewMargin, y: CGFloat(line.position) - kGuideHandlerViewSize / 2, width: w, height: kGuideHandlerViewSize))
					guideHandlers.append(guideHandler)
				case .dynamic:
					if isDynamicLeft {
						let guideHandler = GuideHandler(line: line, frame: NSRect(x: kGuideHandlerViewMargin, y: CGFloat(line.position) - kGuideHandlerViewSize / 2, width: w, height: kGuideHandlerViewSize))
						guideHandlers.append(guideHandler)
					} else {
						let guideHandler = GuideHandler(line: line, frame: NSRect(x: bounds.width - w - kGuideHandlerViewMargin, y: CGFloat(line.position) - kGuideHandlerViewSize / 2, width: w, height: kGuideHandlerViewSize))
						guideHandlers.append(guideHandler)
					}
				}
			case .vertical:
				let linePath = NSBezierPath()
				linePath.move(to: CGPoint(x: line.position, y: 0))
				linePath.line(to: CGPoint(x: line.position, y: Int(self.frame.height)))
				guidePath.append(linePath)
				let h = (line.link.count == 0 ? kGuideHandlerViewSize : kGuideHandlerViewSizeLink)
				switch lineVerticalHandler {
				case .top:
					let guideHandler = GuideHandler(line: line, frame: NSRect(x: CGFloat(line.position) - kGuideHandlerViewSize / 2, y: bounds.height - h - kGuideHandlerViewMargin - topGap, width: kGuideHandlerViewSize, height: h))
					guideHandlers.append(guideHandler)
				case .bottom:
					let guideHandler = GuideHandler(line: line, frame: NSRect(x: CGFloat(line.position) - kGuideHandlerViewSize / 2, y: kGuideHandlerViewMargin, width: kGuideHandlerViewSize, height: h))
					guideHandlers.append(guideHandler)
				case .dynamic:
					if isDynamicTop {
						let guideHandler = GuideHandler(line: line, frame: NSRect(x: CGFloat(line.position) - kGuideHandlerViewSize / 2, y: bounds.height - h - kGuideHandlerViewMargin - topGap, width: kGuideHandlerViewSize, height: h))
						guideHandlers.append(guideHandler)
					} else {
						let guideHandler = GuideHandler(line: line, frame: NSRect(x: CGFloat(line.position) - kGuideHandlerViewSize / 2, y: kGuideHandlerViewMargin, width: kGuideHandlerViewSize, height: h))
						guideHandlers.append(guideHandler)
					}
				}
			}
		}

		for hLine in hLines {
			for vLine in vLines {
				let crossHandler = CrossHandler(hLine: hLine, vLine: vLine, frame: NSRect(x: CGFloat(vLine.position) - kCrossHandlerViewSize / 2, y: CGFloat(hLine.position) - kCrossHandlerViewSize / 2, width: kCrossHandlerViewSize, height: kCrossHandlerViewSize))
				if !crossHandlers.map({ $0.frame }).contains(crossHandler.frame) {
					crossHandlers.append(crossHandler)
				}
			}
		}

		if NSScreen.screen(at: screenIndex) == NSScreen.screenMouse {
			if let point = StatusBarButton.point {
				switch StatusBarButton.orientation {
				case .horizontal:
					let linePath = NSBezierPath()
					linePath.move(to: CGPoint(x: 0, y: point.y))
					linePath.line(to: CGPoint(x: self.frame.width, y: point.y))
					Line.color(for: lineColor).setStroke()
					linePath.stroke()
				case .vertical:
					let linePath = NSBezierPath()
					linePath.move(to: CGPoint(x: point.x, y: 0))
					linePath.line(to: CGPoint(x: point.x, y: self.frame.height))
					Line.color(for: lineColor).setStroke()
					linePath.stroke()
				}
			}

			if let startPoint = StatusBarRectangle.startPoint, let endPoint = StatusBarRectangle.endPoint {
				let verticalGuides = StatusBarRectangle.verticalGuides
				let horzontalGuideGuides = StatusBarRectangle.horzontalGuideGuides

				let minX = Int(min(startPoint.x, endPoint.x))
				let maxX = Int(max(startPoint.x, endPoint.x))
				let deltaX = abs(maxX - minX) / (verticalGuides - 1)

				let minY = Int(min(startPoint.y, endPoint.y))
				let maxY = Int(max(startPoint.y, endPoint.y))
				let deltaY = abs(maxY - minY) / (horzontalGuideGuides - 1)

				var x = minX
				for _ in 0...verticalGuides - 1 {
					let linePath = NSBezierPath()
					linePath.move(to: CGPoint(x: x, y: 0))
					linePath.line(to: CGPoint(x: x, y: Int(self.frame.height)))
					Line.color(for: lineColor).setStroke()
					linePath.stroke()
					x += deltaX
				}

				var y = minY
				for _ in 0...horzontalGuideGuides - 1 {
					let linePath = NSBezierPath()
					linePath.move(to: CGPoint(x: 0, y: y))
					linePath.line(to: CGPoint(x: Int(self.frame.width), y: y))
					Line.color(for: lineColor).setStroke()
					linePath.stroke()
					y += deltaY
				}
			}
		}

		if let selectedLine = lines.filter({ $0.selected }).first, let guideHandler = guideHandlers.first(where: { $0.line.id == selectedLine.id }) {
			guideHandlers.moveToLast(element: guideHandler)
		}

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
			let minX = vLines.map { $0.position }.min() ?? 0
			let maxX = vLines.map { $0.position }.max() ?? Int(bounds.width)
			let minY = hLines.map { $0.position }.min() ?? 0
			let maxY = hLines.map { $0.position }.max() ?? Int(bounds.height)

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

		drawHorizontalValues(displayDimensions: displayDimensions, lineHorizontalHandler: lineHorizontalHandler, hLines: hLines)
		drawVerticalValues(displayDimensions: displayDimensions, lineVerticalHandler: lineVerticalHandler, vLines: vLines)
		drawGuideHandlers(guideHandlers: guideHandlers, lineHorizontalHandler: lineHorizontalHandler, lineVerticalHandler: lineVerticalHandler)
		drawCrossHandler(crossHandlers: crossHandlers)
		drawCursor(guideHandler: selectedGuideHandler, crossHandler: selectedCrossHandler, lineHorizontalHandler: lineHorizontalHandler, lineVerticalHandler: lineVerticalHandler)
	}
}
