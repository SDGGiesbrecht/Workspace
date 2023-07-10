/*
 SymbolPage.swift

 This source file is part of the Workspace open source project.
 Diese Quelldatei ist Teil des quelloffenen Arbeitsbereich‐Projekt.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2018–2023 Jeremy David Giesbrecht and the Workspace project contributors.
 Urheberrecht ©2018–2023 Jeremy David Giesbrecht und die Mitwirkenden des Arbeitsbereich‐Projekts.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

#if !PLATFORM_NOT_SUPPORTED_BY_WORKSPACE_WORKSPACE
  import SDGLogic
  import SDGCollections

  import SDGCommandLine

  import SymbolKit
  import SDGSwiftDocumentation
  import SDGHTML

  import SwiftSyntax
  import SwiftSyntaxParser
  import SDGSwiftSource

  import WorkspaceLocalizations
  import WorkspaceConfiguration

  internal class SymbolPage: Page {

    // MARK: - Initialization

    /// Begins creating a symbol page.
    ///
    /// If `coverageCheckOnly` is `true`, initialization will be aborted and `nil` returned once validation is complete. No other circumstances will cause initialization to fail.
    internal convenience init?<SymbolType>(
      localization: LocalizationIdentifier,
      allLocalizations: [LocalizationIdentifier],
      pathToSiteRoot: StrictString,
      navigationPath: [SymbolLike],
      projectRoot: URL,
      packageImport: StrictString?,
      index: StrictString,
      sectionIdentifier: IndexSectionIdentifier,
      platforms: StrictString,
      symbol: SymbolType,
      package: PackageAPI,
      extensionStorage: [String: SymbolGraph.Symbol.ExtendedProperties],
      tools: PackageCLI? = nil,
      editableModules: [String],
      packageIdentifiers: Set<String>,
      symbolLinks: [String: String],
      status: DocumentationStatus,
      output: Command.Output,
      coverageCheckOnly: Bool
    ) where SymbolType: SymbolLike {

      self.init(
        symbol: symbol
      )
      #warning("↑ Working backwards from here.")
    }

    /// Final initialization which can be skipped when only checking coverage.
    private init<SymbolType>(
      symbol: SymbolType
    ) where SymbolType: SymbolLike {
      super.init(
        title: "",
        content: ""
      )
    }

    internal static func librariesHeader(localization: LocalizationIdentifier) -> StrictString {
      let heading: StrictString
      if let match = localization._reasonableMatch {
        switch match {
        case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
          heading = "Library Products"
        case .deutschDeutschland:
          heading = "Biblioteksprodukte"
        }
      } else {
        heading = "library"  // From “products: [.library(...)]”
      }
      return heading
    }

    internal static func modulesHeader(localization: LocalizationIdentifier) -> StrictString {
      let heading: StrictString
      if let match = localization._reasonableMatch {
        switch match {
        case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
          heading = "Modules"
        case .deutschDeutschland:
          heading = "Module"
        }
      } else {
        heading = "target"  // From “targets: [.target(...)]”
      }
      return heading
    }
  }
#endif
