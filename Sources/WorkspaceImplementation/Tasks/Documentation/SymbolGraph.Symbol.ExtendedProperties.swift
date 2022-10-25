
import SDGSwiftDocumentation
import SymbolKit

import WorkspaceConfiguration

extension SymbolGraph.Symbol {

  internal struct ExtendedProperties {
    internal static let `default` = ExtendedProperties()
    
    internal var skippedLocalizations: Set<LocalizationIdentifier> = []
    internal var relativePagePath: [LocalizationIdentifier: StrictString] = [:]
    internal var homeProduct: LibraryAPI?
  }
}
