
import SDGSwiftDocumentation
import SymbolKit

import WorkspaceConfiguration

extension SymbolGraph.Symbol {

  internal struct ExtendedProperties {
    internal static let `default` = ExtendedProperties()
    
    internal var skippedLocalizations: Set<LocalizationIdentifier> = []
    internal var relativePagePath: [LocalizationIdentifier: StrictString] = [:]
    internal var homeProduct: LibraryAPI?
    internal var homeModule: ModuleAPI?

    internal var packageTypes: [SymbolGraph.Symbol] = []
    internal var packageExtensions: [Extension] = []
    internal var packageProtocols: [SymbolGraph.Symbol] = []
    internal var packageFunctions: [SymbolGraph.Symbol] = []
    internal var packageGlobalVariables: [SymbolGraph.Symbol] = []
    internal var packageOperators: [Operator] = []
    internal var packagePrecedenceGroups: [PrecedenceGroup] = []
  }
}
