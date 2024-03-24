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

    func insertCharacters(_ attributedString: NSAttributedString, at location: Int) {
        guard let storage = textStorage else {
            fatalError("Unable to replace characters in a textview without a backing NSTextStorage")
        }

        storage.insert(attributedString, at: location)

        didChangeText()
    }

    /// Undoable insertion of attributed string at specified location
    func insertString(_ attributedString: NSAttributedString, at location: Int) {
        if let manager = undoManager {
            let inverseLength = attributedString.length
            let inverseRange = NSRange(location: location, length: inverseLength)

            manager.registerUndo(withTarget: self, handler: { view in
                view.deleteString(in: inverseRange)
            })
        }

        insertCharacters(attributedString, at: location)
    }

    func deleteCharacters(in range: NSRange) {
        guard let storage = textStorage else {
            fatalError("Unable to replace characters in a textview without a backing NSTextStorage")
        }

        storage.deleteCharacters(in: range)

        didChangeText()
    }

    /// Undoable deletion of string in specified range
    func deleteString(in range: NSRange) {
        if let manager = undoManager {
            let originalString = safeAttributedSubstring(forProposedRange: range, actualRange: nil)
            let usableReplacementString = originalString ?? NSAttributedString()

            manager.registerUndo(withTarget: self, handler: { view in
                view.insertString(usableReplacementString, at: range.location)
            })
        }

        deleteCharacters(in: range)
    }
}
