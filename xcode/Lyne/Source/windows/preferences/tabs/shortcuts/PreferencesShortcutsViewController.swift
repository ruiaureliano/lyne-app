import Cocoa

class PreferencesShortcutsViewController: NSViewController {

	@IBOutlet weak var shortcutsTable: PreferencesShortcutsTableView!
	@IBOutlet weak var resetShortcutsButton: NSButton!

	var recordingIdentifier: HotKeyIdentifier? { didSet { shortcutsTable.recordingIdentifier = recordingIdentifier } }

	override func viewDidLoad() {
		super.viewDidLoad()
		shortcutsTable.recorderDelegate = self
		NotificationCenter.observe(self, selector: #selector(preferencesDidChangedNotification(_:)), name: .preferencesDidChanged)
		NotificationCenter.observe(self, selector: #selector(preferencesDidChangedNotification(_:)), name: .shortcutsDidChanged)
		updateView()
	}

	override func viewDidAppear() {
		super.viewDidAppear()
		self.view.window?.makeFirstResponder(nil)
	}

	@objc private func preferencesDidChangedNotification(_ notification: Notification) {
		updateView()
	}

	@objc private func shortcutsDidChangedNotification(_ notification: Notification) {
		updateView()
	}

	private func updateView() {
		reloadShortcuts()
	}

	func reloadShortcuts() {
		DispatchQueue.main.async {
			self.shortcutsTable.reloadData()
		}
	}
}
