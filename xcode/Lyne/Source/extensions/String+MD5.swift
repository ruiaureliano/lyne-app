import CommonCrypto
import CryptoKit
import Foundation

extension String {

	var md5: String? {
		if let data = self.data(using: .utf8) {
			let computed = Insecure.MD5.hash(data: data)
			return computed.map { String(format: "%02hhx", $0) }.joined()
		}
		return nil
	}
}
