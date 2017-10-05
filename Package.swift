// swift-tools-version:4.0
import PackageDescription

let package = Package(
    name: "Naamio",
    products: [
        .executable(
            name: "Naamio",
            targets: ["Naamio", "NaamioCore", "NaamioService", "NaamioTemplateEngine", "NaamioWeb"]
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
          .package(url: "https://github.com/IBM-Swift/HeliumLogger.git", from: "1.7.1"),
          .package(url: "https://github.com/IBM-Swift/Kitura.git", from: "2.3.0"),
          .package(url: "https://github.com/IBM-Swift/Kitura-Markdown.git", from: "1.0.0"),
          .package(url: "https://github.com/IBM-Swift/SwiftyRequest.git", .upToNextMajor(from: "1.0.0")),
          .package(url: "https://github.com/Naamio/Loki.git", .upToNextMajor(from: "0.4.0")),
          .package(url: "https://github.com/Naamio/Malline.git", .upToNextMajor(from: "0.4.0")),
          .package(url: "https://github.com/Naamio/Viila.git", .upToNextMajor(from: "0.2.3"))
    ],
    targets: [
        .target(
            name: "Naamio",
            dependencies: [
                .byNameItem(name: "HeliumLogger"),
                .target(name: "NaamioCore"),
                .target(name: "NaamioWeb")
            ]
        ),
        .target(
            name: "NaamioControl",
            dependencies: [
                
            ]
        ),
        .target(
            name: "NaamioCore",
            dependencies: [
                .byNameItem(name: "Kitura"),
                .byNameItem(name: "KituraMarkdown"),
                .byNameItem(name: "Loki"),
                .byNameItem(name: "Viila"),
            ]
        ),
        .target(
            name: "NaamioService",
            dependencies: [
                .target(name: "NaamioCore")
            ]
        ),
        .target(
            name: "NaamioTemplateEngine",
            dependencies: [
                .byNameItem(name: "Kitura"),
                .byNameItem(name: "Malline"),
                .target(name: "NaamioCore")
            ]
        ),
        .target(
            name: "NaamioWeb",
            dependencies: [
                .byNameItem(name: "KituraMarkdown"),
                .target(name: "NaamioTemplateEngine")
            ]
        ),
        .testTarget(
            name: "NaamioTests",
            dependencies: ["NaamioCore"]
        ),
        .testTarget(
            name: "NaamioWebTests",
            dependencies: ["NaamioWeb"]
        )
    ]
)
