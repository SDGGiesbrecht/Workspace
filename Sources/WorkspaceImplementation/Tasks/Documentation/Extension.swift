import Foundation

import SDGSwiftDocumentation
import SymbolKit

struct Extension: SymbolLike {

  init(names: SymbolGraph.Symbol.Names) {
    self.names = names
  }

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
