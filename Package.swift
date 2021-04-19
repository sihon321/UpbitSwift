// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "UpbitSwift",
    platforms: [
        .iOS(.v13),
        .macOS(.v10_15)
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "UpbitSwift",
            targets: ["UpbitSwift"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(url: "https://github.com/Alamofire/Alamofire.git", .upToNextMajor(from: "5.2.0")),
        .package(name: "SwiftJWT", url: "https://github.com/Kitura/Swift-JWT.git", from: "3.6.1")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "UpbitSwift",
            dependencies: ["Alamofire", "SwiftJWT"],
            path: "Sources"),
        .testTarget(
            name: "UpbitSwiftTests",
            dependencies: ["UpbitSwift"]),
    ]
)
