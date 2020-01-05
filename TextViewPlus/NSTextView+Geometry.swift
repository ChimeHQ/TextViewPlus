//
//  NSTextView+Geometry.swift
//  TextViewPlus
//
//  Created by Matt Massicotte on 2019-02-22.
//  Copyright © 2019 Chime Systems. All rights reserved.
//

import Cocoa

public extension NSTextView {
    func enumerateLineFragments(for range: NSRange, block: (NSRect, NSRange) -> Void) {
        guard let layoutManager = layoutManager else {
            return
        }

        let glyphRange = layoutManager.glyphRange(forCharacterRange: range, actualCharacterRange: nil)

        withoutActuallyEscaping(block) { block in
            layoutManager.enumerateLineFragments(forGlyphRange: glyphRange) { (fragmentRect, _, _, fragmentRange, _) in
                block(fragmentRect, fragmentRange)
            }
        }
    }

    func enumerateLineFragments(for rect: NSRect, block: (NSRect, NSRange) -> Void) {
        guard let layoutManager = layoutManager else {
            return
        }

        guard let container = textContainer else {
            return
        }

        let glyphRange = layoutManager.glyphRange(forBoundingRect: rect, in: container)

        withoutActuallyEscaping(block) { block in
            layoutManager.enumerateLineFragments(forGlyphRange: glyphRange) { (fragmentRect, _, _, fragmentRange, _) in
                block(fragmentRect, fragmentRange)
            }
        }
    }
}
