import Cocoa

extension GuideWindowView {

	func guideHandlerContains(point: CGPoint) -> GuideHandler? {
		for guideHandler in guideHandlers where guideHandler.frame.contains(point) {
			return guideHandler
		}
		return nil
	}

	func crossHandlerContains(point: CGPoint) -> CrossHandler? {
		for crossHandler in crossHandlers where crossHandler.frame.contains(point) {
			return crossHandler
		}
		return nil
	}
}
