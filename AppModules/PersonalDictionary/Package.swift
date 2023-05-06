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
        .package(url: "https://github.com/maksimn/CoreModule", from: "2.1.0"),
        .package(url: "https://github.com/pointfreeco/swift-composable-architecture", from: "0.52.0")
    ],
    targets: [
        .target(
            name: "PersonalDictionary",
            dependencies: [
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
                "CoreModule"
            ],
            path: "Source",
            resources: []
        )
    ]
)
