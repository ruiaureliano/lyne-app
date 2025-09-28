import Cocoa

class PreferencesAppearanceViewController: NSViewController {

	@IBOutlet weak var useSystemColorsLabel: NSTextField!
	@IBOutlet weak var useSystemColorsValue: NSSwitch!

	@IBOutlet weak var blueViewColor: PreferencesAppearanceViewColor!
	@IBOutlet weak var purpleViewColor: PreferencesAppearanceViewColor!
	@IBOutlet weak var pinkViewColor: PreferencesAppearanceViewColor!
	@IBOutlet weak var redViewColor: PreferencesAppearanceViewColor!
	@IBOutlet weak var orangeViewColor: PreferencesAppearanceViewColor!
	@IBOutlet weak var yellowViewColor: PreferencesAppearanceViewColor!
	@IBOutlet weak var greenViewColor: PreferencesAppearanceViewColor!
	@IBOutlet weak var graphiteViewColor: PreferencesAppearanceViewColor!
	@IBOutlet weak var multipleViewColor: PreferencesAppearanceViewColor!

	@IBOutlet weak var lineColorAlphaLabel: NSTextField!
	@IBOutlet weak var lineColorAlphaValue: PreferencesAppearanceSlider!

	@IBOutlet weak var lineColorStrokeLabel: NSTextField!
	@IBOutlet weak var lineColorStrokeValue: NSSegmentedControl!

	@IBOutlet weak var outsideInterceptionsLabel: NSTextField!
	@IBOutlet weak var outsideInterceptionsValue: NSSwitch!

	@IBOutlet weak var outsideInterceptionsAlphaLabel: NSTextField!
	@IBOutlet weak var outsideInterceptionsAlphaValue: PreferencesAppearanceSlider!

	@IBOutlet weak var outsideInterceptionsStrokeLabel: NSTextField!
	@IBOutlet weak var outsideInterceptionsStrokeValue: NSSegmentedControl!

	@IBOutlet weak var lineHorizontalHandlerLabel: NSTextField!
	@IBOutlet weak var lineHorizontalHandlerValue: NSPopUpButton!

	@IBOutlet weak var lineVerticalHandlerLabel: NSTextField!
	@IBOutlet weak var lineVerticalHandlerValue: NSPopUpButton!

	@IBOutlet weak var displayDimensionsLabel: NSTextField!
	@IBOutlet weak var displayDimensionsValue: NSSwitch!

	@IBOutlet weak var showDesktopLabel: NSTextField!
	@IBOutlet weak var showDesktopValue: NSSwitch!

	@IBOutlet weak var previewGuidesBackground: PreferencesAppearancePreviewBackground!
	@IBOutlet weak var previewGuides: PreferencesAppearancePreview!

	@IBOutlet weak var resetAppearanceButton: NSButton!

	override func viewDidLoad() {
		super.viewDidLoad()

		blueViewColor.delegate = self
		purpleViewColor.delegate = self
		pinkViewColor.delegate = self
		redViewColor.delegate = self
		orangeViewColor.delegate = self
		yellowViewColor.delegate = self
		greenViewColor.delegate = self
		graphiteViewColor.delegate = self
		multipleViewColor.delegate = self

		updateView()
		NotificationCenter.observe(self, selector: #selector(preferencesDidChangedNotification(_:)), name: .preferencesDidChanged)
	}

	override func viewDidAppear() {
		super.viewDidAppear()
		self.view.window?.makeFirstResponder(nil)
		(NSApp.delegate as? AppDelegate)?.getWallpapers()
	}

	@objc private func preferencesDidChangedNotification(_ notification: Notification) {
		updateView()
	}

	private func updateView() {
		useSystemColorsValue.state = (Preferences.shared.useSytemColors ? .on : .off)

		blueViewColor.enabled = !Preferences.shared.useSytemColors
		purpleViewColor.enabled = !Preferences.shared.useSytemColors
		pinkViewColor.enabled = !Preferences.shared.useSytemColors
		redViewColor.enabled = !Preferences.shared.useSytemColors
		orangeViewColor.enabled = !Preferences.shared.useSytemColors
		yellowViewColor.enabled = !Preferences.shared.useSytemColors
		greenViewColor.enabled = !Preferences.shared.useSytemColors
		graphiteViewColor.enabled = !Preferences.shared.useSytemColors
		multipleViewColor.enabled = !Preferences.shared.useSytemColors

		if let lineColor = LineColor(rawValue: Preferences.shared.lineColor) {
			blueViewColor.selected = (lineColor == .blue)
			purpleViewColor.selected = (lineColor == .purple)
			pinkViewColor.selected = (lineColor == .pink)
			redViewColor.selected = (lineColor == .red)
			orangeViewColor.selected = (lineColor == .orange)
			yellowViewColor.selected = (lineColor == .yellow)
			greenViewColor.selected = (lineColor == .green)
			graphiteViewColor.selected = (lineColor == .graphite)
			multipleViewColor.selected = false
		} else {
			blueViewColor.selected = false
			purpleViewColor.selected = false
			pinkViewColor.selected = false
			redViewColor.selected = false
			orangeViewColor.selected = false
			yellowViewColor.selected = false
			greenViewColor.selected = false
			graphiteViewColor.selected = false
			multipleViewColor.selected = false
			multipleViewColor.selected = true
		}

		lineColorAlphaValue.doubleValue = Preferences.shared.lineColorAlpha * 100

		switch Preferences.shared.lineStroke {
		case .solid:
			lineColorStrokeValue.selectedSegment = 0
		case .dashed:
			lineColorStrokeValue.selectedSegment = 1
		case .dotted:
			lineColorStrokeValue.selectedSegment = 2
		}

		switch Preferences.shared.outsideInterceptions {
		case .none:
			outsideInterceptionsValue.state = .off
			outsideInterceptionsAlphaValue.isEnabled = false
			outsideInterceptionsStrokeValue.isEnabled = false
		case .inside:
			outsideInterceptionsValue.state = .on
			outsideInterceptionsAlphaValue.isEnabled = true
			outsideInterceptionsStrokeValue.isEnabled = true
		}

		outsideInterceptionsAlphaValue.doubleValue = Preferences.shared.outsideInterceptionsAlpha * 100

		switch Preferences.shared.outsideInterceptionsStroke {
		case .solid:
			outsideInterceptionsStrokeValue.selectedSegment = 0
		case .dashed:
			outsideInterceptionsStrokeValue.selectedSegment = 1
		case .dotted:
			outsideInterceptionsStrokeValue.selectedSegment = 2
		}

		self.lineHorizontalHandlerValue.removeAllItems()
		for value in LineHorizontalHandler.allCases {
			self.lineHorizontalHandlerValue.addItem(withTitle: value.rawValue)
		}
		self.lineHorizontalHandlerValue.selectItem(withTitle: Preferences.shared.lineHorizontalHandler.rawValue)

		self.lineVerticalHandlerValue.removeAllItems()
		for value in LineVerticalHandler.allCases {
			self.lineVerticalHandlerValue.addItem(withTitle: value.rawValue)
		}
		self.lineVerticalHandlerValue.selectItem(withTitle: Preferences.shared.lineVerticalHandler.rawValue)

		self.displayDimensionsValue.state = (Preferences.shared.displayDimensions ? .on : .off)

		self.showDesktopValue.state = (Preferences.shared.showDesktop ? .on : .off)
		self.previewGuidesBackground.showDesktop = Preferences.shared.showDesktop
	}
}
