import Cocoa

class GuideWindow: NSWindow {

	var screenName: String = ""
	var screenIndex: Int = 0

	var isDragging: Bool = false { didSet { (self.contentView as? GuideWindowView)?.isDragging = isDragging } }
	var dragCount: Int = 0
	var isDuplicated: Bool = false

	var isShiftReversed = false

	var isDynamicLeft: Bool = true
	var isDynamicTop: Bool = true

	override var canBecomeKey: Bool {
		return true
	}

	init(contentRect: NSRect, screenName: String, screenIndex: Int) {
		super.init(contentRect: contentRect, styleMask: .borderless, backing: .buffered, defer: false)
		self.contentView = GuideWindowView()
		self.backgroundColor = .clear
		self.level = .gridLevel
		self.screenName = screenName
		self.screenIndex = screenIndex
		self.acceptMouse(accept: false)
		(self.contentView as? GuideWindowView)?.update(guideWindow: self, screenName: screenName, screenIndex: screenIndex)
		NotificationCenter.observe(self, selector: #selector(guideLinesChangedNotification(_:)), name: .guideLinesDidChanged)
	}

	@objc private func guideLinesChangedNotification(_ notification: Notification) {
		updateGuideView()
	}

	func updateGuideView() {
		(self.contentView as? GuideWindowView)?.isDynamicLeft = isDynamicLeft
		(self.contentView as? GuideWindowView)?.isDynamicTop = isDynamicTop
		(self.contentView as? GuideWindowView)?.needsDisplay = true
	}

	override func performKeyEquivalent(with event: NSEvent) -> Bool {
		if StatusBarButton.dragCount > kDragCountTolerance {
			if let keyboard = HotKeyCode(rawValue: Int(event.keyCode)) {
				switch keyboard {
				case .a:
					break
				case .d:
					break
				case .l:
					break
				case .r:
					StatusBarButton.toggle()
					switch StatusBarButton.orientation {
					case .horizontal:
						NSCursor.cursorHorizontal().set()
					case .vertical:
						NSCursor.cursorVertical().set()
					}
					NotificationCenter.notify(name: .guideLinesDidChanged)
					return true
				case .backspace:
					break
				case .left:
					break
				case .right:
					break
				case .down:
					break
				case .up:
					break
				case .esc:
					StatusBarButton.reset()
					StatusBarRectangle.reset()
					StatusBarButton.cancel = true
					NSCursor.cursorStandard().set()
					(NSApp.delegate as? AppDelegate)?.setGuidesAcceptMouse(accept: false)
					NotificationCenter.notify(name: .guideLinesDidChanged)
					return true
				}
			}
		} else {
			return HotKeyCode(rawValue: Int(event.keyCode)) != nil
		}
		return false
	}

	func acceptMouse(accept: Bool, fileID: String = #fileID, line: Int = #line, function: String = #function) {
		self.ignoresMouseEvents = !accept
	}
}
