import SDGText

import SDGSwiftDocumentation
import SymbolKit

import WorkspaceConfiguration

extension SymbolLike {

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

  internal var indexSectionIdentifier: IndexSectionIdentifier {
    switch self {
    case let symbol as SymbolGraph.Symbol:
      switch symbol.kind.identifier {
      case .associatedtype, .class, .enum, .struct, .typealias, .module:
        return .types
      case .deinit, .func, .operator, .`init`, .macro, .method, .snippet, .snippetGroup, .subscript, .typeMethod, .typeSubscript, .unknown:
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

  // MARK: - Relationships

  internal func children(package: PackageAPI) -> [SymbolGraph.Symbol] {
    switch self {
    case let symbol as SymbolGraph.Symbol:
      var result: [SymbolGraph.Symbol] = []
      for graph in package.symbolGraphs() {
        for relationship in graph.relationships {
          switch relationship.kind {
          case .memberOf, .requirementOf, .optionalRequirementOf:
            if relationship.target == symbol.identifier.precise,
              let child = graph.symbols[relationship.source],
              ¬result.contains(where: { $0.identifier.precise == child.identifier.precise }) {
              result.append(child)
            }
          default:
            break
          }
        }
      }
      return result
    case is PackageAPI, is LibraryAPI, is ModuleAPI:
      unreachable()
    case let `extension` as Extension:
      var result: [SymbolGraph.Symbol] = []
      for graph in package.symbolGraphs() {
        for relationship in graph.relationships {
          switch relationship.kind {
          case .memberOf, .requirementOf, .optionalRequirementOf:
            if relationship.target == `extension`.identifier.precise,
              let child = graph.symbols[relationship.source],
              ¬result.contains(where: { $0.identifier.precise == child.identifier.precise }) {
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
    extensionStorage[extendedPropertiesIndex, default: .default].localizedDocumentation = parsed.documentation
    extensionStorage[extendedPropertiesIndex, default: .default].crossReference = parsed.crossReference
    extensionStorage[extendedPropertiesIndex, default: .default].skippedLocalizations = parsed.skipped

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
            extensionStorage: extensionStorage
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
    extensionStorage: [String: SymbolGraph.Symbol.ExtendedProperties]
  ) {
    for (localization, _) in extensionStorage[other.extendedPropertiesIndex, default: .default]
      .localizedDocumentation {
      extensionStorage[extendedPropertiesIndex, default: .default]
        .localizedEquivalentFileNames[localization] = extensionStorage[other.extendedPropertiesIndex, default: .default]
        .fileName(customReplacements: customReplacements)
      localizedEquivalentDirectoryNames[localization] = other.directoryName(
        for: localization,
        globalScope: globalScope,
        typeMember: {
          switch other {
          case .package,  // @exempt(from: tests)
            .library,
            .module,
            .type,
            .protocol,
            .extension,
            .case,
            .initializer,
            .subscript,
            .operator,
            .precedence,
            .conformance:
            unreachable()
          case .variable(let variable):
            return variable.declaration.isTypeMember()
          case .function(let function):
            return function.declaration.isTypeMember()
          }
        }
      )
      if ¬isSame {
        localizedChildren.append(contentsOf: other.children)
      }
    }
  }

  internal func determineLocalizedPaths(localizations: [LocalizationIdentifier]) {
    var groups: [StrictString: [APIElement]] = [:]
    for child in children {
      child.determineLocalizedPaths(localizations: localizations)
      if let crossReference = child.crossReference {
        groups[crossReference, default: []].append(child)
      }
    }
    for (_, group) in groups {
      for indexA in group.indices {
        for indexB in group.indices where indexA ≠ indexB {
          group[indexA].addLocalizedPaths(from: group[indexB])
        }
      }
    }
  }

  // MARK: - Paths

  internal func pageURL(
    in outputDirectory: URL,
    for localization: LocalizationIdentifier,
    customReplacements: [(StrictString, StrictString)]
  ) -> URL {
    return outputDirectory.appendingPathComponent(String(relativePagePath[localization]!))
  }

  internal func determinePaths(
    for localization: LocalizationIdentifier,
    customReplacements: [(StrictString, StrictString)],
    namespace: StrictString = ""
  ) -> [String: String] {
    return purgingAutoreleased {

      var links: [String: String] = [:]
      var path = localization._directoryName + "/"

      switch self {
      case .package(let package):
        for library in package.libraries {
          links = APIElement.library(library).determinePaths(
            for: localization,
            customReplacements: customReplacements
          )
          .mergedByOverwriting(from: links)
        }
      case .library(let library):
        path += localizedDirectoryName(for: localization) + "/"
        for module in library.modules {
          links = APIElement.module(module).determinePaths(
            for: localization,
            customReplacements: customReplacements
          )
          .mergedByOverwriting(from: links)
        }
      case .module(let module):
        path += localizedDirectoryName(for: localization) + "/"
        for child in module.children {
          links = child.determinePaths(for: localization, customReplacements: customReplacements)
            .mergedByOverwriting(from: links)
        }
      case .type, .extension, .protocol:
        path += namespace + localizedDirectoryName(for: localization) + "/"
        var newNamespace = namespace
        newNamespace.append(contentsOf: localizedDirectoryName(for: localization) + "/")
        newNamespace.append(
          contentsOf: localizedFileName(for: localization, customReplacements: customReplacements)
            + "/"
        )
        for child in children where child.receivesPage {
          links = child.determinePaths(
            for: localization,
            customReplacements: customReplacements,
            namespace: newNamespace
          )
          .mergedByOverwriting(from: links)
        }
      case .case, .initializer, .subscript, .operator, .precedence:
        path += namespace + localizedDirectoryName(for: localization) + "/"
      case .variable(let variable):
        path +=
          namespace
          + localizedDirectoryName(
            for: localization,
            globalScope: namespace.isEmpty,
            typeMember: variable.declaration.isTypeMember()
          ) + "/"
      case .function(let function):
        path +=
          namespace
          + localizedDirectoryName(
            for: localization,
            globalScope: namespace.isEmpty,
            typeMember: function.declaration.isTypeMember()
          ) + "/"
      case .conformance:
        unreachable()
      }

      path +=
        localizedFileName(for: localization, customReplacements: customReplacements)
        + ".html"
      relativePagePath[localization] = path
      if case .type = self {
        links[name.source().truncated(before: "<")] = String(path)
      } else {
        links[name.source()] = String(path)
      }
      return links
    }
  }

  // MARK: - Parameters

  internal func parameters() -> [String] {
    let parameterList: FunctionParameterListSyntax
    switch self {
    case .package, .library, .module, .type, .protocol, .extension, .case, .operator,
      .precedence, .conformance:
      return []
    case .variable(let variable):
      guard let typeAnnotation = variable.declaration.bindings.first?.typeAnnotation else {
        return []
      }
      return typeAnnotation.type.parameterNames()
    case .initializer(let initializer):
      parameterList = initializer.declaration.parameters.parameterList
    case .subscript(let `subscript`):
      parameterList = `subscript`.declaration.indices.parameterList
    case .function(let function):
      parameterList = function.declaration.signature.input.parameterList
    }
    return Array(parameterList.lazy.map({ $0.parameterNames() }).joined())
  }
}
