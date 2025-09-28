import Cocoa

let kUserDefaultsPlaySounds = "UserDefaultsPlaySounds"
let kUserDefaultsTrackEvents = "UserDefaultsTrackEvents"

extension Preferences {

	func loadGeneral() {
		startLogin = LoginItem.enabled
		if let data = UserDefaults.standard.object(forKey: kUserDefaultsPlaySounds) as? Data, let playSounds = try? JSONDecoder().decode(Bool.self, from: data) {
			self.playSounds = playSounds
		}
		if let data = UserDefaults.standard.object(forKey: kUserDefaultsTrackEvents) as? Data, let trackEvents = try? JSONDecoder().decode(Bool.self, from: data) {
			self.trackEvents = trackEvents
		}
	}

	func resetGeneral(notify: Bool = true) {
		startLogin = false
		playSounds = true
		trackEvents = false
		if notify {
			NotificationCenter.notify(name: .guideLinesDidChanged)
			NotificationCenter.notify(name: .preferencesDidChanged)
		}
	}
}
