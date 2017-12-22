

[🇨🇦EN](🇨🇦EN%20Read%20Me.md) • [🇬🇧EN](🇬🇧EN%20Read%20Me.md) • [🇺🇸EN](🇺🇸EN%20Read%20Me.md) • [🇩🇪DE](🇩🇪DE%20Lies%20mich.md) • [🇫🇷FR](🇫🇷FR%20Lisez%20moi.md) • [🇬🇷ΕΛ](🇬🇷ΕΛ%20Με%20διαβάστε.md) • [🇮🇱עב](🇮🇱עב%20קרא%20אותי.md) • [[zxx]]([zxx]%20Read%20Me.md) <!--Skip in Jazzy-->

macOS • Linux • iOS • watchOS • tvOS

IPA : [SDG](https://example.github.io/SDG/SDG)

# SDG

...

> [« ... »<br>...](https://www.biblegateway.com/passage/?search=Chapter+1&version=WLC;SG21)<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;―...

## Fonctionnalités

...

(Pour une liste de projets lié, voir [ici](🇫🇷FR%20Projets%20liés.md).) <!--Skip in Jazzy-->

## Importation

`SDG` est prévu pour utilisation avec le [Gestionnaire de paquets Swift](https://swift.org/package-manager/).

Ajoutez `SDG` simplement dans la liste des dépendances dans `Package.swift` :

```swift
let paquet = Package(
    name: "MonPaquet",
    dependencies: [
        .package(url: "https://github.com/JohnDoe/SDG", from: Version(1, 0, 0)),
    ],
    targets: [
        .target(name: "MaCible", dependencies: [
            .productItem(name: "SDG", package: "SDG"),
        ])
    ]
)
```

Puis `SDG` peut être importé dans des fichiers sources :

```swift
import SDG
```

...

## À propos

...
