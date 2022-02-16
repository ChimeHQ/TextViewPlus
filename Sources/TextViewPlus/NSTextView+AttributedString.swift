//
//  NSTextView+AttributedString.swift
//  TextViewPlus
//
//  Created by Matt Massicotte on 2019-12-16.
//  Copyright © 2019 Chime Systems Inc. All rights reserved.
//

import Foundation
import class AppKit.NSTextView

public extension NSTextView {
    func replaceCharacters(in range: NSRange, with attributedString: NSAttributedString) {
        guard let storage = textStorage else {
            fatalError("Unable to replace characters in a textview without a backing NSTextStorage")
        }

        storage.replaceCharacters(in: range, with: attributedString)

        didChangeText()
    }

    // swiftlint:disable line_length
    private func safeAttributedSubstring(forProposedRange range: NSRange, actualRange: NSRangePointer?) -> NSAttributedString? {
        // attributedSubstring returns nil for out-of-range AND for length == 0. But, zero-length ranges
        // are totally acceptable, and I'm not sure that's reasonable behavior.
        let maxLength = textStorage?.length ?? 0

        guard NSMaxRange(range) <= maxLength else {
            fatalError("Range out of bounds for underlying storage")
        }

        // also, we must have a copy, as the underlying TextStorage can change, and it seems the
        // string is changing along with it.
        return attributedSubstring(forProposedRange: range, actualRange: actualRange)?.copy() as? NSAttributedString
    }

    func replaceString(in range: NSRange, with attributedString: NSAttributedString) {
        if let manager = undoManager {
            let originalString = safeAttributedSubstring(forProposedRange: range, actualRange: nil)
            let usableReplacementString = originalString ?? NSAttributedString()

            let inverseLength = attributedString.length
            let inverseRange = NSRange(location: range.location, length: inverseLength)

            manager.registerUndo(withTarget: self, handler: { (view) in
                view.replaceString(in: inverseRange, with: usableReplacementString)
            })
        }

        replaceCharacters(in: range, with: attributedString)
    }
}
