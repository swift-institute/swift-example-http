// swift-tools-version: 6.4

import PackageDescription

let package = Package(
    name: "swift-example-http",
    platforms: [
        .macOS(.v27),
        .iOS(.v27),
        .tvOS(.v27),
        .watchOS(.v27),
        .visionOS(.v27),
    ],
    products: [
        .library(
            name: "Example HTTP",
            targets: ["Example HTTP"]
        ),
    ],
    dependencies: [
        .package(
            url: "https://github.com/swift-primitives/swift-byte-primitives.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-institute/swift-example-client.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-foundations/swift-http.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-foundations/swift-coder.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-foundations/swift-http-coder.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-foundations/swift-http-router.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-primitives/swift-coder-primitives.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-primitives/swift-parser-primitives.git",
            branch: "main"
        ),
    ],
    targets: [
        .target(
            name: "Example HTTP",
            dependencies: [
                .product(name: "Example Client", package: "swift-example-client"),
                .product(name: "Coder", package: "swift-coder"),
                .product(name: "HTTP", package: "swift-http"),
                .product(name: "HTTP Coder", package: "swift-http-coder"),
                .product(name: "HTTP Router", package: "swift-http-router"),
                .product(name: "Coder Primitive", package: "swift-coder-primitives"),
            ]
        ),
        .testTarget(
            name: "Example HTTP Tests",
            dependencies: [
                "Example HTTP",
                .product(name: "Byte Primitive", package: "swift-byte-primitives"),
                .product(name: "Coder", package: "swift-coder"),
                .product(name: "Example Client", package: "swift-example-client"),
                .product(name: "HTTP", package: "swift-http"),
                .product(name: "HTTP Coder", package: "swift-http-coder"),
                .product(name: "HTTP Router", package: "swift-http-router"),
                .product(name: "Coder Primitive", package: "swift-coder-primitives"),
                .product(
                    name: "Parser Conversion Primitives",
                    package: "swift-parser-primitives"
                ),
            ]
        ),
    ],
    swiftLanguageModes: [.v6]
)

for target in package.targets where ![.system, .binary, .plugin, .macro].contains(target.type) {
    target.swiftSettings = (target.swiftSettings ?? []) + [
        .strictMemorySafety(),
        .enableUpcomingFeature("ExistentialAny"),
        .enableUpcomingFeature("InternalImportsByDefault"),
        .enableUpcomingFeature("MemberImportVisibility"),
        .enableUpcomingFeature("NonisolatedNonsendingByDefault"),
        .enableExperimentalFeature("Lifetimes"),
        .enableUpcomingFeature("InferIsolatedConformances"),
    ]
}
