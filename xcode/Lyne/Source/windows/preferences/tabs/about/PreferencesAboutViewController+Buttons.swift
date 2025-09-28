import Cocoa

extension PreferencesAboutViewController {

	@IBAction func contactUsButtonPress(_ button: NSButton) {
		guard
			let bundle = AppDelegate.bundle,
			let version = AppDelegate.version,
			let build = AppDelegate.build,
			let info = AppDelegate.info,
			let tmpFolder = AppDelegate.tmpFolder
		else {
			return
		}

		let osXVersion = ProcessInfo.processInfo.operatingSystemVersionString
		let lyneVersion = "\(version) (\(build))"
		let subject = "🖥 Lyne: \(lyneVersion)"
		var body = "Thanks for taking the time to help us make Lyne better:\n"
		body.append("Please describe the issue or suggestion:\n\n")
		body.append("--------------\n\n")
		body.append("by sending this email I agree to share information:\n\n")
		body.append("● Lyne: \(lyneVersion)\n")
		body.append("● Info: \(info)\n")
		body.append("● macOS: \(osXVersion)\n")
		body.append("● bundle: \(bundle)\n")
		body.append("● folder: \(tmpFolder)\n\n")
		body.append("This information is confidential and we only use it to better understand the issue or suggestion.\n")
		body.append("If you do not want to share this information, simply delete this text.")
		if let subjectEncode = subject.urlQueryAllowed, let bodyEncode = body.urlQueryAllowed {
			let mailto = "mailto:lyne@lyneapp.net?subject=\(subjectEncode)&body=\(bodyEncode)"
			if let url = URL(string: mailto) {
				NSWorkspace.shared.open(url)
			}
		}
	}
}
