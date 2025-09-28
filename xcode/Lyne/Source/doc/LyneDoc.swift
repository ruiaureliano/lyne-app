import Cocoa

enum LyneDocType: String, Codable {
	case lyne
}

class LyneDoc: NSDocument {

	override var windowNibName: String? {
		return nil
	}

	override class var autosavesInPlace: Bool {
		return true
	}
}

class LyneDocHandler: NSDocument {

	static func handle(filenames: [String]) {
		for filename in filenames {
			if let type = LyneDocType(rawValue: filename.pathExtension.lowercased()) {
				switch type {
				case .lyne:
					guard
						let data = try? Data(contentsOf: URL(fileURLWithPath: filename)),
						let decryptedData = try? Encrypter.decrypt(data: data, key64: kStaticLayoutsKey64),
						let lines = try? JSONDecoder().decode([Line].self, from: decryptedData)
					else {
						return
					}
					let layout = Guide.uniqueLayout(for: filename.pathName)
					Guide.shared.addLayout(layout: layout)
					for line in lines {
						Guide.shared.addLine(position: line.position, orientation: line.orientation, screenIndex: line.screenIndex, layout: layout)
					}
					NotificationCenter.notify(name: .guideLinesDidChanged)
					Sound.file()
				}
			}
		}
	}
}
