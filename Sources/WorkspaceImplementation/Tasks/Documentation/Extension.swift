import Foundation

import SDGSwiftDocumentation
import SymbolKit

struct Extension: SymbolLike {

  // MARK: - Initialization

  init(
    names: SymbolGraph.Symbol.Names,
    identifier: SymbolGraph.Symbol.Identifier
  ) {
    self.names = names
    self.identifier = identifier
  }

  // MARK: - Properties

  var identifier: SymbolGraph.Symbol.Identifier

  // MARK: - SymbolLike

  var names: SymbolGraph.Symbol.Names

  var declaration: SymbolGraph.Symbol.DeclarationFragments? {
    return nil
  }

  var docComment: SymbolGraph.LineList? {
    return nil
  }

  var location: SymbolGraph.Symbol.Location? {
    return nil
  }

  func parseDocumentation(
    cache: inout [URL: SymbolGraph.Symbol.CachedSource],
    module: String?
  ) -> [SymbolDocumentation] {
    return []
  }
}
