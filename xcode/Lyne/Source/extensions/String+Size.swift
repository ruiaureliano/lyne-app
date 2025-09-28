import Cocoa

extension String {

	func size(font: NSFont? = nil, paragraphStyle: NSParagraphStyle? = nil) -> CGSize {
		var attributes: [NSAttributedString.Key: Any] = [:]
		if let font = font {
			attributes[.font] = font
		}
		if let paragraphStyle = paragraphStyle {
			attributes[.paragraphStyle] = paragraphStyle
		}
		let constraintRect = CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)
		let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: attributes, context: nil)
		return NSSize(width: boundingBox.width.rounded(.up), height: boundingBox.height.rounded(.up))
	}

	func heightWithConstrainedWidth(width: CGFloat, font: NSFont? = nil, paragraphStyle: NSParagraphStyle? = nil) -> CGFloat {
		var attributes: [NSAttributedString.Key: Any] = [:]
		if let font = font {
			attributes[.font] = font
		}
		if let paragraphStyle = paragraphStyle {
			attributes[.paragraphStyle] = paragraphStyle
		}
		let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
		let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: attributes, context: nil)
		return boundingBox.height.rounded(.up)
	}

	func widthWithConstrainedHeight(height: CGFloat, font: NSFont? = nil, paragraphStyle: NSParagraphStyle? = nil) -> CGFloat {
		var attributes: [NSAttributedString.Key: Any] = [:]
		if let font = font {
			attributes[.font] = font
		}
		if let paragraphStyle = paragraphStyle {
			attributes[.paragraphStyle] = paragraphStyle
		}
		let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
		let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: attributes, context: nil)
		return boundingBox.width.rounded(.up)
	}
}
