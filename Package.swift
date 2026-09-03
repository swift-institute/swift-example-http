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
        .package(url: "https://github.com/swift-atoms/swift-cursor.git", branch: "main"),
        .package(
            url: "https://github.com/swift-atoms/swift-ascii.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-atoms/swift-byte.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-atoms/swift-coder.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-atoms/swift-optic.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-atoms/swift-parser.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-atoms/swift-serializer.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-molecules/swift-ascii-coder.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-molecules/swift-ascii-parser.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-molecules/swift-optic-coder.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-institute/swift-example-client.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-institute/swift-example.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-atoms/swift-operation.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-compositions/swift-http.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-compositions/swift-http-coder.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-ietf/swift-rfc-3986.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-ietf/swift-rfc-9110.git",
            branch: "main"
        ),
    ],
    targets: [
        .target(
            name: "Example HTTP",
            dependencies: [
                .product(name: "ASCII", package: "swift-ascii"),
                .product(name: "ASCII Decimal Coder", package: "swift-ascii-coder"),
                .product(name: "ASCII Decimal Parser", package: "swift-ascii-parser"),
                .product(name: "Byte", package: "swift-byte"),
                .product(name: "Byte Standard Library Integration", package: "swift-byte"),
                .product(name: "Cursor Standard Library Integration", package: "swift-cursor"),
                .product(name: "Operation", package: "swift-operation"),
                .product(name: "Coder", package: "swift-coder"),
                .product(name: "Example", package: "swift-example"),
                .product(name: "Example Greeting", package: "swift-example"),
                .product(name: "Example Counter", package: "swift-example"),
                .product(name: "Example Client", package: "swift-example-client"),
                .product(name: "Example Greeting Client", package: "swift-example-client"),
                .product(name: "Example Counter Client", package: "swift-example-client"),
                .product(name: "HTTP", package: "swift-http"),
                .product(name: "HTTP Coder", package: "swift-http-coder"),
                .product(name: "Optic", package: "swift-optic"),
                .product(name: "Optic Coder", package: "swift-optic-coder"),
                .product(name: "Parser", package: "swift-parser"),
                .product(name: "Parser Skip", package: "swift-parser"),
                .product(name: "Serializer", package: "swift-serializer"),
                .product(name: "RFC 3986", package: "swift-rfc-3986"),
                .product(name: "RFC 9110", package: "swift-rfc-9110"),
            ]
        ),
        .testTarget(
            name: "Example HTTP Tests",
            dependencies: [
                "Example HTTP",
                .product(name: "Byte", package: "swift-byte"),
                .product(name: "Operation", package: "swift-operation"),
                .product(name: "Coder", package: "swift-coder"),
                .product(name: "Example", package: "swift-example"),
                .product(name: "Example Greeting", package: "swift-example"),
                .product(name: "Example Counter", package: "swift-example"),
                .product(name: "Example Client", package: "swift-example-client"),
                .product(name: "Example Greeting Client", package: "swift-example-client"),
                .product(name: "Example Counter Client", package: "swift-example-client"),
                .product(name: "HTTP", package: "swift-http"),
                .product(name: "HTTP Coder", package: "swift-http-coder"),
                .product(name: "Optic", package: "swift-optic"),
                .product(name: "Optic Coder", package: "swift-optic-coder"),
                .product(name: "Parser", package: "swift-parser"),
                .product(name: "Parser Skip", package: "swift-parser"),
                .product(name: "Serializer", package: "swift-serializer"),
                .product(name: "RFC 3986", package: "swift-rfc-3986"),
                .product(name: "RFC 9110", package: "swift-rfc-9110"),
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
