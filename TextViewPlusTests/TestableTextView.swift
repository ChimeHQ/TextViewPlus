//
//  TestableTextView.swift
//  TextViewPlusTests
//
//  Created by Matt Massicotte on 2020-01-03.
//  Copyright © 2020 ChimeHq. All rights reserved.
//

import Foundation
import class AppKit.NSTextView

class TestableTextView: NSTextView {
    var settableUndoManager = UndoManager()

    override var undoManager: UndoManager? {
        return settableUndoManager
    }

    convenience init(string: String) {
        self.init()

        self.string = string
    }
}
