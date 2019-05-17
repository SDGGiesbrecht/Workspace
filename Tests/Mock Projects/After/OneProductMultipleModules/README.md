

[🇬🇧EN](Documentation/🇬🇧EN%20Read%20Me.md)

macOS • Linux • iOS • watchOS • tvOS

# OneProductMultipleModules



## Importing

OneProductMultipleModules provides a library for use with the [Swift Package Manager](https://swift.org/package-manager/).

Simply add OneProductMultipleModules as a dependency in `Package.swift`:

```swift
let package = Package(
    name: "MyPackage",
    dependencies: [
        .package(url: "https://somewhere.tld/repository", from: Version(1, 0, 0)),
    ],
    targets: [
        .target(name: "MyTarget", dependencies: [
            .productItem(name: "OneProductMultipleModules", package: "OneProductMultipleModules"),
        ])
    ]
)
```

The library’s modules can then be imported in source files:

```swift
import ModuleA
import ModuleB
```
