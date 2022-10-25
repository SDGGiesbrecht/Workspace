import SymbolKit

extension SymbolGraph.Symbol.Names {

  var resolvedForNavigation: String {
    return navigator?.lazy.map({ $0.spelling }).joined()
      ?? title
  }
}
