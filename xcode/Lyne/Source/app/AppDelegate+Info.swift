import Cocoa

private let kAppVersion: String = "1.1"
private let kAppBuild: Int = 250928

enum AppBundles: String, Codable, CaseIterable {
	case apple = "net.lyneapp.lyne"
	case paddle = "net.lyneapp.lyne-paddle"
	case setapp = "net.lyneapp.lyne-setapp"
}

extension AppDelegate {

	static var bundle: String? {
		return Bundle.main.infoDictionary?["CFBundleIdentifier"] as? String
	}

	static var version: String? {
		#if DEBUG
			if kAppVersion != (Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String) {
				fatalError("APP VERSION DOES NOT MATCH")
			}
		#endif
		return kAppVersion
	}

	static var build: String? {
		return "\(kAppBuild)"
	}

	static var info: String? {
		if bundle == AppBundles.apple.rawValue {
			return "apple"
		} else if bundle == AppBundles.paddle.rawValue {
			return "paddle"
		} else if bundle == AppBundles.setapp.rawValue {
			return "setapp"
		}
		return nil
	}
}
