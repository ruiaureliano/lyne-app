import Cocoa

let kCloseMenuDelay: TimeInterval = 2
let kDragCountTolerance: Int = 15

class StatusBarButton: NSObject, Codable {
	static var point: CGPoint?
	static var dragCount: Int = 0
	static var orientation: LineOrientation = .vertical
	static var dragShow: Bool = false
	static var cancel: Bool = false

	static func toggle() {
		orientation = (orientation == .horizontal ? .vertical : .horizontal)
	}

	static func reset() {
		point = nil
		dragCount = 0
		orientation = .vertical
		dragShow = false
		cancel = false
	}
}

class StatusBarRectangle: NSObject, Codable {
	static var resizing: Bool = false
	static var startPoint: CGPoint?
	static var endPoint: CGPoint?
	static var verticalGuides: Int = 2
	static var horzontalGuideGuides: Int = 2

	static func reset() {
		resizing = false
		startPoint = nil
		endPoint = nil
		verticalGuides = 2
		horzontalGuideGuides = 2
	}
}

extension NSStatusBarButton {

	open override func mouseDown(with event: NSEvent) {}

	open override func mouseUp(with event: NSEvent) {
		if StatusBarButton.dragCount < kDragCountTolerance - 1 {
			super.mouseDown(with: event)
		} else {
			if !StatusBarButton.cancel, let screen = NSScreen.screenMouse, let point = StatusBarButton.point {
				switch StatusBarButton.orientation {
				case .horizontal:
					if Guide.shared.addLine(position: Int(point.y - screen.frame.origin.y), orientation: .horizontal, screenIndex: screen.screenIndex) {
						NotificationCenter.notify(name: .guideLinesDidChanged)
					}
				case .vertical:
					if Guide.shared.addLine(position: Int(point.x - screen.frame.origin.x), orientation: .vertical, screenIndex: screen.screenIndex) {
						NotificationCenter.notify(name: .guideLinesDidChanged)
					}
				}
			}
		}
		StatusBarButton.reset()
		if !StatusBarRectangle.resizing {
			NSCursor.cursorStandard().set()
			(NSApp.delegate as? AppDelegate)?.setGuidesAcceptMouse(accept: false)
		}
	}

	open override func mouseDragged(with event: NSEvent) {
		StatusBarButton.dragCount += 1
		StatusBarButton.point = NSEvent.mouseLocation
		if StatusBarButton.dragCount > kDragCountTolerance && !StatusBarButton.cancel {
			switch StatusBarButton.orientation {
			case .horizontal:
				NSCursor.cursorHorizontal().set()
			case .vertical:
				NSCursor.cursorVertical().set()
			}
			NSApp.activate(ignoringOtherApps: true)
			(NSApp.delegate as? AppDelegate)?.setGuidesAcceptMouse(accept: true)
			if !StatusBarButton.dragShow {
				StatusBarButton.dragShow = true
				if let screen = NSScreen.screenMouse {
					let screenIndex = screen.screenIndex
					if Settings.shared.screenIndexHiddenGuides.contains(screenIndex) {
						Settings.shared.screenIndexHiddenGuides.removeAll { $0 == screenIndex }
						NotificationCenter.notify(name: .screenDidChanged)
					}
				}
			}
			NotificationCenter.notify(name: .guideLinesDidChanged)
		} else {
			NSCursor.cursorStandard().set()
		}
	}
}

extension AppDelegate {

	var statusIconPoint: CGPoint {
		if let frame = statusItem.button?.window?.frame {
			return CGPoint(x: frame.midX, y: frame.minY)
		}
		return .zero
	}
}
