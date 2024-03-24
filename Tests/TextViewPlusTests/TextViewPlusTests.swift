import XCTest
import TextViewPlus

@MainActor
final class TextViewPlusTests: XCTestCase {
    func testProgrammaticModificationOfAttributedString() {
        let textView = TestableTextView(string: "abc")

        let attrString = NSAttributedString(string: "z")
        textView.replaceString(in: NSRange(location: 1, length: 1), with: attrString)

        XCTAssertEqual(textView.string, "azc")

        textView.undoManager!.undo()

        XCTAssertEqual(textView.string, "abc")
    }

    func testProgrammaticModificationOfAttributedStringWithZeroLengthRange() {
        let textView = TestableTextView(string: "abc")

        let attrString = NSAttributedString(string: "z")
        textView.replaceString(in: NSRange(location: 1, length: 0), with: attrString)

        XCTAssertEqual(textView.string, "azbc")

        textView.undoManager!.undo()

        XCTAssertEqual(textView.string, "abc")
    }

    func testProgrammaticModificationOfAttributedStringWithFullRange() {
        let textView = TestableTextView(string: "abc")

        let attrString = NSAttributedString(string: "def")
        textView.replaceString(in: NSRange(location: 0, length: 3), with: attrString)

        XCTAssertEqual(textView.string, "def")

        textView.undoManager!.undo()

        XCTAssertEqual(textView.string, "abc")
    }

    func testProgrammaticInsertionOfAttributedString() {
        let textView = TestableTextView(string: "abc")

        let attrString = NSAttributedString(string: "z")
        textView.insertString(attrString, at: 1)

        XCTAssertEqual(textView.string, "azbc")

        textView.undoManager!.undo()

        XCTAssertEqual(textView.string, "abc")
    }

    func testProgrammaticDeletionOfAttributedString() {
        let textView = TestableTextView(string: "abc")

        textView.deleteString(in: NSRange(location: 1, length: 1))

        XCTAssertEqual(textView.string, "ac")

        textView.undoManager!.undo()

        XCTAssertEqual(textView.string, "abc")
    }

    func testProgrammaticDeletionOfAttributedStringWithFullRange() {
        let textView = TestableTextView(string: "abc")

        textView.deleteString(in: NSRange(location: 0, length: 3))

        XCTAssert(textView.string.isEmpty)

        textView.undoManager!.undo()

        XCTAssertEqual(textView.string, "abc")
    }

}

extension TextViewPlusTests {
    func testSelectionRanges() {
        let textView = TestableTextView(string: "abc")

        XCTAssertEqual(textView.selectedRanges, [NSValue(range: NSRange(3..<3))])
        XCTAssertEqual(textView.selectedTextRanges, [NSRange(3..<3)])

        textView.selectedTextRanges = [NSRange(0..<0)]

        XCTAssertEqual(textView.selectedRanges, [NSValue(range: NSRange(0..<0))])
        XCTAssertEqual(textView.selectedTextRanges, [NSRange(0..<0)])
    }

    func testContinuousSelectionRanges() {
        let textView = TestableTextView(string: "abc")

        XCTAssertEqual(textView.selectedContinuousRange, NSRange(3..<3))

        textView.selectedTextRanges = [NSRange(0..<1), NSRange(2..<3)]

        XCTAssertNil(textView.selectedContinuousRange)
    }

    func testInsertionLocation() {
        let textView = TestableTextView(string: "abc")

        XCTAssertEqual(textView.insertionLocation, 3)

        textView.selectedTextRanges = [NSRange(0..<1)]

        XCTAssertNil(textView.insertionLocation)
    }
}
