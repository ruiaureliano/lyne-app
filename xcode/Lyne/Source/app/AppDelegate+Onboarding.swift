import Cocoa

extension AppDelegate: OnboardingWindowControllerDelegate {

	func onboardWindowWillClose() {
		DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
			self.tooltipStatusWindow.showText(point: self.statusIconPoint, text: "Lyne is ready to use!", closeAfter: kCloseMenuDelay)
		}
	}
}
