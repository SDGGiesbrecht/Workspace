// swift-tools-version:5.0

/*
 Package.swift

 This source file is part of the SDG open source project.
 Diese Quelldatei ist Teil des quelloffenen SDG‐Projekt.
 https://example.github.io/SDG/SDG

 Copyright ©2020 John Doe and the SDG project contributors.
 Urheberrecht ©2020 John Doe und die Mitwirkenden des SDG‐Projekts.
 ©2020

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import PackageDescription

// @localization(🇨🇦EN) @localization(🇬🇧EN) @localization(🇺🇸EN) @localization(🇩🇪DE) @localization(🇫🇷FR) @localization(🇬🇷ΕΛ) @localization(🇮🇱עב) @localization(zxx)
// @example(1, Read‐Me 🇨🇦EN)
/// A package.
///
/// ### Example Usage
///
/// ```swift
/// // 🇨🇦EN
/// ```
let package = Package(
  name: "SDG",
  products: [
    // @localization(🇨🇦EN) @localization(🇬🇧EN) @localization(🇺🇸EN) @localization(🇩🇪DE) @localization(🇫🇷FR) @localization(🇬🇷ΕΛ) @localization(🇮🇱עב) @localization(zxx)
    /// A library.
    .library(name: "Library", targets: ["Library"])
  ],
  dependencies: [
    .package(url: "file:///tmp/Developer/Dependency", from: Version(1, 0, 0))
  ],
  targets: [
    // @localization(🇨🇦EN) @localization(🇬🇧EN) @localization(🇺🇸EN) @localization(🇩🇪DE) @localization(🇫🇷FR) @localization(🇬🇷ΕΛ) @localization(🇮🇱עב) @localization(zxx)
    /// A module.
    .target(
      name: "Library",
      dependencies: [
        .product(name: "Dependency", package: "Dependency")
      ]
    ),
    .testTarget(name: "SDGTests", dependencies: [.target(name: "Library")]),
  ]
)
// Windows Tests (Generated automatically by Workspace.)
import Foundation
if ProcessInfo.processInfo.environment["TARGETING_WINDOWS"] == "true",
  ProcessInfo.processInfo.environment["GENERATING_TESTS"] == nil
{
  var tests: [Target] = []
  var other: [Target] = []
  for target in package.targets {
    if target.type == .test {
      tests.append(target)
    } else {
      other.append(target)
    }
  }
  package.targets = other
  package.targets.append(
    contentsOf: tests.map({ test in
      return .target(
        name: test.name,
        dependencies: test.dependencies,
        path: test.path ?? "Tests/\(test.name)",
        exclude: test.exclude,
        sources: test.sources,
        publicHeadersPath: test.publicHeadersPath,
        cSettings: test.cSettings,
        cxxSettings: test.cxxSettings,
        swiftSettings: test.swiftSettings,
        linkerSettings: test.linkerSettings
      )
    })
  )
  package.targets.append(
    .target(
      name: "WindowsTests",
      dependencies: tests.map({ Target.Dependency.target(name: $0.name) }),
      path: "Tests/WindowsTests"
    )
  )
}
// End Windows Tests
