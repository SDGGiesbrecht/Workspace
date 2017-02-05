<!--
 Project Types.md

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace

 Copyright ©2017 Jeremy David Giesbrecht and the Workspace contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 -->

# Project Types

Some features or operating systems do not make sense for a particular project type. (Such as a command line tool for iOS.)

As a short cut, instead of manually disabling each individual feature, Workspace provides the [configuration](Configuring Workspace.md) option `Project Type`. If a project type is defined, individual features and operating systems not supported by that project type will be disabled implicitly.

Currently supported project types:

- `Library`:
    - Swift Module (when built by the Swift Package Manager)
    - Framework Bundle (when build by Xcode)
- `Executable`: Command Line Tool
