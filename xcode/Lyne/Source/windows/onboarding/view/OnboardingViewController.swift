import Cocoa

enum OnboardingWindowPage: String, Codable {
	case welcome
	case login
	case events
}

class OnboardingViewController: NSViewController {

	@IBOutlet weak var welcomeTitleField: NSLabel!
	@IBOutlet weak var welcomeSubtitleField: NSWrapLabel!

	@IBOutlet weak var loginTitleField: NSLabel!
	@IBOutlet weak var loginSubtitleField: NSWrapLabel!
	@IBOutlet weak var loginSwitchButton: NSSwitch!

	@IBOutlet weak var eventsTitleField: NSLabel!
	@IBOutlet weak var eventsSubtitleField: NSWrapLabel!
	@IBOutlet weak var eventsSwitchButton: NSSwitch!

	@IBOutlet weak var bottomPreviousButton: NSButton!
	@IBOutlet weak var bottomBulletWelcome: NSImageView!
	@IBOutlet weak var bottomBulletLogin: NSImageView!
	@IBOutlet weak var bottomBulletEvents: NSImageView!
	@IBOutlet weak var bottomNextButton: NSButton!
	@IBOutlet weak var bottomDoneButton: NSButton!

	@IBOutlet weak var pageLeftConstraint: NSLayoutConstraint!

	var page: OnboardingWindowPage = .welcome
	var onboardingWindowController: OnboardingWindowController?
	private var kvo: NSKeyValueObservation?
	private var loginChanged: Bool = false

	override func viewDidLoad() {
		super.viewDidLoad()
		setPage(page: page, animated: false)
		updateView()
		NotificationCenter.observe(self, selector: #selector(preferencesDidChangedNotification(_:)), name: .preferencesDidChanged)
		kvo = bottomDoneButton.observe(\.effectiveAppearance, options: .new) { _, _ in
			self.setPage(page: self.page, animated: false)
		}
	}

	@objc private func preferencesDidChangedNotification(_ notification: Notification) {
		updateView()
	}

	private func updateView() {
		loginSwitchButton.state = LoginItem.enabled ? .on : .off
		eventsSwitchButton.state = Preferences.shared.trackEvents ? .on : .off
	}

	func setPage(page: OnboardingWindowPage, animated: Bool) {
		self.page = page
		switch page {
		case .welcome:
			bottomBulletWelcome.image = bottomBulletWelcome.image?.tint(color: .controlAccentColor)
			bottomBulletLogin.image = bottomBulletLogin.image?.tint(color: .black)
			bottomBulletEvents.image = bottomBulletEvents.image?.tint(color: .black)
			if animated {
				bottomPreviousButton.animator().isHidden = true
				bottomBulletWelcome.animator().alphaValue = 1
				bottomBulletLogin.animator().alphaValue = 0.2
				bottomBulletEvents.animator().alphaValue = 0.2
				bottomNextButton.animator().isHidden = false
				bottomDoneButton.animator().isHidden = true
				pageLeftConstraint.animator().constant = 0
			} else {
				bottomPreviousButton.isHidden = true
				bottomBulletWelcome.alphaValue = 1
				bottomBulletLogin.alphaValue = 0.2
				bottomBulletEvents.alphaValue = 0.2
				bottomNextButton.isHidden = false
				bottomDoneButton.isHidden = true
				pageLeftConstraint.constant = 0
			}
		case .login:
			bottomBulletWelcome.image = bottomBulletWelcome.image?.tint(color: .black)
			bottomBulletLogin.image = bottomBulletLogin.image?.tint(color: .controlAccentColor)
			bottomBulletEvents.image = bottomBulletEvents.image?.tint(color: .black)
			if animated {
				bottomPreviousButton.animator().isHidden = false
				bottomBulletWelcome.animator().alphaValue = 0.2
				bottomBulletLogin.animator().alphaValue = 1
				bottomBulletEvents.animator().alphaValue = 0.2
				bottomNextButton.animator().isHidden = false
				bottomDoneButton.animator().isHidden = true
				pageLeftConstraint.animator().constant = -400
			} else {
				bottomPreviousButton.isHidden = false
				bottomBulletWelcome.alphaValue = 0.2
				bottomBulletLogin.alphaValue = 1
				bottomBulletEvents.alphaValue = 0.2
				bottomNextButton.isHidden = false
				bottomDoneButton.isHidden = true
				pageLeftConstraint.constant = -400
			}
			if !loginChanged {
				loginSwitchButton.state = .on
				Preferences.shared.startLogin = true
				loginChanged = true
			}
		case .events:
			bottomBulletWelcome.image = bottomBulletWelcome.image?.tint(color: .black)
			bottomBulletLogin.image = bottomBulletLogin.image?.tint(color: .black)
			bottomBulletEvents.image = bottomBulletEvents.image?.tint(color: .controlAccentColor)
			if animated {
				bottomPreviousButton.animator().isHidden = false
				bottomBulletWelcome.animator().alphaValue = 0.2
				bottomBulletLogin.animator().alphaValue = 0.2
				bottomBulletEvents.animator().alphaValue = 1
				bottomNextButton.animator().isHidden = true
				bottomDoneButton.animator().isHidden = false
				pageLeftConstraint.animator().constant = -800
			} else {
				bottomPreviousButton.isHidden = false
				bottomBulletWelcome.alphaValue = 0.2
				bottomBulletLogin.alphaValue = 0.2
				bottomBulletEvents.alphaValue = 1
				bottomNextButton.isHidden = true
				bottomDoneButton.isHidden = false
				pageLeftConstraint.constant = -800
			}
		}
		bottomDoneButton.image = bottomDoneButton.image?.tint(color: .controlAccentColor)
	}
}
