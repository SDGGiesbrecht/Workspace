

[🇨🇦EN](🇨🇦EN%20Read%20Me.md) • [🇬🇧EN](🇬🇧EN%20Read%20Me.md) • [🇺🇸EN](🇺🇸EN%20Read%20Me.md) • [🇩🇪DE](🇩🇪DE%20Read%20Me.md) • [🇫🇷FR](🇫🇷FR%20Read%20Me.md) • [🇬🇷ΕΛ](🇬🇷ΕΛ%20Read%20Me.md) • [🇮🇱עב](🇮🇱עב%20Read%20Me.md) • [[zxx]]([zxx]%20Read%20Me.md)

macOS • Linux • iOS • watchOS • tvOS

# PartialReadMe

> [Blah blah blah...](https://www.biblegateway.com/passage/?search=Chapter+1&version=SBLGNT;NIVUK)

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
