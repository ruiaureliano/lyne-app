import Cocoa

class Settings: NSObject, Codable {

	static let shared: Settings = {
		let instance = Settings()
		return instance
	}()

	var screenIndexHiddenGuides: [Int] = []
}
