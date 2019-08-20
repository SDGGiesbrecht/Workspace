/*
 APIElement.swift

 This source file is part of the Workspace open source project.
 Diese Quelldatei ist Teil des qeulloffenen Workspace‐Projekt.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2018–2019 Jeremy David Giesbrecht and the Workspace project contributors.
 Urheberrecht ©2018–2019 Jeremy David Giesbrecht und die Mitwirkenden des Workspace‐Projekts.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGLogic
import SDGMathematics
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
                return "Package" // From “let ... = Package(...)”
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
                return "library" // From “products: [.library(...)]”
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
                return "target" // From “targets: [.target(...)]”
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
            default: // @exempt(from: tests)
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
        case localizedEquivalentFileNames
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
            return (extendedProperties[.localizedDocumentation] as? [LocalizationIdentifier: DocumentationSyntax]) ?? [:] // @exempt(from: tests) Never nil.
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

    internal var localizedEquivalentFileNames: [LocalizationIdentifier: StrictString] {
        get {
            return (extendedProperties[.localizedEquivalentFileNames] as? [LocalizationIdentifier: StrictString]) ?? [:]
        }
        nonmutating set {
            extendedProperties[.localizedEquivalentFileNames] = newValue
        }
    }

    internal var localizedEquivalentPaths: [LocalizationIdentifier: StrictString] {
        get {
            return (extendedProperties[.localizedEquivalentPaths] as? [LocalizationIdentifier: StrictString]) ?? [:]
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
        return localizedEquivalentPaths[localization] == nil
    }

    internal var relativePagePath: [LocalizationIdentifier: StrictString] {
        get {
            return (extendedProperties[.relativePagePath] as? [LocalizationIdentifier: StrictString]) ?? [:]
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
            return (extendedProperties[.homeProduct] as? Weak<LibraryAPI>) ?? Weak<LibraryAPI>(nil) // @exempt(from: tests) Should never be nil.
        }
        nonmutating set {
            extendedProperties[.homeProduct] = newValue
        }
    }

    // MARK: - Localization

    internal func determine(localizations: [LocalizationIdentifier]) {
        if case .package = self { // Not handled by any parent.
            for localization in localizations {
                localizedEquivalentFileNames[localization] = fileName
            }
        }
        let parsed = documentation.resolved(localizations: localizations)
        localizedDocumentation = parsed.documentation
        crossReference = parsed.crossReference
        var groups: [StrictString: [APIElement]] = [:]
        for child in children {
            child.determine(localizations: localizations)
            if let crossReference = child.crossReference {
                groups[crossReference, default: []].append(child)
            }
        }
        for (_, group) in groups {
            for indexA in group.indices {
                for indexB in group.indices {
                    group[indexA].addLocalizations(from: group[indexB], isSame: indexA == indexB)
                }
            }
        }
    }

    private func addLocalizations(from other: APIElement, isSame: Bool) {
        for (localization, _) in other.localizedDocumentation {
            localizedEquivalentFileNames[localization] = other.fileName
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
                for indexB in group.indices {
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

    internal func pageURL(in outputDirectory: URL, for localization: LocalizationIdentifier) -> URL {
        return outputDirectory.appendingPathComponent(String(relativePagePath[localization]!))
    }

    internal func determinePaths(for localization: LocalizationIdentifier, namespace: StrictString = "") -> [String: String] {
        return autoreleasepool {

            var links: [String: String] = [:]
            var path = localization._directoryName + "/"

            switch self {
            case .package(let package):
                for library in package.libraries {
                    links = APIElement.library(library).determinePaths(for: localization).mergedByOverwriting(from: links)
                }
            case .library(let library):
                let librariesDirectoryName: StrictString
                if let match = localization._reasonableMatch {
                    switch match {
                    case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                        librariesDirectoryName = "Libraries"
                    case .deutschDeutschland:
                        librariesDirectoryName = "Biblioteken"
                    }
                } else {
                    librariesDirectoryName = "library" // From “products: [.library(...)]”
                }
                path += librariesDirectoryName + "/"

                for module in library.modules {
                    links = APIElement.module(module).determinePaths(for: localization).mergedByOverwriting(from: links)
                }
            case .module(let module):
                let modulesDirectoryName: StrictString
                if let match = localization._reasonableMatch {
                    switch match {
                    case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                        modulesDirectoryName = "Modules"
                    case .deutschDeutschland:
                        modulesDirectoryName = "Module"
                    }
                } else {
                    modulesDirectoryName = "target" // From “targets: [.target(...)]”
                }
                path += modulesDirectoryName + "/"

                for child in module.children {
                    links = child.determinePaths(for: localization).mergedByOverwriting(from: links)
                }
            case .type:
                let typesDirectoryName: StrictString
                if let match = localization._reasonableMatch {
                    switch match {
                    case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                        typesDirectoryName = "Types"
                    case .deutschDeutschland:
                        typesDirectoryName = "Typen"
                    }
                } else {
                    typesDirectoryName = "struct"
                }
                path += namespace + typesDirectoryName + "/"

                var newNamespace = namespace
                newNamespace.append(contentsOf: typesDirectoryName + "/")
                newNamespace.append(contentsOf: localizedEquivalentFileNames[localization]! + "/")
                for child in children where child.receivesPage {
                    links = child.determinePaths(for: localization, namespace: newNamespace).mergedByOverwriting(from: links)
                }
            case .extension:
                let extensionsDirectoryName: StrictString
                if let match = localization._reasonableMatch {
                    switch match {
                    case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                        extensionsDirectoryName = "Extensions"
                    case .deutschDeutschland:
                        extensionsDirectoryName = "Erweiterungen"
                    }
                } else {
                    extensionsDirectoryName = "extension"
                }
                path += namespace + extensionsDirectoryName + "/"

                var newNamespace = namespace
                newNamespace.append(contentsOf: extensionsDirectoryName + "/")
                newNamespace.append(contentsOf: localizedEquivalentFileNames[localization]! + "/")
                for child in children where child.receivesPage {
                    links = child.determinePaths(for: localization, namespace: newNamespace).mergedByOverwriting(from: links)
                }
            case .protocol:
                let protocolsDirectoryName: StrictString
                if let match = localization._reasonableMatch {
                    switch match {
                    case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                        protocolsDirectoryName = "Protocols"
                    case .deutschDeutschland:
                        protocolsDirectoryName = "Protokolle"
                    }
                } else {
                    protocolsDirectoryName = "protocol"
                }
                path += namespace + protocolsDirectoryName + "/"

                var newNamespace = namespace
                newNamespace.append(contentsOf: protocolsDirectoryName + "/")
                newNamespace.append(contentsOf: localizedEquivalentFileNames[localization]! + "/")
                for child in children where child.receivesPage {
                    links = child.determinePaths(for: localization, namespace: newNamespace).mergedByOverwriting(from: links)
                }
            case .case:
                let casesDirectoryName: StrictString
                if let match = localization._reasonableMatch {
                    switch match {
                    case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                        casesDirectoryName = "Cases"
                    case .deutschDeutschland:
                        casesDirectoryName = "Fälle"
                    }
                } else {
                    casesDirectoryName = "case"
                }
                path += namespace + casesDirectoryName + "/"
            case .initializer:
                let initializersDirectoryName: StrictString
                if let match = localization._reasonableMatch {
                    switch match {
                    case .englishUnitedKingdom:
                        initializersDirectoryName = "Initialisers"
                    case .englishUnitedStates, .englishCanada:
                        initializersDirectoryName = "Initializers"
                    case .deutschDeutschland:
                        initializersDirectoryName = "Voreinsteller"
                    }
                } else {
                    initializersDirectoryName = "init"
                }
                path += namespace + initializersDirectoryName + "/"
            case .variable(let variable):
                let variablesDirectoryName: StrictString

                if namespace.isEmpty {
                    if let match = localization._reasonableMatch {
                        switch match {
                        case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                            variablesDirectoryName = "Global Variables"
                        case .deutschDeutschland:
                            variablesDirectoryName = "globale Variablen"
                        }
                    } else {
                        variablesDirectoryName = "var"
                    }
                } else {
                    if variable.declaration.isTypeMember() {
                        if let match = localization._reasonableMatch {
                            switch match {
                            case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                                variablesDirectoryName = "Type Properties"
                            case .deutschDeutschland:
                                variablesDirectoryName = "Typ‐Eigenschaften"
                            }
                        } else {
                            variablesDirectoryName = "static var"
                        }
                    } else {
                        if let match = localization._reasonableMatch {
                            switch match {
                            case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                                variablesDirectoryName = "Properties"
                            case .deutschDeutschland:
                                variablesDirectoryName = "Eigenschaften"
                            }
                        } else {
                            variablesDirectoryName = "var"
                        }
                    }
                }
                path += namespace + variablesDirectoryName + "/"
            case .subscript:
                let subscriptsDirectoryName: StrictString
                if let match = localization._reasonableMatch {
                    switch match {
                    case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                        subscriptsDirectoryName = "Subscripts"
                    case .deutschDeutschland:
                        subscriptsDirectoryName = "Indexe"
                    }
                } else {
                    subscriptsDirectoryName = "subscript"
                }
                path += namespace + subscriptsDirectoryName + "/"
            case .function(let function):
                let functionsDirectoryName: StrictString

                if namespace.isEmpty {
                    if let match = localization._reasonableMatch {
                        switch match {
                        case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                            functionsDirectoryName = "Functions"
                        case .deutschDeutschland:
                            functionsDirectoryName = "Funktionen"
                        }
                    } else {
                        functionsDirectoryName = "func"
                    }
                } else {
                    if function.declaration.isTypeMember() {
                        if let match = localization._reasonableMatch {
                            switch match {
                            case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                                functionsDirectoryName = "Type Methods"
                            case .deutschDeutschland:
                                functionsDirectoryName = "Typ‐Methoden"
                            }
                        } else {
                            functionsDirectoryName = "static func"
                        }
                    } else {
                        if let match = localization._reasonableMatch {
                            switch match {
                            case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                                functionsDirectoryName = "Methods"
                            case .deutschDeutschland:
                                functionsDirectoryName = "Methoden"
                            }
                        } else {
                            functionsDirectoryName = "func"
                        }
                    }
                }
                path += namespace + functionsDirectoryName + "/"
            case .operator:
                let operatorsDirectoryName: StrictString
                if let match = localization._reasonableMatch {
                    switch match {
                    case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                        operatorsDirectoryName = "Operators"
                    case .deutschDeutschland:
                        operatorsDirectoryName = "Operatoren"
                    }
                } else {
                    operatorsDirectoryName = "operator"
                }
                path += namespace + operatorsDirectoryName + "/"
            case .precedence:
                let precedenceGroupsDirectoryName: StrictString
                if let match = localization._reasonableMatch {
                    switch match {
                    case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                        precedenceGroupsDirectoryName = "Precedence Groups"
                    case .deutschDeutschland:
                        precedenceGroupsDirectoryName = "Rangfolgenklassen"
                    }
                } else {
                    precedenceGroupsDirectoryName = "precedencegroup"
                }
                path += namespace + precedenceGroupsDirectoryName + "/"
            case .conformance:
                unreachable()
            }

            path += localizedEquivalentFileNames[localization]! + ".html"
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
        case .package, .library, .module, .type, .protocol, .extension, .case, .operator, .precedence, .conformance:
            return []
        case .variable(let variable):

            // #workaround(SwiftSyntax 0.50000.0, Works around invalid index.)
            guard let typeAnnotation = variable.declaration.bindings.first?.typeAnnotation,
                typeAnnotation.source() ≠ "" else {
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
