// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "Lungful",
    platforms: [
        .iOS(.v17),
        .macOS(.v14)
    ],
    products: [
        .library(name: "Lungful", targets: ["Lungful"]),
        .executable(name: "LungfulDemo", targets: ["LungfulDemo"])
    ],
    targets: [
        .target(
            name: "Lungful"
        ),
        .executableTarget(
            name: "LungfulDemo",
            dependencies: ["Lungful"]
        ),
        .testTarget(
            name: "LungfulTests",
            dependencies: ["Lungful"]
        )
    ]
)
