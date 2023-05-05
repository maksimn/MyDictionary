// swift-tools-version:5.7

import PackageDescription

let package = Package(
    name: "PersonalDictionary",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v16)
    ],
    products: [
        .library(
            name: "PersonalDictionary",
            targets: ["PersonalDictionary"]
        )
    ],
    dependencies: [],
    targets: [
        .target(
            name: "PersonalDictionary",
            dependencies: [],
            path: "Source",
            resources: []
        )
    ]
)
