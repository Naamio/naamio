import PackageDescription

let package = Package(
    name: "Naamio",
       targets: [
        Target(
            name: "Naamio",
            dependencies: []
        )
    ],
    dependencies: [
        .Package(url: "https://github.com/IBM-Swift/Kitura.git", majorVersion: 0, minor: 28),
        .Package(url: "https://github.com/IBM-Swift/HeliumLogger.git", majorVersion: 0, minor: 15),
        .Package(url: "https://github.com/IBM-Swift/Kitura-MustacheTemplateEngine.git", majorVersion: 0, minor: 28),
    ],
    exclude: ["Makefile", "Package-Builder"]
)