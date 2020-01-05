//
//  NSTextView+Ranges.swift
//  TextViewPlus
//
//  Created by Matt Massicotte on 2019-12-16.
//  Copyright © 2019 Chime Systems Inc. All rights reserved.
//

import Foundation
import class AppKit.NSTextView

extension NSTextView {
    @objc open func textRange(for rect: NSRect) -> NSRange {
        let length = self.textStorage?.length ?? 0

        guard let layoutManager = self.layoutManager else {
            return NSRange(0..<length)
        }

        guard let container = self.textContainer else {
            return NSRange(0..<length)
        }

        let origin = textContainerOrigin
        let offsetRect = rect.offsetBy(dx: origin.x, dy: origin.y)

        let glyphRange = layoutManager.glyphRange(forBoundingRect: offsetRect, in: container)

        return layoutManager.characterRange(forGlyphRange: glyphRange, actualGlyphRange: nil)
    }

    @objc open var visibleTextRange: NSRange {
        return textRange(for: visibleRect)
    }
}
