import Foundation

enum HotKeyState: Int, Codable, CaseIterable {
	case enabled = 1
	case disabled = -1
}
