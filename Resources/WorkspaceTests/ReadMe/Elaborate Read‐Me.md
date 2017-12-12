<!--
 Elaborate Read‐Me.md

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2017 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 -->

[🇨🇦EN](Documentation/🇨🇦EN%20Read%20Me.md) • [🇬🇧EN](Documentation/🇬🇧EN%20Read%20Me.md) • [🇺🇸EN](Documentation/🇺🇸EN%20Read%20Me.md) • [🇩🇪DE](Documentation/🇩🇪DE%20Lies%20mich.md) • [🇫🇷FR](Documentation/🇫🇷FR%20Lisez%20moi.md) • [🇬🇷ΕΛ](Documentation/🇬🇷ΕΛ%20Με%20διαβάστε.md) • [🇮🇱עב](Documentation/🇮🇱עב%20קרא%20אותי.md) • [[zxx]](Documentation/[zxx]%20Read%20Me.md) <!--Skip in Jazzy-->

macOS • Linux

APIs: [MyProject](documentation.example.com/MyProject)

# MyProject

MyProject does stuff.

> [« ... »<br>“...”](https://www.biblegateway.com/passage/?search=Chapter+1&version=WLC;NIV)<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;―someone

## Features

- Stuff.
- More stuff.
- Even more stuff.

(For a list of related projects, see [here](Documentation/🇨🇦EN%20Related%20Projects.md).) <!--Skip in Jazzy-->

## Installation

Paste the following into a terminal to install or update `MyProject`:

```shell
curl -sL https://gist.github.com/SDGGiesbrecht/4d76ad2f2b9c7bf9072ca1da9815d7e2/raw/update.sh | bash -s MyProject "https://github.com/User/Project" 1.2.3 "tool help" tool
```

## Importing

`MyProject` is intended for use with the [Swift Package Manager](https://swift.org/package-manager/).

Simply add `MyProject` as a dependency in `Package.swift`:

```swift
let package = Package(
    name: "MyPackage",
    dependencies: [
        .package(url: "https://github.com/User/Project", from: Version(1, 2, 3)),
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

## Example Usage

```swift
doSomething()
```

## Other

...

## About

This project is just a test.
