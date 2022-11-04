
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
    let parsed = (try? SyntaxParser.parse(source: tokens.joined())).map({ Syntax($0) })
    ?? Syntax(SyntaxFactory.makeUnknownSyntax(
      tokens: tokens.map({ SyntaxFactory.makeToken(.unknown($0)) })
        ))
    return parsed.syntaxHighlightedHTML(inline: inline, internalIdentifiers: internalIdentifiers, symbolLinks: symbolLinks)
  }
}
