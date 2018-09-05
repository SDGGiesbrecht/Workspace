

[🇨🇦EN](Documentation/🇨🇦EN%20Read%20Me.md) • [🇬🇧EN](Documentation/🇬🇧EN%20Read%20Me.md) • [🇺🇸EN](Documentation/🇺🇸EN%20Read%20Me.md) • [🇩🇪DE](Documentation/🇩🇪DE%20Read%20Me.md) • [🇫🇷FR](Documentation/🇫🇷FR%20Read%20Me.md) • [🇬🇷ΕΛ](Documentation/🇬🇷ΕΛ%20Read%20Me.md) • [🇮🇱עב](Documentation/🇮🇱עב%20Read%20Me.md) • [[zxx]](Documentation/[zxx]%20Read%20Me.md)

macOS • Linux • iOS • watchOS • tvOS

# PartialReadMe

> [Blah blah blah...](https://www.biblegateway.com/passage/?search=Chapter+1&version=SBLGNT;NIV)

## Importing

PartialReadMe provides a library for use with the [Swift Package Manager](https://swift.org/package-manager/).

Simply add PartialReadMe as a dependency in `Package.swift`:

```swift
let package = Package(
    name: "MyPackage",
    dependencies: [
        .package(url: "https://somewhere.com", .upToNextMinor(from: Version(0, 1, 0))),
    ],
    targets: [
        .target(name: "MyTarget", dependencies: [
            .productItem(name: "PartialReadMe", package: "PartialReadMe"),
        ])
    ]
)
```

The library’s module can then be imported in source files:

```swift
import PartialReadMe
```
