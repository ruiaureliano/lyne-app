import Cocoa

extension PreferencesLayoutsViewCell {

	static let identifier: NSUserInterfaceItemIdentifier = NSUserInterfaceItemIdentifier("PreferencesLayoutsViewCell")
}

class PreferencesLayoutsViewCell: NSTableCellView, NSTextFieldDelegate {

	@IBOutlet weak var layoutName: NSTextField!
	@IBOutlet weak var layoutShare: NSButton!
	private var layout: String = ""

	func setLayout(layout: String, selected: Bool) {
		self.layout = layout
		layoutName.stringValue = layout
		self.needsDisplay = true
	}

	@IBAction func layoutSharePress(_ button: NSButton) {
		let lines = Guide.shared.lines.filter { $0.layout == layout }
		guard
			let data = try? JSONEncoder().encode(lines),
			let encryptedData = try? Encrypter.encrypt(data: data, key64: kStaticLayoutsKey64),
			let bundleIdentifier = Bundle.main.bundleIdentifier
		else {
			return
		}
		let path = "\(NSTemporaryDirectory())\(bundleIdentifier)/export/layouts"
		if !FileManager.default.fileExists(atPath: path) {
			try? FileManager.default.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
		}
		var files: [URL] = []
		do {
			let name = (path + "/\(layout).layout")
			let url = URL(fileURLWithPath: name)
			try encryptedData.write(to: url)
			files.append(url)
		} catch {
		}
		if files.count > 0 {
			let sharingPicker = NSSharingServicePicker(items: files)
			sharingPicker.delegate = self
			sharingPicker.show(relativeTo: .zero, of: layoutShare, preferredEdge: .minY)
		}
	}

	func controlTextDidChange(_ obj: Notification) {
	}

	func control(_ control: NSControl, textView: NSTextView, doCommandBy commandSelector: Selector) -> Bool {
		if commandSelector == #selector(insertNewline(_:)) {
			Guide.shared.rename(layout: layout, to: layoutName.stringValue.trimmingCharacters(in: .whitespacesAndNewlines))
			NotificationCenter.notify(name: .preferencesDidChanged)
		}
		return false
	}
}

extension PreferencesLayoutsViewCell: NSSharingServicePickerDelegate, NSSharingServiceDelegate {

	func sharingServicePicker(_ sharingServicePicker: NSSharingServicePicker, sharingServicesForItems items: [Any], proposedSharingServices proposedServices: [NSSharingService]) -> [NSSharingService] {
		var share = proposedServices
		let customService = NSSharingService(
			title: "Save to Desktop", image: NSImage.sharingServiceSave, alternateImage: NSImage.sharingServiceSave,
			handler: {
				if let urls = items as? [URL], let url = urls.first {
					let savePanel = NSSavePanel()
					savePanel.nameFieldStringValue = url.lastPathComponent
					savePanel.directoryURL = URL(filePath: NSHomeDirectory() + "/Desktop")

					if let mainWindow = NSApp.mainWindow {
						savePanel.beginSheetModal(for: mainWindow) { response in
							if response.rawValue == 1, let saveURL = savePanel.url {
								_ = try? FileManager.default.replaceItemAt(saveURL, withItemAt: url)
							}
						}
					} else {
						let response = savePanel.runModal()
						if response.rawValue == 1, let saveURL = savePanel.url {
							_ = try? FileManager.default.replaceItemAt(saveURL, withItemAt: url)
						}
					}
				}
			}
		)
		share.insert(customService, at: 0)
		return share
	}
}
