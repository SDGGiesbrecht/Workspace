/*
 APIElement.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2018–2019 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGLogic
import SDGMathematics
import WSGeneralImports

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
                }
            } else {
                return "Package" // From “let ... = Package(...)”
            }
        case .library:
            if let match = localization._reasonableMatch {
                switch match {
                case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                    return "Library Product"
                }
            } else {
                return "library" // From “products: [.library(...)]”
            }
        case .module:
            if let match = localization._reasonableMatch {
                switch match {
                case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                    return "Module"
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
                    }
                } else {
                    return "class"
                }
            case is StructDeclSyntax:
                if let match = localization._reasonableMatch {
                    switch match {
                    case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                        return "Structure"
                    }
                } else {
                    return "struct"
                }
            case is EnumDeclSyntax:
                if let match = localization._reasonableMatch {
                    switch match {
                    case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                        return "Enumeration"
                    }
                } else {
                    return "enum"
                }
            case is TypealiasDeclSyntax:
                if let match = localization._reasonableMatch {
                    switch match {
                    case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                        return "Type Alias"
                    }
                } else {
                    return "typealias"
                }
            case is AssociatedtypeDeclSyntax:
                if let match = localization._reasonableMatch {
                    switch match {
                    case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                        return "Associated Type"
                    }
                } else {
                    return "associatedtype"
                }
            default:
                if BuildConfiguration.current == .debug { // @exempt(from: tests)
                    print("Unrecognized type declaration: \(Swift.type(of: type.genericDeclaration))")
                }
                return ""
            }
        case .extension:
            if let match = localization._reasonableMatch {
                switch match {
                case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                    return "Extension"
                }
            } else {
                return "extension"
            }
        case .protocol:
            if let match = localization._reasonableMatch {
                switch match {
                case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                    return "Protocol"
                }
            } else {
                return "protocol"
            }
        case .case:
            if let match = localization._reasonableMatch {
                switch match {
                case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                    return "Case"
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
                        }
                    } else {
                        return "var"
                    }
                } else {
                    if let match = localization._reasonableMatch {
                        switch match {
                        case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                            return "Instance Property"
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
                        }
                    } else {
                        return "func"
                    }
                } else {
                    if let match = localization._reasonableMatch {
                        switch match {
                        case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                            return "Instance Method"
                        }
                    } else {
                        return "func"
                    }
                }
            }
        case .conformance:
            unreachable()
        }
    }

    // MARK: - Properties

    internal enum ExtendedPropertyKey {
        case relativePagePath
        case types
        case `extensions`
        case protocols
        case functions
        case globalVariables
        case homeModule
    }
    internal var extendedProperties: [ExtendedPropertyKey: Any] {
        get {
            return (userInformation as? [ExtendedPropertyKey: Any]) ?? [:]
        }
        nonmutating set {
            userInformation = newValue
        }
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
        get { // @exempt(from: tests) #workaround(Not used yet.)
            return (extendedProperties[.homeModule] as? Weak<ModuleAPI>) ?? Weak<ModuleAPI>(nil)
        }
        nonmutating set {
            extendedProperties[.homeModule] = newValue
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
                    }
                } else {
                    typesDirectoryName = "struct"
                }
                path += namespace + typesDirectoryName + "/"

                var newNamespace = namespace
                newNamespace.append(contentsOf: typesDirectoryName + "/")
                newNamespace.append(contentsOf: fileName + "/")
                for child in children where child.receivesPage {
                    links = child.determinePaths(for: localization, namespace: newNamespace).mergedByOverwriting(from: links)
                }
            case .extension:
                let extensionsDirectoryName: StrictString
                if let match = localization._reasonableMatch {
                    switch match {
                    case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                        extensionsDirectoryName = "Extensions"
                    }
                } else {
                    extensionsDirectoryName = "extension"
                }
                path += namespace + extensionsDirectoryName + "/"

                var newNamespace = namespace
                newNamespace.append(contentsOf: extensionsDirectoryName + "/")
                newNamespace.append(contentsOf: fileName + "/")
                for child in children where child.receivesPage {
                    links = child.determinePaths(for: localization, namespace: newNamespace).mergedByOverwriting(from: links)
                }
            case .protocol:
                let protocolsDirectoryName: StrictString
                if let match = localization._reasonableMatch {
                    switch match {
                    case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                        protocolsDirectoryName = "Protocols"
                    }
                } else {
                    protocolsDirectoryName = "protocol"
                }
                path += namespace + protocolsDirectoryName + "/"

                var newNamespace = namespace
                newNamespace.append(contentsOf: protocolsDirectoryName + "/")
                newNamespace.append(contentsOf: fileName + "/")
                for child in children where child.receivesPage {
                    links = child.determinePaths(for: localization, namespace: newNamespace).mergedByOverwriting(from: links)
                }
            case .case:
                let casesDirectoryName: StrictString
                if let match = localization._reasonableMatch {
                    switch match {
                    case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                        casesDirectoryName = "Cases"
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
                            }
                        } else {
                            variablesDirectoryName = "static var"
                        }
                    } else {
                        if let match = localization._reasonableMatch {
                            switch match {
                            case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                                variablesDirectoryName = "Properties"
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
                            }
                        } else {
                            functionsDirectoryName = "static func"
                        }
                    } else {
                        if let match = localization._reasonableMatch {
                            switch match {
                            case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                                functionsDirectoryName = "Methods"
                            }
                        } else {
                            functionsDirectoryName = "func"
                        }
                    }
                }
                path += namespace + functionsDirectoryName + "/"
            case .conformance:
                unreachable()
            }

            path += fileName + ".html"
            relativePagePath[localization] = path
            if case .type = self {
                links[name.source().truncated(before: "<")] = String(path)
            } else {
                links[name.source()] = String(path)
            }
            return links
        }
    }

    // MARK: - SDGSwiftSource

    // #workaround(SDGSwift 0.4.0, This belongs in SDGSwiftSource.)
    internal var documentation: DocumentationSyntax? {
        switch self {
        case .package(let package):
            return package.documentation
        case .library(let library):
            return library.documentation
        case .module(let module):
            return module.documentation
        case .type(let type):
            return type.documentation
        case .protocol(let `protocol`):
            return `protocol`.documentation
        case .extension(let `extension`):
            return `extension`.documentation
        case .case(let `case`):
            return `case`.documentation
        case .initializer(let initializer):
            return initializer.documentation
        case .variable(let variable):
            return variable.documentation
        case .subscript(let `subscript`):
            return `subscript`.documentation
        case .function(let function):
            return function.documentation
        case .conformance(let conformance):
            return conformance.documentation // @exempt(from: tests) Should never occur.
        }
    }
}
