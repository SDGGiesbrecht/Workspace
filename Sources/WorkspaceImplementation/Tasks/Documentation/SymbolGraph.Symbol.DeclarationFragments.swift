/*
 SymbolGraph.Symbol.DeclarationFragments.swift

 This source file is part of the Workspace open source project.
 Diese Quelldatei ist Teil des quelloffenen Arbeitsbereich‐Projekt.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2022–2023 Jeremy David Giesbrecht and the Workspace project contributors.
 Urheberrecht ©2022–2023 Jeremy David Giesbrecht und die Mitwirkenden des Arbeitsbereich‐Projekts.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

#if !PLATFORM_NOT_SUPPORTED_BY_WORKSPACE_WORKSPACE
  import SymbolKit

  import SwiftSyntax
  import SwiftSyntaxParser

  extension SymbolGraph.Symbol.DeclarationFragments {

    // #workaround(Should be handled in SDGSwift the DocC way.)
    internal func syntaxHighlightedHTML(
      inline: Bool,
      internalIdentifiers: Set<String> = [],
      symbolLinks: [String: String] = [:]
    ) -> String {
      let tokens = declarationFragments.map({ $0.spelling })
      let parsed =
        (try? SyntaxParser.parse(source: tokens.joined())).map({ Syntax($0) })
        ?? Syntax(  // @exempt(from: tests)
          SyntaxFactory.makeUnknownSyntax(
            tokens: tokens.map({ SyntaxFactory.makeToken(.unknown($0)) })
          )
        )
      return parsed.syntaxHighlightedHTML(
        inline: inline,
        internalIdentifiers: internalIdentifiers,
        symbolLinks: symbolLinks
      )
    }
  }
#endif
