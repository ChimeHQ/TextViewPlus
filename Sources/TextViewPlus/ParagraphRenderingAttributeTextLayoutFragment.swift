#if canImport(AppKit)
import AppKit
#elseif canImport(UIKit)
import UIKit
#endif

import Rearrange

@available(iOS 15.0, macOS 12.0, tvOS 15.0, *)
extension NSTextLayoutFragment {
    var textContentManager: NSTextContentManager? {
        return textLayoutManager?.textContentManager
    }

    var lineFragmentPadding: CGFloat {
        return textLayoutManager?.textContainer?.lineFragmentPadding ?? 0.0
    }
}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, *)
public class ParagraphRenderingAttributeTextLayoutFragment: NSTextLayoutFragment {
    public init(textParagraph: NSTextParagraph, range: NSTextRange?) {
        super.init(textElement: textParagraph, range: range)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public var textParagraph: NSTextParagraph {
        return textElement as! NSTextParagraph
    }

    public override func draw(at point: CGPoint, in context: CGContext) {
        guard let fixedString = buildFixedAttributedString() else {
            super.draw(at: point, in: context)
            return
        }

        let xDelta = layoutFragmentFrame.minX + lineFragmentPadding

        let p = CGPoint(x: point.x + xDelta, y: point.y)

        fixedString.draw(at: p)
    }

    private func buildFixedAttributedString() -> NSAttributedString? {
        return applyRenderingAttributes(to: textParagraph.attributedString)
    }

    private func applyRenderingAttributes(to baseString: NSAttributedString) -> NSAttributedString? {
        guard let contentManager = textLayoutManager?.textContentManager else { return nil }

        let fragmentRange = NSRange(rangeInElement, provider: contentManager)
        let delta = -fragmentRange.location
        let endLocation = rangeInElement.endLocation

        let string = NSMutableAttributedString(attributedString: baseString)

        textLayoutManager?.enumerateRenderingAttributes(from: rangeInElement.location, reverse: false, using: { _, attrs, range in
            guard range.endLocation < endLocation else { return false }

            guard let stringRange = NSRange(range, provider: contentManager).shifted(by: delta) else {
                return false
            }

            string.addAttributes(attrs, range: stringRange)

            return true
        })

        return string
    }
}
