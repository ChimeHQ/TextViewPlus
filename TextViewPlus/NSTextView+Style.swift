//
//  NSTextView+Style.swift
//  TextViewPlus
//
//  Created by Matt Massicotte on 2019-12-19.
//  Copyright © 2019 Chime Systems. All rights reserved.
//

import Cocoa

extension NSTextView {
    public func updateFont(_ newFont: NSFont, color newColor: NSColor) {
        // These operations are expensive, the begin/end help reduce
        // the work required, as does skipping the work altogether if
        // unneeded

        let colorChanged = textColor != newColor
        let fontChanged = font != newFont

        if !colorChanged && !fontChanged {
            return
        }

        textStorage?.beginEditing()

        if colorChanged {
            textColor = newColor
        }

        if fontChanged {
            font = newFont
        }

        textStorage?.endEditing()
    }

    public var wrapsTextToHorizontalBounds: Bool {
        get {
            return textContainer?.widthTracksTextView ?? false
        }
        set {
            guard let scrollView = enclosingScrollView else {
                return
            }

            let max = CGFloat.greatestFiniteMagnitude
            let width = newValue ? scrollView.contentSize.width : max
            let size = NSSize(width: width, height: max)

            textContainer?.containerSize = size
            textContainer?.widthTracksTextView = newValue
            isHorizontallyResizable = newValue == false
        }
    }
}
