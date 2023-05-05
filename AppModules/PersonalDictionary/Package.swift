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
    dependencies: [
        .package(url: "https://github.com/maksimn/CoreModule", from: "2.1.0")
    ],
    targets: [
        .target(
            name: "PersonalDictionary",
            dependencies: [
                "CoreModule"
            ],
            path: "Source",
            resources: []
        )
    ]
)
