import SDGText

import SDGSwiftDocumentation
import SymbolKit

import WorkspaceConfiguration

extension SymbolLike {

  internal var extendedPropertiesIndex: String {
    switch self {
    case let symbol as SymbolGraph.Symbol:
      return symbol.identifier.precise
    case let package as PackageAPI:
      return "SDG.Package.\(package.names.title)"
    case let library as LibraryAPI:
      return "SDG.library.\(library.names.title)"
    case let module as ModuleAPI:
      return "SDG.target.\(module.names.title)"
    case let `operator` as Operator:
      return "SDG.operator.\(`operator`.names.title)"
    case let precedenceGroup as PrecedenceGroup:
      return "SDG.precedencegroup.\(precedenceGroup.names.title)"
    default:
      unreachable()
    }
  }
}
