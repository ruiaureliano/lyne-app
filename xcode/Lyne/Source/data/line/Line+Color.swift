import Cocoa

extension Line {

	static func color(for colorString: String) -> NSColor {
		if Preferences.shared.useSytemColors {
			return .controlAccentColor
		}
		if let lineColor = LineColor(rawValue: colorString) {
			switch lineColor {
			case .custom:
				break
			case .blue:
				return .lineBlue
			case .purple:
				return .linePurple
			case .pink:
				return .linePink
			case .red:
				return .lineRed
			case .orange:
				return .lineOrange
			case .yellow:
				return .lineYellow
			case .green:
				return .lineGreen
			case .graphite:
				return .lineGraphite
			}
		} else {
			return NSColor(hex: colorString)
		}
		return .lineBlue
	}
}
