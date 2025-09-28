import Cocoa

class HotKeyCodeMap {

	static func keySymbol(for code: Int) -> String {
		let map: [Int: String] = [
			0: "A",
			1: "S",
			2: "D",
			3: "F",
			4: "H",
			5: "G",
			6: "Z",
			7: "X",
			8: "C",
			9: "V",
			10: "§",
			11: "B",
			12: "Q",
			13: "W",
			14: "E",
			15: "R",
			16: "Y",
			17: "T",
			18: "1",
			19: "2",
			20: "3",
			21: "4",
			22: "6",
			23: "5",
			24: "+",
			25: "9",
			26: "7",
			27: "'",
			28: "8",
			29: "0",
			30: "´",
			31: "O",
			32: "U",
			33: "º",
			34: "I",
			35: "P",
			36: "↵",
			37: "L",
			38: "J",
			39: "^",
			40: "K",
			42: "\\",
			43: ",",
			44: "-",
			45: "N",
			46: "M",
			47: ".",
			48: "⇥",
			49: "⎵",
			50: "<",
			51: "⌫",
			53: "⎋",
			96: "F5",
			97: "F6",
			98: "F7",
			99: "F3",
			100: "F8",
			101: "F9",
			103: "F11",
			105: "F13",
			107: "F14",
			109: "F10",
			111: "F12",
			113: "F15",
			118: "F4",
			121: "F2",
			122: "F1",
			123: "←",
			124: "→",
			125: "↓",
			126: "↑",
		]
		return map[code] ?? ""
	}

	static func shortcutSymbol(flags: NSEvent.ModifierFlags, code: Int? = nil) -> String {
		var shortcut: String = ""
		if flags.contains(.shift) {
			shortcut.append(HotKeyFlag.shift.rawValue)
		}
		if flags.contains(.control) {
			shortcut.append(HotKeyFlag.control.rawValue)
		}
		if flags.contains(.option) {
			shortcut.append(HotKeyFlag.option.rawValue)
		}
		if flags.contains(.command) {
			shortcut.append(HotKeyFlag.command.rawValue)
		}
		if let code = code {
			shortcut.append(" " + keySymbol(for: code))
		}
		return shortcut
	}
}
