/*
 SDG.swift

 This source file is part of the SDG open source project.
 Diese Quelldatei ist Teil des quelloffenen SDG‐Projekt.
 https://example.github.io/SDG/SDG

 Copyright ©[Current Date] John Doe and the SDG project contributors.
 Urheberrecht ©[Current Date] John Doe und die Mitwirkenden des SDG‐Projekts.
 ©[Current Date]

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

internal struct SDG {
  internal func text(_ bool: Bool) -> String {
    if bool {
      return "Hello, World!"
    } else {
      return "Hello, World!"
      // The next line is not relevant to test coverage, but Xcode flags it.
    }
  }

  internal func untestable() {
    preconditionFailure()
  }

  internal func exempt() {  // @exempt(from: tests)

  }

  internal func alsoExempt() {
    // customPreviousLineToken
  }

  internal func anotherExemption() {  // customSameLineToken

  }

  internal func defineExample() {  // @exempt(from: tests)
    // @example(anExample)
    // This is source code.

    // And more after an empty line.
    // @endExample

    // @example(anotherExample )
    // ...
    // @endExample
  }

  // #example(1, anExample) #example(2, anotherExample)
  /// Uses an example.
  ///
  /// ```swift
  /// // This is source code.
  ///
  /// // And more after an empty line.
  /// ```
  ///
  /// ```swift
  /// // ...
  /// ```
  internal func useExample() {}  // @exempt(from: tests)

  // @documentation(someDocumentation)
  /// This is documentation.
  ///
  /// It contains interesting information.
  internal var defineDocumentation: Bool?

  // #documentation(someDocumentation)
  /// This is documentation.
  ///
  /// It contains interesting information.
  internal var instertDocumentation: Bool?

  // #documentation(someDocumentation)
  /// This is documentation.
  ///
  /// It contains interesting information.
  internal var replaceDocumentation: Bool?
}
