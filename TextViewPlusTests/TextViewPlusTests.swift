//
//  TextViewPlusTests.swift
//  TextViewPlusTests
//
//  Created by Matt Massicotte on 2020-01-03.
//  Copyright © 2020 ChimeHq. All rights reserved.
//

import XCTest
@testable import TextViewPlus

class TextViewPlusTests: XCTestCase {
    func testProgrammaticModificationOfAttributedString() {
        let textView = TestableTextView(string: "abc")

        let attrString = NSAttributedString(string: "z")
        textView.replaceString(in: NSRange(location: 1, length: 1), with: attrString)

        XCTAssertEqual(textView.string, "azc")

        textView.undoManager!.undo()

        XCTAssertEqual(textView.string, "abc")
    }
}
