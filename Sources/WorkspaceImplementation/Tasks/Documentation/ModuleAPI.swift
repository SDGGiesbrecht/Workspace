/*
 ModuleAPI.swift

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
  import SymbolKit
  import SDGSwiftDocumentation

  extension ModuleAPI {

    internal func extensions() -> [Extension] {
      var unprocessedExtensionIdentifiers: [String: String] = [:]
      for graph in self.symbolGraphs {
        for relationship in graph.relationships
        where relationship.kind == .memberOf {
          unprocessedExtensionIdentifiers[relationship.target] = relationship.targetFallback
        }
      }
      var extensionIdentifiers: Set<String> = Set(unprocessedExtensionIdentifiers.keys)
      var symbolLookup: [String: SymbolGraph.Symbol] = [:]
      for graph in self.symbolGraphs {
        symbolLookup.mergeByOverwriting(from: graph.symbols)
        for symbol in graph.symbols.values {
          extensionIdentifiers.remove(symbol.identifier.precise)
        }
      }
      let result = extensionIdentifiers.compactMap { identifier in
        if let symbol = symbolLookup[identifier] {
          return Extension(names: symbol.names, identifier: symbol.identifier)
        } else if let fallback = unprocessedExtensionIdentifiers[identifier] {
          return Extension(
            names: SymbolGraph.Symbol.Names(
              title: fallback,
              navigator: nil,
              subHeading: nil,
              prose: nil
            ),
            identifier: SymbolGraph.Symbol.Identifier(
              precise: "SDG.extension.\(fallback)",
              interfaceLanguage: "swift"
            )
          )
        } else {
          return nil
        }
      }
      return result
    }
  }
#endif
