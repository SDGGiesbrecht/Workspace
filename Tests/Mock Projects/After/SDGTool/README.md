<!--
 README.md

 This source file is part of the SDG open source project.
 Diese Quelldatei ist Teil des quelloffenen SDG‐Projekt.
 https://example.github.io/SDG/SDG

 Copyright ©2020 John Doe and the SDG project contributors.
 Urheberrecht ©2020 John Doe und die Mitwirkenden des SDG‐Projekts.
 ©2020

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 -->

macOS • Windows • Web • CentOS • Ubuntu • Android • Amazon Linux

[Documentation](https://example.github.io/SDG/%F0%9F%87%A8%F0%9F%87%A6EN)

# SDG

A package.

### Example Usage

```swift
// 🇨🇦EN
```

## Installation

SDG provides command line tools.

They can be installed any way Swift packages can be installed. The most direct method is pasting the following into a terminal, which will either install or update them:

```shell
curl -sL https://gist.github.com/SDGGiesbrecht/4d76ad2f2b9c7bf9072ca1da9815d7e2/raw/update.sh | bash -s SDG "https://github.com/JohnDoe/SDG" 1.0.0 "tool help" tool werkzeug
```

## Importing

SDG provides a library for use with the [Swift Package Manager](https://swift.org/package-manager/).

Simply add SDG as a dependency in `Package.swift`:

```swift
let package = Package(
  name: "MyPackage",
  dependencies: [
    .package(
      name: "SDG",
      url: "https://github.com/JohnDoe/SDG",
      from: Version(1, 0, 0)
    ),
  ],
  targets: [
    .target(
      name: "MyTarget",
      dependencies: [
        .product(name: "Library", package: "SDG"),
      ]
    )
  ]
)
```

The module can then be imported in source files:

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
