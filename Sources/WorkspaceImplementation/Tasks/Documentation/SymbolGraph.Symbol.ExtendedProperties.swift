
import SymbolKit

import WorkspaceConfiguration

extension SymbolGraph.Symbol {

  internal struct ExtendedProperties {
    internal var skippedLocalizations: Set<LocalizationIdentifier> = []
    internal var relativePagePath: [LocalizationIdentifier: StrictString] = [:]
  }
}
