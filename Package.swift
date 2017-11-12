// swift-tools-version:4.0
import PackageDescription

let package = Package(
    name: "Naamio",
    products: [
        .executable(
            name: "Naamio",
            targets: ["Naamio", "NaamioCore", "NaamioTemplateEngine"]
        ),
        .executable(
            name: "NaamioCtl",
            targets: ["NaamioControl"]
        )
    ],
    dependencies: [
          .package(url: "https://github.com/IBM-Swift/HeliumLogger", from: "1.7.1"),
          .package(url: "https://github.com/IBM-Swift/Kitura", from: "2.0.0"),
          .package(url: "https://github.com/IBM-Swift/Kitura-Markdown", from: "0.9.1"),
          .package(url: "https://github.com/Naamio/malline", from: "0.1.0")
    ],
    targets: [
        .target(
            name: "Naamio",
            dependencies: [
                .byNameItem(name: "HeliumLogger"),
                .target(name: "NaamioCore")
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
                .byNameItem(name: "KituraMarkdown"),
                .target(name: "NaamioTemplateEngine")
            ]
        ),
        .target(
            name: "NaamioTemplateEngine",
            dependencies: [
                .byNameItem(name: "Kitura"),
                .byNameItem(name: "Malline")
            ]
        ),
        .testTarget(
            name: "NaamioTests",
            dependencies: []
        )
    ]
)
