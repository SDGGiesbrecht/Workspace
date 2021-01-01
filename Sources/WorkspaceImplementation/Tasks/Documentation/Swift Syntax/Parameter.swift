/*
 Parameter.swift

 This source file is part of the Workspace open source project.
 Diese Quelldatei ist Teil des quelloffenen Arbeitsbereich‐Projekt.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2019–2021 Jeremy David Giesbrecht and the Workspace project contributors.
 Urheberrecht ©2019–2021 Jeremy David Giesbrecht und die Mitwirkenden des Arbeitsbereich‐Projekts.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGLogic

// #workaround(SwiftSyntax 0.50300.0, Cannot build.)
#if !(os(Windows) || os(WASI) || os(Android))
  import SwiftSyntax
#endif
import SDGSwiftSource

internal protocol Parameter {
  // #workaround(SwiftSyntax 0.50300.0, Cannot build.)
  #if !(os(Windows) || os(WASI) || os(Android))
    var firstName: TokenSyntax? { get }
    var secondName: TokenSyntax? { get }
    var optionalType: TypeSyntax? { get }
  #endif
}

extension Parameter {

  internal func parameterNames() -> [String] {
    // #workaround(SwiftSyntax 0.50300.0, Cannot build.)
    #if os(Windows) || os(WASI) || os(Android)
      return []
    #else
      var result: [String] = []
      if let second = secondName?.text,
        ¬second.isEmpty
      {
        result.append(second)
      } else if let first = firstName?.text,
        ¬first.isEmpty
      {
        result.append(first)
      }

      if let type = optionalType {
        result.append(contentsOf: type.parameterNames())
      }
      return result
    #endif
  }
}
