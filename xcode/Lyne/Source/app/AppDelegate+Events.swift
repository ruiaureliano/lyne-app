import Cocoa

extension AppDelegate {

	func registerEvents() {
		let matching: NSEvent.EventTypeMask = [
			.mouseMoved,
			.leftMouseDown,
			.leftMouseUp,
			.leftMouseDragged,
			.rightMouseDown,
			.rightMouseUp,
			.keyDown,
			.keyUp,
		]

		NSEvent.addLocalMonitorForEvents(matching: matching) { event in
			_ = self.guideWindows.map { $0.handle(event: event) }
			return event
		}

		NSEvent.addGlobalMonitorForEvents(matching: matching) { event in
			_ = self.guideWindows.map { $0.handle(event: event) }
		}
	}
}
