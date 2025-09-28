import Foundation
import ServiceManagement

class LoginItem: NSObject {

	static var enabled: Bool {
		let isEnabled: Bool = SMAppService.mainApp.status == .enabled
		return isEnabled
	}

	@discardableResult static func unregister() -> Bool {
		do {
			try SMAppService.mainApp.unregister()
			return true
		} catch {}
		return false
	}

	@discardableResult static func register() -> Bool {
		do {
			try SMAppService.mainApp.register()
			return true
		} catch {}
		return false
	}
}
