/*
 SDG.swift

 This source file is part of the SDG open source project.
 Diese Quelldatei ist Teil des qeulloffenen SDG‐Projekt.
 https://example.github.io/SDG/SDG

 Copyright ©2020 John Doe and the SDG project contributors.
 Urheberrecht ©2020 John Doe und die Mitwirkenden des SDG‐Projekts.
 ©2020

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

struct SDG {
  func text(_ bool: Bool) -> String {
    if bool {
      return "Hello, World!"
    } else {
      return "Hello, World!"
      // The next line is not relevant to test coverage, but Xcode flags it.
    }
  }

  func untestable() {
    preconditionFailure()
  }

  func exempt() {  // @exempt(from: tests)

  }

  func alsoExempt() {
    // customPreviousLineToken
  }

  func anotherExemption() {  // customSameLineToken

  }

  func defineExample() {  // @exempt(from: tests)
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
  func useExample() {}  // @exempt(from: tests)

  // @documentation(someDocumentation)
  /// This is documentation.
  ///
  /// It contains interesting information.
  var defineDocumentation: Bool?

  // #documentation(someDocumentation)
  /// This is documentation.
  ///
  /// It contains interesting information.
  var instertDocumentation: Bool?

  // #documentation(someDocumentation)
  /// This is documentation.
  ///
  /// It contains interesting information.
  var replaceDocumentation: Bool?
}
