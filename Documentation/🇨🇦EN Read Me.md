<!--
 🇨🇦EN Read Me.md

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2017 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 -->

[🇨🇦EN](🇨🇦EN%20Read%20Me.md) <!--Skip in Jazzy-->

macOS • Linux

# Workspace

Workspace automates management of Swift projects.

> [Πᾶν ὅ τι ἐὰν ποιῆτε, ἐκ ψυχῆς ἐργάζεσθε, ὡς τῷ Κυρίῳ καὶ οὐκ ἀνθρώποις.<br>Whatever you do, work from the heart, as working for the Lord and not for men.](https://www.biblegateway.com/passage/?search=Colossians+3&version=SBLGNT;NIV)<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;―‎שאול/Shaʼul

## Features

- Provides rigorous validation:
  - [Test coverage](Code%20Coverage.md)
  - [Compiler warnings](Compiler%20Warnings.md)
  - [Documentation coverage](Documentation%20Generation.md#enforcement)
  - [Example validation](Examples.md)
  - [Style proofreading](Proofreading.md) (including [SwiftLint](https://github.com/realm/SwiftLint))
  - [Reminders](Manual%20Warnings.md)
  - [Continuous integration set‐up](Continuous%20Integration.md) ([Travis CI](https://travis-ci.org) with help from [Swift Version Manager](https://github.com/kylef/swiftenv))
- Generates API [documentation](Documentation%20Generation.md) (except from Linux). (Using [Jazzy](https://github.com/realm/jazzy))
- Automates code maintenance:
  - [Embedded resources](Resources.md)
  - [Inherited documentation](Documentation%20Inheritance.md)
  - [Xcode project generation](Xcode.md)
- Automates open source details:
  - [File headers](File%20Headers.md)
  - [Read‐me files](Read‐Me.md)
  - [Licence notices](Licence.md)
  - [Contributing instructions](Contributing%20Instructions.md)
- Designed to interoperate with the [Swift Package Manager](https://swift.org/package-manager/).
- Manages projects for macOS, Linux, iOS, watchOS and tvOS.
- [Configurable](Configuring%20Workspace.md)
  -  Configurations can be [shared](Configuring%20Workspace.md#sharing-configurations-between-projects) between projects.

(For a list of related projects, see [here](🇨🇦EN%20Related%20Projects.md).) <!--Skip in Jazzy-->

## Installation

Paste the following into a terminal to install or update `Workspace`:

```shell
curl -sL https://gist.github.com/SDGGiesbrecht/4d76ad2f2b9c7bf9072ca1da9815d7e2/raw/update.sh | bash -s Workspace "https://github.com/SDGGiesbrecht/Workspace" 0.4.1 "arbeitsbereich help" arbeitsbereich workspace
```

## The Workspace Workflow

*The Workspace project is managed by... Workspace! So let’s try it out by following along using the Workspace project itself.*

### When the Repository Is Cloned

Workspace hides as much as it can from Git, so when a project using Workspace is pulled, pushed, or cloned...

```shell
git clone https://github.com/SDGGiesbrecht/Workspace
```

...only one small piece of Workspace comes with it: A short script called “Refresh” that comes in two variants, one for each operating system.

*Hmm... I wish I had more tools at my disposal... Hey! What if I...*

### Refresh the Workspace

To refresh the workspace, double‐click the `Refresh` script for the corresponding operating system. (If you are on Linux and double‐clicking fails or opens a text file, see [here](Linux%20Notes.md#doubleclicking-scripts).)

`Refresh` opens a terminal window, and in it Workspace reports its actions while it sets the project folder up for development.

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

## Set‐Up

The following commands require a full install. (See [Installation](#installation).)

### Existing Projects

To have Workspace take responsibility for an existing project, run this command in the root of its repository:

```shell
workspace refresh
```

When it is added to an existing project, Workspace will refrain from most responsibilities by default, behaving in a primarily opt‐in manner. This setting can be [changed](Responsibilities.md).

### New Projects

To have Workspace create a new Swift project from scratch, run one of the following commands in an empty folder:

To create a [library](Project%20Types.md) project:
```shell
workspace initialize
```

To create an [application](Project%20Types.md) project:
```shell
workspace initialize •type application
```

To create an [executable](Project%20Types.md) project:
```shell
workspace initialize •type executable
```

When it creates a new project, Workspace will handle many responsibilities by default, behaving in a primarily opt‐out manner. This setting can be [changed](Responsibilities.md).

## About

The Workspace project is maintained by Jeremy David Giesbrecht.

If Workspace saves you money, consider giving some of it as a [donation](https://paypal.me/JeremyGiesbrecht).

If Workspace saves you time, consider devoting some of it to [contributing](https://github.com/SDGGiesbrecht/Workspace) back to the project.

> [Ἄξιος γὰρ ὁ ἐργάτης τοῦ μισθοῦ αὐτοῦ ἐστι.<br>For the worker is worthy of his wages.](https://www.biblegateway.com/passage/?search=Luke+10&version=SBLGNT;NIV)<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;―‎ישוע/Yeshuʼa
