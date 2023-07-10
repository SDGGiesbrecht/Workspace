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

    internal var extendedPropertiesIndex: String {
      switch self {
      case let symbol as SymbolGraph.Symbol:
        return symbol.identifier.precise
      case let package as PackageAPI:
        return "SDG.Package.\(package.names.title)"
      case let library as LibraryAPI:
        return "SDG.library.\(library.names.title)"
      case let module as ModuleAPI:
        return "SDG.target.\(module.names.title)"
      case let `operator` as Operator:
        return "SDG.operator.\(`operator`.names.title)"
      case let precedenceGroup as PrecedenceGroup:
        return "SDG.precedencegroup.\(precedenceGroup.names.title)"
      default:
        unreachable()
      }
    }

    internal var kind: SymbolGraph.Symbol.Kind? {
      guard let symbol = self as? SymbolGraph.Symbol else {
        return nil
      }
      return symbol.kind as SymbolGraph.Symbol.Kind
    }

    internal var indexSectionIdentifier: IndexSectionIdentifier {
      switch self {
      case let symbol as SymbolGraph.Symbol:
        switch symbol.kind.identifier {
        case .associatedtype, .class, .enum, .struct, .typealias, .module:
          return .types
        case .deinit, .func, .operator, .`init`, .macro, .method, .snippet, .snippetGroup,
          .subscript, .typeMethod, .typeSubscript:
          return .functions
        case .case, .ivar, .property, .typeProperty, .var:
          return .variables
        case .protocol:
          return .protocols
        default:  // @exempt(from: tests)
          symbol.kind.identifier.warnUnknown()
          return .functions
        }
      case is PackageAPI:
        return .package
      case is LibraryAPI:
        return .libraries
      case is ModuleAPI:
        return .modules
      case is Operator:
        return .operators
      case is PrecedenceGroup:
        return .precedenceGroups
      default:
        unreachable()
      }
    }

    internal func symbolType(localization: LocalizationIdentifier) -> StrictString {
      switch self {
      case is PackageAPI:
        if let match = localization._reasonableMatch {
          switch match {
          case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
            return "Package"
          case .deutschDeutschland:
            return "Paket"
          }
        } else {
          return "Package"  // From “let ... = Package(...)”
        }
      case is LibraryAPI:
        if let match = localization._reasonableMatch {
          switch match {
          case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
            return "Library Product"
          case .deutschDeutschland:
            return "Biblioteksprodukt"
          }
        } else {
          return "library"  // From “products: [.library(...)]”
        }
      case is ModuleAPI:
        if let match = localization._reasonableMatch {
          switch match {
          case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
            return "Module"
          case .deutschDeutschland:
            return "Modul"
          }
        } else {
          return "target"  // From “targets: [.target(...)]”
        }
      case let symbol as SymbolGraph.Symbol:
        switch symbol.kind.identifier {
        case .associatedtype:
          if let match = localization._reasonableMatch {
            switch match {
            case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
              return "Associated Type"
            case .deutschDeutschland:
              return "Zugehöriger Typ"
            }
          } else {
            return "associatedtype"
          }
        case .class:
          if let match = localization._reasonableMatch {
            switch match {
            case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
              return "Class"
            case .deutschDeutschland:
              return "Klasse"
            }
          } else {
            return "class"
          }
        case .deinit, .snippet, .snippetGroup, .module:
          unreachable()
        case .enum:
          if let match = localization._reasonableMatch {
            switch match {
            case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
              return "Enumeration"
            case .deutschDeutschland:
              return "Aufzählung"
            }
          } else {
            return "enum"
          }
        case .`case`:
          if let match = localization._reasonableMatch {
            switch match {
            case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
              return "Case"
            case .deutschDeutschland:
              return "Fall"
            }
          } else {
            return "case"
          }
        case .func, .operator, .macro:
          if let match = localization._reasonableMatch {
            switch match {
            case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
              return "Function"
            case .deutschDeutschland:
              return "Funktion"
            }
          } else {
            return "func"
          }
        case .`init`:
          if let match = localization._reasonableMatch {
            switch match {
            case .englishUnitedKingdom:
              return "Initialiser"
            case .englishUnitedStates, .englishCanada:
              return "Initializer"
            case .deutschDeutschland:
              return "Voreinsteller"
            }
          } else {
            return "init"
          }
        case .ivar, .property:
          if let match = localization._reasonableMatch {
            switch match {
            case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
              return "Instance Property"
            case .deutschDeutschland:
              return "Instanz‐Eigenschaft"
            }
          } else {
            return "var"
          }
        case .method:
          if let match = localization._reasonableMatch {
            switch match {
            case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
              return "Instance Method"
            case .deutschDeutschland:
              return "Instanz‐Methode"
            }
          } else {
            return "func"
          }
        case .protocol:
          if let match = localization._reasonableMatch {
            switch match {
            case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
              return "Protocol"
            case .deutschDeutschland:
              return "Protokoll"
            }
          } else {
            return "protocol"
          }
        case .struct:
          if let match = localization._reasonableMatch {
            switch match {
            case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
              return "Structure"
            case .deutschDeutschland:
              return "Struktur"
            }
          } else {
            return "struct"
          }
        case .subscript, .typeSubscript:
          if let match = localization._reasonableMatch {
            switch match {
            case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
              return "Subscript"
            case .deutschDeutschland:
              return "Index"
            }
          } else {
            return "subscript"
          }
        case .typeMethod:
          if let match = localization._reasonableMatch {
            switch match {
            case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
              return "Type Method"
            case .deutschDeutschland:
              return "Typ‐Methode"
            }
          } else {
            return "func"
          }
        case .typeProperty:
          if let match = localization._reasonableMatch {
            switch match {
            case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
              return "Type Property"
            case .deutschDeutschland:
              return "Typ‐Eigenschaft"
            }
          } else {
            return "var"
          }
        case .typealias:
          if let match = localization._reasonableMatch {
            switch match {
            case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
              return "Type Alias"
            case .deutschDeutschland:
              return "Typ‐Alias"
            }
          } else {
            return "typealias"
          }
        case .var:
          if let match = localization._reasonableMatch {
            switch match {
            case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
              return "Global Variable"
            case .deutschDeutschland:
              return "Globale Variable"
            }
          } else {
            return "var"
          }
        default:  // @exempt(from: tests)
          symbol.kind.identifier.warnUnknown()
          return StrictString(symbol.kind.identifier.identifier)
        }
      case is Operator:
        if let match = localization._reasonableMatch {
          switch match {
          case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
            return "Operator"
          case .deutschDeutschland:
            return "Operator"
          }
        } else {
          return "operator"
        }
      case is PrecedenceGroup:
        if let match = localization._reasonableMatch {
          switch match {
          case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
            return "Precedence Group"
          case .deutschDeutschland:
            return "Rangfolgenklasse"
          }
        } else {
          return "precedencegroup"
        }
      default:
        unreachable()
      }
    }

    // MARK: - Localization

    private func addLocalizedPaths(
      from other: SymbolLike,
      extensionStorage: inout [String: SymbolGraph.Symbol.ExtendedProperties]
    ) {
      for (localization, _) in extensionStorage[
        other.extendedPropertiesIndex,
        default: .default  // @exempt(from: tests) Reachability unknown.
      ].localizedDocumentation {
        extensionStorage[
          self.extendedPropertiesIndex,
          default: .default  // @exempt(from: tests) Reachability unknown.
        ].localizedEquivalentPaths[localization] =
          extensionStorage[
            other.extendedPropertiesIndex,
            default: .default  // @exempt(from: tests) Reachability unknown.
          ].relativePagePath[localization]
      }
    }

    // MARK: - Paths

    private func fileName() -> StrictString {
      return StrictString(names.title)
    }

    private func directoryName(
      for localization: LocalizationIdentifier,
      globalScope: Bool
    ) -> StrictString {

      switch self {
      case is PackageAPI:
        unreachable()
      case is LibraryAPI:
        if let match = localization._reasonableMatch {
          switch match {
          case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
            return "Libraries"
          case .deutschDeutschland:
            return "Biblioteken"
          }
        } else {
          return "library"  // From “products: [.library(...)]”
        }
      case is ModuleAPI:
        if let match = localization._reasonableMatch {
          switch match {
          case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
            return "Modules"
          case .deutschDeutschland:
            return "Module"
          }
        } else {
          return "target"  // From “targets: [.target(...)]”
        }
      case let symbol as SymbolGraph.Symbol:
        switch symbol.kind.identifier {
        case .associatedtype, .class, .enum, .struct, .typealias, .module:
          if let match = localization._reasonableMatch {
            switch match {
            case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
              return "Types"
            case .deutschDeutschland:
              return "Typen"
            }
          } else {
            return "struct"
          }
        case .deinit, .`init`:
          if let match = localization._reasonableMatch {
            switch match {
            case .englishUnitedKingdom:
              return "Initialisers"
            case .englishUnitedStates, .englishCanada:
              return "Initializers"
            case .deutschDeutschland:
              return "Voreinsteller"
            }
          } else {
            return "init"
          }
        case .`case`:
          if let match = localization._reasonableMatch {
            switch match {
            case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
              return "Cases"
            case .deutschDeutschland:
              return "Fälle"
            }
          } else {
            return "case"
          }
        case .func, .operator, .macro, .snippet, .snippetGroup:
          if let match = localization._reasonableMatch {
            switch match {
            case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
              return "Functions"
            case .deutschDeutschland:
              return "Funktionen"
            }
          } else {
            return "func"
          }
        case .ivar, .property:
          if let match = localization._reasonableMatch {
            switch match {
            case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
              return "Properties"
            case .deutschDeutschland:
              return "Eigenschaften"
            }
          } else {
            return "var"
          }
        case .method:
          if let match = localization._reasonableMatch {
            switch match {
            case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
              return "Methods"
            case .deutschDeutschland:
              return "Methoden"
            }
          } else {
            return "func"
          }
        case .protocol:
          if let match = localization._reasonableMatch {
            switch match {
            case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
              return "Protocols"
            case .deutschDeutschland:
              return "Protokolle"
            }
          } else {
            return "protocol"
          }
        case .subscript:
          if let match = localization._reasonableMatch {
            switch match {
            case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
              return "Subscripts"
            case .deutschDeutschland:
              return "Indexe"
            }
          } else {
            return "subscript"
          }
        case .typeMethod, .typeSubscript:
          // #workaround(Type subscripts are not separately supported yet.)
          if let match = localization._reasonableMatch {
            switch match {
            case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
              return "Type Methods"
            case .deutschDeutschland:
              return "Typ‐Methoden"
            }
          } else {
            return "static func"
          }
        case .typeProperty:
          if let match = localization._reasonableMatch {
            switch match {
            case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
              return "Type Properties"
            case .deutschDeutschland:
              return "Typ‐Eigenschaften"
            }
          } else {
            return "static var"
          }
        case .var:
          if let match = localization._reasonableMatch {
            switch match {
            case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
              return "Global Variables"
            case .deutschDeutschland:
              return "globale Variablen"
            }
          } else {
            return "var"
          }
        default:  // @exempt(from: tests)
          symbol.kind.identifier.warnUnknown()
          return StrictString(symbol.kind.identifier.identifier)
        }
      case is Operator:
        if let match = localization._reasonableMatch {
          switch match {
          case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
            return "Operators"
          case .deutschDeutschland:
            return "Operatoren"
          }
        } else {
          return "operator"
        }
      case is PrecedenceGroup:
        if let match = localization._reasonableMatch {
          switch match {
          case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
            return "Precedence Groups"
          case .deutschDeutschland:
            return "Rangfolgenklassen"
          }
        } else {
          return "precedencegroup"
        }
      default:
        unreachable()
      }
    }

    internal func localizedFileName(
      for localization: LocalizationIdentifier,
      extensionStorage: [String: SymbolGraph.Symbol.ExtendedProperties]
    ) -> StrictString {
      return
        extensionStorage[
          self.extendedPropertiesIndex,
          default: .default  // @exempt(from: tests) Reachability unknown.
        ].localizedEquivalentFileNames[localization]
        ?? fileName()
    }

    internal func localizedDirectoryName(
      for localization: LocalizationIdentifier,
      globalScope: Bool = false,
      typeMember: Bool = false,
      extensionStorage: [String: SymbolGraph.Symbol.ExtendedProperties]
    ) -> StrictString {
      return
        extensionStorage[
          self.extendedPropertiesIndex,
          default: .default  // @exempt(from: tests) Reachability unknown.
        ].localizedEquivalentDirectoryNames[localization]
        ?? directoryName(
          for: localization,
          globalScope: globalScope
        )
    }

    internal func pageURL(
      in outputDirectory: URL,
      for localization: LocalizationIdentifier,
      extensionStorage: [String: SymbolGraph.Symbol.ExtendedProperties]
    ) -> URL? {
      return extensionStorage[
        self.extendedPropertiesIndex,
        default: .default  // @exempt(from: tests) Reachability unknown.
      ].relativePagePath[localization].map { relativePath in
        return outputDirectory.appendingPathComponent(String(relativePath))
      }
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
