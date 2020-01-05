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
    public var selectedTextRanges: [NSRange] {
        get {
            return selectedRanges.map({ $0.rangeValue })
        }
        set {
            selectedRanges = newValue.map { NSValue(range: $0) }
        }
    }

    public var selectedContinuousRange: NSRange? {
        let ranges = selectedTextRanges
        if ranges.count != 1 {
            return nil
        }

        return ranges.first!
    }

    public var insertionLocation: Int? {
        guard let range = selectedContinuousRange else {
            return nil
        }

        return range.length == 0 ? range.location : nil
    }
}
