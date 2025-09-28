import Cocoa

extension String {

	var urlQueryAllowed: String? {
		return addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
	}
}
