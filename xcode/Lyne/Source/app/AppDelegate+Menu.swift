import Cocoa
import CoreGraphics

extension AppDelegate: NSMenuDelegate {

	func menuWillOpen(_ menu: NSMenu) {
		if let screen = NSScreen.screenMouse {
			unregisterHotKeys()
			menu.autoenablesItems = false

			var toggleGuidesHotKeyModifierMask = NSEvent.ModifierFlags(rawValue: 0)
			var toggleGuidesHotKeyEquivalent = ""
			if let toggleGuidesHotKey = HotKeys.shared.hotKeys.first(where: { $0.id == .toggleGuides }), !toggleGuidesHotKey.deleted && toggleGuidesHotKey.state == .enabled {
				toggleGuidesHotKeyModifierMask = NSEvent.ModifierFlags(rawValue: UInt(toggleGuidesHotKey.flags))
				toggleGuidesHotKeyEquivalent = HotKeyCodeMap.keySymbol(for: toggleGuidesHotKey.code).lowercased()
			}

			let screenHidden = Settings.shared.screenIndexHiddenGuides.contains(screen.screenIndex)
			if screenHidden {
				let showGuidesMenuItem = NSMenuItem(title: "Show Guides", action: #selector(showGuidesMenuItemPress(_:)), keyEquivalent: toggleGuidesHotKeyEquivalent)
				showGuidesMenuItem.representedObject = screen.screenIndex
				showGuidesMenuItem.keyEquivalentModifierMask = toggleGuidesHotKeyModifierMask
				showGuidesMenuItem.image = NSImage.menuMainShowGuides
				showGuidesMenuItem.image?.isTemplate = true
				menu.addItem(showGuidesMenuItem)
			} else {
				let hideGuidesMenuItem = NSMenuItem(title: "Hide Guides", action: #selector(hideGuidesMenuItemPress(_:)), keyEquivalent: toggleGuidesHotKeyEquivalent)
				hideGuidesMenuItem.representedObject = screen.screenIndex
				hideGuidesMenuItem.keyEquivalentModifierMask = toggleGuidesHotKeyModifierMask
				hideGuidesMenuItem.image = NSImage.menuMainHideGuides
				hideGuidesMenuItem.image?.isTemplate = true
				menu.addItem(hideGuidesMenuItem)
			}

			menu.addItem(.separator())

			var addHorizontalGuideHotKeyModifierMask = NSEvent.ModifierFlags(rawValue: 0)
			var addHorizontalGuideHotKeyEquivalent = ""
			if let addHorizontalGuideHotKey = HotKeys.shared.hotKeys.first(where: { $0.id == .addHorizontalGuide }), !addHorizontalGuideHotKey.deleted && addHorizontalGuideHotKey.state == .enabled {
				addHorizontalGuideHotKeyModifierMask = NSEvent.ModifierFlags(rawValue: UInt(addHorizontalGuideHotKey.flags))
				addHorizontalGuideHotKeyEquivalent = HotKeyCodeMap.keySymbol(for: addHorizontalGuideHotKey.code).lowercased()
			}

			let addHorizontalGuideMenuItem = NSMenuItem(title: "Horizontal Guide", action: #selector(addHorizontalGuideMenuItemPress(_:)), keyEquivalent: addHorizontalGuideHotKeyEquivalent)
			addHorizontalGuideMenuItem.representedObject = screen.screenIndex
			addHorizontalGuideMenuItem.keyEquivalentModifierMask = addHorizontalGuideHotKeyModifierMask
			addHorizontalGuideMenuItem.image = NSImage.menuMainHorizontalGuide
			addHorizontalGuideMenuItem.image?.isTemplate = true
			menu.addItem(addHorizontalGuideMenuItem)

			var addVerticalGuideHotKeyModifierMask = NSEvent.ModifierFlags(rawValue: 0)
			var addVerticalGuideHotKeyEquivalent = ""
			if let addVerticalGuideHotKey = HotKeys.shared.hotKeys.first(where: { $0.id == .addVerticalGuide }), !addVerticalGuideHotKey.deleted && addVerticalGuideHotKey.state == .enabled {
				addVerticalGuideHotKeyModifierMask = NSEvent.ModifierFlags(rawValue: UInt(addVerticalGuideHotKey.flags))
				addVerticalGuideHotKeyEquivalent = HotKeyCodeMap.keySymbol(for: addVerticalGuideHotKey.code).lowercased()
			}

			let addVerticalGuideMenuItem = NSMenuItem(title: "Vertical Guide", action: #selector(addVerticalGuideMenuItemPress(_:)), keyEquivalent: addVerticalGuideHotKeyEquivalent)
			addVerticalGuideMenuItem.representedObject = screen.screenIndex
			addVerticalGuideMenuItem.keyEquivalentModifierMask = addVerticalGuideHotKeyModifierMask
			addVerticalGuideMenuItem.image = NSImage.menuMainVerticalGuide
			addVerticalGuideMenuItem.image?.isTemplate = true
			menu.addItem(addVerticalGuideMenuItem)

			var addRectangleGuideHotKeyModifierMask = NSEvent.ModifierFlags(rawValue: 0)
			var addRectangleGuideHotKeyEquivalent = ""
			if let addRectangleGuideHotKey = HotKeys.shared.hotKeys.first(where: { $0.id == .addRectangleGuide }), !addRectangleGuideHotKey.deleted && addRectangleGuideHotKey.state == .enabled {
				addRectangleGuideHotKeyModifierMask = NSEvent.ModifierFlags(rawValue: UInt(addRectangleGuideHotKey.flags))
				addRectangleGuideHotKeyEquivalent = HotKeyCodeMap.keySymbol(for: addRectangleGuideHotKey.code).lowercased()
			}

			let addRectangleGuideMenuItem = NSMenuItem(title: "Rectangle", action: #selector(addRectangleGuideMenuItemPress(_:)), keyEquivalent: addRectangleGuideHotKeyEquivalent)
			addRectangleGuideMenuItem.representedObject = screen.screenIndex
			addRectangleGuideMenuItem.keyEquivalentModifierMask = addRectangleGuideHotKeyModifierMask
			addRectangleGuideMenuItem.image = NSImage.menuMainRectangleGuide
			addRectangleGuideMenuItem.image?.isTemplate = true
			menu.addItem(addRectangleGuideMenuItem)

			menu.addItem(.separator())

			let layoutGuidesMenuItem = NSMenuItem(title: "Layouts", action: nil, keyEquivalent: "")
			layoutGuidesMenuItem.image = NSImage.menuGuidesLayoutGuides
			layoutGuidesMenuItem.image?.isTemplate = true

			let layoutMenu = NSMenu()
			layoutMenu.autoenablesItems = false
			for layout in Guide.shared.allLayouts() {
				let layoutItem = NSMenuItem(title: layout, action: #selector(toogleLayoutMenuItem(_:)), keyEquivalent: "")
				layoutItem.representedObject = layout
				layoutItem.image?.isTemplate = true
				layoutItem.state = Guide.shared.layout == layout ? .on : .off
				if #available(macOS 14.0, *) {
					let count = Guide.shared.lines.filter { $0.layout == layout }.count
					layoutItem.badge = NSMenuItemBadge(count: count)
				}
				layoutMenu.addItem(layoutItem)
			}

			layoutMenu.addItem(.separator())
			let addLayoutItem = NSMenuItem(title: "Add Layout", action: #selector(addLayoutMenuItem(_:)), keyEquivalent: "")
			layoutMenu.addItem(addLayoutItem)

			layoutMenu.addItem(.separator())
			let manageLayoutItem = NSMenuItem(title: "Manage Layouts", action: #selector(manageLayoutsMenuItem(_:)), keyEquivalent: "")
			layoutMenu.addItem(manageLayoutItem)

			layoutGuidesMenuItem.submenu = layoutMenu
			menu.addItem(layoutGuidesMenuItem)
			menu.addItem(.separator())

			let settingsMenuItem = NSMenuItem(title: "Preferences", action: #selector(settingsMenuItemPress(_:)), keyEquivalent: ",")
			menu.addItem(settingsMenuItem)

			menu.addItem(.separator())

			let quitMenuItem = NSMenuItem(title: "Quit", action: #selector(quitMenuItemPress(_:)), keyEquivalent: "q")
			menu.addItem(quitMenuItem)
		}
	}

	func menuDidClose(_ menu: NSMenu) {
		menu.removeAllItems()
		registerHotKeys()
	}
}

extension AppDelegate {

	@objc private func hideGuidesMenuItemPress(_ menuItem: NSMenuItem) {
		let screenIndex = menuItem.representedObject as? Int ?? 0
		if !Settings.shared.screenIndexHiddenGuides.contains(screenIndex) {
			Settings.shared.screenIndexHiddenGuides.append(screenIndex)
		}
		NotificationCenter.notify(name: .screenDidChanged)
		LyneAnalytics.trackEvent(name: .menu, with: ["name": "hideGuidesMenuItemPress", "screenIndex": "\(screenIndex)"])
	}

	@objc private func showGuidesMenuItemPress(_ menuItem: NSMenuItem) {
		let screenIndex = menuItem.representedObject as? Int ?? 0
		if Settings.shared.screenIndexHiddenGuides.contains(screenIndex) {
			Settings.shared.screenIndexHiddenGuides.removeAll { $0 == screenIndex }
		}
		NotificationCenter.notify(name: .screenDidChanged)
		LyneAnalytics.trackEvent(name: .menu, with: ["name": "showGuidesMenuItemPress", "screenIndex": "\(screenIndex)"])
	}

	@objc private func addHorizontalGuideMenuItemPress(_ menuItem: NSMenuItem) {
		let screenIndex = menuItem.representedObject as? Int ?? 0
		let screenHidden = Settings.shared.screenIndexHiddenGuides.contains(screenIndex)
		if Guide.shared.addLine(orientation: .horizontal, screenIndex: screenIndex) {
			if screenHidden && Settings.shared.screenIndexHiddenGuides.contains(screenIndex) {
				Settings.shared.screenIndexHiddenGuides.removeAll { $0 == screenIndex }
				NotificationCenter.notify(name: .screenDidChanged)
			} else {
				NotificationCenter.notify(name: .guideLinesDidChanged)
			}
			LyneAnalytics.trackEvent(name: .menu, with: ["name": "addHorizontalGuideMenuItemPress", "screenIndex": "\(screenIndex)"])
		}
	}

	@objc private func addVerticalGuideMenuItemPress(_ menuItem: NSMenuItem) {
		let screenIndex = menuItem.representedObject as? Int ?? 0
		let screenHidden = Settings.shared.screenIndexHiddenGuides.contains(screenIndex)
		if Guide.shared.addLine(orientation: .vertical, screenIndex: screenIndex) {
			if screenHidden && Settings.shared.screenIndexHiddenGuides.contains(screenIndex) {
				Settings.shared.screenIndexHiddenGuides.removeAll { $0 == screenIndex }
				NotificationCenter.notify(name: .screenDidChanged)
			} else {
				NotificationCenter.notify(name: .guideLinesDidChanged)
			}
			LyneAnalytics.trackEvent(name: .menu, with: ["name": "addVerticalGuideMenuItemPress", "screenIndex": "\(screenIndex)"])
		}
	}

	@objc private func addRectangleGuideMenuItemPress(_ menuItem: NSMenuItem) {
		let screenIndex = menuItem.representedObject as? Int ?? 0
		let screenHidden = Settings.shared.screenIndexHiddenGuides.contains(screenIndex)
		if screenHidden && Settings.shared.screenIndexHiddenGuides.contains(screenIndex) {
			Settings.shared.screenIndexHiddenGuides.removeAll { $0 == screenIndex }
			NotificationCenter.notify(name: .screenDidChanged)
		}
		StatusBarRectangle.resizing = true
		DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
			self.setGuidesAcceptMouse(accept: true)
			NSCursor.cursorRectangle().set()
		}
		LyneAnalytics.trackEvent(name: .menu, with: ["name": "addRectangleGuideMenuItemPress", "screenIndex": "\(screenIndex)"])
	}

	@objc private func toogleLayoutMenuItem(_ menuItem: NSMenuItem) {
		if let layout = menuItem.representedObject as? String {
			Guide.shared.layout = layout
			NotificationCenter.notify(name: .guideLinesDidChanged)
			LyneAnalytics.trackEvent(name: .menu, with: ["name": "toogleLayoutMenuItem", "layout": "\(layout)"])
		}
	}

	@objc private func addLayoutMenuItem(_ menuItem: NSMenuItem) {
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
						NotificationCenter.notify(name: .preferencesDidChanged)
						LyneAnalytics.trackEvent(name: .menu, with: ["name": "addLayoutMenuItem", "layout": "\( layoutName.stringValue)"])
					}
				}
			}
		} else {
			let response = alert.runModal()
			if response.rawValue == 1000 && layoutName.stringValue.count > 0 {
				if Guide.shared.addLayout(layout: layoutName.stringValue.trimmingCharacters(in: .whitespacesAndNewlines)) {
					NotificationCenter.notify(name: .preferencesDidChanged)
					LyneAnalytics.trackEvent(name: .menu, with: ["name": "addLayoutMenuItem", "layout": "\( layoutName.stringValue)"])
				}
			}
		}
	}

	@objc private func manageLayoutsMenuItem(_ menuItem: NSMenuItem) {
		preferencesWindowController?.openPreferencesWindow(tab: .layouts)
		LyneAnalytics.trackEvent(name: .menu, with: ["name": "manageLayoutsMenuItem"])
	}

	@objc private func settingsMenuItemPress(_ menuItem: NSMenuItem) {
		preferencesWindowController?.openPreferencesWindow(tab: .general)
		LyneAnalytics.trackEvent(name: .menu, with: ["name": "settingsMenuItemPress"])
	}

	@objc private func quitMenuItemPress(_ menuItem: NSMenuItem) {
		LyneAnalytics.trackEvent(name: .menu, with: ["name": "quitMenuItemPress"])
		NSApp.terminate(self)
	}
}
