import Foundation

enum HotKeyIdentifier: Int, Codable, CaseIterable {
	case unknown
	case toggleGuides
	case addHorizontalGuide
	case addVerticalGuide
	case addRectangleGuide
}
