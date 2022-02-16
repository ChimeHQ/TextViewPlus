//
//  NSLayoutManager+Geometry.swift
//  TextViewPlus
//
//  Created by Matt Massicotte on 2020-05-28.
//  Copyright © 2020 Chime Systems Inc. All rights reserved.
//

import Cocoa

public extension NSLayoutManager {
    func enclosingRect(forCharacterIndex index: Int, in container: NSTextContainer) -> NSRect {
        let fullGlyphRange = glyphRange(for: container)
        let fullCharRange = characterRange(forGlyphRange: fullGlyphRange, actualGlyphRange: nil)

        if index == NSMaxRange(fullCharRange) {
            let extraRect = extraLineFragmentRect

            if extraRect.isEmpty == false {
                return extraRect
            }

            let lastGlyphIndex = max(NSMaxRange(fullGlyphRange) - 1, 0)

            return lineFragmentRect(forGlyphAt: lastGlyphIndex, effectiveRange: nil)
        }

        let glyphIndex = glyphIndexForCharacter(at: index)
        let glyphRange = NSRange(location: glyphIndex, length: 1)

        // becuase we are looking at a range with a length of one, we expect
        // to iterate over exactly one enclosing rectangle
        var rect: NSRect?

        // swiftlint:disable line_length
        enumerateEnclosingRects(forGlyphRange: glyphRange, withinSelectedGlyphRange: glyphRange, in: container) { (enclosingRect, _) in
            precondition(rect == nil)

            rect = enclosingRect
        }
        // swiftlint:enable line_length

        return rect!
    }
}
