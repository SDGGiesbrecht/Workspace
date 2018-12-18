/*
 APIElement.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2018 Jeremy David Giesbrecht and the Workspace project contributors.

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
        case is PackageAPI:
            if let match = localization._reasonableMatch {
                switch match {
                case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                    return "Package"
                }
            } else {
                return "Package" // From “let ... = Package(...)”
            }
        case is LibraryAPI:
            if let match = localization._reasonableMatch {
                switch match {
                case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                    return "Library Product"
                }
            } else {
                return "library" // From “products: [.library(...)]”
            }
        case is ModuleAPI:
            if let match = localization._reasonableMatch {
                switch match {
                case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                    return "Module"
                }
            } else {
                return "target" // From “targets: [.target(...)]”
            }
        case let type as TypeAPI:
            switch type.keyword {
            case .classKeyword:
                if let match = localization._reasonableMatch {
                    switch match {
                    case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                        return "Class"
                    }
                } else {
                    return "class"
                }
            case .structKeyword:
                if let match = localization._reasonableMatch {
                    switch match {
                    case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                        return "Structure"
                    }
                } else {
                    return "struct"
                }
            case .enumKeyword:
                if let match = localization._reasonableMatch {
                    switch match {
                    case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                        return "Enumeration"
                    }
                } else {
                    return "enum"
                }
            case .typealiasKeyword:
                if let match = localization._reasonableMatch {
                    switch match {
                    case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                        return "Type Alias"
                    }
                } else {
                    return "typealias"
                }
            case .associatedtypeKeyword:
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
                    print("Unrecognized type keyword: \(type.keyword)")
                }
                return ""
            }
        case is ExtensionAPI:
            if let match = localization._reasonableMatch {
                switch match {
                case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                    return "Extension"
                }
            } else {
                return "extension"
            }
        case is ProtocolAPI:
            if let match = localization._reasonableMatch {
                switch match {
                case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                    return "Protocol"
                }
            } else {
                return "protocol"
            }
        case is CaseAPI:
            if let match = localization._reasonableMatch {
                switch match {
                case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                    return "Case"
                }
            } else {
                return "case"
            }
        case is InitializerAPI:
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
        case let variable as VariableAPI:
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
                if variable.typePropertyKeyword ≠ nil {
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
        case is SubscriptAPI:
            if let match = localization._reasonableMatch {
                switch match {
                case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                    return "Subscript"
                }
            } else {
                return "subscript"
            }
        case let function as FunctionAPI:
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
                if function.typeMethodKeyword ≠ nil {
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
        default:
            if BuildConfiguration.current == .debug { // @exempt(from: tests)
                print("Unrecognized symbol type: \(type(of: self))")
            }
            return ""
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
        set {
            userInformation = newValue
        }
    }

    internal var relativePagePath: [LocalizationIdentifier: StrictString] {
        get {
            return (extendedProperties[.relativePagePath] as? [LocalizationIdentifier: StrictString]) ?? [:]
        }
        set {
            extendedProperties[.relativePagePath] = newValue
        }
    }

    internal var homeModule: Weak<ModuleAPI> {
        get { // @exempt(from: tests) #workaround(Not used yet.)
            return (extendedProperties[.homeModule] as? Weak<ModuleAPI>) ?? Weak<ModuleAPI>(nil)
        }
        set {
            extendedProperties[.homeModule] = newValue
        }
    }

    // MARK: - Paths

    internal var receivesPage: Bool {
        if self is ConformanceAPI {
            return false
        }
        return true
    }

    private var fileName: StrictString {
        return Page.sanitize(fileName: StrictString(name))
    }

    internal func pageURL(in outputDirectory: URL, for localization: LocalizationIdentifier) -> URL {
        return outputDirectory.appendingPathComponent(String(relativePagePath[localization]!))
    }

    internal func determinePaths(for localization: LocalizationIdentifier, namespace: StrictString = "") -> [String: String] {
        return autoreleasepool {

            var links: [String: String] = [:]
            var path = localization._directoryName + "/"

            switch self {
            case let package as PackageAPI :
                for library in package.libraries {
                    links = library.determinePaths(for: localization).mergedByOverwriting(from: links)
                }
            case let library as LibraryAPI :
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
                    links = module.determinePaths(for: localization).mergedByOverwriting(from: links)
                }
            case let module as ModuleAPI :
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
            case is TypeAPI :
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
            case is ExtensionAPI :
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
            case is ProtocolAPI :
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
            case is CaseAPI :
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
            case is InitializerAPI :
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
            case let variable as VariableAPI :
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
                    if variable.typePropertyKeyword ≠ nil {
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
            case is SubscriptAPI :
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
            case let function as FunctionAPI :
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
                    if function.typeMethodKeyword ≠ nil {
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
            default:
                if BuildConfiguration.current == .debug { // @exempt(from: tests)
                    print("Unrecognized symbol type: \(type(of: self))")
                }
            }

            path += fileName + ".html"
            relativePagePath[localization] = path
            if let type = self as? TypeAPI {
                links[type.name.truncated(before: "<")] = String(path)
            } else {
                links[name] = String(path)
            }
            return links
        }
    }
}
