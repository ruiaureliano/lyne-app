import Cocoa

extension PreferencesWindowController {

	@IBAction func generalToolbarItemPress(_ item: NSToolbarItem) {
		setPreferenceTab(tab: .general)
	}

	@IBAction func appearanceToolbarItemItemPress(_ item: NSToolbarItem) {
		setPreferenceTab(tab: .appearance)
	}

	@IBAction func layoutsToolbarItemItemPress(_ item: NSToolbarItem) {
		setPreferenceTab(tab: .layouts)
	}

	@IBAction func shortcutsToolbarItemPress(_ item: NSToolbarItem) {
		setPreferenceTab(tab: .shortcuts)
	}

	@IBAction func aboutToolbarItemPress(_ item: NSToolbarItem) {
		setPreferenceTab(tab: .about)
	}
}
