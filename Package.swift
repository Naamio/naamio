// swift-tools-version:4.0
import PackageDescription

let package = Package(
    name: "Naamio",
    dependencies: [
          Package(url: "https://github.com/IBM-Swift/HeliumLogger", majorVersion: 1, minor: 7),
          Package(url: "https://github.com/IBM-Swift/Kitura", majorVersion: 1, minor: 7),
          Package(url: "https://github.com/IBM-Swift/Kitura-Markdown", majorVersion: 0, minor: 9),
          Package(url: "https://github.com/OmnijarStudio/malline", majorVersion: 0, minor: 2)
    ],
    targets: [
        Target(
            name: "Naamio",
            dependencies: [
                .Target(name: "NaamioCore")
            ]),
        Target(
            name: "NaamioCore",
            dependencies: [
                .Target(name: "NaamioTemplateEngine")
            ]),
        Target(
            name: "NaamioTemplateEngine",
            dependencies: [
            ])])
