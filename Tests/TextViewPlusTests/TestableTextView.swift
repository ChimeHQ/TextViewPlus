import AppKit

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
