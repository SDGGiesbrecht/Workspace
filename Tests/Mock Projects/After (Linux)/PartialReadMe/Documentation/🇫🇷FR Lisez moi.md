

[🇨🇦EN](🇨🇦EN%20Read%20Me.md) • [🇬🇧EN](🇬🇧EN%20Read%20Me.md) • [🇺🇸EN](🇺🇸EN%20Read%20Me.md) • [🇩🇪DE](🇩🇪DE%20Lies%20mich.md) • [🇫🇷FR](🇫🇷FR%20Lisez%20moi.md) • [🇬🇷ΕΛ](🇬🇷ΕΛ%20Με%20διαβάστε.md) • [🇮🇱עב](🇮🇱עב%20קרא%20אותי.md) • [[zxx]]([zxx]%20Read%20Me.md) <!--Skip in Jazzy-->

macOS • Linux • iOS • watchOS • tvOS

# PartialReadMe

> [Blah blah blah...](https://www.biblegateway.com/passage/?search=Chapter+1&version=SBLGNT;SG21)

## Importation

`PartialReadMe` est prévu pour utilisation avec le [Gestionnaire de paquets Swift](https://swift.org/package-manager/).

Ajoutez `PartialReadMe` simplement dans la liste des dépendances dans `Package.swift` :

```swift
let paquet = Package(
    name: "MonPaquet",
    dependencies: [
        .package(url: "https://somewhere.com", .upToNextMinor(from: Version(0, 1, 0))),
    ],
    targets: [
        .target(name: "MaCible", dependencies: [
            .productItem(name: "PartialReadMe", package: "PartialReadMe"),
        ])
    ]
)
```

Puis `PartialReadMe` peut être importé dans des fichiers sources :

```swift
import PartialReadMe
```
