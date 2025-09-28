import Cocoa

extension HotKeys {

	func groupState(group: HotKeyGroupIdentifier) -> HotKeyGroupState? {
		let states = Set(hotKeys.filter { $0.group == group }.map { $0.state })
		if states.count == 1 {
			return states.first == .enabled ? .enabled : .disabled
		} else if states.count == 2 {
			return .mixed
		}
		return nil
	}

	var groups: [HotKeyGroupIdentifier] {
		return hotKeys.map { $0.group }
	}
}
