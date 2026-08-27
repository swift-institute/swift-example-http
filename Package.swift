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
            url: "https://github.com/swift-institute/swift-example.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-foundations/swift-call.git",
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
        .package(
            url: "https://github.com/swift-primitives/swift-optic-primitives.git",
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
                .product(name: "Byte Primitive", package: "swift-byte-primitives"),
                .product(name: "Example", package: "swift-example"),
                .product(name: "Example Greeting", package: "swift-example"),
                .product(name: "Example Counter", package: "swift-example"),
                .product(name: "Example Client", package: "swift-example-client"),
                .product(name: "Example Greeting Client", package: "swift-example-client"),
                .product(name: "Example Counter Client", package: "swift-example-client"),
                .product(name: "Coder", package: "swift-coder"),
                .product(name: "HTTP", package: "swift-http"),
                .product(name: "HTTP Coder", package: "swift-http-coder"),
                .product(name: "HTTP Router", package: "swift-http-router"),
                .product(name: "Coder Primitive", package: "swift-coder-primitives"),
                .product(name: "Coder Parser Primitives", package: "swift-coder-primitives"),
                .product(name: "Optic Primitives", package: "swift-optic-primitives"),
                .product(name: "RFC 9110", package: "swift-rfc-9110"),
                .product(name: "RFC 3986", package: "swift-rfc-3986"),
                .product(
                    name: "Parser Conversion Primitives",
                    package: "swift-parser-primitives"
                ),
                .product(
                    name: "Parser Error Primitives",
                    package: "swift-parser-primitives"
                ),
            ]
        ),
        .testTarget(
            name: "Example HTTP Tests",
            dependencies: [
                "Example HTTP",
                .product(name: "Byte Primitive", package: "swift-byte-primitives"),
                .product(name: "Call", package: "swift-call"),
                .product(name: "Coder", package: "swift-coder"),
                .product(name: "Example Client", package: "swift-example-client"),
                .product(name: "Example", package: "swift-example"),
                .product(name: "Example Greeting", package: "swift-example"),
                .product(name: "Example Counter", package: "swift-example"),
                .product(name: "Example Greeting Client", package: "swift-example-client"),
                .product(name: "Example Counter Client", package: "swift-example-client"),
                .product(name: "HTTP", package: "swift-http"),
                .product(name: "HTTP Coder", package: "swift-http-coder"),
                .product(name: "HTTP Router", package: "swift-http-router"),
                .product(name: "Coder Primitive", package: "swift-coder-primitives"),
                .product(name: "Coder Parser Primitives", package: "swift-coder-primitives"),
                .product(name: "Optic Primitives", package: "swift-optic-primitives"),
                .product(name: "RFC 9110", package: "swift-rfc-9110"),
                .product(name: "RFC 3986", package: "swift-rfc-3986"),
                .product(
                    name: "Parser Conversion Primitives",
                    package: "swift-parser-primitives"
                ),
                .product(
                    name: "Parser Error Primitives",
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
