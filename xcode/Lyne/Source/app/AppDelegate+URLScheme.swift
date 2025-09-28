import Cocoa

/*
 *	+ HORIZONTAL
 *		- lyne://create-horizontal?line=100&layout=Some%20Layout
 *		- lyne://create-horizontal?lines=[100,200,300]&layout=Some%20Layout
 *
 * 	+ VERTICAL
 *		- lyne://create-vertical?line=100&layout=Some%20Layout
 *		- lyne://create-vertical?lines=[100,200,300]&layout=Some%20Layout

 * 	+ RECTANGLE
 *		- lyne://create-rectangle?hlines=[100,200,300]&vlines=[100,200,300]&layout=Some%20Layout
 */

enum LyneURLSchemeOperation: String, Codable {
	case createHorizontal = "create-horizontal"
	case createVertical = "create-vertical"
	case createRectangle = "create-rectangle"
}

enum LyneURLSchemeKey: String, Codable {
	case line
	case lines
	case hlines
	case vlines
	case layout
}

extension AppDelegate {

	func application(_ application: NSApplication, open urls: [URL]) {
		for url in urls where url.scheme == "lyne" {
			if let last = url.absoluteString.components(separatedBy: "/").last {
				let tokens = last.components(separatedBy: "?")
				if tokens.count == 2, let operation = LyneURLSchemeOperation(rawValue: tokens[0]) {
					let keyValues = tokens[1].components(separatedBy: "&")
					switch operation {
					case .createHorizontal:
						var lyneValue: Int?
						var lyneValues: [Int]?
						var lyneLayout: String = kLineDefaultLayout
						for keyValue in keyValues {
							let keyValueEqual = keyValue.components(separatedBy: "=")
							if let key = LyneURLSchemeKey(rawValue: keyValueEqual[0]), let value = URLComponents(string: keyValueEqual[1])?.percentEncodedPath.removingPercentEncoding {
								switch key {
								case .line:
									lyneValue = Int(value)
								case .lines:
									var values: [Int] = []
									for n in value.replacingOccurrences(of: "[", with: "").replacingOccurrences(of: "]", with: "").components(separatedBy: ",") {
										if let num = Int(n) {
											values.append(num)
										}
									}
									if values.count > 0 {
										lyneValues = values
									}
								case .hlines:
									break
								case .vlines:
									break
								case .layout:
									lyneLayout = value
								}
							}
						}
						if let lyneValue = lyneValue {
							_ = createHorizontalLine(position: lyneValue, layout: lyneLayout)
						} else if let lyneValues = lyneValues {
							_ = createHorizontalLines(positions: lyneValues, layout: lyneLayout)
						}
					case .createVertical:
						var lyneValue: Int?
						var lyneValues: [Int]?
						var lyneLayout: String = kLineDefaultLayout
						for keyValue in keyValues {
							let keyValueEqual = keyValue.components(separatedBy: "=")
							if let key = LyneURLSchemeKey(rawValue: keyValueEqual[0]), let value = URLComponents(string: keyValueEqual[1])?.percentEncodedPath.removingPercentEncoding {
								switch key {
								case .line:
									lyneValue = Int(value)
								case .lines:
									var values: [Int] = []
									for n in value.replacingOccurrences(of: "[", with: "").replacingOccurrences(of: "]", with: "").components(separatedBy: ",") {
										if let num = Int(n) {
											values.append(num)
										}
									}
									if values.count > 0 {
										lyneValues = values
									}
								case .hlines:
									break
								case .vlines:
									break
								case .layout:
									lyneLayout = value
								}
							}
						}
						if let lyneValue = lyneValue {
							_ = createVerticalLine(position: lyneValue, layout: lyneLayout)
						} else if let lyneValues = lyneValues {
							_ = createVerticalLines(positions: lyneValues, layout: lyneLayout)
						}
					case .createRectangle:
						var lyneHValues: [Int]?
						var lyneVValues: [Int]?
						var lyneLayout: String = kLineDefaultLayout
						for keyValue in keyValues {
							let keyValueEqual = keyValue.components(separatedBy: "=")
							if let key = LyneURLSchemeKey(rawValue: keyValueEqual[0]), let value = URLComponents(string: keyValueEqual[1])?.percentEncodedPath.removingPercentEncoding {
								switch key {
								case .line:
									break
								case .lines:
									break
								case .hlines:
									var values: [Int] = []
									for n in value.replacingOccurrences(of: "[", with: "").replacingOccurrences(of: "]", with: "").components(separatedBy: ",") {
										if let num = Int(n) {
											values.append(num)
										}
									}
									if values.count > 0 {
										lyneHValues = values
									}
								case .vlines:
									var values: [Int] = []
									for n in value.replacingOccurrences(of: "[", with: "").replacingOccurrences(of: "]", with: "").components(separatedBy: ",") {
										if let num = Int(n) {
											values.append(num)
										}
									}
									if values.count > 0 {
										lyneVValues = values
									}
								case .layout:
									lyneLayout = value
								}
							}
						}
						if let lyneHValues = lyneHValues, let lyneVValues = lyneVValues {
							_ = createRectangle(hPositions: lyneHValues, vPositions: lyneVValues, layout: lyneLayout)
						}
					}
				}
			}
		}
	}

