
import SDGSwiftDocumentation
import SymbolKit

import WorkspaceConfiguration

extension SymbolGraph.Symbol {

  internal struct ExtendedProperties {

    // MARK: - Static Properties

    internal static let `default` = ExtendedProperties()

    // MARK: - General Properties

    internal var localizedDocumentation: [LocalizationIdentifier: SymbolGraph.LineList] = [:]
    internal var crossReference: StrictString? = nil
    internal var skippedLocalizations: Set<LocalizationIdentifier> = []
    internal var localizedEquivalentFileNames: [LocalizationIdentifier: StrictString] = [:]
    internal var localizedEquivalentDirectoryNames: [LocalizationIdentifier: StrictString] = [:]
    internal var localizedEquivalentPaths: [LocalizationIdentifier: StrictString] = [:]
    internal var localizedChildren: [SymbolGraph.Symbol] = []
    internal func exists(in localization: LocalizationIdentifier) -> Bool {
      return localizedEquivalentPaths[localization] == nil ∧ localization ∉ skippedLocalizations
    }

    internal var relativePagePath: [LocalizationIdentifier: StrictString] = [:]

    internal var homeProduct: LibraryAPI?
    internal var homeModule: ModuleAPI?

    // MARK: - PackageAPI Only

    internal var packageTypes: [SymbolGraph.Symbol] = []
    internal var packageExtensions: [Extension] = []
    internal var packageProtocols: [SymbolGraph.Symbol] = []
    internal var packageFunctions: [SymbolGraph.Symbol] = []
    internal var packageGlobalVariables: [SymbolGraph.Symbol] = []
    internal var packageOperators: [Operator] = []
    internal var packagePrecedenceGroups: [PrecedenceGroup] = []
  }
}
