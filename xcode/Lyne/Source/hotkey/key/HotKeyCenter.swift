import Carbon
import Cocoa

class HotKeyCenter {

	private var _hotKeys: [HotKeyIdentifier: EventHotKeyRef] = [:]
	private var _hotKeyRef: EventHotKeyRef?
	weak var delegate: HotKeysDelegate?

	func register(flags: NSEvent.ModifierFlags, code: Int, identifier: HotKeyIdentifier) {
		unregister(identifier: identifier)

		var modifierFlags: Int = 0
		var modifierFlagsSymbols: String = ""
		if flags.contains(.shift) {
			modifierFlags += shiftKey
			modifierFlagsSymbols.append(HotKeyFlag.shift.rawValue)
		}
		if flags.contains(.control) {
			modifierFlags += controlKey
			modifierFlagsSymbols.append(HotKeyFlag.control.rawValue)
		}
		if flags.contains(.option) {
			modifierFlags += optionKey
			modifierFlagsSymbols.append(HotKeyFlag.option.rawValue)
		}
		if flags.contains(.command) {
			modifierFlags += cmdKey
			modifierFlagsSymbols.append(HotKeyFlag.command.rawValue)
		}

		var eventType = EventTypeSpec(eventClass: OSType(kEventClassKeyboard), eventKind: UInt32(kEventHotKeyPressed))
		var eventRef = EventHotKeyID()
		eventRef.signature = OSType(4)
		eventRef.id = UInt32(identifier.rawValue)
		RegisterEventHotKey(UInt32(code), UInt32(modifierFlags), eventRef, GetApplicationEventTarget(), 0, &_hotKeyRef)
		if _hotKeyRef != nil {
			_hotKeys[identifier] = _hotKeyRef
			// ("REGISTER: \(identifier), SHORTCUT: \(HotKeyCodeMap.shortcutSymbol(flags: flags, code: code))")
		}

		// swift-format-ignore
		InstallEventHandler(GetEventDispatcherTarget(), { _, event, data in
			if let data = data {
				var hotKeyId = EventHotKeyID()
				let error = GetEventParameter(event, EventParamName(kEventParamDirectObject), EventParamName(typeEventHotKeyID), nil, MemoryLayout<EventHotKeyID>.size, nil, &hotKeyId)
				if let identifier = HotKeyIdentifier(rawValue: Int(hotKeyId.id)) {
					let handler = Unmanaged<HotKeyCenter>.fromOpaque(data).takeUnretainedValue()
					handler.handleHotKeyDidPress(identifier: identifier)
					return error
				}
			}
			return OSStatus(eventNotHandledErr)
		}, 1, &eventType, UnsafeMutableRawPointer(Unmanaged.passUnretained(self).toOpaque()), nil)
	}

	func unregister(identifier: HotKeyIdentifier) {
		if let hotKey = _hotKeys[identifier] {
			UnregisterEventHotKey(hotKey)
			_hotKeys.removeValue(forKey: identifier)
			// ("UNREGISTER: \(identifier)")
		}
	}

	func unregister() {
		for (identifier, _) in _hotKeys {
			unregister(identifier: identifier)
		}
	}

	private func handleHotKeyDidPress(identifier: HotKeyIdentifier) {
		var shortcut = "..."
		if let hotkey = HotKeys.shared.hotKeys.first(where: { $0.id == identifier }) {
			shortcut = HotKeyCodeMap.shortcutSymbol(flags: NSEvent.ModifierFlags(rawValue: UInt(hotkey.flags)), code: hotkey.code)
		}
		delegate?.hotKeyDidPress(identifier: identifier, shortcut: shortcut)
	}
}
