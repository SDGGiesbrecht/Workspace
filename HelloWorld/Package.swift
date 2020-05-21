// swift-tools-version:5.2

import PackageDescription

let package = Package(
  name: "HelloWorld",
  products: [
    .library(
      name: "HelloWorld",
      targets: ["HelloWorld"]),
  ],
  targets: [
    .target(
      name: "HelloWorld",
      dependencies: []),
    .testTarget(
      name: "HelloWorldTests",
      dependencies: ["HelloWorld"]),
  ]
)
