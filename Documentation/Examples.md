<!--
 Examples.md

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2017 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 -->

# Examples

Workspace can force example code to compile.

When APIs change, it is easy to forget to update any examples in the documentation. Workspace allows examples to be synchronized with real, compiled source code in a test module. That way, when an API change makes an example invalid, it will be caught by the compiler.

## Defining Examples

Examples can be defined anywhere in the project, but usually the best place for them is in a test module.

To define an example, place it between `[_Define Example: Identifier_]` and `[_End_]`. Anything on the same line as either token will be ignored (such as `//`).

```swift
func forTheSakeOfLeavingTheGlobalScope() {

    let a = 0
    let b = 0
    let c = 0

    // [_Define Example: Symmetry_]
    if a == b {
        assert(b == a)
    }
    // [_End_]

    // [_Define Example: Transitivity_]
    if a == b ∧ b == c {
        assert(a == c)
    }
    // [_End_]
}
```

## Symbol Documentation

To use an example in a symbol’s documentation, add one or more instances of `[_Example 0: Indentifier_]` to the line immediately preceding the documentation.

```swift
// [_Example 1: Symmetry_] [_Example 2: Transitivity_]
/// Returns `true` if `lhs` is equal to `rhs`.
///
/// Equality is symmetrical:
///
/// ```swift
/// (Workspace will automatically fill these in whenever the project is refreshed.)
/// ```
///
/// Equality is transitive:
///
/// ```swift
/// ```
func == (lhs: Thing, rhs: Thing) -> Bool {
    return lhs.rawValue == rhs.rawValue
}
```

## Read‐Me

If [read‐me management](Read‐Me.md) is enabled, Workspace will look for an example identifiers beginning with `Read‐Me ` and ending with a localization key, and will include them in the read‐me. Arbitrary examples can also be included in read‐me templates as [dynamic elements](Read‐Me.md#customization).

```swift
// [&#x5F;Define Example: Read‐Me 🇨🇦EN_]
import MyInterpreterLibrary

func practiceWithInterpreter() {

    let interpreter = Interpreter(language: .german)

    let greeting = "Hello, World!"
    print(greeting)

    interpreter.interpret(greeting)
    // Prints, „Guten Tag, Welt!“
}
// [_End_]
```
