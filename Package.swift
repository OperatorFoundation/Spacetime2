// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Spacetime",
    platforms: [.macOS(.v12)],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "Spacetime",
            targets: ["Spacetime"]),
        .library(
            name: "Universe",
            targets: ["Universe"]),
        .library(
            name: "Simulation",
            targets: ["Simulation"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        .package(url: "https://github.com/OperatorFoundation/Chord", branch: "main"),
        .package(url: "https://github.com/OperatorFoundation/Datable", branch: "main"),
        .package(url: "https://github.com/OperatorFoundation/SwiftHexTools", branch: "main"),
        .package(url: "https://github.com/OperatorFoundation/SwiftQueue", branch: "main"),
        .package(url: "https://github.com/OperatorFoundation/Transmission", branch: "main"),
        .package(url: "https://github.com/OperatorFoundation/TransmissionTypes", branch: "main"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "Spacetime",
            dependencies: []),
        .target(
            name: "Universe",
            dependencies: [
                "Chord",
                "Datable",
                "SwiftHexTools",
                "SwiftQueue",
                "Spacetime",
                "TransmissionTypes",
            ]),
        .target(
            name: "Simulation",
            dependencies: ["SwiftQueue", "Spacetime", "Chord", "Transmission"]),
        .testTarget(
            name: "SpacetimeTests",
            dependencies: ["Universe", "Simulation", "Datable", "Spacetime"]),
    ],
    swiftLanguageVersions: [.v5]
)
