import Cocoa

class Guide: NSObject, Codable {

	var lines: [Line] = []
	var layouts: [String] = [kLineDefaultLayout]
	var layout: String = kLineDefaultLayout

	private enum CodingKeys: String, CodingKey {
		case lines
		case layouts
		case layout
	}

	required init(from decoder: Decoder) throws {
		super.init()
		let values = try decoder.container(keyedBy: CodingKeys.self)
		self.lines = (try? values.decode([Line].self, forKey: .lines)) ?? []
		self.layouts = (try? values.decode([String].self, forKey: .layouts)) ?? [kLineDefaultLayout]
		self.layout = (try? values.decode(String.self, forKey: .layout)) ?? kLineDefaultLayout
	}

	override init() {
		super.init()
	}

	static let shared: Guide = {
		let instance = Guide()
		instance.load()
		return instance
	}()

	func lines(screenIndex: Int) -> [Line] {
		return lines.filter { $0.screenIndex == screenIndex && layout == $0.layout }.sorted { $0.position < $1.position }
	}

	func lines(orientation: LineOrientation) -> [Line] {
		return lines.filter { $0.orientation == orientation && layout == $0.layout }.sorted { $0.position < $1.position }
	}

	func lines(orientation: LineOrientation, layout: String) -> [Line] {
		return lines.filter { $0.orientation == orientation && layout == $0.layout }.sorted { $0.position < $1.position }
	}

	func lines(orientation: LineOrientation, screenIndex: Int) -> [Line] {
		return lines.filter { $0.orientation == orientation && $0.screenIndex == screenIndex && layout == $0.layout }.sorted { $0.position < $1.position }
	}
}
