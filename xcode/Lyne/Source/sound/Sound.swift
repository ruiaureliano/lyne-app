import Cocoa

class Sound: NSObject {

	static func file() {
		if Preferences.shared.playSounds {
			DispatchQueue.global(qos: .background).async {
				if let path = Bundle.main.path(forResource: "file", ofType: "aiff"), let sound = NSSound(contentsOfFile: path, byReference: true) {
					sound.play()
				}
			}
		}
	}

	static func url() {
		if Preferences.shared.playSounds {
			DispatchQueue.global(qos: .background).async {
				if let path = Bundle.main.path(forResource: "url", ofType: "aiff"), let sound = NSSound(contentsOfFile: path, byReference: true) {
					sound.play()
				}
			}
		}
	}
}
