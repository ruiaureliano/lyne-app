import Foundation

enum HotKeyCode: Int, Codable, CaseIterable {
	/* LETTERS */
	case a = 0
	case d = 2
	case l = 37
	case r = 15
	/* SYMBOLS */
	case backspace = 51
	case left = 123
	case right = 124
	case down = 125
	case up = 126
	case esc = 53
}
