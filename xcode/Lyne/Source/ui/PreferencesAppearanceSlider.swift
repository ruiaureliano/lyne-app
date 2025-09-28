import Cocoa

class PreferencesAppearanceSlider: NSSlider {
}

class PreferencesAppearanceSliderCell: NSSliderCell {

	override func drawTickMarks() {
	}

	override func rectOfTickMark(at index: Int) -> NSRect {
		return .zero
	}
}
