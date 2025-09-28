import Cocoa

extension NotificationCenter {

	static func notify(name: NSNotification.Name, object: Any? = nil) {
		NotificationCenter.default.post(name: name, object: object)
	}

	static func observe(_ observer: Any, selector: Selector, name: NSNotification.Name?) {
		NotificationCenter.default.addObserver(observer, selector: selector, name: name, object: nil)
	}
}
