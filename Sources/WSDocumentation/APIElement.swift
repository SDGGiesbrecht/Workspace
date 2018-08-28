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
import WSGeneralImports

import SDGSwiftSource

import WSProject

extension APIElement {

    // MARK: - Symbol Types

    internal func symbolType(localization: LocalizationIdentifier) -> StrictString {
        switch self {
        case is PackageAPI :
            if let match = localization._reasonableMatch {
                switch match {
                case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                    return "Package"
                }
            } else {
                return "Package" // From “let ... = Package(...)”
            }
        case is LibraryAPI :
            if let match = localization._reasonableMatch {
                switch match {
                case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                    return "Library Product"
                }
            } else {
                return "library" // From “products: [.library(...)]”
            }
        case let type as TypeAPI :
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
            default:
                if BuildConfiguration.current == .debug {
                    print("Unrecognized type keyword: \(type.keyword)")
                }
                return ""
            }
        default:
            if BuildConfiguration.current == .debug {
                print("Unrecognized symbol type: \(type(of: self))")
            }
            return ""
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

    internal var relativePagePath: [LocalizationIdentifier: StrictString] {
        get {
            return (userInformation as? [LocalizationIdentifier: StrictString]) ?? [:]
        }
        set {
            userInformation = newValue
        }
    }

    internal func pageURL(in outputDirectory: URL, for localization: LocalizationIdentifier) -> URL {
        return outputDirectory.appendingPathComponent(String(relativePagePath[localization]!))
    }

    internal func determinePaths(for localization: LocalizationIdentifier, namespace: StrictString = "") -> [String: String] {
        var links: [String: String] = [:]
        var path = localization.directoryName + "/"

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
            if BuildConfiguration.current == .debug {
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
