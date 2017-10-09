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

var targets: [Target] = []
var testTargets: [Target] = []

let appTargets: [Target] = [
     .target(
        name: "NaamioConsole",
        dependencies: [
            .target(name: "NaamioCore"),
            .target(name: "NaamioService"),
            .target(name: "NaamioWeb")
        ],
        path: getSourcePath("Console")
    ),
    .target(
        name: "NaamioControl",
        dependencies: [
            .target(name: "NaamioClient")
        ],
        path: getSourcePath("Control")
    ),
]

let coreTargets: [Target] = [
    .target(
        name: "NaamioAnalytics",
        dependencies: [
            .target(name: "NaamioCore")
        ],
        path: getSourcePath("Analytics")
    ),
    .target(
        name: "NaamioContent",
        dependencies: [
            .target(name: "NaamioCore")
        ],
        path: getSourcePath("Content")
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
        name: "NaamioEvents",
        dependencies: [
            .target(name: "NaamioCore")
        ],
        path: getSourcePath("Events")
    ),
    .target(
        name: "NaamioHealth",
        dependencies: [
            .target(name: "NaamioCore")
        ],
        path: getSourcePath("Health")
    ),
    .target(
        name: "NaamioMessaging",
        dependencies: [
            .target(name: "NaamioCore")
        ],
        path: getSourcePath("Messaging")
    ),
    .target(
        name: "NaamioMeta",
        dependencies: [
            .target(name: "NaamioCore")
        ],
        path: getSourcePath("Meta")
    ),
    .target(
        name: "NaamioMetrics",
        dependencies: [
            .target(name: "NaamioCore")
        ],
        path: getSourcePath("Metrics")
    ),
    .target(
        name: "NaamioScheduling",
        dependencies: [
            .target(name: "NaamioCore")
        ],
        path: getSourcePath("Scheduling")
    ),
    .target(
        name: "NaamioStore",
        dependencies: [
            .target(name: "NaamioCore"),
            .byNameItem(name: "SwiftKuerySQLite")
        ],
        path: getSourcePath("Store")
    )
]

let serviceTargets: [Target] = [
    .target(
        name: "NaamioAPI",
        dependencies: [
            .byNameItem(name: "Palvelu")
        ],
        path: getSourcePath("API")
    ),
    .target(
        name: "NaamioClient",
        dependencies: [
            .byNameItem(name: "NaamioAPI")
        ],
        path: getSourcePath("Client")
    ),
    .target(
        name: "NaamioService",
        dependencies: [
            .target(name: "NaamioAnalytics"),
            .target(name: "NaamioAPI"),
            .target(name: "NaamioContent"),
            .target(name: "NaamioCore"),
            .target(name: "NaamioEvents"),
            .target(name: "NaamioHealth"),
            .target(name: "NaamioMessaging"),
            .target(name: "NaamioMeta"),
            .target(name: "NaamioMetrics"),
            .target(name: "NaamioScheduling"),
            .byNameItem(name: "Palvelu")
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
            .target(name: "NaamioAnalytics"),
            .target(name: "NaamioAPI"),
            .target(name: "NaamioContent"),
            .target(name: "NaamioCore"),
            .target(name: "NaamioEvents"),
            .target(name: "NaamioHealth"),
            .target(name: "NaamioMessaging"),
            .target(name: "NaamioMeta"),
            .target(name: "NaamioMetrics"),
            .target(name: "NaamioScheduling"),
            .target(name: "NaamioTemplateEngine"),
            .byNameItem(name: "Palvelu")
        ],
        path: getSourcePath("Web")
    ),
]

testTargets = [
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

targets.append(contentsOf: coreTargets)
targets.append(contentsOf: appTargets)
targets.append(contentsOf: serviceTargets)
targets.append(contentsOf: testTargets)

let package = Package(
    name: "Naamio",
    products: [
        .executable(
            name: "Naamio",
            targets: ["NaamioConsole"]
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
    targets: targets
)