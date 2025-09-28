import Cocoa

extension PreferencesAppearanceViewController: PreferencesAppearanceColorViewDelegate {

	func didPressColorView(colorView: PreferencesAppearanceViewColor) {
		switch colorView {
		case blueViewColor:
			Preferences.shared.lineColor = LineColor.blue.rawValue
		case purpleViewColor:
			Preferences.shared.lineColor = LineColor.purple.rawValue
		case pinkViewColor:
			Preferences.shared.lineColor = LineColor.pink.rawValue
		case redViewColor:
			Preferences.shared.lineColor = LineColor.red.rawValue
		case orangeViewColor:
			Preferences.shared.lineColor = LineColor.orange.rawValue
		case yellowViewColor:
			Preferences.shared.lineColor = LineColor.yellow.rawValue
		case greenViewColor:
			Preferences.shared.lineColor = LineColor.green.rawValue
		case graphiteViewColor:
			Preferences.shared.lineColor = LineColor.graphite.rawValue
		case multipleViewColor:
			let colorPanel = NSColorPanel.shared
			colorPanel.color = Line.color(for: Preferences.shared.lineColor)
			colorPanel.setTarget(self)
			colorPanel.isContinuous = true
			colorPanel.setAction(#selector(colorDidChange(_:)))
			colorPanel.center()
			colorPanel.makeKeyAndOrderFront(self)
		default:
			break
		}
		previewGuides.update()
	}

	@objc private func colorDidChange(_ colorPanel: NSColorPanel) {
		Preferences.shared.lineColor = colorPanel.color.hex
		previewGuides.update()
	}
}
