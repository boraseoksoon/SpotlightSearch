// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SpotlightSearch",
    platforms: [
        .iOS(.v14)
    ],
    
    products: [
        // Products define the executables and libraries produced by a package, and make them visible to other packages.
        .library(
            name: "SpotlightSearch",
            targets: ["SpotlightSearch"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "SpotlightSearch",
            dependencies: []),
        .testTarget(
            name: "SpotlightSearchTests",
            dependencies: ["SpotlightSearch"]),
    ]
)
