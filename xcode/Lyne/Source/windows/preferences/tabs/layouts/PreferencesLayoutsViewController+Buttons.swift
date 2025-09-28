import Cocoa

extension PreferencesLayoutsViewController {

	@IBAction func addLayoutButtonPress(_ button: NSButton) {
		let alert = NSAlert()
		alert.alertStyle = .informational
		alert.messageText = "Add Layout"
		alert.informativeText = ""
		alert.addButton(withTitle: "OK")
		alert.addButton(withTitle: "Cancel")
		let layoutName = NSTextField(frame: NSRect(x: 0, y: 0, width: 228, height: 24))
		layoutName.bezelStyle = .roundedBezel
		layoutName.placeholderString = "Layout Name"
		alert.accessoryView = layoutName

		if let window = NSApp.mainWindow {
			alert.beginSheetModal(for: window) { response in
				if response.rawValue == 1000 && layoutName.stringValue.count > 0 {
					if Guide.shared.addLayout(layout: layoutName.stringValue.trimmingCharacters(in: .whitespacesAndNewlines)) {
						self.reloadLayouts()
					}
				}
			}
		} else {
			let response = alert.runModal()
			if response.rawValue == 1000 && layoutName.stringValue.count > 0 {
				if Guide.shared.addLayout(layout: layoutName.stringValue.trimmingCharacters(in: .whitespacesAndNewlines)) {
					self.reloadLayouts()
				}
			}
		}
	}

	@IBAction func removeLayoutButtonPress(_ button: NSButton) {
		var selectedLayouts: [String] = []
		let layouts = Guide.shared.allLayouts()
		for row in layoutsTable.selectedRowIndexes.map({ $0 }) where row < layouts.count {
			let layout = layouts[row]
			if layout != kLineDefaultLayout {
				selectedLayouts.append(layout)
			}
		}

		let plural: String = selectedLayouts.count == 1 ? "" : "s"
		let alert = NSAlert()
		alert.messageText = "Delete Layout\(plural)"
		alert.informativeText = "Are you sure you want to delete app layout\(plural)?"
		alert.alertStyle = .informational
		alert.addButton(withTitle: "OK")
		alert.addButton(withTitle: "Cancel")

		if let window = NSApp.mainWindow {
			alert.beginSheetModal(for: window) { response in
				if response.rawValue == 1000 {
					_ = selectedLayouts.map { Guide.shared.removeLayout(layout: $0) }
					self.reloadLayouts()
				}
			}
		} else {
			let response = alert.runModal()
			if response.rawValue == 1000 {
				_ = selectedLayouts.map { Guide.shared.removeLayout(layout: $0) }
				self.reloadLayouts()
			}
		}
	}

	@IBAction func resetLayoutsButtonPress(_ button: NSButton) {
		let alert = NSAlert()
		alert.messageText = "Reset Layouts"
		alert.informativeText = "Are you sure you want to reset app layouts?"
		alert.alertStyle = .informational
		alert.addButton(withTitle: "OK")
		alert.addButton(withTitle: "Cancel")

		if let window = NSApp.mainWindow {
			alert.beginSheetModal(for: window) { response in
				if response.rawValue == 1000 {
					Guide.shared.resetLayouts()
					self.reloadLayouts()
				}
			}
		} else {
			let response = alert.runModal()
			if response.rawValue == 1000 {
				Guide.shared.resetLayouts()
				self.reloadLayouts()
			}
		}
	}
}
