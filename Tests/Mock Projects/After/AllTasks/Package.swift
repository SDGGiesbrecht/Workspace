// swift-tools-version:5.0

/*
 Package.swift


 ©[Current Date]

 This software is subject to copyright law.
 It may not be used, copied, distributed or modified without first obtaining a private licence from the copyright holder(s).
 */

import PackageDescription

/// A package with all tasks configured.
let package = Package(
    name: "AllTasks",
    products: [
        /// A library.
        .library(name: "AllTasks", targets: ["AllTasks"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
    ],
    targets: [
        /// A module.
        .target(name: "AllTasks", dependencies: []),
        .testTarget(
            name: "AllTasksTests",
            dependencies: ["AllTasks"]),
    ]
)

import Foundation
if ProcessInfo.processInfo.environment["TARGETING_WATCHOS"] == "true" {
  // #workaround(xcodebuild -version 11.6, Test targets don’t work on watchOS.) @exempt(from: unicode)
  package.targets.removeAll(where: { $0.isTest })
}
