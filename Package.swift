// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription
import CompilerPluginSupport

let package = Package(
  name: "QDSL",
  platforms: [.macOS(.v11), .iOS(.v12)],
  products: [
    .library(
      name: "QDSL",
      targets: ["QDSL"]
    ),
    .executable(
      name: "SampleApp",
      targets: ["SampleApp"]
    ),
  ],
  dependencies: [
    .package(url: "https://github.com/dmitriykotenko/swift-syntax", branch: "feature/swift6.1_ios12"),
    .package(url: "https://github.com/pointfreeco/swift-nonempty", .upToNextMajor(from: "0.4.0")),
  ],
  targets: [
    // QDSL Library.
    .target(
      name: "QDSL",
      dependencies: [
        .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
        .product(name: "SwiftCompilerPlugin", package: "swift-syntax"),
      ],
      path: "Sources/QDSL"
    ),

    // Library with some sample macros as part of its API.
    .macro(
      name: "SampleMacros",
      dependencies: [
        .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
        .product(name: "SwiftCompilerPlugin", package: "swift-syntax"),
        "QDSL"
      ],
      path: "Sources/SampleMacros",
      swiftSettings: [
        .unsafeFlags([
          "-enable-experimental-feature", "PackIteration"
        ], .when(configuration: .debug))
      ]
    ),

    // A sample app to debug the macros.
    .executableTarget(
      name: "SampleApp",
      dependencies: [
        "QDSL",
        "SampleMacros",
        .product(name: "NonEmpty", package: "swift-nonempty"),
      ],
      path: "Sources/SampleApp"
    ),
  ]
)
