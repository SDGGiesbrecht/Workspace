

macOS • Windows • Web • CentOS • Ubuntu • tvOS • iOS • Android • Amazon Linux • watchOS

# PartialReadMe

A package.

## Importing

PartialReadMe provides a library for use with the [Swift Package Manager](https://swift.org/package-manager/).

Simply add PartialReadMe as a dependency in `Package.swift`:

```swift
let package = Package(
  name: "MyPackage",
  dependencies: [
    .package(
      name: "PartialReadMe",
      url: "http://example.com",
      .upToNextMinor(from: Version(0, 1, 0))
    ),
  ],
  targets: [
    .target(
      name: "MyTarget",
      dependencies: [
        .product(name: "PartialReadMe", package: "PartialReadMe"),
      ]
    )
  ]
)
```

The module can then be imported in source files:

```swift
import PartialReadMe
```
