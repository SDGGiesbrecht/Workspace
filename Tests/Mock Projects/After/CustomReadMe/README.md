<!--
 README.md

 This source file is part of the CustomReadMe open source project.

 Copyright ©2019 the CustomReadMe project contributors.

 Dedicated to the public domain.
 See http://unlicense.org/ for more information.
 -->

[🇬🇧EN](Documentation/🇬🇧EN%20Read%20Me.md)

macOS • Linux • iOS • watchOS • tvOS

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

CustomReadMe provides a library for use with the [Swift Package Manager](https://swift.org/package-manager/).

Simply add CustomReadMe as a dependency in `Package.swift`:

```swift
let package = Package(
    name: "MyPackage",
    dependencies: [
        .package(url: "https://github.com/User/Repository", from: Version(1, 2, 3)),
    ],
    targets: [
        .target(name: "MyTarget", dependencies: [
            .productItem(name: "CustomReadMe", package: "CustomReadMe"),
        ])
    ]
)
```

The library’s module can then be imported in source files:

```swift
import CustomReadMe
```
