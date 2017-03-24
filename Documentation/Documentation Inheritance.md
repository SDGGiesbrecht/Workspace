<!--
 Documentation Inheritance.md

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2017 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 -->

# Documentation Inheritance

Workspace can make symbols inherit their documentation.

It can be tedious re‐writing the same documentation over again when conforming to a protocol or creating a subclass. Workspace can make documentation comments re‐usable—even by dependent packages.

## Defining Documentation

To designate a documentation comment as a definition, place `[_Define Documentation: Identifier_]` on the line above. Anything on the same line will be ignored (such as `//`).

```swift
protocol Rambler {

    // [_Define Documentation: MyLibrary.Rambler.ramble()_]
    /// Rambles on and on and on and on...
    func ramble() -> Never
}
```

## Inheriting Documentation

To inherit for documentation defined elsewhere, place `[_Inherit Documentation: Identifier_]` where the documentation would go (or above it if it already exists). Anything on the same line will be ignored (such as `//`).

```swift
struct Teacher : Rambler {

    // [_Inherit Documentation: MyLibrary.Rambler.ramble()_]
    /// (Workspace will automatically fill this in whenever the project is refreshed.)
    func ramble() -> Never {

        print("Blah")
        while true {
            print(", blah")
        }
    }
}
```

Workspace can find definitions anywhere in the project or even in dependencies as long as their source is present in the `Packages` folder.
