/*
 Examples.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2018 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

/// Workspace can force example code to compile.
///
/// ```shell
/// $ workspace refresh examples
/// ```
///
/// When APIs change, it is easy to forget to update any examples in the documentation. Workspace allows examples to be synchronized with real, compiled source code in a test module. That way, when an API change makes an example invalid, it will be caught by the compiler.
///
/// ### Defining Examples
///
/// Examples can be defined anywhere in the project, but usually the best place for them is in a test module.
///
/// To define an example, place it between `@example(identifier)` and `@endExample`. Anything on the same line as either token will be ignored (such as `//`).
///
/// ```swift
/// func forTheSakeOfLeavingTheGlobalScope() {
///
///     let a = 0
///     let b = 0
///     let c = 0
///
///     // @example(symmetry)
///     if a == b {
///         assert(b == a)
///     }
///     // @endExample
///
///     // @example(transitivity)
///     if a == b ∧ b == c {
///         assert(a == c)
///     }
///     // @endExample
/// }
/// ```
///
/// ### Symbol Documentation
///
/// To use an example in a symbol’s documentation, add one or more instances of “#example(0, identifier)” to the line immediately preceding the documentation.
///
/// ```swift
/// // #example(1, symmetry) #example(2, transitivity)
/// /// Returns `true` if `lhs` is equal to `rhs`.
/// ///
/// /// Equality is symmetrical:
/// ///
/// /// ```swift
/// /// (Workspace will automatically fill these in whenever the project is refreshed.)
/// /// ```
/// ///
/// /// Equality is transitive:
/// ///
/// /// ```swift
/// ///
/// /// ```
/// func == (lhs: Thing, rhs: Thing) -> Bool {
///     return lhs.rawValue == rhs.rawValue
/// }
/// ```
///
/// ### Read‐Me
///
/// Examples can also be included in the read‐me. See `exampleUsage`.
public enum Examples {}
