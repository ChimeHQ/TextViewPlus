#if canImport(AppKit)
import AppKit
import OSLog

// I guess this should be defined by AppKit, but isn't
fileprivate let NSOldSelectedCharacterRanges = "NSOldSelectedCharacterRanges"

/// A minimal `NSTextView` subclass to support correct functionality using TextKit 2.
///
/// - Warning: TextKit 1 is **unsupported**. An attempt to access the `layoutManager` property will assert in debug.
@available(macOS 12.0, *)
open class BaseTextView: NSTextView {
	public typealias OnEvent = (_ event: NSEvent, _ action: () -> Void) -> Void

	private let logger = Logger(subsystem: "com.chimehq.TextViewPlus", category: "BaseTextView")
	private var activeScrollValue: (NSRange, CGSize)?
	private var lastSelectionValue = [NSValue]()

	public var onKeyDown: OnEvent = { $1() }
	public var onFlagsChanged: OnEvent = { $1() }
	public var onMouseDown: OnEvent = { $1() }
	/// Deliver `NSTextView.didChangeSelectionNotification` for all selection changes.
	///
	/// See the documenation for `setSelectedRanges(_:affinity:stillSelecting:)` for details.
	public var continuousSelectionNotifications: Bool = false

	public override init(frame frameRect: NSRect, textContainer container: NSTextContainer?) {
		let effectiveContainer = container ?? NSTextContainer()

		if effectiveContainer.textLayoutManager == nil {
			let textLayoutManager = NSTextLayoutManager()

			textLayoutManager.textContainer = effectiveContainer

			let storage = NSTextContentStorage()

			storage.addTextLayoutManager(textLayoutManager)
			storage.primaryTextLayoutManager = textLayoutManager
		}

		super.init(frame: frameRect, textContainer: effectiveContainer)

		self.textContainerInset = CGSize(width: 5.0, height: 5.0)
	}

	public convenience init() {
		self.init(frame: .zero, textContainer: nil)
	}

	@available(*, unavailable)
	public required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	public override var layoutManager: NSLayoutManager? {
		assertionFailure("TextKit 1 is not supported by this type")

		return nil
	}
}

@available(macOS 12.0, *)
extension BaseTextView {
	open override var textContainerInset: NSSize {
		get { super.textContainerInset }
		set {
			let effectiveInset = NSSize(width: max(newValue.width, 5.0), height: newValue.height)

			if effectiveInset != newValue {
				logger.warning("textContainerInset has been modified to workaround scrolling bug")
			}

			super.textContainerInset = effectiveInset
		}
	}

	open override func scrollRangeToVisible(_ range: NSRange) {
		// this scroll won't actually happen if the desired location is too far to the trailing edge. This is because at this point the view's bounds haven't yet been resized, so the scroll cannot happen. FB13100459

		self.activeScrollValue = (range, bounds.size)

		super.scrollRangeToVisible(range)
	}

	open override func setFrameSize(_ newSize: NSSize) {
		super.setFrameSize(newSize)

		guard
			let (range, size) = self.activeScrollValue,
			newSize != size
		else {
			return
		}

		// this produces scroll/text flicker. But I'm unable to find a better solution.
		self.activeScrollValue = nil

		DispatchQueue.main.async {
			super.scrollRangeToVisible(range)
		}
	}
}

@available(macOS 12.0, *)
extension BaseTextView {
	open override func paste(_ sender: Any?) {
		let handled = delegate?.textView?(self, doCommandBy: #selector(paste(_:))) ?? false

		if handled == false {
			super.paste(sender)
		}
	}

	open override func pasteAsRichText(_ sender: Any?) {
		let handled = delegate?.textView?(self, doCommandBy: #selector(pasteAsRichText(_:))) ?? false

		if handled == false {
			super.pasteAsRichText(sender)
		}
	}

	open override func pasteAsPlainText(_ sender: Any?) {
		let handled = delegate?.textView?(self, doCommandBy: #selector(pasteAsPlainText(_:))) ?? false

		if handled == false {
			super.pasteAsPlainText(sender)
		}
	}
}

@available(macOS 12.0, *)
extension BaseTextView {
	open override func keyDown(with event: NSEvent) {
		onKeyDown(event) {
			super.keyDown(with: event)
		}
	}

	open override func flagsChanged(with event: NSEvent) {
		onFlagsChanged(event) {
			super.flagsChanged(with: event)
		}
	}

	open override func mouseDown(with event: NSEvent) {
		onMouseDown(event) {
			super.mouseDown(with: event)
		}
	}
}

@available(macOS 12.0, *)
extension BaseTextView {
	open override func setSelectedRanges(_ ranges: [NSValue], affinity: NSSelectionAffinity, stillSelecting stillSelectingFlag: Bool) {
		let oldRanges = selectedRanges

		super.setSelectedRanges(ranges, affinity: affinity, stillSelecting: stillSelectingFlag)

		// try to filter out notifications that have already been set
		if ranges == lastSelectionValue {
			return
		}

		lastSelectionValue = ranges

		if stillSelectingFlag && continuousSelectionNotifications {
			let userInfo: [AnyHashable: Any] = [NSOldSelectedCharacterRanges: oldRanges]

			NotificationCenter.default.post(name: NSTextView.didChangeSelectionNotification, object: self, userInfo: userInfo)
		}
	}
}
#endif
