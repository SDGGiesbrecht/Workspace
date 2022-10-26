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
    case let `operator` as Operator:
      return "SDG.operator.\(`operator`.names.title)"
    case let precedenceGroup as PrecedenceGroup:
      return "SDG.precedencegroup.\(precedenceGroup.names.title)"
    default:
      unreachable()
    }
  }

  // MARK: - Localization

  internal func determine(
    localizations: [LocalizationIdentifier],
    customReplacements: [(StrictString, StrictString)]
  ) {

    let parsed = documentation.resolved(localizations: localizations)
    localizedDocumentation = parsed.documentation
    crossReference = parsed.crossReference
    skippedLocalizations = parsed.skipped

    let globalScope: Bool
    if case .module = self {
      globalScope = true
    } else {
      globalScope = false
    }

    var unique = 0
    var groups: [StrictString: [APIElement]] = [:]
    for child in children {
      child.determine(localizations: localizations, customReplacements: customReplacements)
      let crossReference =
        child.crossReference
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
            customReplacements: customReplacements
          )
        }
      }
    }
  }

  // MARK: - Paths

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
}
