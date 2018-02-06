

[🇨🇦EN](🇨🇦EN%20Read%20Me.md) • [🇬🇧EN](🇬🇧EN%20Read%20Me.md) • [🇺🇸EN](🇺🇸EN%20Read%20Me.md) • [🇩🇪DE](🇩🇪DE%20Lies%20mich.md) • [🇫🇷FR](🇫🇷FR%20Lisez%20moi.md) • [🇬🇷ΕΛ](🇬🇷ΕΛ%20Με%20διαβάστε.md) • [🇮🇱עב](🇮🇱עב%20קרא%20אותי.md) • [[zxx]]([zxx]%20Read%20Me.md) <!--Skip in Jazzy-->

macOS • Linux • iOS • watchOS • tvOS

SAPs [Library](https://example.github.io/SDG/Library)

# SDG

...

> [« ... »<br>...](https://www.biblegateway.com/passage/?search=Chapter+1&version=WLC;SCH2000)<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;―...

## Merkmale

...

(Für eine Liste verwandter Projekte, siehe [hier](🇩🇪DE%20Verwandte%20Projekte.md).) <!--Skip in Jazzy-->

## Einführung

`SDG` ist für den Einsatz mit dem [Swift‐Paketverwalter](https://swift.org/package-manager/) vorgesehen.

Fügen Sie `SDG` einfach in der Abhängigkeitsliste in `Package.swift` hinzu:

```swift
let paket = Package(
    name: "MeinPaket",
    dependencies: [
        .package(url: "https://github.com/JohnDoe/SDG", from: Version(1, 0, 0)),
    ],
    targets: [
        .target(name: "MeinZiel", dependencies: [
            .productItem(name: "Library", package: "SDG"),
        ])
    ]
)
```

Dann kann `SDG` in Quelldateien eingeführt werden:

```swift
import Library
```

## Verwendungsbeispiele

```swift
// 🇩🇪DE
```

...

## Über

...
