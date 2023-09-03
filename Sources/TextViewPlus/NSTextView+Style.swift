#if os(macOS)
import AppKit

extension NSTextView {
	/// Update `textColor` and `font` properties together.
	///
	/// These operations are expensive. The begin/end help reduce the work required, as does skipping the work altogether if unneeded.
    public func updateFont(_ newFont: NSFont, color newColor: NSColor) {
        let colorChanged = textColor != newColor
        let fontChanged = font != newFont

        if !colorChanged && !fontChanged {
            return
        }

        textStorage?.beginEditing()

        if colorChanged {
            textColor = newColor
        }

        if fontChanged {
            font = newFont
        }

        textStorage?.endEditing()
    }
}
#endif
