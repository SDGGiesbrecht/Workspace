

macOS • Web • CentOS • Ubuntu • tvOS • iOS • Amazon Linux • watchOS

# OneProductMultipleModules



## Importing

OneProductMultipleModules provides a library for use with the [Swift Package Manager](https://swift.org/package-manager/).

Simply add OneProductMultipleModules as a dependency in `Package.swift`:

```swift
let package = Package(
  name: "MyPackage",
  dependencies: [
    .package(
      name: "OneProductMultipleModules",
      url: "https://somewhere.tld/repository",
      from: Version(1, 0, 0)
    ),
  ],
  targets: [
    .target(
      name: "MyTarget",
      dependencies: [
        .product(name: "OneProductMultipleModules", package: "OneProductMultipleModules"),
      ]
    )
  ]
)
```

The modules can then be imported in source files:

```swift
import ModuleA
import ModuleB
```
