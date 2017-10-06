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
          .package(url: "https://github.com/IBM-Swift/Kitura.git", from: "2.3.0"),
          .package(url: "https://github.com/IBM-Swift/Kitura-Markdown.git", from: "1.0.0"),
          .package(url: "../palvelu", .branch("features/service-api")),
          .package(url: "https://github.com/Naamio/Loki.git", .upToNextMajor(from: "0.4.0")),
          .package(url: "https://github.com/Naamio/Malline.git", .upToNextMajor(from: "0.4.0")),
          .package(url: "https://github.com/Naamio/Viila.git", .upToNextMajor(from: "0.2.3"))
    ],
    targets: [
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
                .target(name: "NaamioCore")
            ],
            path: getSourcePath("Service")
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
                .target(name: "NaamioTemplateEngine")
            ],
            path: getSourcePath("Web")
        ),
        .testTarget(
            name: "NaamioConsoleTests",
            dependencies: ["NaamioConsole"],
            path: getTestPath("Console")
        ),
        .testTarget(
            name: "NaamioWebTests",
            dependencies: ["NaamioWeb"],
            path: getTestPath("Web")
        )
    ]
)