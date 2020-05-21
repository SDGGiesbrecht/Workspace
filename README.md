<!--
 README.md

 This source file is part of the Workspace open source project.
 Diese Quelldatei ist Teil des quelloffenen Arbeitsbereich‐Projekt.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2017–2020 Jeremy David Giesbrecht and the Workspace project contributors.
 Urheberrecht ©2017–2020 Jeremy David Giesbrecht und die Mitwirkenden des Arbeitsbereich‐Projekts.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 -->

macOS • Linux

[Documentation](https://sdggiesbrecht.github.io/Workspace/%F0%9F%87%AC%F0%9F%87%A7EN)

# Workspace

Workspace automates management of Swift projects.

> [Πᾶν ὅ τι ἐὰν ποιῆτε, ἐκ ψυχῆς ἐργάζεσθε, ὡς τῷ Κυρίῳ καὶ οὐκ ἀνθρώποις.](https://www.biblegateway.com/passage/?search=Colossians+3&version=SBLGNT;NIVUK)
>
> [Whatever you do, work from the heart, as working for the Lord and not for men.](https://www.biblegateway.com/passage/?search=Colossians+3&version=SBLGNT;NIVUK)
>
> ―⁧שאול⁩/Shaʼul

### Features

- Provides rigorous validation:
    - [Test coverage](https://sdggiesbrecht.github.io/Workspace/🇬🇧EN/Types/TestingConfiguration/Properties/enforceCoverage.html)
    - [Compiler warnings](https://sdggiesbrecht.github.io/Workspace/🇬🇧EN/Types/TestingConfiguration/Properties/prohibitCompilerWarnings.html)
    - [Documentation coverage](https://sdggiesbrecht.github.io/Workspace/🇬🇧EN/Types/APIDocumentationConfiguration/Properties/enforceCoverage.html)
    - [Example validation](https://sdggiesbrecht.github.io/Workspace/🇬🇧EN/Tools/workspace/Subcommands/refresh/Subcommands/examples.html)
    - [Style proofreading](https://sdggiesbrecht.github.io/Workspace/🇬🇧EN/Types/ProofreadingConfiguration.html)
    - [Reminders](https://sdggiesbrecht.github.io/Workspace/🇬🇧EN/Types/ProofreadingRule/Cases/manualWarnings.html)
    - [Continuous integration set‐up](https://sdggiesbrecht.github.io/Workspace/🇬🇧EN/Types/ContinuousIntegrationConfiguration/Properties/manage.html) ([GitHub Actions](https://github.com/features/actions))
- Generates API [documentation](https://sdggiesbrecht.github.io/Workspace/🇬🇧EN/Types/APIDocumentationConfiguration/Properties/generate.html).
- Automates code maintenance:
    - [Embedded resources](https://sdggiesbrecht.github.io/Workspace/🇬🇧EN/Tools/workspace/Subcommands/refresh/Subcommands/resources.html)
    - [Inherited documentation](https://sdggiesbrecht.github.io/Workspace/🇬🇧EN/Tools/workspace/Subcommands/refresh/Subcommands/inherited%E2%80%90documentation.html)
    - [Xcode project generation](https://sdggiesbrecht.github.io/Workspace/🇬🇧EN/Types/XcodeConfiguration/Properties/manage.html)
- Automates open source details:
    - [File headers](https://sdggiesbrecht.github.io/Workspace/🇬🇧EN/Types/FileHeaderConfiguration.html)
    - [Read‐me files](https://sdggiesbrecht.github.io/Workspace/🇬🇧EN/Types/ReadMeConfiguration.html)
    - [Licence notices](https://sdggiesbrecht.github.io/Workspace/🇬🇧EN/Types/LicenceConfiguration.html)
    - [Contributing instructions](https://sdggiesbrecht.github.io/Workspace/🇬🇧EN/Types/GitHubConfiguration.html)
- Designed to interoperate with the [Swift Package Manager](https://swift.org/package-manager/).
- Manages projects for macOS, Windows, Linux, tvOS, iOS, Android and watchOS.
- [Configurable](https://sdggiesbrecht.github.io/Workspace/🇬🇧EN/Libraries/WorkspaceConfiguration.html)

## Installation

Workspace provides command line tools.

They can be installed any way Swift packages can be installed. The most direct method is pasting the following into a terminal, which will either install or update them:

```shell
curl -sL https://gist.github.com/SDGGiesbrecht/4d76ad2f2b9c7bf9072ca1da9815d7e2/raw/update.sh | bash -s Workspace "https://github.com/SDGGiesbrecht/Workspace" 0.32.4 "workspace help" workspace arbeitsbereich
```

## Importing

Workspace provides a library for use with the [Swift Package Manager](https://swift.org/package-manager/).

Simply add Workspace as a dependency in `Package.swift`:

```swift
let package = Package(
  name: "MyPackage",
  dependencies: [
    .package(
      name: "Workspace",
      url: "https://github.com/SDGGiesbrecht/Workspace",
      .upToNextMinor(from: Version(0, 32, 4))
    ),
  ],
  targets: [
    .target(
      name: "MyTarget",
      dependencies: [
        .product(name: "WorkspaceConfiguration", package: "Workspace"),
      ]
    )
  ]
)
```

The module can then be imported in source files:

```swift
import WorkspaceConfiguration
```

## About

The Workspace project is maintained by Jeremy David Giesbrecht.

If Workspace saves you money, consider giving some of it as a [donation](https://paypal.me/JeremyGiesbrecht).

If Workspace saves you time, consider devoting some of it to [contributing](https://github.com/SDGGiesbrecht/Workspace) back to the project.

> [Ἄξιος γὰρ ὁ ἐργάτης τοῦ μισθοῦ αὐτοῦ ἐστι.](https://www.biblegateway.com/passage/?search=Luke+10&version=SBLGNT;NIV)
>
> [For the worker is worthy of his wages.](https://www.biblegateway.com/passage/?search=Luke+10&version=SBLGNT;NIV)
>
> ―‎ישוע/Yeshuʼa
