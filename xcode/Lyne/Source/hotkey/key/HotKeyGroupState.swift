import Foundation

enum HotKeyGroupState: Int, Codable, CaseIterable {
	case enabled = 1
	case disabled = 0
	case mixed = -1
}
