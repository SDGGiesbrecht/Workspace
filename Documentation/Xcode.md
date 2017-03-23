<!--
 Xcode.md

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2017 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 -->

# Xcode

Workspace can generate and maintain a local [Xcode](https://developer.apple.com/xcode/) project on macOS for ease of development.

This is controlled by the [configuration](Configuring%20Workspace.md) option `Manage Xcode`. The [default](Responsibilities.md#default-vs-automatic) value is `False`. The [automatic](Responsibilities.md#default-vs-automatic) value is `True`.

The Xcode project will not be checked into the repository. (The Swift Package Manager does not use it.) Manual changes to the Xcode project settings will not persist.

## Manual Xcode Management

When Workspace is not in charge of Xcode, it may not know where to find some of the things it needs. If errors occur because Workspace is looking in the wrong place, try specifying the following [configuration](Configuring%20Workspace.md) options to point it in the right direction.

- `Project Name`: The project’s name for human‐readable output.
- `Package Name`: The name of the entire package. (Normally declared in `Package.swift`.)
- `Module Name`: The name of the main module as used by `import` statements. Workspace uses this for documentation generation and for finding an application’s delegate.
- `Xcode Scheme Name`: The name of the Xcode scheme as used by the `xcodebuild` `-scheme` flag. Workspace uses this for running unit tests.
- `Xcode Test Target`: The name of the Xcode test target as used by the `xcodebuild` `-target` flag. Workspace uses this for setting the host application.
- `Primary Xcode Target`: The name of the main Xcode target as used by the `xcodebuild` `-target` flag. Workspace uses this for code coverage, for documentation generation and for inserting the proofread phase.
