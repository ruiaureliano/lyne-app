import Cocoa

extension PreferencesLayoutsViewController: NSTableViewDataSource, NSTableViewDelegate {

	func numberOfRows(in tableView: NSTableView) -> Int {
		return Guide.shared.allLayouts().count
	}

	func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
		return 32
	}

	func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
		if let cell = tableView.makeView(withIdentifier: PreferencesLayoutsViewCell.identifier, owner: self) as? PreferencesLayoutsViewCell {
			let layouts = Guide.shared.allLayouts()
			let layout = layouts[row]
			cell.setLayout(layout: layout, selected: Guide.shared.layout == layout)
			return cell
		}
		return nil
	}

	func tableView(_ tableView: NSTableView, shouldSelectRow row: Int) -> Bool {
		return true
	}

	func tableViewSelectionDidChange(_ notification: Notification) {
		var selectedLayouts: [String] = []
		let layouts = Guide.shared.allLayouts()
		for row in layoutsTable.selectedRowIndexes.map({ $0 }) where row < layouts.count {
			let layout = layouts[row]
			if layout != kLineDefaultLayout {
				selectedLayouts.append(layout)
			}
		}
		removeLayoutButton.isEnabled = selectedLayouts.count > 0
	}
}
