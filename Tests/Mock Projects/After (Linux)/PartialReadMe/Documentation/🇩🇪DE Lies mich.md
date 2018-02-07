

[🇨🇦EN](🇨🇦EN%20Read%20Me.md) • [🇬🇧EN](🇬🇧EN%20Read%20Me.md) • [🇺🇸EN](🇺🇸EN%20Read%20Me.md) • [🇩🇪DE](🇩🇪DE%20Lies%20mich.md) • [🇫🇷FR](🇫🇷FR%20Lisez%20moi.md) • [🇬🇷ΕΛ](🇬🇷ΕΛ%20Με%20διαβάστε.md) • [🇮🇱עב](🇮🇱עב%20קרא%20אותי.md) • [[zxx]]([zxx]%20Read%20Me.md) <!--Skip in Jazzy-->

macOS • Linux • iOS • watchOS • tvOS

# PartialReadMe

> [Blah blah blah...](https://www.biblegateway.com/passage/?search=Chapter+1&version=SBLGNT;SCH2000)

## Einführung

`PartialReadMe` ist für den Einsatz mit dem [Swift‐Paketverwalter](https://swift.org/package-manager/) vorgesehen.

Fügen Sie `PartialReadMe` einfach in der Abhängigkeitsliste in `Package.swift` hinzu:

```swift
let paket = Package(
    name: "MeinPaket",
    dependencies: [
        .package(url: "https://somewhere.com", .upToNextMinor(from: Version(0, 1, 0))),
    ],
    targets: [
        .target(name: "MeinZiel", dependencies: [
            .productItem(name: "PartialReadMe", package: "PartialReadMe"),
        ])
    ]
)
```

Dann kann `PartialReadMe` in Quelldateien eingeführt werden:

```swift
import PartialReadMe
```
