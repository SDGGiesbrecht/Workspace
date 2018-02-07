

[🇨🇦EN](🇨🇦EN%20Read%20Me.md) • [🇬🇧EN](🇬🇧EN%20Read%20Me.md) • [🇺🇸EN](🇺🇸EN%20Read%20Me.md) • [🇩🇪DE](🇩🇪DE%20Lies%20mich.md) • [🇫🇷FR](🇫🇷FR%20Lisez%20moi.md) • [🇬🇷ΕΛ](🇬🇷ΕΛ%20Με%20διαβάστε.md) • [🇮🇱עב](🇮🇱עב%20קרא%20אותי.md) • [[zxx]]([zxx]%20Read%20Me.md) <!--Skip in Jazzy-->

macOS • Linux • iOS • watchOS • tvOS

# PartialReadMe

> [Blah blah blah...](https://www.biblegateway.com/passage/?search=Chapter+1&version=SBLGNT;NIVUK)

## Importing

`PartialReadMe` is intended for use with the [Swift Package Manager](https://swift.org/package-manager/).

Simply add `PartialReadMe` as a dependency in `Package.swift`:

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

`PartialReadMe` can then be imported in source files:

```swift
import PartialReadMe
```
