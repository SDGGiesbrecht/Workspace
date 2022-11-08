/*
 SymbolGraph.LineList.swift

 This source file is part of the Workspace open source project.
 Diese Quelldatei ist Teil des quelloffenen Arbeitsbereich‐Projekt.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2022 Jeremy David Giesbrecht and the Workspace project contributors.
 Urheberrecht ©2022 Jeremy David Giesbrecht und die Mitwirkenden des Arbeitsbereich‐Projekts.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

#if !PLATFORM_NOT_SUPPORTED_BY_WORKSPACE_WORKSPACE

  import SymbolKit

  import SwiftSyntax
  import SDGSwiftSource

  extension SymbolGraph.LineList {

    internal func documentation() -> DocumentationSyntax {
      let source = lines.lazy.map({ $0.text }).joined(separator: "\n")
      let triviaPiece = TriviaPiece.docBlockComment("/**\n\(source)\n*/")
      let trivia = Trivia(pieces: [triviaPiece])
      let extended = trivia.first!.syntax(siblings: trivia, index: trivia.indices.first!)
      return (extended as! BlockDocumentationSyntax).documentation
    }

    internal func normalizedParameters() -> [ParameterDocumentation] {
      documentation().normalizedParameters
    }
  }
#endif
