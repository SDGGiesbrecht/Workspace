// swift-tools-version:4.0

/*
 Package.swift


 ©[Current Date]

 Licensed under the GNU General Public Licence, Version 3.0.
 See http://www.gnu.org/licenses/ for licence information.
 */

import PackageDescription

let package = Package(
  name: "CustomProofread",
  products: [
    // Products define the executables and libraries produced by a package, and make them visible to other packages.
    .library(
      name: "CustomProofread",
      targets: ["CustomProofread"]
    )
  ],
  dependencies: [
    // Dependencies declare other packages that this package depends on.
  ],
  targets: [
    // Targets are the basic building blocks of a package. A target can define a module or a test suite.
    .target(
      name: "CustomProofread",
      dependencies: []
    ),
    .testTarget(
      name: "CustomProofreadTests",
      dependencies: ["CustomProofread"]
    ),
  ]
)
