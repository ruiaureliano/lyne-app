import Cocoa

extension OnboardingViewController {

	@IBAction func switchButtonPress(_ button: NSSwitch) {
		switch button {
		case loginSwitchButton:
			if button.state == .on {
				Preferences.shared.startLogin = true
			} else {
				Preferences.shared.startLogin = false
			}
		case eventsSwitchButton:
			if button.state == .on {
				Preferences.shared.trackEvents = true
			} else {
				Preferences.shared.trackEvents = false
			}
		default:
			break
		}
	}

	@IBAction func bottomPreviousButtonPress(_ button: NSButton) {
		switch page {
		case .welcome:
			break
		case .login:
			setPage(page: .welcome, animated: true)
		case .events:
			setPage(page: .login, animated: true)
		}
	}

	@IBAction func bottomNextButtonPress(_ button: NSButton) {
		switch page {
		case .welcome:
			setPage(page: .login, animated: true)
		case .login:
			setPage(page: .events, animated: true)
		case .events:
			break
		}
	}

	@IBAction func bottomDoneButtonPress(_ button: NSButton) {
		onboardingWindowController?.closeWindow()
	}
}
