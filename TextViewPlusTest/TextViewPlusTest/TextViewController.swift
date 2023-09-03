import AppKit

import TextViewPlus

final class TextViewController: NSViewController {
	let textView = NSTextView()
//	let textView = BaseTextView()

	init() {
		super.init(nibName: nil, bundle: nil)
	}

	@available(*, unavailable)
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func loadView() {
		// scrolling and resizing
		textView.isVerticallyResizable = true
		textView.isHorizontallyResizable = true
		textView.wrapsTextToHorizontalBounds = true

		let scrollView = NSScrollView()
		scrollView.hasHorizontalScroller = true
		scrollView.hasVerticalScroller = true

		NSLayoutConstraint.activate([
			scrollView.widthAnchor.constraint(greaterThanOrEqualToConstant: 400.0),
			scrollView.heightAnchor.constraint(greaterThanOrEqualToConstant: 300.0),
		])

		scrollView.documentView = textView

		textView.string = "abc"

		self.view = scrollView
	}
}

extension TextViewController: NSTextViewDelegate {

}
