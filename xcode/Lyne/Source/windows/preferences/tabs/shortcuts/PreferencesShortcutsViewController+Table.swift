import Cocoa

extension PreferencesShortcutsViewController: NSTableViewDataSource, NSTableViewDelegate {

	func numberOfRows(in tableView: NSTableView) -> Int {
		let hotkeys = HotKeys.shared.hotKeys.sorted { $0.index < $1.index }.filter { $0.visible }
		return hotkeys.count
	}

	func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
		return 32
	}

	func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
		let hotkeys = HotKeys.shared.hotKeys.sorted { $0.index < $1.index }.filter { $0.visible }
		if let cell = tableView.makeView(withIdentifier: PreferencesShortcutsViewCell.identifier, owner: self) as? PreferencesShortcutsViewCell {
			cell.setHotKey(hotKey: hotkeys[row])
			cell.delegate = self
			return cell
		}
		return nil
	}

	func tableView(_ tableView: NSTableView, shouldSelectRow row: Int) -> Bool {
		return false
	}
}
