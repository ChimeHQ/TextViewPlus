import AppKit

extension NSTextView {

    /// Fixes selection drawing artifact issues.
    ///
    /// In many circumstances, NSTextView will perform incorrect drawing of selection. This
    /// will result in visual artifacts left over on the text background. This problem is
    /// visible in most applications that use NSTextView, including ones shipped by Apple.
    ///
    /// After some trial and error, it was determined that performing this operation will
    /// eliminate the visual artifacts and have limited (or possibly no) performance impact.
    public func applySelectionDrawingWorkaround() {
        rotate(byDegrees: 1.0)
        rotate(byDegrees: -1.0)
    }
}
