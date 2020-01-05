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

    func replaceString(in range: NSRange, with attributedString: NSAttributedString) {
        if let manager = undoManager {
            guard let originalString = attributedSubstring(forProposedRange: range, actualRange: nil) else {
                fatalError("Range invalid for string")
            }

            let inverseLength = attributedString.length
            let inverseRange = NSRange(location: range.location, length: inverseLength)

            manager.registerUndo(withTarget: self, handler: { (view) in
                view.replaceString(in: inverseRange, with: originalString)
            })
        }

        replaceCharacters(in: range, with: attributedString)
    }
}
