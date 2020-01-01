/*
 APIElement.swift

 This source file is part of the Workspace open source project.
 Diese Quelldatei ist Teil des qeulloffenen Arbeitsbereich‐Projekt.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2018–2020 Jeremy David Giesbrecht and the Workspace project contributors.
 Urheberrecht ©2018–2020 Jeremy David Giesbrecht und die Mitwirkenden des Arbeitsbereich‐Projekts.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGLogic
import SDGMathematics
import SDGCollections
import WSGeneralImports

import SwiftSyntax
import SDGSwiftSource

import WSProject

extension APIElement {

  // MARK: - Symbol Types

  internal func symbolType(localization: LocalizationIdentifier) -> StrictString {
    switch self {
    case .package:
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
    case .library:
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
    case .module:
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
    case .type(let type):
      switch type.genericDeclaration {
      case is ClassDeclSyntax:
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
      case is StructDeclSyntax:
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
      case is EnumDeclSyntax:
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
      case is TypealiasDeclSyntax:
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
      case is AssociatedtypeDeclSyntax:
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
      default:  // @exempt(from: tests)
        // @exempt(from: tests)
        type.genericDeclaration.warnUnidentified()
        return ""
      }
    case .extension:
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
    case .case:
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
    case .initializer:
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
    case .variable(let variable):
      if relativePagePath[localization]!.components(separatedBy: "/").count ≤ 3 {
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
      } else {
        if variable.declaration.isTypeMember() {
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
        } else {
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
        }
      }
    case .subscript:
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
    case .function(let function):
      if relativePagePath[localization]!.components(separatedBy: "/").count ≤ 3 {
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
      } else {
        if function.declaration.isTypeMember() {
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
        } else {
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
        }
      }
    case .operator:
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
    case .precedence:
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
    case .conformance:
      unreachable()
    }
  }

  // MARK: - Properties

  internal enum ExtendedPropertyKey {
    case localizedDocumentation
    case crossReference
    case skippedLocalizations
    case localizedEquivalentFileNames
    case localizedEquivalentDirectoryNames
    case localizedEquivalentPaths
    case localizedChildren
    case relativePagePath
    case types
    case `extensions`
    case protocols
    case functions
    case globalVariables
    case operators
    case precedenceGroups
    case homeModule
    case homeProduct
  }
  internal var extendedProperties: [ExtendedPropertyKey: Any] {
    get {
      return (userInformation as? [ExtendedPropertyKey: Any]) ?? [:]
    }
    nonmutating set {
      userInformation = newValue
    }
  }

  internal var localizedDocumentation: [LocalizationIdentifier: DocumentationSyntax] {
    get {
      return (
        extendedProperties[.localizedDocumentation]
          as? [LocalizationIdentifier: DocumentationSyntax]
      ) ?? [:]  // @exempt(from: tests) Never nil.
    }
    nonmutating set {
      extendedProperties[.localizedDocumentation] = newValue
    }
  }

  internal var crossReference: StrictString? {
    get {
      return extendedProperties[.crossReference] as? StrictString
    }
    nonmutating set {
      extendedProperties[.crossReference] = newValue
    }
  }

  internal var skippedLocalizations: Set<LocalizationIdentifier> {
    get {
      return (
        extendedProperties[.skippedLocalizations]
          as? Set<LocalizationIdentifier>
      ) ?? []  // @exempt(from: tests) Never nil.
    }
    nonmutating set {
      extendedProperties[.skippedLocalizations] = newValue
    }
  }

  private var localizedEquivalentFileNames: [LocalizationIdentifier: StrictString] {
    get {
      return (
        extendedProperties[.localizedEquivalentFileNames]
          as? [LocalizationIdentifier: StrictString]
      ) ?? [:]
    }
    nonmutating set {
      extendedProperties[.localizedEquivalentFileNames] = newValue
    }
  }

  private var localizedEquivalentDirectoryNames: [LocalizationIdentifier: StrictString] {
    get {
      return (
        extendedProperties[.localizedEquivalentDirectoryNames]
          as? [LocalizationIdentifier: StrictString]
      ) ?? [:]
    }
    nonmutating set {
      extendedProperties[.localizedEquivalentDirectoryNames] = newValue
    }
  }

  internal var localizedEquivalentPaths: [LocalizationIdentifier: StrictString] {
    get {
      return (
        extendedProperties[.localizedEquivalentPaths]
          as? [LocalizationIdentifier: StrictString]
      ) ?? [:]
    }
    nonmutating set {
      extendedProperties[.localizedEquivalentPaths] = newValue
    }
  }

  internal var localizedChildren: [APIElement] {
    get {
      return (extendedProperties[.localizedChildren] as? [APIElement]) ?? []
    }
    nonmutating set {
      extendedProperties[.localizedChildren] = newValue
    }
  }

  internal func exists(in localization: LocalizationIdentifier) -> Bool {
    return localizedEquivalentPaths[localization] == nil ∧ localization ∉ skippedLocalizations
  }

  internal var relativePagePath: [LocalizationIdentifier: StrictString] {
    get {
      return (
        extendedProperties[.relativePagePath] as? [LocalizationIdentifier: StrictString]
      ) ?? [:]
    }
    nonmutating set {
      extendedProperties[.relativePagePath] = newValue
    }
  }

  internal var homeModule: Weak<ModuleAPI> {
    get {
      return (extendedProperties[.homeModule] as? Weak<ModuleAPI>) ?? Weak<ModuleAPI>(nil)
    }
    nonmutating set {
      extendedProperties[.homeModule] = newValue
      for child in children {
        child.extendedProperties[.homeModule] = newValue
      }
    }
  }

  internal var homeProduct: Weak<LibraryAPI> {
    get {
      return (extendedProperties[.homeProduct] as? Weak<LibraryAPI>)
        ?? Weak<LibraryAPI>(nil)  // @exempt(from: tests) Should never be nil.
    }
    nonmutating set {
      extendedProperties[.homeProduct] = newValue
    }
  }

  // MARK: - Localization

  internal func determine(localizations: [LocalizationIdentifier]) {

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
      child.determine(localizations: localizations)
      let crossReference = child.crossReference
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
            globalScope: globalScope
          )
        }
      }
    }
  }

  private func addLocalizations(from other: APIElement, isSame: Bool, globalScope: Bool) {
    for (localization, _) in other.localizedDocumentation {
      localizedEquivalentFileNames[localization] = other.fileName
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

  private func addLocalizedPaths(from other: APIElement) {
    for (localization, _) in other.localizedDocumentation {
      localizedEquivalentPaths[localization] = other.relativePagePath[localization]
    }
  }

  // MARK: - Paths

  internal var receivesPage: Bool {
    if case .conformance = self {
      return false
    }
    return true
  }

  private var fileName: StrictString {
    return Page.sanitize(fileName: StrictString(name.source()))
  }
  private func directoryName(
    for localization: LocalizationIdentifier,
    globalScope: Bool,
    typeMember: () -> Bool
  ) -> StrictString {

    switch self {
    case .package:
      unreachable()
    case .library:
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
    case .module:
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
    case .type:
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
    case .extension:
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
    case .case:
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
    case .initializer:
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
    case .variable:
      if globalScope {
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
      } else {
        if typeMember() {
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
        } else {
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
        }
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
    case .function:
      if globalScope {
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
      } else {
        if typeMember() {
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
        } else {
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
        }
      }
    case .operator:
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
    case .precedence:
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
    case .conformance:
      unreachable()
    }
  }

  internal func localizedFileName(for localization: LocalizationIdentifier) -> StrictString {
    return localizedEquivalentFileNames[localization] ?? fileName
  }
  internal func localizedDirectoryName(
    for localization: LocalizationIdentifier,
    globalScope: Bool = false,
    typeMember: Bool = false
  ) -> StrictString {
    return localizedEquivalentDirectoryNames[localization]
      ?? directoryName(
        for: localization,
        globalScope: globalScope,
        typeMember: { typeMember }  // @exempt(from: tests) Should never be called.
      )
  }

  internal func pageURL(
    in outputDirectory: URL,
    for localization: LocalizationIdentifier
  ) -> URL {
    return outputDirectory.appendingPathComponent(String(relativePagePath[localization]!))
  }

  internal func determinePaths(
    for localization: LocalizationIdentifier,
    namespace: StrictString = ""
  ) -> [String: String] {
    return autoreleasepool {

      var links: [String: String] = [:]
      var path = localization._directoryName + "/"

      switch self {
      case .package(let package):
        for library in package.libraries {
          links = APIElement.library(library).determinePaths(for: localization)
            .mergedByOverwriting(from: links)
        }
      case .library(let library):
        path += localizedDirectoryName(for: localization) + "/"
        for module in library.modules {
          links = APIElement.module(module).determinePaths(for: localization)
            .mergedByOverwriting(from: links)
        }
      case .module(let module):
        path += localizedDirectoryName(for: localization) + "/"
        for child in module.children {
          links = child.determinePaths(for: localization).mergedByOverwriting(from: links)
        }
      case .type, .extension, .protocol:
        path += namespace + localizedDirectoryName(for: localization) + "/"
        var newNamespace = namespace
        newNamespace.append(contentsOf: localizedDirectoryName(for: localization) + "/")
        newNamespace.append(contentsOf: localizedFileName(for: localization) + "/")
        for child in children where child.receivesPage {
          links = child.determinePaths(for: localization, namespace: newNamespace)
            .mergedByOverwriting(from: links)
        }
      case .case, .initializer, .subscript, .operator, .precedence:
        path += namespace + localizedDirectoryName(for: localization) + "/"
      case .variable(let variable):
        path += namespace
          + localizedDirectoryName(
            for: localization,
            globalScope: namespace.isEmpty,
            typeMember: variable.declaration.isTypeMember()
          ) + "/"
      case .function(let function):
        path += namespace
          + localizedDirectoryName(
            for: localization,
            globalScope: namespace.isEmpty,
            typeMember: function.declaration.isTypeMember()
          ) + "/"
      case .conformance:
        unreachable()
      }

      path += localizedFileName(for: localization) + ".html"
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

  func parameters() -> [String] {
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
