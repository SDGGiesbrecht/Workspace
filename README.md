<!--
 README.md

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2017 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 -->

[🇨🇦EN](Documentation/🇨🇦EN%20Read%20Me.md) <!--Skip in Jazzy-->

macOS • Linux

# Workspace

Workspace automates management of Swift projects.

> [Πᾶν ὅ τι ἐὰν ποιῆτε, ἐκ ψυχῆς ἐργάζεσθε, ὡς τῷ Κυρίῳ καὶ οὐκ ἀνθρώποις.<br>Whatever you do, work from the heart, as working for the Lord and not for men.](https://www.biblegateway.com/passage/?search=Colossians+3&version=SBLGNT;NIV)<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;―‎שאול/Shaʼul

(For a list of related projecs, see [here](Documentation/Related%20Projects.md).) <!--Skip in Jazzy-->

### Table of Contents
- [Platforms](#platforms)
- [What Workspace Can Do](#what-workspace-can-do)
- [Installation](#installation)
- [The Workspace Workflow](#the-workspace-workflow)
- [Set‐Up](#setup)
  - [New Projects](#new-projects)
  - [Existing Projects](#existing-projects)

## Platforms

Workspace can be used for development on [macOS](http://www.apple.com/macos/) and [Linux](https://www.ubuntu.com).

Workspace can manage:

- [Library](Documentation/Project%20Types.md) projects for [macOS](http://www.apple.com/macos/), [Linux](https://www.ubuntu.com), [iOS](http://www.apple.com/ios/), [watchOS](http://www.apple.com/watchos/) and [tvOS](http://www.apple.com/tvos/).
- [Application](Documentation/Project%20Types.md) projects for [macOS](http://www.apple.com/macos/), [iOS](http://www.apple.com/ios/) and [tvOS](http://www.apple.com/tvos/).
- [Executable](Documentation/Project%20Types.md) projects for [macOS](http://www.apple.com/macos/) and [Linux](https://www.ubuntu.com).

A particular project can [configure](Documentation/Operating%20Systems.md) which operating systems it supports.

## What Workspace Can Do

- Set [new projects](#new-projects) up from scratch.
- Be [configured](Documentation/Configuring%20Workspace.md) to opt in or out of any of the following features.
- Have its configuration [shared](Documentation/Configuring%20Workspace.md#sharing-configurations-between-projects) between projects.
- Automatically...
  - Keep [read‐me](Documentation/Read‐Me.md) files uniform.
  - Keep [licence notices](Documentation/Licence.md) uniform.
  - Keep [contributing instructions](Documentation/Contributing%20Instructions.md) uniform, including issue and pull request templates.
  - Generate and maintain a local [Xcode project](Documentation/Xcode.md) (except on Linux).
  - Keep [file headers](Documentation/File%20Headers.md) uniform and up to date.
  - Embed [resources](Documentation/Resources.md) in package targets.
  - [Proofread](Documentation/Proofreading.md) source files for code style. (Including [SwiftLint](https://github.com/realm/SwiftLint))
  - Trigger [manual warnings](Documentation/Manual%20Warnings.md) in source code.
  - Prohibit [compiler warnings](Documentation/Compiler%20Warnings.md).
  - Run unit tests on each operating system (except watchOS).
  - Enforce [code coverage](Documentation/Code%20Coverage.md).
  - Enforce validity of [example](Documentation/Examples.md) code.
  - Make symbols [inherit documentation](Documentation/Documentation%20Inheritance.md).
  - Generate API [documentation](Documentation/Documentation%20Generation.md) (except from Linux). (Using [Jazzy](https://github.com/realm/jazzy))
  - Enforce [documentation coverage](Documentation/Documentation%20Generation.md#enforcement).
  - Configure [continuous integration](Documentation/Continuous%20Integration.md) for each operating system. ([Travis CI](https://travis-ci.org) with help from [Swift Version Manager](https://github.com/kylef/swiftenv))

## Installation

Run the following in a terminal to perform a full installation or update (on either macOS or Linux):

```shell
curl -sL https://gist.github.com/SDGGiesbrecht/4d76ad2f2b9c7bf9072ca1da9815d7e2/raw/update.sh | bash -s Workspace https://github.com/SDGGiesbrecht/Workspace 0.3.0 "workspace help" workspace arbeitsbereich
```

This will install and register the `workspace` command for `bash`, `zsh` and `fish`.

A full installation is only necessary in order to use the command line interface. Contributors to a Workspace‐managed project can use the provided scripts without a permanent install. (See [The Workspace Workflow](#the-workspace-workflow).)

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

To refresh the workspace, double‐click the `Refresh` script for the corresponding operating system. (If you are on Linux and double‐clicking fails or opens a text file, see [here](Documentation/Linux%20Notes.md#doubleclicking-scripts).)

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

### New Projects

To have Workspace create a new Swift project from scratch, run one of the following commands in an empty folder:

To create a [library](Documentation/Project%20Types.md) project:
```shell
workspace initialize
```

To create an [application](Documentation/Project%20Types.md) project:
```shell
workspace initialize •type application
```

To create an [executable](Documentation/Project%20Types.md) project:
```shell
workspace initialize •type executable
```

When it creates a new project, Workspace will handle many responsibilities by default, behaving in a primarily opt‐out manner. This setting can be [changed](Documentation/Responsibilities.md).

### Existing Projects

To have Workspace take responsibility for an existing project, run this command in the root of its repository:

```shell
workspace refresh
```

When it is added to an existing project, Workspace will refrain from most responsibilities by default, behaving in a primarily opt‐in manner. This setting can be [changed](Documentation/Responsibilities.md).

## About

The Workspace project is maintained by Jeremy David Giesbrecht.

If Workspace saves you money, consider giving some of it as a [donation](https://paypal.me/JeremyGiesbrecht).

If Workspace saves you time, consider devoting some of it to [contributing](https://github.com/SDGGiesbrecht/Workspace) back to the project.

> [Ἄξιος γὰρ ὁ ἐργάτης τοῦ μισθοῦ αὐτοῦ ἐστι.<br>For the worker is worthy of his wages.](https://www.biblegateway.com/passage/?search=Luke+10&version=SBLGNT;NIV)<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;―‎ישוע/Yeshuʼa
