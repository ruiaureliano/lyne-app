import Cocoa

class PreferencesViewController: NSViewController {

	var preferencesGeneralViewController: PreferencesGeneralViewController?
	var preferencesAppearanceViewController: PreferencesAppearanceViewController?
	var preferencesLayoutsViewController: PreferencesLayoutsViewController?
	var preferencesShortcutsViewController: PreferencesShortcutsViewController?
	var preferencesAboutViewController: PreferencesAboutViewController?
	var preferencesWindowController: PreferencesWindowController?

	override func prepare(for segue: NSStoryboardSegue, sender: Any?) {
		super.prepare(for: segue, sender: sender)
		if let preferencesGeneralViewController = segue.destinationController as? PreferencesGeneralViewController {
			self.preferencesGeneralViewController = preferencesGeneralViewController
		}
		if let preferencesAppearanceViewController = segue.destinationController as? PreferencesAppearanceViewController {
			self.preferencesAppearanceViewController = preferencesAppearanceViewController
		}
		if let preferencesLayoutsViewController = segue.destinationController as? PreferencesLayoutsViewController {
			self.preferencesLayoutsViewController = preferencesLayoutsViewController
		}
		if let preferencesShortcutsViewController = segue.destinationController as? PreferencesShortcutsViewController {
			self.preferencesShortcutsViewController = preferencesShortcutsViewController
		}
		if let preferencesAboutViewController = segue.destinationController as? PreferencesAboutViewController {
			self.preferencesAboutViewController = preferencesAboutViewController
		}
	}

	func setPreferenceTab(tab: PreferenceTabName) {
		preferencesGeneralViewController?.view.isHidden = (tab != .general)
		preferencesAppearanceViewController?.view.isHidden = (tab != .appearance)
		preferencesLayoutsViewController?.view.isHidden = (tab != .layouts)
		preferencesShortcutsViewController?.view.isHidden = (tab != .shortcuts)
		preferencesAboutViewController?.view.isHidden = (tab != .about)
	}
}
