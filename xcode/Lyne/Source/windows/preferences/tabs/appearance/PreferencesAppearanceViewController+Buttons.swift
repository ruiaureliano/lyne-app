import Cocoa

extension PreferencesAppearanceViewController {

	@IBAction func useSystemColorsValueChange(_ button: NSSwitch) {
		Preferences.shared.useSytemColors = (button.state == .on)
		previewGuides.update()
	}

	@IBAction func lineColorAlphaValueChanged(_ slider: PreferencesAppearanceSlider) {
		Preferences.shared.lineColorAlpha = (slider.doubleValue.rounded() / 100)
		previewGuides.update()
	}

	@IBAction func lineColorStrokeValueChanged(_ segmented: NSSegmentedControl) {
		switch lineColorStrokeValue.selectedSegment {
		case 0:
			Preferences.shared.lineStroke = .solid
		case 1:
			Preferences.shared.lineStroke = .dashed
		case 2:
			Preferences.shared.lineStroke = .dotted
		default:
			break
		}
		previewGuides.update()
	}

	@IBAction func outsideInterceptionsValueChange(_ button: NSSwitch) {
		if button.state == .on {
			Preferences.shared.outsideInterceptions = .inside
		} else {
			Preferences.shared.outsideInterceptions = .none
		}
		previewGuides.update()
	}

	@IBAction func outsideInterceptionsAlphaValueChanged(_ slider: PreferencesAppearanceSlider) {
		Preferences.shared.outsideInterceptionsAlpha = (slider.doubleValue.rounded() / 100)
		previewGuides.update()
	}

	@IBAction func outsideInterceptionsStrokeValueChanged(_ segmented: NSSegmentedControl) {
		switch outsideInterceptionsStrokeValue.selectedSegment {
		case 0:
			Preferences.shared.outsideInterceptionsStroke = .solid
		case 1:
			Preferences.shared.outsideInterceptionsStroke = .dashed
		case 2:
			Preferences.shared.outsideInterceptionsStroke = .dotted
		default:
			break
		}
		previewGuides.update()
	}

	@IBAction func lineHorizontalHandlerValuePress(_ button: NSPopUpButton) {
		if let title = button.selectedItem?.title, let lineHorizontalHandler = LineHorizontalHandler(rawValue: title) {
			Preferences.shared.lineHorizontalHandler = lineHorizontalHandler
		} else {
			Preferences.shared.lineHorizontalHandler = .left
		}
		previewGuides.update()
	}

	@IBAction func lineVerticalHandlerValuePress(_ button: NSPopUpButton) {
		if let title = button.selectedItem?.title, let lineVerticalHandler = LineVerticalHandler(rawValue: title) {
			Preferences.shared.lineVerticalHandler = lineVerticalHandler
		} else {
			Preferences.shared.lineVerticalHandler = .bottom
		}
		previewGuides.update()
	}

	@IBAction func displayDimensionsValuePress(_ button: NSSwitch) {
		Preferences.shared.displayDimensions = (button.state == .on)
		previewGuides.update()
	}

	@IBAction func showDesktopValuePress(_ button: NSSwitch) {
		Preferences.shared.showDesktop = (button.state == .on)
		previewGuidesBackground.showDesktop = Preferences.shared.showDesktop
		(NSApp.delegate as? AppDelegate)?.getWallpapers()
		previewGuides.update()
	}

	@IBAction func resetAppearanceButtonPress(_ button: NSButton) {
		let alert = NSAlert()
		alert.messageText = "Reset Appearance"
		alert.informativeText = "Are you sure you want to reset app appearance?"
		alert.alertStyle = .informational
		alert.addButton(withTitle: "OK")
		alert.addButton(withTitle: "Cancel")

		if let window = NSApp.mainWindow {
			alert.beginSheetModal(for: window) { response in
				if response.rawValue == 1000 {
					Preferences.shared.resetAppearance(notify: true)
					self.previewGuides.update()
				}
			}
		} else {
			let response = alert.runModal()
			if response.rawValue == 1000 {
				Preferences.shared.resetAppearance(notify: true)
				self.previewGuides.update()
			}
		}
	}
}
