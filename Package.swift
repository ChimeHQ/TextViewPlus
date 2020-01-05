// swift-tools-version:5.0

import PackageDescription

let package = Package(
    name: "TextViewPlus",
    platforms: [.macOS(.v10_12)],
    products: [
        .library(name: "TextViewPlus", targets: ["TextViewPlus"]),
    ],
    dependencies: [],
    targets: [
        .target(name: "TextViewPlus", dependencies: [], path: "TextViewPlus/"),
        .testTarget(name: "TextViewPlusTests", dependencies: ["TextViewPlus"], path: "TextViewPlusTests/"),
    ]
)
