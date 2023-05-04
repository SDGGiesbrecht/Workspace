// swift-tools-version:5.7

import PackageDescription

let package = Package(
  name: "FailingTestCoverage",
  products: [
    .library(
      name: "FailingTestCoverage",
      targets: ["FailingTestCoverage"]
    ),
  ],
  targets: [
    .target(
      name: "FailingTestCoverage",
      dependencies: []
    ),
    .testTarget(
      name: "FailingTestCoverageTests",
      dependencies: ["FailingTestCoverage"]
    ),
  ]
)
