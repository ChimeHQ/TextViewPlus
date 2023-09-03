import AppKit

public extension NSTextView {
    func boundingRect(for range: NSRange) -> NSRect? {
        guard let glyphRange = layoutManager?.glyphRange(forCharacterRange: range, actualCharacterRange: nil) else {
            return nil
        }

        return boundingRect(forGlyphRange: glyphRange)
    }

    func boundingRect(forGlyphRange range: NSRange) -> NSRect? {
        guard let textContainer = textContainer else {
            return nil
        }

        let origin = textContainerOrigin

        guard let rect = layoutManager?.boundingRect(forGlyphRange: range, in: textContainer) else {
            return nil
        }

        return rect.offsetBy(dx: origin.x, dy: origin.y)
    }

    func boundingSelectionRects(forRange range: NSRange) -> [NSRect] {
        guard let layoutManager = layoutManager else {
            return []
        }

        guard let textContainer = textContainer else {
            return []
        }

        let origin = textContainerOrigin

        var rects: [NSRect] = []

        let glyphRange = layoutManager.glyphRange(forCharacterRange: range, actualCharacterRange: nil)

        // swiftlint:disable line_length
        layoutManager.enumerateEnclosingRects(forGlyphRange: glyphRange, withinSelectedGlyphRange: glyphRange, in: textContainer) { (rect, stop) in
            let offsetRect = rect.offsetBy(dx: origin.x, dy: origin.y)

            rects.append(offsetRect)
        }
        // swiftlint:enable line_length

        return rects
    }

    func enclosingLineRect(forCharacterIndex location: Int) -> NSRect? {
        guard let layoutManager = layoutManager, let container = textContainer else {
            return nil
        }

        let origin = self.textContainerOrigin
        let enclosingRect = layoutManager.enclosingRect(forCharacterIndex: location, in: container)
        let offsetRect = enclosingRect.offsetBy(dx: origin.x, dy: origin.y)
        let fullWidthRect = NSRect(x: 0.0, y: offsetRect.minY, width: self.bounds.width, height: offsetRect.height)

        return fullWidthRect
    }
}
