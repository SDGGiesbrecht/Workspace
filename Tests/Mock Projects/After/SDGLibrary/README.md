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

macOS • Windows • Web • Linux • tvOS • iOS • Android • watchOS

[Documentation](https://example.github.io/SDG/%F0%9F%87%A8%F0%9F%87%A6EN)

# SDG

A package.

### Example Usage

```swift
// 🇨🇦EN
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
