// swift-tools-version:4.0
import PackageDescription

private func getTargetPath(_ name: String, for type: String) -> String {
    return "\(type)/\(name)"
}

private func getSourcePath(_ name: String) -> String {
    return getTargetPath(name, for: "Sources")
}

private func getTestPath(_ name: String) -> String {
    return getTargetPath(name, for: "Tests")
}

let package = Package(
    name: "Naamio",
    products: [
        .executable(
            name: "Naamio",
            targets: ["NaamioConsole", "NaamioCore", "NaamioService", "NaamioTemplateEngine", "NaamioWeb"]
        ),
        .executable(
            name: "NaamioCtl",
            targets: ["NaamioControl"]
        ),
        .library(
            name: "NaamioWeb",
            targets: ["NaamioWeb"]
        )
    ],
    dependencies: [
          .package(url: "https://github.com/ibm-swift/kitura", from: "2.3.0"),
          .package(url: "https://github.com/ibm-swift/swift-kuery-sqlite", .upToNextMajor(from: "1.0.0")),
          .package(url: "https://github.com/ibm-swift/kitura-markdown", from: "1.0.0"),
          .package(url: "https://github.com/naamio/palvelu", .branch("master")),
          .package(url: "https://github.com/naamio/loki", .upToNextMajor(from: "0.4.0")),
          .package(url: "https://github.com/naamio/malline", .upToNextMajor(from: "0.4.0")),
          .package(url: "https://github.com/naamio/viila", .upToNextMajor(from: "0.2.3"))
    ],
    targets: [
        .target(
            name: "NaamioAPI",
            dependencies: [
                .target(name: "NaamioCore"),
                .byNameItem(name: "Palvelu")
            ],
            path: getSourcePath("API")
        ),
        .target(
            name: "NaamioConsole",
            dependencies: [
                .target(name: "NaamioCore"),
                .target(name: "NaamioWeb")
            ],
            path: getSourcePath("Console")
        ),
        .target(
            name: "NaamioControl",
            dependencies: [
                
            ],
            path: getSourcePath("Control")
        ),
        .target(
            name: "NaamioCore",
            dependencies: [
                .byNameItem(name: "Kitura"),
                .byNameItem(name: "KituraMarkdown"),
                .byNameItem(name: "Loki"),
                .byNameItem(name: "Viila"),
            ],
            path: getSourcePath("Core")
        ),
        .target(
            name: "NaamioService",
            dependencies: [
                .target(name: "NaamioAPI"),
                .target(name: "NaamioCore"),
                .byNameItem(name: "Palvelu"),
            ],
            path: getSourcePath("Service")
        ),
        .target(
            name: "NaamioStore",
            dependencies: [
                .target(name: "NaamioCore"),
                .byNameItem(name: "SwiftKuerySQLite")
            ],
            path: getSourcePath("Store")
        ),
        .target(
            name: "NaamioTemplateEngine",
            dependencies: [
                .byNameItem(name: "Kitura"),
                .byNameItem(name: "Malline"),
                .target(name: "NaamioCore")
            ],
            path: getSourcePath("Template")
        ),
        .target(
            name: "NaamioWeb",
            dependencies: [
                .byNameItem(name: "KituraMarkdown"),
                .target(name: "NaamioTemplateEngine"),
                .byNameItem(name: "Palvelu")
            ],
            path: getSourcePath("Web")
        ),
        .testTarget(
            name: "NaamioConsoleTests",
            dependencies: ["NaamioConsole"],
            path: getTestPath("Console")
        ),
        .testTarget(
            name: "NaamioStoreTests",
            dependencies: ["NaamioStore"],
            path: getTestPath("Store")
        ),
        .testTarget(
            name: "NaamioWebTests",
            dependencies: ["NaamioWeb"],
            path: getTestPath("Web")
        )
    ]
)