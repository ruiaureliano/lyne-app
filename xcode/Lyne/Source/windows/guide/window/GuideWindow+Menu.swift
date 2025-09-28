import Cocoa

extension GuideWindow: NSMenuDelegate {

	func menuWillOpen(_ menu: NSMenu) {
		menu.autoenablesItems = false

		let lines = Guide.shared.lines(screenIndex: screenIndex).filter { $0.selected }
		let hLines = lines.filter { $0.orientation == .horizontal }
		let vLines = lines.filter { $0.orientation == .vertical }
		let links = Set(lines.map { $0.link })

		let plural: String = lines.count == 1 ? "" : "s"
		if lines.count > 0 {
			let deleteGuidesMenuItem = NSMenuItem(title: "Delete Guide\(plural)", action: #selector(deleteGuidesMenuItemPress(_:)), keyEquivalent: "\u{08}")
			deleteGuidesMenuItem.keyEquivalentModifierMask = NSEvent.ModifierFlags.init(rawValue: 0)
			deleteGuidesMenuItem.image = NSImage.menuGuidesDeleteGuides
			deleteGuidesMenuItem.image?.isTemplate = true
			menu.addItem(deleteGuidesMenuItem)
			menu.addItem(.separator())

			let rotateGuidesMenuItem = NSMenuItem(title: "Rotate Guide", action: #selector(rotateGuidesMenuItemPress(_:)), keyEquivalent: "r")
			rotateGuidesMenuItem.isEnabled = lines.count == 1
			rotateGuidesMenuItem.keyEquivalentModifierMask = NSEvent.ModifierFlags.init(rawValue: 0)
			rotateGuidesMenuItem.image = NSImage.menuGuidesRotateGuides
			rotateGuidesMenuItem.image?.isTemplate = true
			menu.addItem(rotateGuidesMenuItem)
			menu.addItem(.separator())

			let linkGuidesMenuItem = NSMenuItem(title: "Link Guide\(plural)", action: #selector(linkGuidesMenuItemPress(_:)), keyEquivalent: "l")
			linkGuidesMenuItem.isEnabled = lines.count > 1 && (links.count > 1 || links.count == 1 && links.contains(""))
			linkGuidesMenuItem.keyEquivalentModifierMask = NSEvent.ModifierFlags.init(rawValue: 0)
			linkGuidesMenuItem.image = NSImage.menuGuidesLinkGuides
			linkGuidesMenuItem.image?.isTemplate = true
			menu.addItem(linkGuidesMenuItem)

			let unlinkGuidesMenuItem = NSMenuItem(title: "Unlink Guide\(plural)", action: #selector(inlinkGuidesMenuItemPress(_:)), keyEquivalent: "l")
			unlinkGuidesMenuItem.isEnabled = !(links.count == 1 && links.contains(""))
			let mouseInWindow = convertPoint(fromScreen: NSEvent.mouseLocation)
			let guideWindowView = self.contentView as? GuideWindowView
			let guideHandler = guideWindowView?.guideHandlerContains(point: mouseInWindow)
			unlinkGuidesMenuItem.representedObject = guideHandler
			unlinkGuidesMenuItem.keyEquivalentModifierMask = NSEvent.ModifierFlags.shift
			unlinkGuidesMenuItem.image = NSImage.menuGuidesUnlinkGuides
			unlinkGuidesMenuItem.image?.isTemplate = true
			menu.addItem(unlinkGuidesMenuItem)

			menu.addItem(.separator())

			let distributeGuidesMenuItem = NSMenuItem(title: "Distribute Guide\(plural)", action: #selector(distributeGuidesMenuItemPress(_:)), keyEquivalent: "d")
			distributeGuidesMenuItem.isEnabled = hLines.count > 2 || vLines.count > 2
			distributeGuidesMenuItem.keyEquivalentModifierMask = NSEvent.ModifierFlags.init(rawValue: 0)
			distributeGuidesMenuItem.image = NSImage.menuGuidesDistributeGuides
			distributeGuidesMenuItem.image?.isTemplate = true
			menu.addItem(distributeGuidesMenuItem)

			let duplicateGuidesMenuItem = NSMenuItem(title: "Duplicate Guide\(plural)", action: #selector(duplicateGuidesMenuItemPress(_:)), keyEquivalent: "d")
			duplicateGuidesMenuItem.isEnabled = lines.count > 0
			duplicateGuidesMenuItem.keyEquivalentModifierMask = NSEvent.ModifierFlags.shift
			duplicateGuidesMenuItem.image = NSImage.menuGuidesDuplicateGuides
			duplicateGuidesMenuItem.image?.isTemplate = true
			menu.addItem(duplicateGuidesMenuItem)

			menu.addItem(.separator())

			if NSScreen.screens.count > 1 {
				let moveGuidesToScreenMenuItem = NSMenuItem(title: "Move to Screen", action: nil, keyEquivalent: "")
				moveGuidesToScreenMenuItem.image = NSImage.menuGuidesScreenGuides
				moveGuidesToScreenMenuItem.image?.isTemplate = true
				let screenMenu = NSMenu()
				screenMenu.autoenablesItems = false

				for screen in NSScreen.screens {
					let screenItem = NSMenuItem(title: screen.localizedName, action: #selector(moveGuidesToScreenMenuItemPress(_:)), keyEquivalent: "")
					screenItem.representedObject = screen
					screenItem.state = screen.screenIndex == screenIndex ? .on : .off
					screenMenu.addItem(screenItem)
				}
				moveGuidesToScreenMenuItem.submenu = screenMenu
				menu.addItem(moveGuidesToScreenMenuItem)
			}

			if Guide.shared.allLayouts().count > 1 {
				let layoutGuidesMenuItem = NSMenuItem(title: "Move to Layout", action: nil, keyEquivalent: "")
				layoutGuidesMenuItem.image = NSImage.menuGuidesLayoutGuides
				layoutGuidesMenuItem.image?.isTemplate = true
				let layoutMenu = NSMenu()
				layoutMenu.autoenablesItems = false

				for layout in Guide.shared.allLayouts() {
					let layoutItem = NSMenuItem(title: layout, action: #selector(moveGuideToLayoutMenuItem(_:)), keyEquivalent: "")
					layoutItem.representedObject = layout
					layoutItem.image?.isTemplate = true
					layoutItem.state = Guide.shared.layout == layout ? .on : .off
					if #available(macOS 14.0, *) {
						let count = Guide.shared.lines.filter { $0.layout == layout }.count
						layoutItem.badge = NSMenuItemBadge(count: count)
					}
					layoutMenu.addItem(layoutItem)
				}
				layoutGuidesMenuItem.submenu = layoutMenu
				menu.addItem(layoutGuidesMenuItem)
			}
		}
	}

	func menuDidClose(_ menu: NSMenu) {
	}
}

extension GuideWindow {

	@objc private func deleteGuidesMenuItemPress(_ menuItem: NSMenuItem) {
		let lines = Guide.shared.lines(screenIndex: screenIndex).filter { $0.selected }
		deleteSelectedLines(lines: lines)
		LyneAnalytics.trackEvent(name: .lineMenu, with: ["name": "deleteGuidesMenuItemPress", "screenIndex": "\(screenIndex)"])
	}

	@objc private func rotateGuidesMenuItemPress(_ menuItem: NSMenuItem) {
		let lines = Guide.shared.lines(screenIndex: screenIndex).filter { $0.selected }
		rotateSelectedLines(lines: lines)
		LyneAnalytics.trackEvent(name: .lineMenu, with: ["name": "rotateGuidesMenuItemPress", "screenIndex": "\(screenIndex)"])
	}

	@objc private func linkGuidesMenuItemPress(_ menuItem: NSMenuItem) {
		let lines = Guide.shared.lines(screenIndex: screenIndex).filter { $0.selected }
		linkSelectedLines(lines: lines)
		LyneAnalytics.trackEvent(name: .lineMenu, with: ["name": "linkGuidesMenuItemPress", "screenIndex": "\(screenIndex)"])
	}

	@objc private func inlinkGuidesMenuItemPress(_ menuItem: NSMenuItem) {
		let lines = Guide.shared.lines(screenIndex: screenIndex).filter { $0.selected }
		unlinkSelectedLines(lines: lines, selected: (menuItem.representedObject as? GuideHandler)?.line)
		LyneAnalytics.trackEvent(name: .lineMenu, with: ["name": "inlinkGuidesMenuItemPress", "screenIndex": "\(screenIndex)"])
	}

	@objc private func duplicateGuidesMenuItemPress(_ menuItem: NSMenuItem) {
		let lines = Guide.shared.lines(screenIndex: screenIndex).filter { $0.selected }
		duplicateSelectedLines(lines: lines)
		LyneAnalytics.trackEvent(name: .lineMenu, with: ["name": "duplicateGuidesMenuItemPress", "screenIndex": "\(screenIndex)"])
	}

	@objc private func distributeGuidesMenuItemPress(_ menuItem: NSMenuItem) {
		let lines = Guide.shared.lines(screenIndex: screenIndex).filter { $0.selected }
		let hLines = lines.filter { $0.orientation == .horizontal }
		let vLines = lines.filter { $0.orientation == .vertical }
		distributeSelectedLines(hLines: hLines, vLines: vLines)
		LyneAnalytics.trackEvent(name: .lineMenu, with: ["name": "distributeGuidesMenuItemPress", "screenIndex": "\(screenIndex)"])
	}

	@objc private func moveGuidesToScreenMenuItemPress(_ menuItem: NSMenuItem) {
		if let screen = menuItem.representedObject as? NSScreen {
			let lines = Guide.shared.lines(screenIndex: screenIndex).filter { $0.selected }
			moveToScreenSelectedLines(lines: lines, to: screen.screenIndex)
			LyneAnalytics.trackEvent(name: .lineMenu, with: ["name": "moveGuidesToScreenMenuItemPress", "screenIndex": "\(screenIndex)"])
		}
	}

	@objc private func moveGuideToLayoutMenuItem(_ menuItem: NSMenuItem) {
		if let layout = menuItem.representedObject as? String {
			let lines = Guide.shared.lines(screenIndex: screenIndex).filter { $0.selected }
			moveToLayoutSelectedLines(lines: lines, to: layout)
			LyneAnalytics.trackEvent(name: .lineMenu, with: ["name": "moveGuideToLayoutMenuItem", "screenIndex": "\(screenIndex)"])
		}
	}
}
