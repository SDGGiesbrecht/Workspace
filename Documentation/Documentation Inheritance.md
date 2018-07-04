<!--
 Documentation Inheritance.md

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2017–2018 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 -->

# Documentation Inheritance

Workspace can make symbols inherit their documentation.

It can be tedious re‐writing the same documentation over again when conforming to a protocol or creating a subclass. Workspace can make documentation comments re‐usable—even by dependent packages.

Note: Xcode has begun doing this automatically for protocol conformances, default implementations and subclass overrides wherever the symbol is left undocumented. However, Jazzy—which is used by Workspace for documentation generation and coverage validation—does not understand the inheritance tree. Projects using documentation features will need to continue using this method of inheritance for now.

## Defining Documentation

To designate a documentation comment as a definition, place `@documentation(identifier)` on the line above. Anything on the same line will be ignored (such as `//`).

```swift
protocol Rambler {

    // @documentation(MyLibrary.Rambler.ramble)
    /// Rambles on and on and on and on...
    func ramble() -> Never
}
```

Workspace will only check Swift files for definitions.

## Inheriting Documentation

To inherit for documentation defined elsewhere, place `#documentation(identifier)` where the documentation would go (or above it if it already exists). Anything on the same line will be ignored (such as `//`).

```swift
struct Teacher : Rambler {

    // #documentation(MyLibrary.Rambler.ramble)
    /// (Workspace will automatically fill this in whenever the project is refreshed.)
    func ramble() -> Never {

        print("Blah")
        while true {
            print(", blah")
        }
    }
}
```

Workspace can find definitions in any Swift file in the project and even in package dependencies.
