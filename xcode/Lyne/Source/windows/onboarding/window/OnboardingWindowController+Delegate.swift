import Cocoa

extension OnboardingWindowController: NSWindowDelegate {

	func windowWillClose(_ notification: Notification) {
		isOpen = false
		delegate?.onboardWindowWillClose()
	}
}
