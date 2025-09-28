import Cocoa

extension NSParagraphStyle {

	static var center: NSParagraphStyle {
		let paragraphStyle = NSMutableParagraphStyle()
		paragraphStyle.alignment = .center
		paragraphStyle.lineBreakMode = .byTruncatingTail
		return paragraphStyle
	}

	static var onboarding: NSParagraphStyle {
		let paragraphStyle = NSMutableParagraphStyle()
		paragraphStyle.lineSpacing = 16
		return paragraphStyle
	}
}
