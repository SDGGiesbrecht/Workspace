

[🇨🇦EN](Documentation/🇨🇦EN%20Read%20Me.md) • [🇬🇧EN](Documentation/🇬🇧EN%20Read%20Me.md) • [🇺🇸EN](Documentation/🇺🇸EN%20Read%20Me.md) • [🇩🇪DE](Documentation/🇩🇪DE%20Read%20Me.md) • [🇫🇷FR](Documentation/🇫🇷FR%20Read%20Me.md) • [🇬🇷ΕΛ](Documentation/🇬🇷ΕΛ%20Read%20Me.md) • [🇮🇱עב](Documentation/🇮🇱עב%20Read%20Me.md) • [[zxx]](Documentation/[zxx]%20Read%20Me.md) <!--Skip in Jazzy-->

macOS • Linux • iOS • watchOS • tvOS

APIs: [Library](https://example.github.io/SDG/Library)

# SDG

This project does stuff.

> [« ... »<br>“...”](https://www.biblegateway.com/passage/?search=Chapter+1&version=WLC;NIV)<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;―someone

## Features

- Stuff.
- More stuff.
- Even more stuff.

(For a list of related projects, see [here](Documentation/🇨🇦EN%20Related%20Projects.md).) <!--Skip in Jazzy-->

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

## Example Usage

```swift
// 🇨🇦EN
```

## Other

...

## About

The SDG project is maintained by Jeremy David Giesbrecht.

If SDG saves you money, consider giving some of it as a [donation](https://paypal.me/JeremyGiesbrecht).

If SDG saves you time, consider devoting some of it to [contributing](https://github.com/JohnDoe/SDG) back to the project.

> [Ἄξιος γὰρ ὁ ἐργάτης τοῦ μισθοῦ αὐτοῦ ἐστι.<br>For the worker is worthy of his wages.](https://www.biblegateway.com/passage/?search=Luke+10&version=SBLGNT;NIV)<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;―‎ישוע/Yeshuʼa
