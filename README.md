<!--
 README.md

 This source file is part of the Workspace open source project.
 Diese Quelldatei ist Teil des quelloffenen Arbeitsbereich‐Projekt.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2017–2022 Jeremy David Giesbrecht and the Workspace project contributors.
 Urheberrecht ©2017–2022 Jeremy David Giesbrecht und die Mitwirkenden des Arbeitsbereich‐Projekts.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 -->

macOS • Ubuntu • Amazon Linux

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
    - [Resource accessors](https://sdggiesbrecht.github.io/Workspace/🇬🇧EN/Tools/workspace/Subcommands/refresh/Subcommands/resources.html)
    - [Inherited documentation](https://sdggiesbrecht.github.io/Workspace/🇬🇧EN/Tools/workspace/Subcommands/refresh/Subcommands/inherited%E2%80%90documentation.html)
    - [Xcode project generation](https://sdggiesbrecht.github.io/Workspace/🇬🇧EN/Types/XcodeConfiguration/Properties/manage.html)
- Automates open source details:
    - [File headers](https://sdggiesbrecht.github.io/Workspace/🇬🇧EN/Types/FileHeaderConfiguration.html)
    - [Read‐me files](https://sdggiesbrecht.github.io/Workspace/🇬🇧EN/Types/ReadMeConfiguration.html)
    - [Licence notices](https://sdggiesbrecht.github.io/Workspace/🇬🇧EN/Types/LicenceConfiguration.html)
    - [Contributing instructions](https://sdggiesbrecht.github.io/Workspace/🇬🇧EN/Types/GitHubConfiguration.html)
- Designed to interoperate with the [Swift Package Manager](https://swift.org/package-manager/).
- Manages projects for macOS, Windows, web, CentOS, Ubuntu, tvOS, iOS, Android, Amazon Linux and watchOS.
- [Configurable](https://sdggiesbrecht.github.io/Workspace/🇬🇧EN/Libraries/WorkspaceConfiguration.html)

### The Workspace Workflow

(The following demonstration package is a real repository. You can use it to follow along.)

#### When the Repository Is Cloned

The need to hunt down workflow tools can deter contributors. On the other hand, including them in the repository causes a lot of clutter. To reduce both, when a project using Workspace is pulled, pushed, or cloned...

```shell
git clone https://github.com/SDGGiesbrecht/SDGCornerstone
```

...only one small piece of Workspace comes with it: A short script called `Refresh` that has several platform variants.

*Hmm... I wish I had more tools at my disposal... Hey! What if I...*

#### Refresh the Project

To refresh the project, double‐click the `Refresh` script for your platform. (You can also execute the script from the command line if your system is set up not to execute scripts when they are double‐clicked.)

`Refresh` opens a terminal window, and in it Workspace reports its actions while it sets the project folder up for development. (This may take a while the first time, but subsequent runs are faster.)

*This looks better. Let’s get coding!*

*[Add this... Remove that... Change something over here...]*

*...All done. I wonder if I broke anything while I was working? Hey! It looks like I can...*

#### Validate Changes

When the project seems ready for a push, merge, or pull request, validate the current state of the project by double‐clicking the `Validate` script.

`Validate` opens a terminal window and in it Workspace runs the project through a series of checks.

When it finishes, it prints a summary of which tests passed and which tests failed.

*Oops! I never realized that would happen...*

#### Summary

- `Refresh` before working.
- `Validate` when it looks complete.

*Wow! That was so much easier than doing it all manually!*

#### Advanced

While the above workflow is the simplest to learn, Workspace can also be installed as a command line tool that can be used in a wider variety of ways. Most notably, any individual task can be executed in isolation, which can speed things up considerably for users who become familiar with it.

### Applying Workspace to a Project

To apply Workspace to a project, run the following command in the root of the project’s repository. (This requires a full install.)

```shell
$ workspace refresh
```

By default, Workspace refrains from tasks which would involve modifying project files. Such tasks must be activated with a [configuration](https://sdggiesbrecht.github.io/Workspace/🇬🇧EN/Libraries/WorkspaceConfiguration.html) file. `optIntoAllTasks()` can be used in the configuration file to easily activate everything at once, no matter how much it might end up overwriting.

## Installation

Workspace provides command line tools.

They can be installed any way Swift packages can be installed. The most direct method is pasting the following into a terminal, which will either install or update them:

```shell
curl -sL https://gist.github.com/SDGGiesbrecht/4d76ad2f2b9c7bf9072ca1da9815d7e2/raw/update.sh | bash -s Workspace "https://github.com/SDGGiesbrecht/Workspace" 0.41.1 "workspace help" workspace arbeitsbereich
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
      .upToNextMinor(from: Version(0, 41, 1))
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
