// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "Lungful",
    platforms: [
        .iOS(.v17),
        .macOS(.v14)
    ],
    products: [
        .library(name: "Lungful", targets: ["Lungful"])
    ],
    targets: [
        .target(
            name: "Lungful",
            path: "Sources/Lungful"
        ),
        .testTarget(
            name: "LungfulTests",
            dependencies: ["Lungful"],
            path: "Tests/LungfulTests"
        )
    ]
)
