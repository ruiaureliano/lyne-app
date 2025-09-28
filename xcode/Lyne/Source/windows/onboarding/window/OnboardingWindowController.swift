import Cocoa

let kOnboardingWindowOpenDelay: TimeInterval = 2

private let kUserDefaultsOnboardingNeedsDisplay = "UserDefaultsOnboardingNeedsDisplay"

protocol OnboardingWindowControllerDelegate: AnyObject {
	func onboardWindowWillClose()
}

extension OnboardingWindowController {

	static var storyboardInstance: OnboardingWindowController? {
		let sceneIdentifier: NSStoryboard.SceneIdentifier = NSStoryboard.SceneIdentifier("OnboardingWindowController")
		return NSStoryboard(name: "Onboarding", bundle: nil).instantiateController(withIdentifier: sceneIdentifier) as? OnboardingWindowController
	}
}

class OnboardingWindowController: NSWindowController {

	var isOpen: Bool = false
	weak var delegate: OnboardingWindowControllerDelegate?

	var onboardingNeedsDisplay: Bool {
		get {
			return UserDefaults.standard.object(forKey: kUserDefaultsOnboardingNeedsDisplay) as? Bool ?? true
		}
		set {
			UserDefaults.standard.setValue(newValue, forKey: kUserDefaultsOnboardingNeedsDisplay)
			UserDefaults.standard.synchronize()
		}
	}

	override func windowDidLoad() {
		super.windowDidLoad()
		self.window?.backgroundColor = .textBackgroundColor
		self.window?.delegate = self
		self.window?.isMovableByWindowBackground = true
		self.hideStandardWindowButtons()
		(self.contentViewController as? OnboardingViewController)?.onboardingWindowController = self
	}

	func openWindow(after: TimeInterval = kOnboardingWindowOpenDelay) {
		if onboardingNeedsDisplay {
			DispatchQueue.main.asyncAfter(deadline: .now() + after) {
				guard let window = self.window else { return }
				if !self.isOpen {
					self.isOpen = true
					window.center()
				}
				window.makeFirstResponder(nil)
				window.makeKeyAndOrderFront(self)
				NSApp.activate(ignoringOtherApps: true)
			}
		}
	}

	func closeWindow() {
		if isOpen {
			DispatchQueue.main.async {
				guard let window = self.window else { return }
				window.orderOut(self)
				self.isOpen = false
				self.onboardingNeedsDisplay = false
				self.delegate?.onboardWindowWillClose()
			}
		}
	}

	private func hideStandardWindowButtons() {
		guard
			let window = self.window,
			let closeButton = window.standardWindowButton(.closeButton),
			let miniaturizeButton = window.standardWindowButton(.miniaturizeButton),
			let zoomButton = window.standardWindowButton(.zoomButton)
		else {
			return
		}

		closeButton.isHidden = true
		miniaturizeButton.isHidden = true
		zoomButton.isHidden = true
	}

	static func reset() {
		UserDefaults.standard.removeObject(forKey: kUserDefaultsOnboardingNeedsDisplay)
		UserDefaults.standard.synchronize()
		self.load()
	}
}
