
import SymbolKit
import SDGSwiftDocumentation

extension ModuleAPI {

  internal func extensions() -> [Extension] {
    var unprocessedExtensionIdentifiers: [String: String] = [:]
    for graph in self.symbolGraphs {
      for relationship in graph.relationships
      where relationship.kind == .memberOf {
        unprocessedExtensionIdentifiers[relationship.target] = relationship.targetFallback
      }
    }
    var extensionIdendifiers: Set<String> = Set(unprocessedExtensionIdentifiers.keys)
    var symbolLookup: [String: SymbolGraph.Symbol] = [:]
    for graph in self.symbolGraphs {
      symbolLookup.mergeByOverwriting(from: graph.symbols)
      for symbol in graph.symbols.values {
        extensionIdendifiers.remove(symbol.identifier.precise)
      }
    }
    return extensionIdendifiers.compactMap { identifier in
      if let symbol = symbolLookup[identifier] {
        return Extension(names: symbol.names, identifier: symbol.identifier)
      } else if let fallback = unprocessedExtensionIdentifiers[identifier] {
        return Extension(
          names: SymbolGraph.Symbol.Names(
            title: fallback,
            navigator: nil,
            subHeading: nil,
            prose: nil
          ),
          identifier: SymbolGraph.Symbol.Identifier(
            precise: "SDG.extension.\(fallback)",
            interfaceLanguage: "swift"
          )
        )
      } else {
        return nil
      }
    }
  }
}
