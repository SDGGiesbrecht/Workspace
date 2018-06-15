

[🇨🇦EN](🇨🇦EN%20Read%20Me.md) • [🇬🇧EN](🇬🇧EN%20Read%20Me.md) • [🇺🇸EN](🇺🇸EN%20Read%20Me.md) • [🇩🇪DE](🇩🇪DE%20Read%20Me.md) • [🇫🇷FR](🇫🇷FR%20Read%20Me.md) • [🇬🇷ΕΛ](🇬🇷ΕΛ%20Read%20Me.md) • [🇮🇱עב](🇮🇱עב%20Read%20Me.md) • [[zxx]]([zxx]%20Read%20Me.md) <!--Skip in Jazzy-->

macOS • Linux • iOS • watchOS • tvOS

APIs: [Library](https://example.github.io/SDG/Library)

# SDG

This project does stuff.

> [« ... »<br>“...”](https://www.biblegateway.com/passage/?search=Chapter+1&version=WLC;NIV)<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;―someone

## Features

- Stuff.
- More stuff.
- Even more stuff.

(For a list of related projects, see [here](🇨🇦EN%20Related%20Projects.md).) <!--Skip in Jazzy-->

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

This project is just a test.
