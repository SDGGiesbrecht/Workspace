import Foundation

import SDGSwiftDocumentation
import SymbolKit

internal struct Extension: SymbolLike {

  // MARK: - Initialization

  internal init(
    names: SymbolGraph.Symbol.Names,
    identifier: SymbolGraph.Symbol.Identifier
  ) {
    self.names = names
    self.identifier = identifier
  }

  // MARK: - Properties

  internal var identifier: SymbolGraph.Symbol.Identifier

  // MARK: - SymbolLike

  internal var names: SymbolGraph.Symbol.Names

  internal var declaration: SymbolGraph.Symbol.DeclarationFragments? {
    return nil
  }

  internal var docComment: SymbolGraph.LineList? {
    return nil
  }

  internal var location: SymbolGraph.Symbol.Location? {
    return nil
  }

  internal func parseDocumentation(
    cache: inout [URL: SymbolGraph.Symbol.CachedSource],
    module: String?
  ) -> [SymbolDocumentation] {
    return []
  }
}
