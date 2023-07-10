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
          if docComment == nil {  // Undocumented.
            if declaration?.declarationFragments.contains(where: { fragment in
              return fragment.spelling == "override"
                ∨ fragment.spelling == "required"
            }) == true {  // Override. @exempt(from: tests)
              return false
            }
            if symbol.location?.uri.contains(".build/checkouts") == true {
              // Locally synthesized due to a declaration reported in a dependency. @exempt(from: tests)
              return false
            }
            return true
          }
          if ¬editableModules.contains(where: { module in
            return symbol.isDocCommentFromSameModule(symbolModuleName: module) == true
          }) {  // From dependency.
            return false
          } else {
            return true
          }
        }
      default:
        return true
      }
    }

    internal func isCapableOfInheritingDocumentation(graphs: [SymbolGraph]) -> Bool {
      switch self {
      case let symbol as SymbolGraph.Symbol:  // @exempt(from: tests) Reachability unknown.
        return graphs.contains(where: { graph in
          return graph.relationships.contains(
            where: { relationship in  // @exempt(from: tests) Reachability unknown.
              if relationship.source == symbol.identifier.precise {
                switch relationship.kind {
                case .defaultImplementationOf, .overrides, .requirementOf, .optionalRequirementOf:
                  return true
                default:
                  return false
                }
              }
              return false
            })
        })
      default:
        return false
      }
    }

    internal var kind: SymbolGraph.Symbol.Kind? {
      guard let symbol = self as? SymbolGraph.Symbol else {
        return nil
      }
      return symbol.kind as SymbolGraph.Symbol.Kind
    }

    // MARK: - Parameters

    internal func parameters() -> [String] {
      guard let symbol = self as? SymbolGraph.Symbol else {
        return []
      }
      switch symbol.kind.identifier {
      case .associatedtype, .class, .deinit, .enum, .`case`, .ivar, .property, .protocol, .snippet,
        .snippetGroup, .struct, .typeProperty, .typealias, .var, .module:
        return []
      case .func, .operator, .`init`, .macro, .method, .subscript, .typeMethod, .typeSubscript:
        guard let fragments = declaration?.declarationFragments else {
          return []  // @exempt(from: tests) Reachability unknown.
        }
        return fragments.indices.compactMap({ index in
          let fragment = fragments[index]
          switch fragment.kind {
          case .externalParameter:
            let remainder = fragments[index...].dropFirst()
            let afterWhitespace = remainder.drop(while: { nextFragment in
              return nextFragment.spelling.scalars.allSatisfy { $0 == " " }
            })
            if afterWhitespace.first?.kind == .internalParameter {
              return nil
            }
            return fragment.spelling
          case .internalParameter:
            return fragment.spelling
          default:
            return nil
          }
        })
      default:  // @exempt(from: tests)
        symbol.kind.identifier.warnUnknown()
        return []
      }
    }
  }
#endif
