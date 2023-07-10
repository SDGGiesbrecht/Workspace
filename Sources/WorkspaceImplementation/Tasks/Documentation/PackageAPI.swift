/*
 PackageAPI.swift

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
  import SDGControlFlow
  import SDGLogic

  import SDGSwiftDocumentation
  import SymbolKit

  extension PackageAPI {

    internal func identifierList() -> Set<String> {
      var result: Set<String> = []
      for graph in symbolGraphs() {
        for (_, symbol) in graph.graph.symbols {
          if let declaration = symbol.declaration {
            for fragment in declaration.declarationFragments {
              switch fragment.kind {
              case .identifier, .typeIdentifier, .genericParameter, .externalParameter:
                result.insert(fragment.spelling)
              default:
                break
              }
            }
          }
        }
      }
      for module in modules {
        for `operator` in module.operators {
          result.insert(`operator`.names.title)
        }
        for group in module.precedenceGroups {
          result.insert(group.names.title)
        }
      }
      return result
    }
  }
#endif
