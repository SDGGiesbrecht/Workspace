/*
 SymbolGraph.Symbol.ExtendedProperties.swift

 This source file is part of the Workspace open source project.
 Diese Quelldatei ist Teil des quelloffenen Arbeitsbereich‐Projekt.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2022–2023 Jeremy David Giesbrecht and the Workspace project contributors.
 Urheberrecht ©2022–2023 Jeremy David Giesbrecht und die Mitwirkenden des Arbeitsbereich‐Projekts.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

#if !PLATFORM_NOT_SUPPORTED_BY_WORKSPACE_WORKSPACE
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
      internal var localizedChildren: [SymbolLike] = []
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
#endif
