<!--
 README.md

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace

 Copyright ©2017 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 -->

# Workspace

Workspace automates management of Swift projects.

> [Πᾶν ὅ τι ἐὰν ποιῆτε, ἐκ ψυχῆς ἐργάζεσθε, ὡς τῷ Κυρίῳ καὶ οὐκ ἀνθρώποις.<br>Whatever you do, work from the heart, as working for the Lord and not for men.](https://www.biblegateway.com/passage/?search=Colossians+3&version=SBLGNT;NIV)<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;―‎שאול/Shaʼul of Tarsus

### Table of Contents
- [Platforms](#platforms)
- [What Workspace Can Do](#what-workspace-can-do)
- [The Workspace Workflow](#the-workspace-workflow)
- [Set‐Up](#setup)
  - [New Projects](#new-projects)
  - [Existing Projects](#existing-projects)

## Platforms

Workspace can be used for development on [macOS](http://www.apple.com/macos/) and [Linux](https://www.ubuntu.com).

Workspace can manage:

- [Library](Documentation/Project Types.md) projects for [macOS](http://www.apple.com/macos/), [Linux](https://www.ubuntu.com), [iOS](http://www.apple.com/ios/), [watchOS](http://www.apple.com/watchos/) and [tvOS](http://www.apple.com/tvos/).
- [Application](Documentation/Project Types.md) projects for [macOS](http://www.apple.com/macos/), [iOS](http://www.apple.com/ios/) and [tvOS](http://www.apple.com/tvos/).
- [Executable](Documentation/Project Types.md) projects for [macOS](http://www.apple.com/macos/) and [Linux](https://www.ubuntu.com).

A particular project can [configure](Documentation/Operating Systems.md) which operating systems it supports.

## What Workspace Can Do

- Set [new projects](#new-projects) up from scratch.
- Be [configured](Documentation/Configuring Workspace.md) to opt in or out of any of the following features.
- Have its configuration [shared](Documentation/Configuring Workspace.md#sharing-configurations-between-projects) between projects.
- Automatically...
    - Keep [licence notices](Documentation/Licence.md) uniform.
    - Keep [contributing instructions](Documentation/Contributing Instructions.md) uniform, including issue and pull request templates.
    - Generate and maintain a local [Xcode project](Documentation/Xcode.md) (except on Linux).
    - Keep [dependencies and their version restrictions](Documentation/Dependency Graph.md) up to date.
    - Keep [file headers](Documentation/File Headers.md) uniform and up to date.
    - [Proofread](Documentation/Proofreading.md) source files for code style. (Including [SwiftLint](https://github.com/realm/SwiftLint))
    - Trigger [manual warnings](Documentation/Manual Warnings.md) in source code.
    - Run unit tests on each operating system (except watchOS).
    - Generate API [documentation](Documentation/Documentation Generation.md) (except from Linux). (Using [Jazzy](https://github.com/realm/jazzy))
    - Configure [continuous integration](Documentation/Continuous Integration.md) for each operating system. ([Travis CI](https://travis-ci.org) with help from [Swift Version Manager](https://github.com/kylef/swiftenv))

## The Workspace Workflow

*The Workspace project is managed by... Workspace! So let’s try it out by following along using the Workspace project itself.*

### When the Repository Is Cloned

Workspace hides as much as it can from Git, so when a project using Workspace is pulled, pushed, or cloned...

```
git clone https://github.com/SDGGiesbrecht/Workspace
```

...only one small piece of Workspace comes with it: A short script called “Refresh Workspace” that comes in two variants, one for each operating system.

*Hmm... I wish I had more tools at my disposal... Hey! What if I...*

### Refresh the Workspace

To refresh the workspace, double‐click the `Refresh Workspace` script for the corresponding operating system. (If you are on Linux and double‐clicking fails or opens a text file, see [here](Documentation/Linux Notes.md#doubleclicking-scripts).)

`Refresh Workspace` opens a terminal window, and in it Workspace reports its actions while it sets the project folder up for development.

*This looks better. Let’s get coding!*

*[Add this... Remove that... Change something over here...]*

*...All done. I wonder if I broke anything while I was working? Hey! It looks like I can...*

### Validate Changes

When the project seems ready for a push, merge, or pull request, validate the current state of the project by double‐clicking the `Validate Changes` script.

`Validate Changes` opens a terminal window and in it Workspace runs the project through a series of checks.

When it finishes, it prints a summary of which tests passed and which tests failed.

*Oops! I never realized that would happen...*

### Summary

1. `Refresh Workspace` before working.
2. `Validate Changes` when it looks complete.

*Wow! That was so much easier than doing it all manually!*

## Set‐Up

For the following set‐up commands to work, the device needs to have run `Refresh Workspace` at least once already.

This script can be used to trigger `Refresh Workspace`:
```shell
git clone https://github.com/SDGGiesbrecht/Workspace
Workspace/Refresh\ \Workspace\ \(macOS\).command
rm -rf Workspace
```

### New Projects

To have Workspace create a new Swift project from scratch, run one of the following commands in an empty folder:

To create a [library](Documentation/Project Types.md) project:
```shell
~/.Workspace/Workspace/.build/release/workspace initialize
```

To create an [application](Documentation/Project Types.md) project:
```shell
~/.Workspace/Workspace/.build/release/workspace initialize •type application
```

To create an [executable](Documentation/Project Types.md) project:
```shell
~/.Workspace/Workspace/.build/release/workspace initialize •type executable
```

When it creates a new project, Workspace will handle many responsibilities by default, behaving in a primarily opt‐out manner. This setting can be [changed](Documentation/Responsibilities.md).

### Existing Projects

To have Workspace take responsibility for an existing project, run this command in the root of its repository:

```shell
~/.Workspace/Workspace/.build/release/workspace refresh
```

When it is added to an existing project, Workspace will refrain from most responsibilities by default, behaving in a primarily opt‐in manner. This setting can be [changed](Documentation/Responsibilities.md).
