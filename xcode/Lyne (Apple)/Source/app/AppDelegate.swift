import Cocoa
import Mixpanel
import Sentry

private let kSentryDSN = "..."
private let kMixPanelToken = "..."

@main class AppDelegate: NSObject, NSApplicationDelegate {

	var hotKeyCenter = HotKeyCenter()

	var statusItem: NSStatusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
	var guideWindows: [GuideWindow] = []

	var preferencesWindowController: PreferencesWindowController?
	var onboardingWindowController: OnboardingWindowController?

	static var wallpapers: [NSScreen: NSImage] = [:]

	var tooltipStatusWindow: TooltipStatusWindow = TooltipStatusWindow()

	func applicationDidFinishLaunching(_ aNotification: Notification) {

		/* STATUS MENU */
		statusItem.button?.image = NSImage.menuIcon
		statusItem.button?.image?.isTemplate = true
		statusItem.menu = NSMenu()
		statusItem.menu?.delegate = self

		/* REGISTER HOTKEYS */
		registerHotKeys()

		/* DRAW GUIDES WINDOWS */
		buildGuidesWindows()

		/* REGISTER NOTIFICATIONS */
		registerNotifications()

		/* REGISTER EVENTS */
		registerEvents()

		/* WALLPAPERS*/
		getWallpapers()

		/* STORYBOARD INSTANCES */
		preferencesWindowController = PreferencesWindowController.storyboardInstance

		onboardingWindowController = OnboardingWindowController.storyboardInstance
		onboardingWindowController?.delegate = self

		/* ONBOARDING */
		if onboardingWindowController?.onboardingNeedsDisplay == true {
			onboardingWindowController?.openWindow()
		} else {
			DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
				self.tooltipStatusWindow.showText(point: self.statusIconPoint, text: "Lyne is ready to use!", closeAfter: kCloseMenuDelay)
			}
		}

		/* SENTRY CRASH REPORT */
		SentrySDK.start { options in
			options.dsn = kSentryDSN
			options.debug = false
			options.tracesSampleRate = 1.0
			options.profilesSampleRate = 1.0
			options.enableCaptureFailedRequests = false
			options.enableAppHangTracking = false
		}

		/* MIXPANEL ANALYTICS */
		Mixpanel.initialize(token: kMixPanelToken)
	}

	func applicationWillTerminate(_ aNotification: Notification) {
	}

	func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
		return true
	}
}
