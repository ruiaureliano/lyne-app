import Cocoa

class PreferencesGeneralViewController: NSViewController {

	@IBOutlet weak var startupLabel: NSTextField!
	@IBOutlet weak var startupValue: NSButton!

	@IBOutlet weak var playSoundsLabel: NSTextField!
	@IBOutlet weak var playSoundsValue: NSButton!

	@IBOutlet weak var trackEventsLabel: NSTextField!
	@IBOutlet weak var trackEventsValue: NSButton!
	@IBOutlet weak var trackEventsInfo: NSTextField!

	@IBOutlet weak var resetPreferencesButton: NSButton!

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
		self.startupValue.state = (Preferences.shared.startLogin ? .on : .off)
		self.playSoundsValue.state = (Preferences.shared.playSounds ? .on : .off)
		self.trackEventsValue.state = (Preferences.shared.trackEvents ? .on : .off)
	}
}
