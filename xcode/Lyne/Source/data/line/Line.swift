import Cocoa

let kLineDefaultLayout: String = "Default Layout"

enum LineOrientation: String, Codable, CaseIterable {
	case horizontal
	case vertical
}

enum LineColor: String, Codable, CaseIterable {
	case custom
	case blue
	case purple
	case pink
	case red
	case orange
	case yellow
	case green
	case graphite
}

enum LineStroke: String, Codable, CaseIterable {
	case solid
	case dashed
	case dotted
}

enum LineOutsideInterception: String, Codable, CaseIterable {
	case none
	case inside
}

enum LineHorizontalHandler: String, Codable, CaseIterable {
	case left = "Left"
	case right = "Right"
	case dynamic = "Dynamic"
}

enum LineVerticalHandler: String, Codable, CaseIterable {
	case top = "Top"
	case bottom = "Bottom"
	case dynamic = "Dynamic"
}

enum LineDraggingOrientation: String, Codable, CaseIterable {
	case horizontal
	case vertical
	case multiple
}

enum MagnifierPosition: Int, Codable {
	case topLeft
	case left
	case bottomLeft
	case top
	case center
	case bottom
	case topRight
	case right
	case bottomRight
}

class Line: NSObject, Codable {

	var id: String = String.uuid
	var orientation: LineOrientation = .horizontal
	var position: Int = 0
	var screenIndex: Int = 0
	var selected: Bool = false
	var hover: Bool = false
	var link: String = ""
	var layout: String = kLineDefaultLayout

	private enum CodingKeys: String, CodingKey {
		case id
		case orientation
		case position
		case screenIndex
		case selected
		case hover
		case link
		case layout
	}

	required init(from decoder: Decoder) throws {
		super.init()
		let values = try decoder.container(keyedBy: CodingKeys.self)
		self.id = (try? values.decode(String.self, forKey: .id)) ?? String.uuid
		self.orientation = (try? values.decode(LineOrientation.self, forKey: .orientation)) ?? .horizontal
		self.position = (try? values.decode(Int.self, forKey: .position)) ?? 0
		self.screenIndex = (try? values.decode(Int.self, forKey: .screenIndex)) ?? 0
		self.selected = (try? values.decode(Bool.self, forKey: .selected)) ?? false
		self.hover = (try? values.decode(Bool.self, forKey: .hover)) ?? false
		self.link = (try? values.decode(String.self, forKey: .link)) ?? ""
		self.layout = (try? values.decode(String.self, forKey: .layout)) ?? kLineDefaultLayout
	}

	override init() {
		super.init()
	}

	init(id: String? = nil, orientation: LineOrientation, position: Int, screenIndex: Int = 0, selected: Bool = false, hover: Bool = false, link: String = "", layout: String = kLineDefaultLayout) {
		if let id = id {
			self.id = id
		}
		self.orientation = orientation
		self.position = position
		self.screenIndex = screenIndex
		self.selected = selected
		self.hover = hover
		self.link = link
		self.layout = layout
	}

	var clone: Line {
		return Line(orientation: orientation, position: position, screenIndex: screenIndex, layout: layout)
	}

	func deleteOutOfBounds(guideHandler: GuideHandler?, selectedLines: [Line]?) {
		if let screen = NSScreen.screen(at: screenIndex), let lines = selectedLines, lines.count > 0 {
			switch orientation {
			case .horizontal:
				if position < 0 {
					Guide.shared.deleteLines(lines: lines)
				} else if position > Int(screen.frame.height) {
					Guide.shared.deleteLines(lines: lines)
				}
			case .vertical:
				if position < 0 {
					Guide.shared.deleteLines(lines: lines)
				} else if position > Int(screen.frame.width) {
					Guide.shared.deleteLines(lines: lines)
				}
			}
		}
	}
}
