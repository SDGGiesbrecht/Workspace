/*
 PackageAPI.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2018–2019 Jeremy David Giesbrecht and the Workspace project contributors.

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
                case .package, .library, .module, .case, .initializer, .subscript, .conformance:
                    break // @exempt(from: tests) Should never occur.
                case .type(let type):
                    types.append(type)
                case .protocol(let `protocol`):
                    protocols.append(`protocol`)
                case .extension(let `extension`):
                    unprocessedExtensions.append(`extension`)
                case .function(let function):
                    functions.append(function)
                case .variable(let globalVariable):
                    globalVariables.append(globalVariable)
                }
            }
        }

        var extensions: [ExtensionAPI] = []
        for `extension` in unprocessedExtensions {
            if ¬types.contains(where: { `extension`.isExtension(of: $0) }),
                ¬protocols.contains(where: { `extension`.isExtension(of: $0) }),
                ¬extensions.contains(where: { `extension`.extendsSameType(as: $0) }) {
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
            return APIElement.package(self).extendedProperties[.types] as? [TypeAPI] ?? [] // @exempt(from: tests) Should never be nil.
        }
        set {
            APIElement.package(self).extendedProperties[.types] = newValue
        }
    }

    internal var uniqueExtensions: [ExtensionAPI] {
        get {
            return APIElement.package(self).extendedProperties[.extensions] as? [ExtensionAPI] ?? [] // @exempt(from: tests) Should never be nil.
        }
        set {
            APIElement.package(self).extendedProperties[.extensions] = newValue
        }
    }

    internal var allExtensions: AnyBidirectionalCollection<ExtensionAPI> { // @exempt(from: tests) #workaround(Not used yet.)
        return AnyBidirectionalCollection(modules.map({ $0.extensions }).joined())
    }

    internal var protocols: [ProtocolAPI] {
        get {
            return APIElement.package(self).extendedProperties[.protocols] as? [ProtocolAPI] ?? [] // @exempt(from: tests) Should never be nil.
        }
        set {
            APIElement.package(self).extendedProperties[.protocols] = newValue
        }
    }

    internal var functions: [FunctionAPI] {
        get {
            return APIElement.package(self).extendedProperties[.functions] as? [FunctionAPI] ?? [] // @exempt(from: tests) Should never be nil.
        }
        set {
            APIElement.package(self).extendedProperties[.functions] = newValue
        }
    }

    internal var globalVariables: [VariableAPI] {
        get {
            return APIElement.package(self).extendedProperties[.globalVariables] as? [VariableAPI] ?? [] // @exempt(from: tests) Should never be nil.
        }
        set {
            APIElement.package(self).extendedProperties[.globalVariables] = newValue
        }
    }
}
