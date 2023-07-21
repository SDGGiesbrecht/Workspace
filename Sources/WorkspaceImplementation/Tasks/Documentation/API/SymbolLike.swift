/*
 SymbolLike.swift

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
  import SDGControlFlow
  import SDGText

  import SDGSwiftDocumentation
  import SymbolKit

  import WorkspaceConfiguration

  extension SymbolLike {

    internal func hasEditableDocumentation(editableModules: [String]) -> Bool {
      switch self {
      case let symbol as SymbolGraph.Symbol:
        if symbol.location == nil {  // Synthesized, such as from default conformance.
          return false
        } else {  // Has somewhere to attach documentation.
          if symbol.location?.uri.contains(".build/checkouts") == true {
            // Locally synthesized due to a declaration reported in a dependency. @exempt(from: tests)
            return false
          }
          return true
        }
      default:
        return true
      }
    }
  }
#endif
