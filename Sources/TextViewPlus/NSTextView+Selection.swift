//
//  NSTextView+Selection.swift
//  TextViewPlus
//
//  Created by Matt Massicotte on 2019-12-16.
//  Copyright © 2019 Chime Systems Inc. All rights reserved.
//

import Foundation
import class AppKit.NSTextView

extension NSTextView {
    /// All the selected ranges, as NSRange instances
    public var selectedTextRanges: [NSRange] {
        get {
            return selectedRanges.map({ $0.rangeValue })
        }
        set {
            selectedRanges = newValue.map { NSValue(range: $0) }
        }
    }

    /// A single range representing a single, continuous selection
    ///
    /// This method returns nil if there isn't exactly one selection range.
    public var selectedContinuousRange: NSRange? {
        let ranges = selectedTextRanges
        if ranges.count != 1 {
            return nil
        }

        return ranges.first!
    }

    /// A singlel location representing a single, zero-length selection
    ///
    /// This method returns nil if there is more than one selected range,
    /// or if that range has a non-zero length.
    public var insertionLocation: Int? {
        guard let range = selectedContinuousRange else {
            return nil
        }

        return range.length == 0 ? range.location : nil
    }
}
