import Cocoa

extension NSEvent.ModifierFlags {

	var isNone: Bool {
		return !self.contains(.shift) && !self.contains(.command) && !self.contains(.option) && !self.contains(.control)
	}

	var isShift: Bool {
		return self.contains(.shift) && !self.contains(.command) && !self.contains(.option) && !self.contains(.control)
	}

	var isOption: Bool {
		return !self.contains(.shift) && !self.contains(.command) && self.contains(.option) && !self.contains(.control)
	}

	var isCommand: Bool {
		return !self.contains(.shift) && self.contains(.command) && !self.contains(.option) && !self.contains(.control)
	}

	var isShiftCommand: Bool {
		return self.contains(.shift) && self.contains(.command) && !self.contains(.option) && !self.contains(.control)
	}
}
