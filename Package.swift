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
        .package(url: "https://github.com/swift-atoms/swift-byte.git", branch: "main"),
        .package(url: "https://github.com/swift-atoms/swift-coder.git", branch: "main"),
        .package(url: "https://github.com/swift-atoms/swift-either.git", branch: "main"),
        .package(url: "https://github.com/swift-atoms/swift-operation.git", branch: "main"),
        .package(url: "https://github.com/swift-atoms/swift-parser.git", branch: "main"),
        .package(url: "https://github.com/swift-atoms/swift-serializer.git", branch: "main"),
        .package(url: "https://github.com/swift-atoms/swift-tagged.git", branch: "main"),
        .package(url: "https://github.com/swift-molecules/swift-string-coder.git", branch: "main"),
        .package(url: "https://github.com/swift-molecules/swift-tagged-coder.git", branch: "main"),
        .package(url: "https://github.com/swift-institute/swift-example.git", branch: "main"),
        .package(url: "https://github.com/swift-institute/swift-example-signature.git", branch: "main"),
        .package(url: "https://github.com/swift-standards/swift-http.git", branch: "main"),
        .package(url: "https://github.com/swift-compositions/swift-http-router.git", branch: "main"),
        .package(url: "https://github.com/swift-ietf/swift-rfc-9110.git", branch: "main"),
    ],
    targets: [
        .target(
            name: "Example HTTP",
            dependencies: [
                .product(name: "Byte", package: "swift-byte"),
                .product(name: "Operation", package: "swift-operation"),
                .product(name: "Either", package: "swift-either"),
                .product(name: "Coder", package: "swift-coder"),
                .product(name: "String Coder", package: "swift-string-coder"),
                .product(name: "Tagged Coder", package: "swift-tagged-coder"),
                .product(name: "Example", package: "swift-example"),
                .product(name: "Example Greeting", package: "swift-example"),
                .product(name: "Example Counter", package: "swift-example"),
                .product(name: "Example Signature", package: "swift-example-signature"),
                .product(name: "Example Greeting Signature", package: "swift-example-signature"),
                .product(name: "Example Counter Signature", package: "swift-example-signature"),
                .product(name: "HTTP", package: "swift-http"),
                .product(name: "HTTP Router", package: "swift-http-router"),
                .product(name: "Parser", package: "swift-parser"),
                .product(name: "Parser Skip", package: "swift-parser"),
                .product(name: "Serializer", package: "swift-serializer"),
                .product(name: "RFC 9110", package: "swift-rfc-9110"),
            ]
        ),
        .testTarget(
            name: "Example HTTP Tests",
            dependencies: [
                "Example HTTP",
                .product(name: "Byte", package: "swift-byte"),
                .product(name: "Operation", package: "swift-operation"),
                .product(name: "Either", package: "swift-either"),
                .product(name: "Coder", package: "swift-coder"),
                .product(name: "Example", package: "swift-example"),
                .product(name: "Example Greeting", package: "swift-example"),
                .product(name: "Example Counter", package: "swift-example"),
                .product(name: "Example Signature", package: "swift-example-signature"),
                .product(name: "Example Greeting Signature", package: "swift-example-signature"),
                .product(name: "Example Counter Signature", package: "swift-example-signature"),
                .product(name: "HTTP", package: "swift-http"),
                .product(name: "HTTP Router", package: "swift-http-router"),
                .product(name: "HTTP Reply", package: "swift-http-router"),
                .product(name: "Parser", package: "swift-parser"),
                .product(name: "Serializer", package: "swift-serializer"),
                .product(name: "RFC 9110", package: "swift-rfc-9110"),
                .product(name: "Tagged", package: "swift-tagged"),
                .product(name: "Tagged Coder", package: "swift-tagged-coder"),
                .product(name: "Tagged Standard Library Integration", package: "swift-tagged"),
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
