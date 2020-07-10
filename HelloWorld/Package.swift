// swift-tools-version:5.2

import PackageDescription

let package = Package(
  name: "HelloWorld",
  products: [
    .library(
      name: "HelloWorld",
      targets: ["HelloWorld"])
  ],
  targets: [
    .target(
      name: "HelloWorld",
      dependencies: ["HelloC"]),
    .target(
      name: "HelloC",
      dependencies: []),
    .testTarget(
      name: "HelloWorldTests",
      dependencies: ["HelloWorld"])
  ]
)
