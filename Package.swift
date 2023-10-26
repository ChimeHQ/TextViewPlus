// swift-tools-version: 5.8

import PackageDescription

let settings: [SwiftSetting] = [
	.enableExperimentalFeature("StrictConcurrency")
]

let package = Package(
	name: "TextViewPlus",
	platforms: [.macOS(.v10_13), .iOS(.v15), .tvOS(.v15)],
	products: [
		.library(name: "TextViewPlus", targets: ["TextViewPlus"]),
		.library(name: "BaseTextView", targets: ["BaseTextView"]),
	],
	dependencies: [
		.package(url: "https://github.com/ChimeHQ/Rearrange", from: "1.6.0"),
	],
	targets: [
		.target(name: "TextViewPlus", dependencies: ["Rearrange"], swiftSettings: settings),
		.testTarget(name: "TextViewPlusTests", dependencies: ["TextViewPlus"], swiftSettings: settings),

		.target(name: "BaseTextView", dependencies: [], swiftSettings: settings),
		.testTarget(name: "BaseTextViewTests", dependencies: ["BaseTextView"], swiftSettings: settings),
	]
)
