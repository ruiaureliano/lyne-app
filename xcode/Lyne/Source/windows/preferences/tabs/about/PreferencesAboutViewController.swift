import Cocoa

class PreferencesAboutViewController: NSViewController {

	@IBOutlet weak var aboutAppIconView: NSImageView!
	@IBOutlet weak var aboutAppNameLabel: NSTextField!
	@IBOutlet weak var aboutAppVersionLabel: NSTextField!
	@IBOutlet weak var aboutAppBuildLabel: NSTextField!
	@IBOutlet weak var aboutAppCopyrightLabel: NSTextField!
	@IBOutlet weak var contactUsButton: NSButton!

	override func viewDidLoad() {
		super.viewDidLoad()
		updateView()
		NotificationCenter.observe(self, selector: #selector(preferencesDidChangedNotification(_:)), name: .preferencesDidChanged)
	}

	override func viewDidAppear() {
		super.viewDidAppear()
		self.view.window?.makeFirstResponder(nil)
	}

	@objc private func preferencesDidChangedNotification(_ notification: Notification) {
		updateView()
	}

	private func updateView() {
		self.aboutAppBuildLabel.stringValue = "\(AppDelegate.version ?? "1.0") (\(AppDelegate.build ?? "100"))"
		self.aboutAppCopyrightLabel.stringValue = "© Olá Brothers, \(Date().string(with: "yyyy"))"
	}
}
