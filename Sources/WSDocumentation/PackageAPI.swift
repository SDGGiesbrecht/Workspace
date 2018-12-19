/*
 PackageAPI.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2018 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import WSGeneralImports

import WSProject

import SDGSwiftSource

extension PackageAPI {

    internal func computeMergedAPI() {
        var types: [TypeAPI] = []
        var unprocessedExtensions: [ExtensionAPI] = []
        var protocols: [ProtocolAPI] = []
        var functions: [FunctionAPI] = []
        var globalVariables: [VariableAPI] = []
        for module in modules {
            for element in module.children {
                element.homeModule = Weak(module)

                switch element {
                case let type as TypeAPI:
                    types.append(type)
                case let `protocol` as ProtocolAPI:
                    protocols.append(`protocol`)
                case let `extension` as ExtensionAPI:
                    unprocessedExtensions.append(`extension`)
                case let function as FunctionAPI:
                    functions.append(function)
                case let globalVariable as VariableAPI:
                    globalVariables.append(globalVariable)
                default:
                    if BuildConfiguration.current == .debug { // @exempt(from: tests) Should never occur.
                        print("Unidentified API element: \(Swift.type(of: element))")
                    }
                }
            }
        }

        var extensions: [ExtensionAPI] = []
        for `extension` in unprocessedExtensions {
            if ¬types.contains(where: { `extension`.isExtension(of: $0) }),
                ¬protocols.contains(where: { `extension`.isExtension(of: $0) }),
                ¬extensions.contains(where: { `extension`.extendsSameType(as: $0) }) { // @exempt(from: tests) False coverage result in Xcode 9.4.1.
                extensions.append(`extension`)
            }
        }

        self.types = types.sorted()
        self.uniqueExtensions = extensions.sorted()
        self.protocols = protocols.sorted()
        self.functions = functions.sorted()
        self.globalVariables = globalVariables.sorted()
    }

    internal var types: [TypeAPI] {
        get {
            return extendedProperties[.types] as? [TypeAPI] ?? [] // @exempt(from: tests) Should never be nil.
        }
        set {
            extendedProperties[.types] = newValue
        }
    }

    internal var uniqueExtensions: [ExtensionAPI] {
        get {
            return extendedProperties[.extensions] as? [ExtensionAPI] ?? [] // @exempt(from: tests) Should never be nil.
        }
        set {
            extendedProperties[.extensions] = newValue
        }
    }

    internal var allExtensions: AnyBidirectionalCollection<ExtensionAPI> { // @exempt(from: tests) @workaround(Not used yet.)
        return AnyBidirectionalCollection(modules.map({ $0.extensions }).joined())
    }

    internal var protocols: [ProtocolAPI] {
        get {
            return extendedProperties[.protocols] as? [ProtocolAPI] ?? [] // @exempt(from: tests) Should never be nil.
        }
        set {
            extendedProperties[.protocols] = newValue
        }
    }

    internal var functions: [FunctionAPI] {
        get {
            return extendedProperties[.functions] as? [FunctionAPI] ?? [] // @exempt(from: tests) Should never be nil.
        }
        set {
            extendedProperties[.functions] = newValue
        }
    }

    internal var globalVariables: [VariableAPI] {
        get {
            return extendedProperties[.globalVariables] as? [VariableAPI] ?? [] // @exempt(from: tests) Should never be nil.
        }
        set {
            extendedProperties[.globalVariables] = newValue
        }
    }
}
