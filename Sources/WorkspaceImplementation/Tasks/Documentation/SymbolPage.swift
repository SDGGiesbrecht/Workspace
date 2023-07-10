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

    /// Final initialization which can be skipped when only checking coverage.
    private init<SymbolType>(
      symbol: SymbolType
    ) where SymbolType: SymbolLike {
      super.init(
        title: "",
        content: ""
      )
    }
  }
#endif
