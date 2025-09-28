import Cocoa

class PreferencesLayoutsViewController: NSViewController {

	@IBOutlet weak var addLayoutButton: NSButton!
	@IBOutlet weak var removeLayoutButton: NSButton!
	@IBOutlet weak var layoutsTable: NSTableView!
	@IBOutlet weak var resetLayoutsButton: NSButton!

	override func viewDidLoad() {
		super.viewDidLoad()
		NotificationCenter.observe(self, selector: #selector(preferencesDidChangedNotification(_:)), name: .preferencesDidChanged)
		updateView()
	}

	override func viewDidAppear() {
		super.viewDidAppear()
		self.view.window?.makeFirstResponder(nil)
	}

	@objc private func preferencesDidChangedNotification(_ notification: Notification) {
		updateView()
	}

	private func updateView() {
		reloadLayouts()
	}

	func reloadLayouts() {
		DispatchQueue.main.async {
			self.layoutsTable.reloadData()
		}
	}
}
