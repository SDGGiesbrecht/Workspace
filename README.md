<!--
 README.md

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2017–2018 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 -->

[🇨🇦EN](Documentation/🇨🇦EN%20Read%20Me.md)

macOS • Linux

[Documentation](https://sdggiesbrecht.github.io/Workspace/%F0%9F%87%A8%F0%9F%87%A6EN)

# Workspace

Workspace automates management of Swift projects.

> [Πᾶν ὅ τι ἐὰν ποιῆτε, ἐκ ψυχῆς ἐργάζεσθε, ὡς τῷ Κυρίῳ καὶ οὐκ ἀνθρώποις.<br>Whatever you do, work from the heart, as working for the Lord and not for men.](https://www.biblegateway.com/passage/?search=Colossians+3&version=SBLGNT;NIV)<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;―‎שאול/Shaʼul

## Features

- Provides rigorous validation:
  - [Test coverage](https://sdggiesbrecht.github.io/Workspace/🇨🇦EN/Types/TestingConfiguration/Properties/enforceCoverage.html)
  - [Compiler warnings](https://sdggiesbrecht.github.io/Workspace/🇨🇦EN/Types/TestingConfiguration/Properties/prohibitCompilerWarnings.html)
  - [Documentation coverage](https://sdggiesbrecht.github.io/Workspace/🇨🇦EN/Types/APIDocumentationConfiguration/Properties/enforceCoverage.html)
  - [Example validation](https://sdggiesbrecht.github.io/Workspace/🇨🇦EN/Types/Examples.html)
  - [Style proofreading](https://sdggiesbrecht.github.io/Workspace/🇨🇦EN/Types/ProofreadingConfiguration.html) (including [SwiftLint](https://github.com/realm/SwiftLint))
  - [Reminders](https://sdggiesbrecht.github.io/Workspace/🇨🇦EN/Types/ProofreadingRule/Cases/manualWarnings.html)
  - [Continuous integration set‐up](https://sdggiesbrecht.github.io/Workspace/🇨🇦EN/Types/ContinuousIntegrationConfiguration/Properties/manage.html) ([Travis CI](https://travis-ci.org) with help from [Swift Version Manager](https://github.com/kylef/swiftenv))
- Generates API [documentation](https://sdggiesbrecht.github.io/Workspace/🇨🇦EN/Types/APIDocumentationConfiguration/Properties/generate.html).
- Automates code maintenance:
  - [Embedded resources](https://sdggiesbrecht.github.io/Workspace/🇨🇦EN/Types/PackageResources.html)
  - [Inherited documentation](https://sdggiesbrecht.github.io/Workspace/🇨🇦EN/Types/DocumentationInheritance.html)
  - [Xcode project generation](https://sdggiesbrecht.github.io/Workspace/🇨🇦EN/Types/XcodeConfiguration/Properties/manage.html)
- Automates open source details:
  - [File headers](https://sdggiesbrecht.github.io/Workspace/🇨🇦EN/Types/FileHeaderConfiguration.html)
  - [Read‐me files](https://sdggiesbrecht.github.io/Workspace/🇨🇦EN/Types/ReadMeConfiguration.html)
  - [Licence notices](https://sdggiesbrecht.github.io/Workspace/🇨🇦EN/Types/LicenceConfiguration.html)
  - [Contributing instructions](https://sdggiesbrecht.github.io/Workspace/🇨🇦EN/Types/GitHubConfiguration.html)
- Designed to interoperate with the [Swift Package Manager](https://swift.org/package-manager/).
- Manages projects for macOS, Linux, iOS, watchOS and tvOS.
- [Configurable](https://sdggiesbrecht.github.io/Workspace/🇨🇦EN/Libraries/WorkspaceConfiguration.html)

(For a list of related projects, see [here](Documentation/🇨🇦EN%20Related%20Projects.md).)

## Installation

Workspace provides command line tools.

Paste the following into a terminal to install or update them:

```shell
curl -sL https://gist.github.com/SDGGiesbrecht/4d76ad2f2b9c7bf9072ca1da9815d7e2/raw/update.sh | bash -s Workspace "https://github.com/SDGGiesbrecht/Workspace" 0.12.0 "workspace help" workspace arbeitsbereich
```

## Importing

Workspace provides a library for use with the [Swift Package Manager](https://swift.org/package-manager/).

Simply add Workspace as a dependency in `Package.swift`:

```swift
let package = Package(
    name: "MyPackage",
    dependencies: [
        .package(url: "https://github.com/SDGGiesbrecht/Workspace", .upToNextMinor(from: Version(0, 12, 0))),
    ],
    targets: [
        .target(name: "MyTarget", dependencies: [
            .productItem(name: "WorkspaceConfiguration", package: "Workspace"),
        ])
    ]
)
```

The library’s module can then be imported in source files:

```swift
import WorkspaceConfiguration
```

## The Workspace Workflow

(The following sample package is a real repository. You can use it to follow along.)

### When the Repository Is Cloned

The need to hunt down workflow tools can deter contributors. On the other hand, including them in the repository causes a lot of clutter. To reduce both, when a project using Workspace is pulled, pushed, or cloned...

```shell
git clone https://github.com/SDGGiesbrecht/SamplePackage
```

...only one small piece of Workspace comes with it: A short script called “Refresh” that comes in two variants, one for each operating system.

*Hmm... I wish I had more tools at my disposal... Hey! What if I...*

### Refresh the Project

To refresh the project, double‐click the `Refresh` script for the corresponding operating system. (If you are on Linux and double‐clicking fails or opens a text file, see [here](https://sdggiesbrecht.github.io/Workspace/🇨🇦EN/Types/Linux.html).)

`Refresh` opens a terminal window, and in it Workspace reports its actions while it sets the project folder up for development. (This may take a while the first time, but subsequent runs are faster.)

*This looks better. Let’s get coding!*

*[Add this... Remove that... Change something over here...]*

*...All done. I wonder if I broke anything while I was working? Hey! It looks like I can...*

### Validate Changes

When the project seems ready for a push, merge, or pull request, validate the current state of the project by double‐clicking the `Validate` script.

`Validate` opens a terminal window and in it Workspace runs the project through a series of checks.

When it finishes, it prints a summary of which tests passed and which tests failed.

*Oops! I never realized that would happen...*

### Summary

1. `Refresh` before working.
2. `Validate` when it looks complete.

*Wow! That was so much easier than doing it all manually!*

## Applying Workspace to a Project

To apply Workspace to a project, run the following command in the root of the project’s repository. (This requires a full install.)

```shell
$ workspace refresh
```

By default, Workspace refrains from tasks which would involve modifying project files. Such tasks must be activated with a [configuration](https://sdggiesbrecht.github.io/Workspace/🇨🇦EN/Libraries/WorkspaceConfiguration.html) file.

## About

The Workspace project is maintained by Jeremy David Giesbrecht.

If Workspace saves you money, consider giving some of it as a [donation](https://paypal.me/JeremyGiesbrecht).

If Workspace saves you time, consider devoting some of it to [contributing](https://github.com/SDGGiesbrecht/Workspace) back to the project.

> [Ἄξιος γὰρ ὁ ἐργάτης τοῦ μισθοῦ αὐτοῦ ἐστι.<br>For the worker is worthy of his wages.](https://www.biblegateway.com/passage/?search=Luke+10&version=SBLGNT;NIV)<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;―‎ישוע/Yeshuʼa
