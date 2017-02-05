<!--
 Xcode.md

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace

 Copyright ©2017 Jeremy David Giesbrecht and the Workspace contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 -->

# Xcode

Workspace can generate and maintain a local [Xcode](https://developer.apple.com/xcode/) project on macOS for ease of development.

This is controlled by the [configuration](Configuring Workspace.md) option `Manage Xcode`. The [default](Responsibilities.md#default-vs-automatic) value is `False`. The [automatic](Responsibilities.md#default-vs-automatic) value is `True`.

The Xcode project will not be checked into the repository. (The Swift Package Manager does not use it.) Manual changes to the Xcode project settings will not persist.
