// swift-tools-version:5.0

import PackageDescription

let package = Package(
    name: "TextViewPlus",
    platforms: [.macOS(.v10_12)],
    products: [
        .library(name: "TextViewPlus", targets: ["TextViewPlus"]),
    ],
    dependencies: [
        .package(url: "https://github.com/ChimeHQ/Rearrange", from: "1.4.0"),
    ],
    targets: [
        .target(name: "TextViewPlus", dependencies: ["Rearrange"]),
        .testTarget(name: "TextViewPlusTests", dependencies: ["TextViewPlus"]),
    ]
)
