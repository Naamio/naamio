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
          .package(url: "https://github.com/IBM-Swift/HeliumLogger", from: "1.7.1"),
          .package(url: "https://github.com/IBM-Swift/Kitura", from: "2.0.0"),
          .package(url: "https://github.com/IBM-Swift/Kitura-Markdown", from: "0.9.1"),
          .package(url: "https://github.com/Naamio/malline", from: "0.2.0"),
          .package(url: "https://github.com/JohnSundell/Files", from: "2.0.1")
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
                .byNameItem(name: "Files"),
                .byNameItem(name: "KituraMarkdown"),
                .target(name: "NaamioTemplateEngine")
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
                .byNameItem(name: "Malline")
            ]
        ),
        .target(
            name: "NaamioWeb",
            dependencies: [
                .byNameItem(name: "KituraMarkdown"),
                .target(name: "NaamioCore")
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