	private func createHorizontalLine(position: Int, layout: String = kLineDefaultLayout) -> Bool {
		var success = false
		if !Guide.shared.lines(orientation: .horizontal, layout: layout).map({ $0.position }).contains(position) {
			success = Guide.shared.addLine(position: position, orientation: .horizontal, layout: layout)
			if success {
				Guide.shared.layout = layout
				Sound.url()
				NotificationCenter.notify(name: .guideLinesDidChanged)
			}
		}
		return success
	}

	private func createHorizontalLines(positions: [Int], layout: String = kLineDefaultLayout) -> Bool {
		var success = false
		for position in positions where !Guide.shared.lines(orientation: .horizontal, layout: layout).map({ $0.position }).contains(position) {
			if Guide.shared.addLine(position: position, orientation: .horizontal, layout: layout) {
				success = true
			}
		}
		if success {
			Guide.shared.layout = layout
			Sound.url()
			NotificationCenter.notify(name: .guideLinesDidChanged)
		}
		return success
	}

	private func createVerticalLine(position: Int, layout: String = kLineDefaultLayout) -> Bool {
		var success = false
		if !Guide.shared.lines(orientation: .vertical, layout: layout).map({ $0.position }).contains(position) {
			success = Guide.shared.addLine(position: position, orientation: .vertical, layout: layout)
			if success {
				Guide.shared.layout = layout
				Sound.url()
				NotificationCenter.notify(name: .guideLinesDidChanged)
			}
		}
		return success
	}

	private func createVerticalLines(positions: [Int], layout: String = kLineDefaultLayout) -> Bool {
		var success = false
		for position in positions where !Guide.shared.lines(orientation: .vertical, layout: layout).map({ $0.position }).contains(position) {
			if Guide.shared.addLine(position: position, orientation: .vertical, layout: layout) {
				success = true
			}
		}
		if success {
			Guide.shared.layout = layout
			Sound.url()
			NotificationCenter.notify(name: .guideLinesDidChanged)
		}
		return success
	}

	private func createRectangle(hPositions: [Int], vPositions: [Int], layout: String = kLineDefaultLayout) -> Bool {
		var success = false
		for position in hPositions where !Guide.shared.lines(orientation: .horizontal, layout: layout).map({ $0.position }).contains(position) {
			if Guide.shared.addLine(position: position, orientation: .horizontal, layout: layout) {
				success = true
			}
		}
		for position in vPositions where !Guide.shared.lines(orientation: .vertical, layout: layout).map({ $0.position }).contains(position) {
			if Guide.shared.addLine(position: position, orientation: .vertical, layout: layout) {
				success = true
			}
		}
		if success {
			Guide.shared.layout = layout
			Sound.url()
			NotificationCenter.notify(name: .guideLinesDidChanged)
		}
		return success
	}
}
