<!--
 README.md
 
 This source file is part of the Workspace open source project.
 
 Copyright ©2017 Jeremy David Giesbrecht and the Workspace contributors.
 
 Soli Deo gloria
 
 Licensed under the Apache License, Version 2.0
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 -->

# Workspace

Workspace automates management of Swift projects.

Table of Contents:
- [Platforms](#platforms)
- [What Workspace Can Do](#what-workspace-can-do)
- [Set‐Up](#setup)
- [The Workspace Workflow](#the-workspace-workflow)

## Platforms

Workspace can be used for development on macOS and Linux.

## What Workspace Can Do

- Set [new projects](#new-projects) up from scratch.
- Be [configured](Documentation/Configuring Workspace.md) to opt in or out of any of these features.
- Generate and maintain a local [Xcode project](Documentation/Xcode.md). (macOS‐only)
- Automatically configure projects for [continuous integration](Documentation/Continuous Integration.md) on each operating system. ([Travis CI](https://travis-ci.org) with help from [Swift Version Manager](https://github.com/kylef/swiftenv))

## Set‐Up

### New Projects

To have Workspace create a new Swift project from scratch, run one of the following scripts in an empty folder:

To create a library project:
```shell
git clone https://github.com/SDGGiesbrecht/Workspace .Workspace
cd .Workspace
swift build --configuration release
cd ..
.Workspace/.build/release/workspace initialize
```

To create an executable project:
```shell
git clone https://github.com/SDGGiesbrecht/Workspace .Workspace
cd .Workspace
swift build --configuration release
cd ..
.Workspace/.build/release/workspace initialize •executable
```

By default, Workspace will handle many responsibilities when it creates a new project, behaving in a primarily opt‐out manner, but this setting can be [changed](Documentation/Responsibilities.md).

### Existing Projects

To have Workspace take responsibility for an existing project, run this script the root of its repository:

```shell
git clone https://github.com/SDGGiesbrecht/Workspace .Workspace
cd .Workspace
swift build --configuration release
cd ..
.Workspace/.build/release/workspace refresh
```

By default, Workspace will refrain from most responsibilities when it is added to an existing project, behaving in a primarily opt‐in manner, but this setting can be [changed](Documentation/Responsibilities.md).

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
