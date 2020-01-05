//
//  NSTextView+Bounding.swift
//  TextViewPlus
//
//  Created by Matt Massicotte on 2018-10-18.
//  Copyright © 2018 Chime Systems. All rights reserved.
//

import Cocoa

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

        var rects: [NSRect] = []

        let glyphRange = layoutManager.glyphRange(forCharacterRange: range, actualCharacterRange: nil)

        // swiftlint:disable line_length
        layoutManager.enumerateEnclosingRects(forGlyphRange: glyphRange, withinSelectedGlyphRange: glyphRange, in: textContainer) { (rect, stop) in
            rects.append(rect)
        }

        return rects
    }
}
