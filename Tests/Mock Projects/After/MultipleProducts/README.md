

macOS • Windows • Web • CentOS • Ubuntu • tvOS • iOS • Android • Amazon Linux • watchOS

# MultipleProducts



## Installation

MultipleProducts provides command line tools.

They can be installed any way Swift packages can be installed. The most direct method is pasting the following into a terminal, which will either install or update them:

```shell
curl -sL https://gist.github.com/SDGGiesbrecht/4d76ad2f2b9c7bf9072ca1da9815d7e2/raw/update.sh | bash -s MultipleProducts "https://somewhere.tld/repository" 1.0.0 "executable‐a help" executable‐a executable‐b
```

## Importing

MultipleProducts provides libraries for use with the [Swift Package Manager](https://swift.org/package-manager/).

Simply add MultipleProducts as a dependency in `Package.swift` and specify which of the libraries to use:

```swift
let package = Package(
  name: "MyPackage",
  dependencies: [
    .package(
      name: "MultipleProducts",
      url: "https://somewhere.tld/repository",
      from: Version(1, 0, 0)
    ),
  ],
  targets: [
    .target(
      name: "MyTarget",
      dependencies: [
        .product(name: "LibraryA", package: "MultipleProducts"),
        .product(name: "LibraryB", package: "MultipleProducts"),
      ]
    )
  ]
)
```

The modules can then be imported in source files:

```swift
import ModuleA
import ModuleB
import ModuleC
import ModuleD
```
