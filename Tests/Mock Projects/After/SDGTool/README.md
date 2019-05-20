<!--
 README.md

 This source file is part of the SDG open source project.
 https://example.github.io/SDG/SDG

 Copyright ©2019 John Doe and the SDG project contributors.
 ©2019

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 -->

[🇨🇦EN](Documentation/🇨🇦EN%20Read%20Me.md) • [🇬🇧EN](Documentation/🇬🇧EN%20Read%20Me.md) • [🇺🇸EN](Documentation/🇺🇸EN%20Read%20Me.md) • [🇩🇪DE](Documentation/🇩🇪DE%20Read%20Me.md) • [🇫🇷FR](Documentation/🇫🇷FR%20Read%20Me.md) • [🇬🇷ΕΛ](Documentation/🇬🇷ΕΛ%20Read%20Me.md) • [🇮🇱עב](Documentation/🇮🇱עב%20Read%20Me.md) • [[zxx]](Documentation/[zxx]%20Read%20Me.md)

macOS • Linux

[Documentation](https://example.github.io/SDG/%F0%9F%87%A8%F0%9F%87%A6EN)

# SDG

A package.

### Example Usage

```swift
// 🇨🇦EN
```

(For a list of related projects, see [here](Documentation/🇨🇦EN%20Related%20Projects.md).)

## Installation

SDG provides a command line tool.

Paste the following into a terminal to install or update it:

```shell
curl -sL https://gist.github.com/SDGGiesbrecht/4d76ad2f2b9c7bf9072ca1da9815d7e2/raw/update.sh | bash -s SDG "https://github.com/JohnDoe/SDG" 1.0.0 "tool help" tool
```

## Importing

SDG provides a library for use with the [Swift Package Manager](https://swift.org/package-manager/).

Simply add SDG as a dependency in `Package.swift`:

```swift
let package = Package(
    name: "MyPackage",
    dependencies: [
        .package(url: "https://github.com/JohnDoe/SDG", from: Version(1, 0, 0)),
    ],
    targets: [
        .target(name: "MyTarget", dependencies: [
            .productItem(name: "Library", package: "SDG"),
        ])
    ]
)
```

The library’s module can then be imported in source files:

```swift
import Library
```

## About

The SDG project is maintained by Jeremy David Giesbrecht.

If SDG saves you money, consider giving some of it as a [donation](https://paypal.me/JeremyGiesbrecht).

If SDG saves you time, consider devoting some of it to [contributing](https://github.com/JohnDoe/SDG) back to the project.

> [Ἄξιος γὰρ ὁ ἐργάτης τοῦ μισθοῦ αὐτοῦ ἐστι.](https://www.biblegateway.com/passage/?search=Luke+10&version=SBLGNT;NIV)
>
> [For the worker is worthy of his wages.](https://www.biblegateway.com/passage/?search=Luke+10&version=SBLGNT;NIV)
>
> ―‎ישוע/Yeshuʼa
