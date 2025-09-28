import Cocoa

let kUserDefaultsUseSystemColors = "UserDefaultsUseSystemColors"
let kUserDefaultsLineColor = "UserDefaultsLineColor"
let kUserDefaultsLineColorAlpha = "UserDefaultsLineColorAlpha"
let kUserDefaultsLineStroke = "UserDefaultsLineStroke"
let kUserDefaultsOutsideInterceptions = "UserDefaultsOutsideInterceptions"
let kUserDefaultsOutsideInterceptionsAlpha = "UserDefaultsOutsideInterceptionsAlpha"
let kUserDefaultsOutsideInterceptionsStroke = "UserDefaultsOutsideInterceptionsStroke"
let kUserDefaultsGuideHorizontalHandler = "UserDefaultsGuideHorizontalHandler"
let kUserDefaultsGuideVerticalHandler = "UserDefaultsGuideVerticalHandler"
let kUserDefaultsDisplayDimensions = "UserDefaultsLineDisplayDimensions"
let kUserDefaultsShowDesktop = "UserDefaultsShowDesktop"

extension Preferences {

	func loadAppearance() {
		if let data = UserDefaults.standard.object(forKey: kUserDefaultsUseSystemColors) as? Data, let useSytemColors = try? JSONDecoder().decode(Bool.self, from: data) {
			self.useSytemColors = useSytemColors
		}
		if let data = UserDefaults.standard.object(forKey: kUserDefaultsLineColor) as? Data, let lineColor = try? JSONDecoder().decode(String.self, from: data) {
			self.lineColor = lineColor
		}
		if let data = UserDefaults.standard.object(forKey: kUserDefaultsLineColorAlpha) as? Data, let lineColorAlpha = try? JSONDecoder().decode(CGFloat.self, from: data) {
			self.lineColorAlpha = lineColorAlpha
		}
		if let data = UserDefaults.standard.object(forKey: kUserDefaultsLineStroke) as? Data, let lineStroke = try? JSONDecoder().decode(LineStroke.self, from: data) {
			self.lineStroke = lineStroke
		}
		if let data = UserDefaults.standard.object(forKey: kUserDefaultsOutsideInterceptions) as? Data, let outsideInterceptions = try? JSONDecoder().decode(LineOutsideInterception.self, from: data) {
			self.outsideInterceptions = outsideInterceptions
		}
		if let data = UserDefaults.standard.object(forKey: kUserDefaultsOutsideInterceptionsAlpha) as? Data, let outsideInterceptionsAlpha = try? JSONDecoder().decode(CGFloat.self, from: data) {
			self.outsideInterceptionsAlpha = outsideInterceptionsAlpha
		}
		if let data = UserDefaults.standard.object(forKey: kUserDefaultsOutsideInterceptionsStroke) as? Data, let outsideInterceptionsStroke = try? JSONDecoder().decode(LineStroke.self, from: data) {
			self.outsideInterceptionsStroke = outsideInterceptionsStroke
		}
		if let data = UserDefaults.standard.object(forKey: kUserDefaultsGuideHorizontalHandler) as? Data, let lineHorizontalHandler = try? JSONDecoder().decode(LineHorizontalHandler.self, from: data) {
			self.lineHorizontalHandler = lineHorizontalHandler
		}
		if let data = UserDefaults.standard.object(forKey: kUserDefaultsGuideVerticalHandler) as? Data, let lineVerticalHandler = try? JSONDecoder().decode(LineVerticalHandler.self, from: data) {
			self.lineVerticalHandler = lineVerticalHandler
		}
		if let data = UserDefaults.standard.object(forKey: kUserDefaultsDisplayDimensions) as? Data, let displayDimensions = try? JSONDecoder().decode(Bool.self, from: data) {
			self.displayDimensions = displayDimensions
		}
		if let data = UserDefaults.standard.object(forKey: kUserDefaultsShowDesktop) as? Data, let showDesktop = try? JSONDecoder().decode(Bool.self, from: data) {
			self.showDesktop = showDesktop
		}
	}

	func resetAppearance(notify: Bool = true) {
		useSytemColors = true
		lineColor = LineColor.blue.rawValue
		lineColorAlpha = 1.0
		lineStroke = .solid
		outsideInterceptions = .none
		outsideInterceptionsAlpha = 0.1
		outsideInterceptionsStroke = .solid
		lineHorizontalHandler = .left
		lineVerticalHandler = .top
		displayDimensions = true
		showDesktop = false
	}
}
