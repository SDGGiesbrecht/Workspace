

[🇨🇦EN](🇨🇦EN%20Read%20Me.md) • [🇬🇧EN](🇬🇧EN%20Read%20Me.md) • [🇺🇸EN](🇺🇸EN%20Read%20Me.md) • [🇩🇪DE](🇩🇪DE%20Read%20Me.md) • [🇫🇷FR](🇫🇷FR%20Read%20Me.md) • [🇬🇷ΕΛ](🇬🇷ΕΛ%20Read%20Me.md) • [🇮🇱עב](🇮🇱עב%20Read%20Me.md) • [[zxx]]([zxx]%20Read%20Me.md) <!--Skip in Jazzy-->

macOS • Linux

APIs: [Library](https://example.github.io/SDG/Library)

# SDG

...

> [« ... »<br>...](https://www.biblegateway.com/passage/?search=Chapter+1&version=WLC;NIV)<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;―...

## Features

...

(For a list of related projects, see [here]([zxx]%20Related%20Projects.md).) <!--Skip in Jazzy-->

## Installation

Paste the following into a terminal to install or update `SDG`:

```shell
curl -sL https://gist.github.com/SDGGiesbrecht/4d76ad2f2b9c7bf9072ca1da9815d7e2/raw/update.sh | bash -s SDG "https://github.com/JohnDoe/SDG" 1.0.0 "tool help" tool
```

## Importing

`SDG` is intended for use with the [Swift Package Manager](https://swift.org/package-manager/).

Simply add `SDG` as a dependency in `Package.swift`:

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

`SDG` can then be imported in source files:

```swift
import Library
```

## Example Usage

```swift
// zxx
```

...

## About

...
