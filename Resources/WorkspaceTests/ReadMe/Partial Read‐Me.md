<!--
 Partial Read‐Me.md

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2017 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 -->

[🇨🇦EN](Documentation/🇨🇦EN%20Read%20Me.md) <!--Skip in Jazzy-->

macOS • Linux • iOS • watchOS • tvOS

# MyProject

> Blah blah blah...

## Importing

`MyProject` is intended for use with the [Swift Package Manager](https://swift.org/package-manager/).

Simply add `MyProject` as a dependency in `Package.swift`:

```swift
    let package = Package(
    name: "MyPackage",
    dependencies: [
        .package(url: "https://somewhere.com", .upToNextMinor(Version(0, 1, 0))),
    ],
    targets: [
        .target(name: "MyTarget", dependencies: [
            .productItem(name: "MyProject", package: "MyProject"),
        ])
    ]
)
```

`MyProject` can then be imported in source files:

```swift
import MyProject
```
