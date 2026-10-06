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
        // Local sibling checkout (~/Desktop/UCNetworkKit) so it can be edited from the UnionCoop workspace directly.
        .package(path: "../UCNetworkKit")
    ],
    targets: [
        .target(
            name: "UCCoreServices",
            dependencies: [
                .product(name: "UCNetworkKit", package: "UCNetworkKit")
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
