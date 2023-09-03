import AppKit

@main
final class AppDelegate: NSObject, NSApplicationDelegate {
	let window: NSWindow

	override init() {
		self.window = NSWindow(contentViewController: TextViewController())
	}

	func applicationDidFinishLaunching(_ aNotification: Notification) {
		window.makeKeyAndOrderFront(self)
	}

	func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
		return true
	}
}
