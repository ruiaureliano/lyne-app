import Foundation

enum HotKeyFlag: String, Codable, CaseIterable {
	case shift = "⇧"
	case control = "⌃"
	case option = "⌥"
	case command = "⌘"
}
