<!--
 Xcode.md
 
 This source file is part of the Workspace open source project.
 
 Copyright ©2017 Jeremy David Giesbrecht and the Workspace contributors.
 
 Soli Deo gloria
 
 Licensed under the Apache License, Version 2.0
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 -->

# Xcode

Workspace can generate and maintain local [Xcode](https://developer.apple.com/xcode/) projects on macOS for ease of development.

This is controlled by the [configuration](Configuring Workspace.md) option `Manage Xcode`. The [default](Responsibilities.md#default-vs-automatic) value is `False`. The [automatic](Responsibilities.md#default-vs-automatic) value is `True`.

The Xcode projects will not be checked into the repository. (The Swift Package Manager does not use them.) Manual changes to the Xcode projects’ settings will not persist.
