[![Build Status][build status badge]][build status]
[![Platforms][platforms badge]][platforms]

# TextViewPlus

This project aims to make it easier to use `NSTextView`. It was originally built to support TextKit 1. But, now a major goal is to support TextKit 2.

## Integration

```swift
dependencies: [
    .package(url: "https://github.com/ChimeHQ/TextViewPlus")
],
targets: [
    .target(
        name: "UseCoreFunctionality",
        dependencies: ["TextViewPlus"]
    ),
    .target(
        name: "UseBaseTextView",
        dependencies: [.product(name: "BaseTextView", package: "TextViewPlus")]
    ),
]
```

## BaseTextView

This is an TextKit 2-only `NSTextView` subclass that aims for an absolute minimal amount of changes. Things are allowed only if they are required for correct functionality. It is intended to be a drop-in replacement for `NSTextView`, and should maintain compatibilty with existing subclasses. Behaviors are appropriate for all types of text.

- Disables all support for TextKit 1
- Workaround for `scrollRangeToVisible` bug (FB13100459)
- Minimum `textContainerInset` enforcement to address more `scrollRangeToVisible` bugs
- Additional routing to `NSTextViewDelegate.textView(_:, doCommandBy:) -> Bool`:  `paste`, `pasteAsRichText`, `pasteAsPlainText`
- Hooks for `onKeyDown`, `onFlagsChanged`, `onMouseDown`
- Configurable selection notifcation delivery via `continuousSelectionNotifications`

## NSTextView Extensions

### Ranges

Handy methods for computing ranges of text within the view.

```swift
func textRange(for rect: NSRect) -> NSRange
var visibleTextRange: NSRange
```

### Selection

Convenience methods for computing selection ranges/locations.

```swift
var selectedTextRanges: [NSRange]
var selectedContinuousRange: NSRange?
var insertionLocation: Int?
```

### Style

Styling changes can be very expensive, this method is much faster in certain common cases.

```swift
func updateFont(_ newFont: NSFont, color newColor: NSColor)
```

### Bounding

Computing bounding rectangles of displayed text.

```swift
func boundingRect(for range: NSRange) -> NSRect?
func boundingRect(forGlyphRange range: NSRange) -> NSRect?
func boundingSelectionRects(forRange range: NSRange) -> [NSRect]
```

### Attributed Strings

Programmatic modification of the underlying attributed string in the `NSTextStorage`, with support for delegate callbacks and undo.

```swift
func replaceCharacters(in range: NSRange, with attributedString: NSAttributedString)

// with undo supported
func replaceString(in range: NSRange, with attributedString: NSAttributedString)
```

### Behavior

Changing `NSTextView` behaviors can be tricky, and often involve complex interactions with the whole system (`NSLayoutManager`, `NSTextContainer`, `NSScrollView`, etc).

```swift
public var wrapsTextToHorizontalBounds: Bool
```

## TextKit 2 Features

### Workarounds

In versions of macOS before 13, TextKit 2 doesn't correctly apply rendering attributes. You can sub in this `NSTextLayoutFragment` to workaround the issue.

```swift
extension YourClass: NSTextLayoutManagerDelegate {
    func textLayoutManager(_ textLayoutManager: NSTextLayoutManager, textLayoutFragmentFor location: NSTextLocation, in textElement: NSTextElement) -> NSTextLayoutFragment {
        let range = textElement.elementRange

        switch textElement {
        case let paragraph as NSTextParagraph:
            return ParagraphRenderingAttributeTextLayoutFragment(textParagraph: paragraph, range: range)
        default:
            return NSTextLayoutFragment(textElement: textElement, range: range)
        }
    }
}
```

## TextKit 1 Features

### `NSLayoutManager` extensions

```swift
func enumerateLineFragments(for range: NSRange, block: (NSRect, NSRange) -> Void)
func enumerateLineFragments(for rect: NSRect, block: (NSRect, NSRange) -> Void)
```

## Contributing and Collaboration

I'd love to hear from you! Get in touch via an issue or pull request.

I prefer collaboration, and would love to find ways to work together if you have a similar project.

I prefer indentation with tabs for improved accessibility. But, I'd rather you use the system you want and make a PR than hesitate because of whitespace.

By participating in this project you agree to abide by the [Contributor Code of Conduct](CODE_OF_CONDUCT.md).

[build status]: https://github.com/ChimeHQ/TextViewPlus/actions
[build status badge]: https://github.com/ChimeHQ/TextViewPlus/workflows/CI/badge.svg
[platforms]: https://swiftpackageindex.com/ChimeHQ/TextViewPlus
[platforms badge]: https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2FChimeHQ%2FTextViewPlus%2Fbadge%3Ftype%3Dplatforms
