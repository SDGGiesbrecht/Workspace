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
