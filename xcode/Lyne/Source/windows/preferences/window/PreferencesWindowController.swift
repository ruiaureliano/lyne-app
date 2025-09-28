import Cocoa

enum PreferenceTabName: String {
	case general = "General"
	case appearance = "Appearance"
	case layouts = "Layouts"
	case shortcuts = "Shortcuts"
	case about = "About"
}

private let kGeneralHeight: CGFloat = 80 + 243
private let kAppearanceHeight: CGFloat = 80 + 470
private let kLayoutsHeight: CGFloat = 80 + 340
private let kShortcutsHeight: CGFloat = 80 + 280
private let kAboutHeight: CGFloat = 80 + 289

extension PreferencesWindowController {
	static var storyboardInstance: PreferencesWindowController? {
		let sceneIdentifier: NSStoryboard.SceneIdentifier = NSStoryboard.SceneIdentifier("PreferencesWindowController")
		return NSStoryboard(name: "Preferences", bundle: nil).instantiateController(withIdentifier: sceneIdentifier) as? PreferencesWindowController
	}
}

class PreferencesWindowController: NSWindowController {

	@IBOutlet weak var preferencesToolbar: NSToolbar!
	@IBOutlet weak var generalToolbarItem: NSToolbarItem!
	@IBOutlet weak var appearanceToolbarItem: NSToolbarItem!
	@IBOutlet weak var layoutsToolbarItem: NSToolbarItem!
	@IBOutlet weak var shortcutsToolbarItem: NSToolbarItem!
	@IBOutlet weak var aboutToolbarItem: NSToolbarItem!

	private var preferenceTab: PreferenceTabName = .general
	private var preferencesViewController: PreferencesViewController?

	var isOpen: Bool = false

	override func windowDidLoad() {
		super.windowDidLoad()
		self.window?.delegate = self
		self.window?.level = .preferencesLevel

		generalToolbarItem.image?.isTemplate = true
		appearanceToolbarItem.image?.isTemplate = true
		layoutsToolbarItem.image?.isTemplate = true
		shortcutsToolbarItem.image?.isTemplate = true
		aboutToolbarItem.image?.isTemplate = true

		if let preferencesViewController = self.contentViewController as? PreferencesViewController {
			self.preferencesViewController = preferencesViewController
			self.preferencesViewController?.preferencesWindowController = self
		}
		self.setPreferenceTab(tab: .general)
	}

	func openPreferencesWindow(tab: PreferenceTabName) {
		DispatchQueue.main.async {
			if let window = self.window {
				if !self.isOpen {
					window.center()
				}
				window.makeKeyAndOrderFront(self)
				self.setPreferenceTab(tab: tab)
				self.isOpen = true
			}
			NSApp.activate(ignoringOtherApps: true)
		}
	}

	func closeWindow() {
		DispatchQueue.main.async {
			if let window = self.window, self.isOpen {
				window.orderOut(self)
				self.isOpen = false
			}
		}
	}

	func setPreferenceTab(tab: PreferenceTabName) {
		self.preferenceTab = tab
		self.window?.title = tab.rawValue
		preferencesToolbar.selectedItemIdentifier = NSToolbarItem.Identifier(rawValue: tab.rawValue)
		preferencesViewController?.setPreferenceTab(tab: tab)

		switch self.preferenceTab {
		case .general:
			if let window = self.window {
				var frame = window.frame
				let gapY = frame.size.height - kGeneralHeight
				frame.origin.y += gapY
				frame.size.height = kGeneralHeight
				window.setFrame(frame, display: true, animate: true)
			}
		case .appearance:
			if let window = self.window {
				var frame = window.frame
				let gapY = frame.size.height - kAppearanceHeight
				frame.origin.y += gapY
				frame.size.height = kAppearanceHeight
				window.setFrame(frame, display: true, animate: true)
			}
		case .layouts:
			if let window = self.window {
				var frame = window.frame
				let gapY = frame.size.height - kLayoutsHeight
				frame.origin.y += gapY
				frame.size.height = kLayoutsHeight
				window.setFrame(frame, display: true, animate: true)
			}
		case .shortcuts:
			if let window = self.window {
				var frame = window.frame
				let gapY = frame.size.height - kShortcutsHeight
				frame.origin.y += gapY
				frame.size.height = kShortcutsHeight
				window.setFrame(frame, display: true, animate: true)
			}
		case .about:
			if let window = self.window {
				var frame = window.frame
				let gapY = frame.size.height - kAboutHeight
				frame.origin.y += gapY
				frame.size.height = kAboutHeight
				window.setFrame(frame, display: true, animate: true)
			}
		}
	}
}
