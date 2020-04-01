// swift-tools-version:4.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

// @localization(🇨🇦EN) @localization(🇬🇧EN) @localization(🇺🇸EN) @localization(🇩🇪DE) @localization(zxx)
/// A package.
let package = Package(
  name: "CheckedInDocumentation",
  products: [
    // @localization(🇨🇦EN) @localization(🇬🇧EN) @localization(🇺🇸EN) @localization(🇩🇪DE) @localization(zxx)
    /// A library.
    .library(name: "CheckedInDocumentation", targets: ["CheckedInDocumentation"]),
    // @localization(🇨🇦EN) @localization(🇬🇧EN) @localization(🇺🇸EN) @localization(🇩🇪DE) @localization(zxx)
    /// Extensions.
    .library(name: "Extensions", targets: ["Extensions"]),
    // @localization(🇨🇦EN) @localization(🇬🇧EN) @localization(🇺🇸EN) @localization(🇩🇪DE) @localization(zxx)
    /// An executable.
    .executable(name: "executable", targets: ["Tool"]),
  ],
  dependencies: [
    // Dependencies declare other packages that this package depends on.
    // .package(url: /* package url */, from: "1.0.0"),
  ],
  targets: [
    // @localization(🇨🇦EN) @localization(🇬🇧EN) @localization(🇺🇸EN) @localization(🇩🇪DE) @localization(zxx)
    /// A module.
    .target(name: "CheckedInDocumentation", dependencies: ["EnableBuild"]),
    .target(name: "EnableBuild"),
    // @localization(🇨🇦EN) @localization(🇬🇧EN) @localization(🇺🇸EN) @localization(🇩🇪DE) @localization(zxx)
    /// Extensions.
    .target(name: "Extensions", dependencies: ["CheckedInDocumentation"]),
    // @localization(🇨🇦EN) @localization(🇬🇧EN) @localization(🇺🇸EN) @localization(🇩🇪DE) @localization(zxx)
    /// An executable.
    .target(name: "Tool", dependencies: ["EnableBuild"]),
    .testTarget(
      name: "CheckedInDocumentationTests",
      dependencies: ["CheckedInDocumentation"]
    ),
  ]
)
