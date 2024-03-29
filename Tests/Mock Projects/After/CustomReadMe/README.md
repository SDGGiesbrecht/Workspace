<!--
 README.md

 This source file is part of the CustomReadMe open source project.

 Copyright ©[Current Date] the CustomReadMe project contributors.

 Dedicated to the public domain.
 See http://unlicense.org/ for more information.
 -->

macOS • Windows • Web • Ubuntu • tvOS • iOS • Android • Amazon Linux • watchOS

# CustomReadMe

> [Blah blah blah...](http://somewhere.com)

## Example Usage

```swift
let x = something()
```

## Installation

## Installation

Build from source at tag `1.2.3` of `https://github.com/User/Repository`.

## Importing

CustomReadMe provides a library for use with the Swift Package Manager.

Simply add CustomReadMe as a dependency in `Package.swift`:

```swift
let package = Package(
  name: "MyPackage",
  dependencies: [
    .package(
      url: "https://github.com/User/Repository",
      from: Version(1, 2, 3)
    ),
  ],
  targets: [
    .target(
      name: "MyTarget",
      dependencies: [
        .product(name: "CustomReadMe", package: "Repository"),
      ]
    )
  ]
)
```

The module can then be imported in source files:

```swift
import CustomReadMe
```
