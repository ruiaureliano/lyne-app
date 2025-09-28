import Foundation

extension String {

	var pathExtension: String {
		return (self as NSString).pathExtension
	}

	var pathName: String {
		return ((self as NSString).deletingPathExtension as NSString).lastPathComponent
	}
}
