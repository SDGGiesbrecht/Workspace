/*
 Extension.swift

 This source file is part of the Workspace open source project.
 Diese Quelldatei ist Teil des quelloffenen Arbeitsbereich‐Projekt.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2022 Jeremy David Giesbrecht and the Workspace project contributors.
 Urheberrecht ©2022 Jeremy David Giesbrecht und die Mitwirkenden des Arbeitsbereich‐Projekts.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

#if !PLATFORM_NOT_SUPPORTED_BY_WORKSPACE_WORKSPACE
  import Foundation

  import SDGSwiftDocumentation
  import SymbolKit

  internal struct Extension: SymbolLike {

    // MARK: - Initialization

    internal init(
      names: SymbolGraph.Symbol.Names,
      identifier: SymbolGraph.Symbol.Identifier
    ) {
      self.names = names
      self.identifier = identifier
    }

    // MARK: - Properties

    internal var identifier: SymbolGraph.Symbol.Identifier

    // MARK: - SymbolLike

    internal var names: SymbolGraph.Symbol.Names

    internal var declaration: SymbolGraph.Symbol.DeclarationFragments? {
      return nil
    }

    internal var docComment: SymbolGraph.LineList? {
      return nil
    }

    internal var location: SymbolGraph.Symbol.Location? {
      return nil
    }

    internal func parseDocumentation(
      cache: inout [URL: SymbolGraph.Symbol.CachedSource],
      module: String?
    ) -> [SymbolDocumentation] {
      return []
    }
  }
#endif
