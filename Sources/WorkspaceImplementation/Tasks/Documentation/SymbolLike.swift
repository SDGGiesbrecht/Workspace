/*
 SymbolLike.swift

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
  import SDGControlFlow
  import SDGText

  import SDGSwiftDocumentation
  import SymbolKit

  import WorkspaceConfiguration

  extension SymbolLike {

    internal func hasEditableDocumentation(editableModules: [String]) -> Bool {
      switch self {
      case is Extension:
        return false
      case let symbol as SymbolGraph.Symbol:
        if ¬editableModules.contains(where: { module in
          return symbol.isDocCommentFromSameModule(symbolModuleName: module) == true
        }) {  // From dependency.
          return false
        }
        return true
      default:
        return true
      }
    }

    internal func isCapableOfInheritingDocumentation(graphs: [SymbolGraph]) -> Bool {
      switch self {
      case let symbol as SymbolGraph.Symbol:
        return graphs.contains(where: { graph in
          return graph.relationships.contains(where: { relationship in
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
      case let `extension` as Extension:
        return `extension`.identifier.precise
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
          .subscript, .typeMethod, .typeSubscript, .unknown:
          return .functions
        case .case, .ivar, .property, .typeProperty, .var:
          return .variables
        case .protocol:
          return .protocols
        }
      case is PackageAPI:
        return .package
      case is LibraryAPI:
        return .libraries
      case is ModuleAPI:
        return .modules
      case is Extension:
        return .extensions
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
        case .deinit, .snippet, .snippetGroup, .module, .unknown:
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
        }
      case is Extension:
        if let match = localization._reasonableMatch {
          switch match {
          case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
            return "Extension"
          case .deutschDeutschland:
            return "Erweiterung"
          }
        } else {
          return "extension"
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

    // MARK: - Relationships

    internal func children(package: PackageAPI) -> [SymbolLike] {
      switch self {
      case let symbol as SymbolGraph.Symbol:
        var result: [SymbolGraph.Symbol] = []
        for graph in package.symbolGraphs() {
          for relationship in graph.relationships {
            switch relationship.kind {
            case .memberOf, .requirementOf, .optionalRequirementOf:
              if relationship.target == symbol.identifier.precise,
                let child = graph.symbols[relationship.source],
                ¬result.contains(where: { $0.identifier.precise == child.identifier.precise })
              {
                result.append(child)
              }
            default:
              break
            }
          }
        }
        return result
      case let package as PackageAPI:
        return package.libraries + package.modules
      case is LibraryAPI:
        return []
      case let module as ModuleAPI:
        var result: [SymbolLike] = []
        for graph in module.symbolGraphs {
          for (_, symbol) in graph.symbols {
            if ¬graph.relationships.contains(where: { relationship in
              guard relationship.source == symbol.identifier.precise else {
                return false
              }
              switch relationship.kind {
              case .memberOf, .requirementOf, .defaultImplementationOf, .optionalRequirementOf:
                return true
              default:
                return false
              }
            }) {
              result.append(symbol)
            }
          }
        }
        result.append(contentsOf: module.operators)
        result.append(contentsOf: module.precedenceGroups)
        result.append(contentsOf: module.extensions())
        return result
      case let `extension` as Extension:
        var result: [SymbolGraph.Symbol] = []
        for graph in package.symbolGraphs() {
          for relationship in graph.relationships {
            switch relationship.kind {
            case .memberOf, .requirementOf, .optionalRequirementOf:
              if relationship.targetFallback == `extension`.names.title,
                let child = graph.symbols[relationship.source],
                ¬result.contains(where: { $0.identifier.precise == child.identifier.precise })
              {
                result.append(child)
              }
            default:
              break
            }
          }
        }
        return result
      case is Operator, is PrecedenceGroup:
        return []
      default:
        unreachable()
      }
    }

    // MARK: - Localization

    internal func determine(
      localizations: [LocalizationIdentifier],
      customReplacements: [(StrictString, StrictString)],
      package: PackageAPI,
      module: String?,
      extensionStorage: inout [String: SymbolGraph.Symbol.ExtendedProperties],
      parsingCache: inout [URL: SymbolGraph.Symbol.CachedSource]
    ) {

      let parsed = parseDocumentation(cache: &parsingCache, module: module)
        .resolved(localizations: localizations)
      extensionStorage[extendedPropertiesIndex, default: .default].localizedDocumentation =
        parsed.documentation
      extensionStorage[extendedPropertiesIndex, default: .default].crossReference =
        parsed.crossReference
      extensionStorage[extendedPropertiesIndex, default: .default].skippedLocalizations =
        parsed.skipped

      let globalScope: Bool
      if self is ModuleAPI {
        globalScope = true
      } else {
        globalScope = false
      }

      var unique = 0
      var groups: [StrictString: [SymbolLike]] = [:]
      for child in children(package: package) {
        child.determine(
          localizations: localizations,
          customReplacements: customReplacements,
          package: package,
          module: module,
          extensionStorage: &extensionStorage,
          parsingCache: &parsingCache
        )
        let crossReference =
          extensionStorage[child.extendedPropertiesIndex, default: .default].crossReference
          ?? {
            unique += 1
            return "\u{7F}\(String(describing: unique))"
          }()
        groups[crossReference, default: []].append(child)
      }
      for (_, group) in groups {
        for indexA in group.indices {
          for indexB in group.indices {
            group[indexA].addLocalizations(
              from: group[indexB],
              isSame: indexA == indexB,
              globalScope: globalScope,
              customReplacements: customReplacements,
              package: package,
              extensionStorage: &extensionStorage
            )
          }
        }
      }
    }

    private func addLocalizations(
      from other: SymbolLike,
      isSame: Bool,
      globalScope: Bool,
      customReplacements: [(StrictString, StrictString)],
      package: PackageAPI,
      extensionStorage: inout [String: SymbolGraph.Symbol.ExtendedProperties]
    ) {
      for (localization, _) in extensionStorage[other.extendedPropertiesIndex, default: .default]
        .localizedDocumentation
      {
        extensionStorage[extendedPropertiesIndex, default: .default]
          .localizedEquivalentFileNames[localization] =
          other
          .fileName(customReplacements: customReplacements)
        extensionStorage[extendedPropertiesIndex, default: .default]
          .localizedEquivalentDirectoryNames[localization] = other.directoryName(
            for: localization,
            globalScope: globalScope,
            typeMember: {
              switch other {
              case let symbol as SymbolGraph.Symbol:
                switch symbol.kind.identifier {
                case .associatedtype, .class, .deinit, .enum, .`case`, .func, .operator, .`init`,
                  .ivar, .macro, .method, .property, .protocol, .snippet, .snippetGroup, .struct,
                  .subscript, .typealias, .var, .module, .unknown:
                  return false
                case .typeMethod, .typeProperty, .typeSubscript:
                  return true
                }
              default:
                unreachable()
              }
            }
          )
        if ¬isSame {
          extensionStorage[self.extendedPropertiesIndex, default: .default].localizedChildren
            .append(contentsOf: other.children(package: package))
        }
      }
    }

    internal func determineLocalizedPaths(
      localizations: [LocalizationIdentifier],
      package: PackageAPI,
      extensionStorage: inout [String: SymbolGraph.Symbol.ExtendedProperties]
    ) {
      var groups: [StrictString: [SymbolLike]] = [:]
      for child in children(package: package) {
        child.determineLocalizedPaths(
          localizations: localizations,
          package: package,
          extensionStorage: &extensionStorage
        )
        if let crossReference = extensionStorage[child.extendedPropertiesIndex, default: .default]
          .crossReference
        {
          groups[crossReference, default: []].append(child)
        }
      }
      for (_, group) in groups {
        for indexA in group.indices {
          for indexB in group.indices where indexA ≠ indexB {
            group[indexA].addLocalizedPaths(
              from: group[indexB],
              extensionStorage: &extensionStorage
            )
          }
        }
      }
    }

    private func addLocalizedPaths(
      from other: SymbolLike,
      extensionStorage: inout [String: SymbolGraph.Symbol.ExtendedProperties]
    ) {
      for (localization, _) in extensionStorage[other.extendedPropertiesIndex, default: .default]
        .localizedDocumentation
      {
        extensionStorage[self.extendedPropertiesIndex, default: .default].localizedEquivalentPaths[
          localization
        ] =
          extensionStorage[other.extendedPropertiesIndex, default: .default].relativePagePath[
            localization
          ]
      }
    }

    // MARK: - Paths

    private func fileName(customReplacements: [(StrictString, StrictString)]) -> StrictString {
      return Page.sanitize(
        fileName: StrictString(names.title),
        customReplacements: customReplacements
      )
    }

    private func directoryName(
      for localization: LocalizationIdentifier,
      globalScope: Bool,
      typeMember: () -> Bool
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
        case .func, .operator, .macro, .snippet, .snippetGroup, .unknown:
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
        }
      case is Extension:
        if let match = localization._reasonableMatch {
          switch match {
          case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
            return "Extensions"
          case .deutschDeutschland:
            return "Erweiterungen"
          }
        } else {
          return "extension"
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
      customReplacements: [(StrictString, StrictString)],
      extensionStorage: [String: SymbolGraph.Symbol.ExtendedProperties]
    ) -> StrictString {
      return
        extensionStorage[self.extendedPropertiesIndex, default: .default]
        .localizedEquivalentFileNames[localization]
        ?? fileName(customReplacements: customReplacements)
    }

    internal func localizedDirectoryName(
      for localization: LocalizationIdentifier,
      globalScope: Bool = false,
      typeMember: Bool = false,
      extensionStorage: [String: SymbolGraph.Symbol.ExtendedProperties]
    ) -> StrictString {
      return
        extensionStorage[self.extendedPropertiesIndex, default: .default]
        .localizedEquivalentDirectoryNames[localization]
        ?? directoryName(
          for: localization,
          globalScope: globalScope,
          typeMember: { typeMember }  // @exempt(from: tests) Should never be called.
        )
    }

    internal func pageURL(
      in outputDirectory: URL,
      for localization: LocalizationIdentifier,
      customReplacements: [(StrictString, StrictString)],
      extensionStorage: [String: SymbolGraph.Symbol.ExtendedProperties]
    ) -> URL {
      return outputDirectory.appendingPathComponent(
        String(
          extensionStorage[self.extendedPropertiesIndex, default: .default].relativePagePath[
            localization
          ]!
        )
      )
    }

    internal func determinePaths(
      for localization: LocalizationIdentifier,
      customReplacements: [(StrictString, StrictString)],
      namespace: StrictString = "",
      package: PackageAPI,
      extensionStorage: inout [String: SymbolGraph.Symbol.ExtendedProperties]
    ) -> [String: String] {
      return purgingAutoreleased {

        var links: [String: String] = [:]
        var path = localization._directoryName + "/"

        switch self {
        case let package as PackageAPI:
          for library in package.libraries {
            links = library.determinePaths(
              for: localization,
              customReplacements: customReplacements,
              package: package,
              extensionStorage: &extensionStorage
            ).merging(links, uniquingKeysWith: min)
          }
        case let library as LibraryAPI:
          path +=
            localizedDirectoryName(for: localization, extensionStorage: extensionStorage) + "/"
          for module in library.modules {
            links = package.modules.first(where: { $0.names.title == module })!.determinePaths(
              for: localization,
              customReplacements: customReplacements,
              package: package,
              extensionStorage: &extensionStorage
            ).merging(links, uniquingKeysWith: min)
          }
        case let module as ModuleAPI:
          path +=
            localizedDirectoryName(for: localization, extensionStorage: extensionStorage) + "/"
          for child in module.children(package: package) {
            links = child.determinePaths(
              for: localization,
              customReplacements: customReplacements,
              package: package,
              extensionStorage: &extensionStorage
            ).merging(links, uniquingKeysWith: min)
          }
        case let symbol as SymbolGraph.Symbol:
          switch symbol.kind.identifier {
          case .associatedtype, .class, .enum, .protocol, .struct, .typealias, .module:
            path +=
              namespace
              + localizedDirectoryName(for: localization, extensionStorage: extensionStorage) + "/"
            var newNamespace = namespace
            newNamespace.append(
              contentsOf: localizedDirectoryName(
                for: localization,
                extensionStorage: extensionStorage
              ) + "/"
            )
            newNamespace.append(
              contentsOf: localizedFileName(
                for: localization,
                customReplacements: customReplacements,
                extensionStorage: extensionStorage
              )
                + "/"
            )
            for child in symbol.children(package: package) {
              links = child.determinePaths(
                for: localization,
                customReplacements: customReplacements,
                namespace: newNamespace,
                package: package,
                extensionStorage: &extensionStorage
              ).merging(links, uniquingKeysWith: min)
            }
          case .deinit, .`case`, .`init`, .macro, .snippet, .snippetGroup, .subscript,
            .typeSubscript, .unknown:
            path +=
              namespace
              + localizedDirectoryName(for: localization, extensionStorage: extensionStorage) + "/"
          case .func, .ivar, .operator, .method, .property, .var:
            path +=
              namespace
              + localizedDirectoryName(
                for: localization,
                globalScope: namespace.isEmpty,
                typeMember: false,
                extensionStorage: extensionStorage
              ) + "/"
          case .typeMethod, .typeProperty:
            path +=
              namespace
              + localizedDirectoryName(
                for: localization,
                globalScope: namespace.isEmpty,
                typeMember: true,
                extensionStorage: extensionStorage
              ) + "/"
          }
        case is Operator, is PrecedenceGroup:
          path +=
            namespace
            + localizedDirectoryName(for: localization, extensionStorage: extensionStorage) + "/"
        case let `extension` as Extension:
          path +=
            namespace
            + localizedDirectoryName(for: localization, extensionStorage: extensionStorage) + "/"
          var newNamespace = namespace
          newNamespace.append(
            contentsOf: localizedDirectoryName(
              for: localization,
              extensionStorage: extensionStorage
            ) + "/"
          )
          newNamespace.append(
            contentsOf: localizedFileName(
              for: localization,
              customReplacements: customReplacements,
              extensionStorage: extensionStorage
            )
              + "/"
          )
          for child in `extension`.children(package: package) {
            links = child.determinePaths(
              for: localization,
              customReplacements: customReplacements,
              namespace: newNamespace,
              package: package,
              extensionStorage: &extensionStorage
            ).merging(links, uniquingKeysWith: min)
          }
        default:
          unreachable()
        }

        path +=
          localizedFileName(
            for: localization,
            customReplacements: customReplacements,
            extensionStorage: extensionStorage
          )
          + ".html"
        extensionStorage[self.extendedPropertiesIndex, default: .default]
          .relativePagePath[localization] = path
        if case .types = self.indexSectionIdentifier {
          links[names.title.truncated(before: "<")] = String(path)
        } else {
          links[names.title] = String(path)
        }
        return links
      }
    }

    // MARK: - Parameters

    internal func parameters() -> [String] {
      switch self {
      case is PackageAPI, is LibraryAPI, is ModuleAPI:
        return []
      default:
        guard let fragments = declaration?.declarationFragments else {
          return []
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
      }
    }
  }
#endif
