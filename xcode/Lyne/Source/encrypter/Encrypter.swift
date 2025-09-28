import CryptoKit
import Foundation

public enum EncrypterError: Swift.Error {
	case base64TextDecodeFailed
	case base64KeyDecodeFailed
}

let kStaticLayoutsKey64 = "KCWU3HV2NLhtkp09hNX0YVvE7lLC9jhg2ZvfK24s3vo="

class Encrypter: NSObject {

	static var key: String {
		let key = SymmetricKey(size: .bits256)
		let key64 = key.withUnsafeBytes { return Data(Array($0)).base64EncodedString() }
		return key64
	}

	static func encrypt(data: Data, key64: String) throws -> Data? {
		guard let keyData = Data(base64Encoded: key64) else { throw EncrypterError.base64KeyDecodeFailed }
		let symmetricKey = SymmetricKey(data: keyData)
		let encryptedContent = try ChaChaPoly.seal(data, using: symmetricKey).combined
		return encryptedContent
	}

	static func decrypt(data: Data, key64: String) throws -> Data? {
		guard let keyData = Data(base64Encoded: key64) else { throw EncrypterError.base64KeyDecodeFailed }
		let sealedBox = try ChaChaPoly.SealedBox(combined: data)
		let symmetricKey = SymmetricKey(data: keyData)
		let decryptedContent = try ChaChaPoly.open(sealedBox, using: symmetricKey)
		return decryptedContent
	}
}
