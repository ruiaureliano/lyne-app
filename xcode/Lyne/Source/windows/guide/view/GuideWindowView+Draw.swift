import Cocoa

extension GuideWindowView {

	func drawHorizontalValues(displayDimensions: Bool, lineHorizontalHandler: LineHorizontalHandler, hLines: [Line]) {
		if displayDimensions && hLines.count > 1 {
			for i in 1...hLines.count - 1 {
				let valueY = (hLines[i].position - hLines[i - 1].position)
				let positionY = (hLines[i].position - hLines[i - 1].position) / 2 + hLines[i - 1].position
				let boxSize = "\(valueY)".size(font: kValueViewFont)

				let w = Int(boxSize.width + 2 * kValueViewPadding)
				let h = Int(boxSize.height + 2 * kValueViewPadding)
				let y = Int(positionY - h / 2)
				var x = Int(kValueViewMargin)

				switch lineHorizontalHandler {
				case .left:
					if valueY < 50 {
						x = Int(kValueViewMargin + kGuideHandlerViewSize + kValueViewMargin)
					}
				case .right:
					if valueY < 50 {
						x = Int(bounds.width - (kValueViewMargin + kGuideHandlerViewSize + kValueViewMargin)) - w
					} else {
						x = Int(bounds.width - kValueViewMargin) - w
					}
				case .dynamic:
					if isDynamicLeft {
						if valueY < 50 {
							x = Int(kValueViewMargin + kGuideHandlerViewSize + kValueViewMargin)
						}
					} else {
						if valueY < 50 {
							x = Int(bounds.width - (kValueViewMargin + kGuideHandlerViewSize + kValueViewMargin)) - w
						} else {
							x = Int(bounds.width - kValueViewMargin) - w
						}
					}
				}

				NSColor.black.withAlphaComponent(0.5).setFill()
				NSBezierPath(roundedRect: NSRect(x: x, y: y, width: w, height: h), xRadius: kValueViewRadius, yRadius: kValueViewRadius).fill()
				"\(valueY)".draw(in: NSRect(x: x, y: y - Int(kValueViewPadding), width: w, height: h), withAttributes: [.foregroundColor: NSColor.white, .font: kValueViewFont, .paragraphStyle: NSParagraphStyle.center])
			}
		}
	}

	func drawVerticalValues(displayDimensions: Bool, lineVerticalHandler: LineVerticalHandler, vLines: [Line]) {
		if displayDimensions && vLines.count > 1 {
			for i in 1...vLines.count - 1 {
				let valueX = (vLines[i].position - vLines[i - 1].position)
				let positionX = (vLines[i].position - vLines[i - 1].position) / 2 + vLines[i - 1].position
				let boxSize = "\(valueX)".size(font: kValueViewFont)

				let w = Int(boxSize.width + 2 * kValueViewPadding)
				let h = Int(boxSize.height + 2 * kValueViewPadding)
				var y = Int(kValueViewMargin)
				let x = Int(positionX - h / 2)

				switch lineVerticalHandler {
				case .top:
					if valueX < 50 {
						y = Int(bounds.height - (kValueViewMargin + kGuideHandlerViewSize + kValueViewMargin) - topGap) - h
					} else {
						y = Int(bounds.height - kValueViewMargin - topGap) - h
					}
				case .bottom:
					if valueX < 50 {
						y = Int(kValueViewMargin + kGuideHandlerViewSize + kValueViewMargin)
					}
				case .dynamic:
					if isDynamicTop {
						if valueX < 50 {
							y = Int(bounds.height - (kValueViewMargin + kGuideHandlerViewSize + kValueViewMargin) - topGap) - h
						} else {
							y = Int(bounds.height - kValueViewMargin - topGap) - h
						}
					} else {
						if valueX < 50 {
							y = Int(kValueViewMargin + kGuideHandlerViewSize + kValueViewMargin)
						}
					}
				}

				NSColor.black.withAlphaComponent(0.5).setFill()
				NSBezierPath(roundedRect: NSRect(x: x, y: y, width: w, height: h), xRadius: kValueViewRadius, yRadius: kValueViewRadius).fill()
				"\(valueX)".draw(in: NSRect(x: x, y: y - Int(kValueViewPadding), width: w, height: h), withAttributes: [.foregroundColor: NSColor.white, .font: kValueViewFont, .paragraphStyle: NSParagraphStyle.center])
			}
		}
	}

