import Foundation

extension String {

	static var uuid: String {
		return uuid(with: "\(Date())-\(NSUUID())")
	}

	static func uuid(with token: Any) -> String {
		if let md5 = "\(token)".md5 {
			let c1 = md5[0..<7]
			let c2 = md5[7..<10]
			let c3 = md5[10..<13]
			let c4 = md5[13..<16]
			let c5 = md5[16..<27]
			return (c1 + "-" + c2 + "-" + c3 + "-" + c4 + "-" + c5).uppercased()
		}
		return NSUUID().uuidString.uppercased()
	}
}
