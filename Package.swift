// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Utils",
    defaultLocalization: "en",
    platforms: [.iOS(.v15)],
    products: [
        .library(
            name: "Defaults",
            targets: ["Defaults"]
        ),
        .library(
            name: "Appearance",
            targets: ["Appearance"]
        ),
        .library(
            name: "AppearanceUI",
            targets: ["AppearanceUI"]
        ),
        .library(
            name: "AlternateIconUI",
            targets: ["AlternateIconUI"]
        ),
        .library(
            name: "AppInfo",
            targets: ["AppInfo"]
        ),
        .library(
            name: "AppInfoUI",
            targets: ["AppInfoUI"]
        ),
        .library(
            name: "LicensePlist",
            targets: ["LicensePlist"]
        ),
        .library(
            name: "LicensePlistUI",
            targets: ["LicensePlistUI"]
        ),
        .library(
            name: "UserDefaultsBrowser",
            targets: ["UserDefaultsBrowser"]
        )
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "Defaults",
            dependencies: []
        ),
        .target(
            name: "Appearance",
            dependencies: ["Defaults"]
        ),
        .target(
            name: "AppearanceUI",
            dependencies: ["Appearance"],
            resources: [
                .process("Resources")
            ]
        ),
        .target(
            name: "AlternateIconUI",
            dependencies: []
        ),
        .target(
            name: "AppInfo",
            dependencies: []
        ),
        .target(
            name: "AppInfoUI",
            dependencies: ["AppInfo"]
        ),
        .target(
            name: "LicensePlist",
            dependencies: []
        ),
        .target(
            name: "LicensePlistUI",
            dependencies: ["LicensePlist"],
            resources: [
                .process("Resources")
            ]
        ),
        .target(
            name: "UserDefaultsBrowser",
            dependencies: []
        ),
        .testTarget(
            name: "UtilsTests",
            dependencies: ["Appearance"]
        )
    ]
)
