<!--
 Dependency Graph.md

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace

 Copyright ©2017 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 -->

# Dependency Graph

Workspace can keep the project’s dependency graph restrictions up to date.

This is controlled by the [configuration](Configuring Workspace.md) option `Manage Dependency Graph`. The [default](Responsibilities.md#default-vs-automatic) value is `False`. The [automatic](Responsibilities.md#default-vs-automatic) value is `True`.

## Updating Dependencies

Workspace updates any dependencies that can be updated and still satisfy the version range specified in `Package.swift`.

## Updating Restrictions

After updating dependencies, Workspace updates `Package.swift` so that the lower bound of each version range matches the resolved version. (This is to prevent inadvertent use of new features from a version 1.2 in a package that still declares compatibility with version 1.1.)

For Workspace to recognize and modify version restrictions, the dependency must be declared in the following form:

```swift
...
    dependencies: [
        ...
        .Package(url: "https://url.to/Package", versions: "3.1.4" ..< "4.0.0"),
        ...
    ]
...
```