	func drawGuideHandlers(guideHandlers: [GuideHandler], lineHorizontalHandler: LineHorizontalHandler, lineVerticalHandler: LineVerticalHandler) {
		for guideHandler in guideHandlers {
			if guideHandler.line.selected {
				let lineColor = Preferences.shared.lineColor
				Line.color(for: lineColor).withAlphaComponent(1).setFill()
			} else {
				NSColor.black.withAlphaComponent(guideHandler.backgroundAlpha).setFill()
			}

			if !isDragging || !guideHandler.line.selected {
				let bezier = NSBezierPath(roundedRect: guideHandler.frame, xRadius: kGuideHandlerViewRadius, yRadius: kGuideHandlerViewRadius)
				bezier.setClip()
				bezier.fill()

				switch guideHandler.line.orientation {
				case .horizontal:
					if guideHandler.line.link.count == 0 {
						NSImage.handlerMoveVertical.draw(
							at: NSPoint(x: guideHandler.frame.origin.x + (kGuideHandlerViewSize - kGuideHandlerViewIconSize) / 2, y: guideHandler.frame.origin.y + (kGuideHandlerViewSize - kGuideHandlerViewIconSize) / 2),
							from: NSRect(x: 0, y: 0, width: kGuideHandlerViewIconSize, height: kGuideHandlerViewIconSize),
							operation: .sourceOver,
							fraction: guideHandler.line.hover ? 1.0 : 0.8
						)
					} else {
						switch Preferences.shared.lineHorizontalHandler {
						case .left:
							NSImage.handlerMoveVertical.draw(
								at: NSPoint(x: guideHandler.frame.origin.x + (kGuideHandlerViewSize - kGuideHandlerViewIconSize) / 2, y: guideHandler.frame.origin.y + (kGuideHandlerViewSize - kGuideHandlerViewIconSize) / 2),
								from: NSRect(x: 0, y: 0, width: kGuideHandlerViewIconSize, height: kGuideHandlerViewIconSize),
								operation: .sourceOver,
								fraction: guideHandler.line.hover ? 1.0 : 0.8
							)
							NSImage.handlerLink.draw(
								at: NSPoint(x: guideHandler.frame.origin.x + kGuideHandlerViewSize, y: guideHandler.frame.origin.y + (kGuideHandlerViewSize - kGuideHandlerViewIconSize) / 2),
								from: NSRect(x: 0, y: 0, width: kGuideHandlerViewIconSize, height: kGuideHandlerViewIconSize),
								operation: .sourceOver,
								fraction: guideHandler.line.hover ? 1.0 : 0.8
							)
						case .right:
							NSImage.handlerMoveVertical.draw(
								at: NSPoint(x: guideHandler.frame.origin.x + kGuideHandlerViewSize, y: guideHandler.frame.origin.y + (kGuideHandlerViewSize - kGuideHandlerViewIconSize) / 2),
								from: NSRect(x: 0, y: 0, width: kGuideHandlerViewIconSize, height: kGuideHandlerViewIconSize),
								operation: .sourceOver,
								fraction: guideHandler.line.hover ? 1.0 : 0.8
							)
							NSImage.handlerLink.draw(
								at: NSPoint(x: guideHandler.frame.origin.x + (kGuideHandlerViewSize - kGuideHandlerViewIconSize) / 2, y: guideHandler.frame.origin.y + (kGuideHandlerViewSize - kGuideHandlerViewIconSize) / 2),
								from: NSRect(x: 0, y: 0, width: kGuideHandlerViewIconSize, height: kGuideHandlerViewIconSize),
								operation: .sourceOver,
								fraction: guideHandler.line.hover ? 1.0 : 0.8
							)
						case .dynamic:
							if isDynamicLeft {
								NSImage.handlerMoveVertical.draw(
									at: NSPoint(x: guideHandler.frame.origin.x + (kGuideHandlerViewSize - kGuideHandlerViewIconSize) / 2, y: guideHandler.frame.origin.y + (kGuideHandlerViewSize - kGuideHandlerViewIconSize) / 2),
									from: NSRect(x: 0, y: 0, width: kGuideHandlerViewIconSize, height: kGuideHandlerViewIconSize),
									operation: .sourceOver,
									fraction: guideHandler.line.hover ? 1.0 : 0.8
								)
								NSImage.handlerLink.draw(
									at: NSPoint(x: guideHandler.frame.origin.x + kGuideHandlerViewSize, y: guideHandler.frame.origin.y + (kGuideHandlerViewSize - kGuideHandlerViewIconSize) / 2),
									from: NSRect(x: 0, y: 0, width: kGuideHandlerViewIconSize, height: kGuideHandlerViewIconSize),
									operation: .sourceOver,
									fraction: guideHandler.line.hover ? 1.0 : 0.8
								)
							} else {
								NSImage.handlerMoveVertical.draw(
									at: NSPoint(x: guideHandler.frame.origin.x + kGuideHandlerViewSize, y: guideHandler.frame.origin.y + (kGuideHandlerViewSize - kGuideHandlerViewIconSize) / 2),
									from: NSRect(x: 0, y: 0, width: kGuideHandlerViewIconSize, height: kGuideHandlerViewIconSize),
									operation: .sourceOver,
									fraction: guideHandler.line.hover ? 1.0 : 0.8
								)
								NSImage.handlerLink.draw(
									at: NSPoint(x: guideHandler.frame.origin.x + (kGuideHandlerViewSize - kGuideHandlerViewIconSize) / 2, y: guideHandler.frame.origin.y + (kGuideHandlerViewSize - kGuideHandlerViewIconSize) / 2),
									from: NSRect(x: 0, y: 0, width: kGuideHandlerViewIconSize, height: kGuideHandlerViewIconSize),
									operation: .sourceOver,
									fraction: guideHandler.line.hover ? 1.0 : 0.8
								)
							}
						}
					}
				case .vertical:
					if guideHandler.line.link.count == 0 {
						NSImage.handlerMoveHorizontal.draw(
							at: NSPoint(x: guideHandler.frame.origin.x + (kGuideHandlerViewSize - kGuideHandlerViewIconSize) / 2, y: guideHandler.frame.origin.y + (kGuideHandlerViewSize - kGuideHandlerViewIconSize) / 2),
							from: NSRect(x: 0, y: 0, width: kGuideHandlerViewIconSize, height: kGuideHandlerViewIconSize),
							operation: .sourceOver,
							fraction: guideHandler.line.hover ? 1.0 : 0.8
						)
					} else {
						switch Preferences.shared.lineVerticalHandler {
						case .top:
							NSImage.handlerMoveHorizontal.draw(
								at: NSPoint(x: guideHandler.frame.origin.x + (kGuideHandlerViewSize - kGuideHandlerViewIconSize) / 2, y: guideHandler.frame.origin.y + kGuideHandlerViewSize),
								from: NSRect(x: 0, y: 0, width: kGuideHandlerViewIconSize, height: kGuideHandlerViewIconSize),
								operation: .sourceOver,
								fraction: guideHandler.line.hover ? 1.0 : 0.8
							)
							NSImage.handlerLink.draw(
								at: NSPoint(x: guideHandler.frame.origin.x + (kGuideHandlerViewSize - kGuideHandlerViewIconSize) / 2, y: guideHandler.frame.origin.y + (kGuideHandlerViewSize - kGuideHandlerViewIconSize) / 2),
								from: NSRect(x: 0, y: 0, width: kGuideHandlerViewIconSize, height: kGuideHandlerViewIconSize),
								operation: .sourceOver,
								fraction: guideHandler.line.hover ? 1.0 : 0.8
							)
						case .bottom:
							NSImage.handlerLink.draw(
								at: NSPoint(x: guideHandler.frame.origin.x + (kGuideHandlerViewSize - kGuideHandlerViewIconSize) / 2, y: guideHandler.frame.origin.y + kGuideHandlerViewSize),
								from: NSRect(x: 0, y: 0, width: kGuideHandlerViewIconSize, height: kGuideHandlerViewIconSize),
								operation: .sourceOver,
								fraction: guideHandler.line.hover ? 1.0 : 0.8
							)
							NSImage.handlerMoveHorizontal.draw(
								at: NSPoint(x: guideHandler.frame.origin.x + (kGuideHandlerViewSize - kGuideHandlerViewIconSize) / 2, y: guideHandler.frame.origin.y + (kGuideHandlerViewSize - kGuideHandlerViewIconSize) / 2),
								from: NSRect(x: 0, y: 0, width: kGuideHandlerViewIconSize, height: kGuideHandlerViewIconSize),
								operation: .sourceOver,
								fraction: guideHandler.line.hover ? 1.0 : 0.8
							)
						case .dynamic:
							if isDynamicTop {
								NSImage.handlerMoveHorizontal.draw(
									at: NSPoint(x: guideHandler.frame.origin.x + (kGuideHandlerViewSize - kGuideHandlerViewIconSize) / 2, y: guideHandler.frame.origin.y + kGuideHandlerViewSize),
									from: NSRect(x: 0, y: 0, width: kGuideHandlerViewIconSize, height: kGuideHandlerViewIconSize),
									operation: .sourceOver,
									fraction: guideHandler.line.hover ? 1.0 : 0.8
								)
								NSImage.handlerLink.draw(
									at: NSPoint(x: guideHandler.frame.origin.x + (kGuideHandlerViewSize - kGuideHandlerViewIconSize) / 2, y: guideHandler.frame.origin.y + (kGuideHandlerViewSize - kGuideHandlerViewIconSize) / 2),
									from: NSRect(x: 0, y: 0, width: kGuideHandlerViewIconSize, height: kGuideHandlerViewIconSize),
									operation: .sourceOver,
									fraction: guideHandler.line.hover ? 1.0 : 0.8
								)
							} else {
								NSImage.handlerLink.draw(
									at: NSPoint(x: guideHandler.frame.origin.x + (kGuideHandlerViewSize - kGuideHandlerViewIconSize) / 2, y: guideHandler.frame.origin.y + kGuideHandlerViewSize),
									from: NSRect(x: 0, y: 0, width: kGuideHandlerViewIconSize, height: kGuideHandlerViewIconSize),
									operation: .sourceOver,
									fraction: guideHandler.line.hover ? 1.0 : 0.8
								)
								NSImage.handlerMoveHorizontal.draw(
									at: NSPoint(x: guideHandler.frame.origin.x + (kGuideHandlerViewSize - kGuideHandlerViewIconSize) / 2, y: guideHandler.frame.origin.y + (kGuideHandlerViewSize - kGuideHandlerViewIconSize) / 2),
									from: NSRect(x: 0, y: 0, width: kGuideHandlerViewIconSize, height: kGuideHandlerViewIconSize),
									operation: .sourceOver,
									fraction: guideHandler.line.hover ? 1.0 : 0.8
								)
							}
						}
					}
				}
			}
		}
	}

