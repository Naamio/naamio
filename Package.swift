import PackageDescription

let package = Package(
    name: "Naamio",
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
                
            ])],
    dependencies: [
        .Package(url: "https://github.com/IBM-Swift/Kitura.git", majorVersion: 1, minor: 7),
        .Package(url: "https://github.com/IBM-Swift/HeliumLogger.git", majorVersion: 1, minor: 7),
        .Package(url: "https://github.com/IBM-Swift/Kitura-StencilTemplateEngine", majorVersion: 1, minor: 8),
        .Package(url: "https://github.com/IBM-Swift/Kitura-Markdown", majorVersion: 0, minor: 9)
    ],
    exclude: ["Makefile"])
