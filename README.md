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

Contents:
- [What Workspace Can Do](#what-workspace-can-do)
- [Set‐Up](#set-up)
- [The Workspace Workflow](#the-workspace-workflow)

## What Workspace Can Do

- Set [new projects](#new-projects) up from scratch.

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

By default, Workspace will refrain from most responsibilities when it is added to an existing project, behaving in a primarily opt‐in manner, but this setting can be [changed](Documentation/Responsibilies.md).

## The Workspace Workflow

The Workspace project is managed by... Workspace! It is possible to try it out and follow along using the Workspace project itself.

### When the Repository Is Cloned

Workspace hides as much as it can from Git, so when a project using Workspace is pulled, pushed, or cloned...

```
git clone https://github.com/SDGGiesbrecht/Workspace
```

...only one small piece of Workspace comes with it: A short script called “Refresh Workspace” that comes in two variants, one for each operating system.

The development environment seems kind of sparse and unwieldly in this state though, so...

### Refreshing the Workspace

To refresh the workspace, double‐click the “Refresh Workspace” script for the right operating system.

(If you are on Linux and double‐clicking fails or opens a text file, see [here](Documentation/Linux Notes#double-clicking-scripts).)

A terminal window opens and Workspace reports its actions as it sets the project folder up for development.

Now its time to write some code...

### Validating Changes

Once you are finished making changes and you think they are ready to push, merge, or submit a pull request...

Validate the current state of the project by double‐clicking the “Validate Changes” script.

A terminal window opens and Workspace runs the project through a series of checks.

When it finishes, you will see a summary of which tests passed and which tests failed.

### Summary

1. “Refresh Workspace” before you work.
2. “Validate Changes” when you think you are done.

That’s all there is to it!

Of course, if you are setting Workspace up to manage your own project, you will also want to learn how to [configure](Documents/Configuring Workspace.md) which [tasks](#what-workspace-can-do) Workspace should handle.
