import Foundation

class HotKey: NSObject, Codable {

	var id: HotKeyIdentifier = .unknown
	var name: String = ""
	var index: Int = 0
	var flags: Int = 0
	var code: Int = 0
	var readonly: Bool = false
	var global: Bool = true
	var visible: Bool = true
	var state: HotKeyState = .disabled
	var deleted: Bool = false
	var group: HotKeyGroupIdentifier = .group

	init(id: HotKeyIdentifier, name: String, index: Int, flags: Int, code: Int, readonly: Bool = false, global: Bool = true, visible: Bool = true, state: HotKeyState = .disabled, deleted: Bool = false, group: HotKeyGroupIdentifier = .group) {
		self.id = id
		self.name = name
		self.index = index
		self.flags = flags
		self.code = code
		self.readonly = readonly
		self.global = global
		self.visible = visible
		self.state = state
		self.deleted = deleted
		self.group = group
	}
}
