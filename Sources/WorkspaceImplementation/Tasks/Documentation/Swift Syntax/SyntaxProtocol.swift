/*
 SyntaxProtocol.swift

 This source file is part of the Workspace open source project.
 Diese Quelldatei ist Teil des quelloffenen Arbeitsbereich‐Projekt.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2019–2021 Jeremy David Giesbrecht and the Workspace project contributors.
 Urheberrecht ©2019–2021 Jeremy David Giesbrecht und die Mitwirkenden des Arbeitsbereich‐Projekts.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import Foundation

#if !PLATFORM_NOT_SUPPORTED_BY_SWIFT_SYNTAX
  import SwiftSyntax
#endif
import SDGSwiftSource

#if !PLATFORM_NOT_SUPPORTED_BY_SWIFT_SYNTAX
  extension SyntaxProtocol {

    internal func asSyntax() -> Syntax {
      return Syntax(self)
    }

    internal func warnUnidentified(
      file: StaticString = #fileID,
      function: StaticString = #function
    ) {  // @exempt(from: tests)
      #if DEBUG
        print("Unidentified syntax node: \(Swift.type(of: self)) (\(file).\(function))")
      #endif
    }
  }
#endif