	func drawCrossHandler(crossHandlers: [CrossHandler]) {
		if let crossHandler = crossHandlers.first(where: { $0.id == selectedCrossHandler?.id }), !isDragging {
			let bezier = NSBezierPath(ovalIn: crossHandler.frame)
			bezier.setClip()
			let lineColor = Preferences.shared.lineColor
			NSColor.white.setFill()
			Line.color(for: lineColor).withAlphaComponent(1).setStroke()
			bezier.fill()
			bezier.strokeInside()
		}
	}

	func drawCursor(guideHandler: GuideHandler?, crossHandler: CrossHandler?, lineHorizontalHandler: LineHorizontalHandler, lineVerticalHandler: LineVerticalHandler) {
		if isDragging, let screen = NSScreen.screenMouse {
			if let guideHandler = guideHandler {
				let hSelectedLines = Guide.shared.lines(orientation: .horizontal, screenIndex: screenIndex).filter { $0.selected }
				let vSelectedLines = Guide.shared.lines(orientation: .vertical, screenIndex: screenIndex).filter { $0.selected }
				let orientation: LineDraggingOrientation = (hSelectedLines.count > 0 && vSelectedLines.count > 0) ? .multiple : (guideHandler.line.orientation == .horizontal ? .horizontal : .vertical)

				switch orientation {
				case .horizontal:
					if NSEvent.mouseLocation.y.rounded(.down) <= screen.frame.origin.y.rounded(.up) {
						NSCursor.cursorDeleteTop().set()
					} else if NSEvent.mouseLocation.y.rounded(.up) >= (screen.frame.origin.y + screen.frame.height).rounded(.down) {
						NSCursor.cursorDeleteBottom().set()
					} else {
						NSCursor.cursorHorizontal().set()
					}
				case .vertical:
					if NSEvent.mouseLocation.x.rounded(.down) <= screen.frame.origin.x.rounded(.up) {
						NSCursor.cursorDeleteRight().set()
					} else if NSEvent.mouseLocation.x.rounded(.up) >= (screen.frame.origin.x + screen.frame.width).rounded(.down) {
						NSCursor.cursorDeleteLeft().set()
					} else {
						NSCursor.cursorVertical().set()
					}
				case .multiple:
					switch guideHandler.line.orientation {
					case .horizontal:
						if NSEvent.mouseLocation.y.rounded(.down) <= screen.frame.origin.y.rounded(.up) {
							NSCursor.cursorDeleteTop().set()
						} else if NSEvent.mouseLocation.y.rounded(.up) >= (screen.frame.origin.y + screen.frame.height).rounded(.down) {
							NSCursor.cursorDeleteBottom().set()
						} else {
							NSCursor.cursorMultiple().set()
						}
					case .vertical:
						if NSEvent.mouseLocation.x.rounded(.down) <= screen.frame.origin.x.rounded(.up) {
							NSCursor.cursorDeleteRight().set()
						} else if NSEvent.mouseLocation.x.rounded(.up) >= (screen.frame.origin.x + screen.frame.width).rounded(.down) {
							NSCursor.cursorDeleteLeft().set()
						} else {
							NSCursor.cursorMultiple().set()
						}
					}
				}
			} else if crossHandler != nil {
				NSCursor.cursorCross().set()
			}
		}
	}
}
