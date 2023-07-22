// swift-tools-version:5.3

import PackageDescription

/// ...
let package = Package(
    name: "Deutsch",
    products: [
        /// ...
        .library(name: "Deutsch", targets: ["Deutsch"]),
        .executable(name: "werkzeug", targets: ["werkzeug"])
    ],
    targets: [
        /// ...
        .target(name: "Deutsch"),
        .target(name: "werkzeug", resources: [.copy("Deutsch.txt")]),
        .testTarget(name: "DeutschTests", dependencies: ["Deutsch"])
    ]
)
