// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "brainfuck-swift", 
    platforms: [.macOS(.v10_12)],
    products: [
        .executable(name: "brainfuck", targets: ["BrainfuckCLI"]),
        .library(name: "BrainfuckCore", targets: ["BrainfuckCore"]),
        .library(name: "BrainfuckRun", targets: ["BrainfuckRun"])
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser", branch: "main"),
        .package(url: "https://github.com/andybest/linenoise-swift", branch: "master")
    ],
    targets: [
        .target(
            name: "BrainfuckCore", 
            dependencies: [.product(name: "LineNoise", package: "linenoise-swift")]),
        .target(
            name: "BrainfuckRun",
            dependencies: ["BrainfuckCore"]),
        .executableTarget(
            name: "BrainfuckCLI",
            dependencies: ["BrainfuckCore", "BrainfuckRun", .product(name: "ArgumentParser", package: "swift-argument-parser")]),
        .testTarget(
            name: "brainfuck-swiftTests",
            dependencies: ["BrainfuckCore", "BrainfuckRun", "BrainfuckCLI"]),
    ]
)
