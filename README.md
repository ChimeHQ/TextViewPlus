[![Github CI](https://github.com/ChimeHQ/TextViewPlus/workflows/CI/badge.svg)](https://github.com/ChimeHQ/TextViewPlus/actions)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg)](https://github.com/Carthage/Carthage)
![](https://img.shields.io/badge/Swift-5.0-orange.svg)

# TextViewPlus

TextViewPlus is a collection of utilities for making it easier to work with NSTextView.

## Integration

Swift Package Manager:

```swift
dependencies: [
    .package(url: "https://github.com/ChimeHQ/TextViewPlus.git")
]
```

Carthage:

```
github "ChimeHQ/TextViewPlus"
```

## Extensions

**Geometry**

Wrappers around the underlying NSLayoutManager, but with a much more convenient API.

```swift
func enumerateLineFragments(for range: NSRange, block: (NSRect, NSRange) -> Void)
func enumerateLineFragments(for rect: NSRect, block: (NSRect, NSRange) -> Void)
```

**Ranges**

Handy methods for computing ranges of text within the view.

```swift
func textRange(for rect: NSRect) -> NSRange
var visibleTextRange: NSRange
```

**Selection**

Convenience methods for computing selection ranges/locations.

```swift
var selectedTextRanges: [NSRange]
var selectedContinuousRange: NSRange?
var insertionLocation: Int?
```

**Style**

Styling changes can be very expensive, this method is much faster in certain common cases.

```swift
func updateFont(_ newFont: NSFont, color newColor: NSColor)
```

**Bounding**

Computing bounding rectangles of displayed text.

```swift
func boundingRect(for range: NSRange) -> NSRect?
func boundingRect(forGlyphRange range: NSRange) -> NSRect?
func boundingSelectionRects(forRange range: NSRange) -> [NSRect]
```

**Attributed Strings**

Programmtic modification of the underlying attributed string in the NSTextStorage, with support for delegate callbacks and undo.

```swift
func replaceCharacters(in range: NSRange, with attributedString: NSAttributedString)

// with undo supported
func replaceString(in range: NSRange, with attributedString: NSAttributedString)
```

### Suggestions or Feedback

We'd love to hear from you! Get in touch via [twitter](https://twitter.com/chimehq), an issue, or a pull request.

Please note that this project is released with a [Contributor Code of Conduct](CODE_OF_CONDUCT.md). By participating in this project you agree to abide by its terms.
