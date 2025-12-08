// swift-tools-version: 6.2
import PackageDescription

let package = Package(
    name: "UCCoreServices",
    platforms: [
        .iOS(.v16),
        .macOS(.v13),
        .visionOS(.v1)
    ],
    products: [
        .library(name: "UCCoreServices", targets: ["UCCoreServices"]),
        .library(name: "UCPaymentKit", targets: ["UCPaymentKit"]),
    ],
    dependencies: [
        .package(url: "https://github.com/unioncoophypermarket/UCNetworkKit.git",
                 branch: "Optimization/Swift6")
    ],
    targets: [
        .target(
            name: "UCCoreServices",
            dependencies: [
                .product(name: "UCNetworkKit", package: "ucnetworkkit")
            ]
        ),
        .testTarget(
            name: "UCCoreServicesTests",
            dependencies: ["UCCoreServices"]
        ),
        .target(
            name: "UCPaymentKit",
            path: "Sources/UCPaymentKit"
        )
    ]
)
