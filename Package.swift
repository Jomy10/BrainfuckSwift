// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "brainfuck-swift",
    products: [
        .executable(name: "Brainfuck", targets: ["BrainfuckCLI"]),
        .library(name: "BrainfuckCore", targets: ["BrainfuckCore"]),
        .library(name: "BrainfuckRun", targets: ["BrainfuckRun"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "BrainfuckCore", 
            dependencies: []),
        .target(
            name: "BrainfuckRun",
            dependencies: []),
        .executableTarget(
            name: "BrainfuckCLI",
            dependencies: ["BrainfuckCore", "BrainfuckRun"]),
        .testTarget(
            name: "brainfuck-swiftTests",
            dependencies: ["BrainfuckCore", "BrainfuckRun", "BrainfuckCLI"]),
    ]
)
