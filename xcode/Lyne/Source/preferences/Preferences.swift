import Cocoa

class Preferences: NSObject, Codable {

	static let shared: Preferences = {
		let instance = Preferences()
		instance.load()
		return instance
	}()

	/* GENERAL */
	var startLogin: Bool = LoginItem.enabled {
		didSet {
			if startLogin {
				LoginItem.register()
				NotificationCenter.notify(name: .preferencesDidChanged)
			} else {
				LoginItem.unregister()
				NotificationCenter.notify(name: .preferencesDidChanged)
			}
		}
	}

	var playSounds: Bool = true {
		didSet {
			if let data = try? JSONEncoder().encode(playSounds) {
				UserDefaults.standard.set(data, forKey: kUserDefaultsPlaySounds)
				UserDefaults.standard.synchronize()
				NotificationCenter.notify(name: .preferencesDidChanged)
			}
		}
	}

	var trackEvents: Bool = true {
		didSet {
			if let data = try? JSONEncoder().encode(trackEvents) {
				UserDefaults.standard.set(data, forKey: kUserDefaultsTrackEvents)
				UserDefaults.standard.synchronize()
				NotificationCenter.notify(name: .preferencesDidChanged)
			}
		}
	}

	/* APPEARANCE */
	var useSytemColors: Bool = true {
		didSet {
			if let data = try? JSONEncoder().encode(useSytemColors) {
				UserDefaults.standard.set(data, forKey: kUserDefaultsUseSystemColors)
				UserDefaults.standard.synchronize()
				NotificationCenter.notify(name: .guideLinesDidChanged)
				NotificationCenter.notify(name: .preferencesDidChanged)
			}
		}
	}

	var lineColor: String = LineColor.blue.rawValue {
		didSet {
			if let data = try? JSONEncoder().encode(lineColor) {
				UserDefaults.standard.set(data, forKey: kUserDefaultsLineColor)
				UserDefaults.standard.synchronize()
				NotificationCenter.notify(name: .guideLinesDidChanged)
				NotificationCenter.notify(name: .preferencesDidChanged)
			}
		}
	}

	var lineColorAlpha: CGFloat = 1.0 {
		didSet {
			if let data = try? JSONEncoder().encode(lineColorAlpha) {
				UserDefaults.standard.set(data, forKey: kUserDefaultsLineColorAlpha)
				UserDefaults.standard.synchronize()
				NotificationCenter.notify(name: .guideLinesDidChanged)
				NotificationCenter.notify(name: .preferencesDidChanged)
			}
		}
	}

	var lineStroke: LineStroke = .solid {
		didSet {
			if let data = try? JSONEncoder().encode(lineStroke) {
				UserDefaults.standard.set(data, forKey: kUserDefaultsLineStroke)
				UserDefaults.standard.synchronize()
				NotificationCenter.notify(name: .guideLinesDidChanged)
				NotificationCenter.notify(name: .preferencesDidChanged)
			}
		}
	}

	var outsideInterceptions: LineOutsideInterception = .none {
		didSet {
			if let data = try? JSONEncoder().encode(outsideInterceptions) {
				UserDefaults.standard.set(data, forKey: kUserDefaultsOutsideInterceptions)
				UserDefaults.standard.synchronize()
				NotificationCenter.notify(name: .guideLinesDidChanged)
				NotificationCenter.notify(name: .preferencesDidChanged)
			}
		}
	}

	var outsideInterceptionsAlpha: CGFloat = 0.1 {
		didSet {
			if let data = try? JSONEncoder().encode(outsideInterceptionsAlpha) {
				UserDefaults.standard.set(data, forKey: kUserDefaultsOutsideInterceptionsAlpha)
				UserDefaults.standard.synchronize()
				NotificationCenter.notify(name: .guideLinesDidChanged)
				NotificationCenter.notify(name: .preferencesDidChanged)
			}
		}
	}

	var outsideInterceptionsStroke: LineStroke = .solid {
		didSet {
			if let data = try? JSONEncoder().encode(outsideInterceptionsStroke) {
				UserDefaults.standard.set(data, forKey: kUserDefaultsOutsideInterceptionsStroke)
				UserDefaults.standard.synchronize()
				NotificationCenter.notify(name: .guideLinesDidChanged)
				NotificationCenter.notify(name: .preferencesDidChanged)
			}
		}
	}

	var lineHorizontalHandler: LineHorizontalHandler = .left {
		didSet {
			if let data = try? JSONEncoder().encode(lineHorizontalHandler) {
				UserDefaults.standard.set(data, forKey: kUserDefaultsGuideHorizontalHandler)
				UserDefaults.standard.synchronize()
				NotificationCenter.notify(name: .guideLinesDidChanged)
				NotificationCenter.notify(name: .preferencesDidChanged)
			}
		}
	}

	var lineVerticalHandler: LineVerticalHandler = .top {
		didSet {
			if let data = try? JSONEncoder().encode(lineVerticalHandler) {
				UserDefaults.standard.set(data, forKey: kUserDefaultsGuideVerticalHandler)
				UserDefaults.standard.synchronize()
				NotificationCenter.notify(name: .guideLinesDidChanged)
				NotificationCenter.notify(name: .preferencesDidChanged)
			}
		}
	}

	var displayDimensions: Bool = true {
		didSet {
			if let data = try? JSONEncoder().encode(displayDimensions) {
				UserDefaults.standard.set(data, forKey: kUserDefaultsDisplayDimensions)
				UserDefaults.standard.synchronize()
				NotificationCenter.notify(name: .guideLinesDidChanged)
				NotificationCenter.notify(name: .preferencesDidChanged)
			}
		}
	}

	var showDesktop: Bool = false {
		didSet {
			if let data = try? JSONEncoder().encode(showDesktop) {
				UserDefaults.standard.set(data, forKey: kUserDefaultsShowDesktop)
				UserDefaults.standard.synchronize()
				NotificationCenter.notify(name: .guideLinesDidChanged)
				NotificationCenter.notify(name: .preferencesDidChanged)
			}
		}
	}
}

extension Preferences {

	private func load() {
		loadGeneral()
		loadAppearance()
	}

	func reset() {
		resetGeneral(notify: false)
		resetAppearance(notify: false)
		NotificationCenter.notify(name: .guideLinesDidChanged)
		NotificationCenter.notify(name: .preferencesDidChanged)
	}
}
