import Cocoa

let kTooltipStatusWindowPadding: CGFloat = 12
let kTooltipStatusWindowHeight: CGFloat = 31
let kTooltipStatusWindowAnimation: TimeInterval = 0.25
let kTooltipStatusWindowRadius: CGFloat = 6
let kTooltipStatusWindowFont: NSFont = NSFont.systemFont(ofSize: 13, weight: .regular)

class TooltipStatusWindow: NSWindow {

	var tooltipView: TooltipStatusView = TooltipStatusView()
	var tooltipTimer = Timer()
	var tooltipOn: Bool = false

	init() {
		super.init(contentRect: .zero, styleMask: .borderless, backing: .buffered, defer: false)
		self.isOpaque = false
		self.hasShadow = false
		self.isMovable = true
		self.isMovableByWindowBackground = false
		self.level = .tooltipLevel
		self.backgroundColor = .clear
		self.contentView = tooltipView
		tooltipView.autoresizingMask = [.width, .height]
	}

	func showText(point: CGPoint, text: String, closeAfter: TimeInterval) {
		DispatchQueue.main.async {
			self.tooltipView.updateWith(text: text, type: .text)
			self.showWindow(point: point, closeAfter: closeAfter)
		}
	}

	private func showWindow(point: CGPoint, closeAfter: TimeInterval) {
		let w = self.tooltipView.expectedWidth
		self.setFrame(NSRect(x: point.x - w / 2, y: point.y - kTooltipStatusWindowHeight - 5, width: w, height: kTooltipStatusWindowHeight), display: true)
		self.alphaValue = 0
		self.orderFrontRegardless()
		if self.tooltipTimer.isValid {
			self.tooltipTimer.invalidate()
		}
		self.tooltipOn = true
		NSAnimationContext.runAnimationGroup { context in
			context.duration = kTooltipStatusWindowAnimation
			self.animator().alphaValue = 1
		} completionHandler: {
			self.tooltipTimer = Timer.scheduledTimer(withTimeInterval: closeAfter, repeats: false) { _ in
				self.hide()
			}
		}
	}

	func hide() {
		DispatchQueue.main.async {
			NSAnimationContext.runAnimationGroup { context in
				context.duration = kTooltipStatusWindowAnimation
				self.animator().alphaValue = 0
			} completionHandler: {
				self.orderOut(nil)
				self.tooltipTimer.invalidate()
				self.tooltipOn = false
			}
		}
	}
}
