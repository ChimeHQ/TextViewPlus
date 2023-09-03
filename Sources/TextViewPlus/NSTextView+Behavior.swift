import AppKit

extension NSTextView {
    private var maximumUsableWidth: CGFloat {
        guard let scrollView = enclosingScrollView else {
            return bounds.width
        }

        let usableWidth = scrollView.contentSize.width - textContainerInset.width

        guard scrollView.rulersVisible, let rulerView = scrollView.verticalRulerView else {
            return usableWidth
        }

        return usableWidth - rulerView.requiredThickness
    }

    /// Controls the relative sizing behavior of the NSTextView and its NSTextContainer
    ///
	/// NSTextView size changes/scrolling behavior is tricky. This adjusts:
	/// - `textContainer.widthTracksTextView`
	/// - `textContainer?.size`: to allow unlimited height/width growth
	/// - `maxSize`: to allow unlimited height/width growth
	/// - `frame`: to account for `NSScrollView` rulers
	///
    /// Check out: https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/TextUILayer/Tasks/TextInScrollView.html
    public var wrapsTextToHorizontalBounds: Bool {
        get {
            guard let container = textContainer else {
                return false
            }

            return container.widthTracksTextView
        }
        set {
            textContainer?.widthTracksTextView = newValue

            let max = CGFloat.greatestFiniteMagnitude
			let size = NSSize(width: max, height: max)

            textContainer?.size = size
			maxSize = size

            // if we are turning on wrapping, our view could be the wrong size,
            // so need to adjust it. Also, the textContainer's width could have
            // been set to large, but adjusting the frame will fix that
            // automatically
            if newValue {
                let newSize = NSSize(width: maximumUsableWidth, height: frame.height)

                self.frame = NSRect(origin: frame.origin, size: newSize)
            }
        }
    }
}
