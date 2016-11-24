import PackageDescription

let package = Package(
    name: "Naamio",
    targets: [
        Target(
            name: "Naamio",
            dependencies: [.Target(name: "NaamioCore")]),
        Target(
            name: "NaamioCore",
            dependencies: [])],
    dependencies: [
        .Package(url: "https://github.com/IBM-Swift/Kitura.git", majorVersion: 1, minor: 2),
        .Package(url: "https://github.com/IBM-Swift/HeliumLogger.git", majorVersion: 1, minor: 1),
        .Package(url: "https://github.com/IBM-Swift/Kitura-MustacheTemplateEngine.git", majorVersion: 1, minor: 1)],
    exclude: ["Makefile"])