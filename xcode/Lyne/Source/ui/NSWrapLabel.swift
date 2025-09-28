import Cocoa

class NSWrapLabel: NSTextField {

	@IBInspectable var lineSpaceEnabled: Bool = false { didSet { update() } }
	@IBInspectable var lineSpace: CGFloat = 0 { didSet { update() } }
	@IBInspectable var centered: Bool = false { didSet { update() } }

	var paragraphStyle: NSParagraphStyle?

	override func awakeFromNib() {
		super.awakeFromNib()
		update()
	}

	override var needsLayout: Bool {
		willSet {
			update()
		}
		didSet {
			update()
		}
	}

	private func update() {
		if lineSpaceEnabled {
			let attributedString = NSMutableAttributedString(attributedString: self.attributedStringValue)
			let paragraphStyle = NSMutableParagraphStyle()
			paragraphStyle.lineSpacing = lineSpace
			if centered {
				paragraphStyle.alignment = .center
			}
			self.paragraphStyle = paragraphStyle
			attributedString.addAttributes([.paragraphStyle: paragraphStyle], range: NSRange(location: 0, length: attributedString.string.count))
			self.allowsEditingTextAttributes = true
			self.attributedStringValue = attributedString
		}
	}
}
