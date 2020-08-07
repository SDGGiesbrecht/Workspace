// swift-tools-version:5.0

import PackageDescription

/// ...
let package = Package(
  name: "Deutsch",
  products: [
    /// ...
    .library(name: "Deutsch", targets: ["Deutsch"]),
    .executable(name: "werkzeug", targets: ["werkzeug"]),
  ],
  targets: [
    /// ...
    .target(name: "Deutsch"),
    .target(name: "werkzeug"),
    .testTarget(name: "DeutschTests", dependencies: ["Deutsch"]),
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
