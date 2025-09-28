import Foundation
import Mixpanel

enum LyneAnalyticsName: String, Codable {
	case shortcut = "Shortcut"
	case preferences = "Preferences"
	case menu = "Menu"
	case lineMenu = "Line Menu"
}

class LyneAnalytics: NSObject {

	static func trackEvent(name: LyneAnalyticsName, with properties: [String: String]?) {
		#if !DEBUG
			if Preferences.shared.trackEvents {
				Mixpanel.mainInstance().track(event: name.rawValue, properties: properties)
			}
		#endif
	}
}
