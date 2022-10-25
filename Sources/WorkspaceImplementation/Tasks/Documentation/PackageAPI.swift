/*
 PackageAPI.swift

 This source file is part of the Workspace open source project.
 Diese Quelldatei ist Teil des quelloffenen Arbeitsbereich‐Projekt.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2018–2022 Jeremy David Giesbrecht and the Workspace project contributors.
 Urheberrecht ©2018–2022 Jeremy David Giesbrecht und die Mitwirkenden des Arbeitsbereich‐Projekts.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

#if !PLATFORM_NOT_SUPPORTED_BY_WORKSPACE_WORKSPACE
  import SDGControlFlow
  import SDGLogic

  import SDGSwiftDocumentation

  extension PackageAPI {

    internal func computeMergedAPI() {
      var types: [TypeAPI] = []
      var unprocessedExtensions: [ExtensionAPI] = []
      var protocols: [ProtocolAPI] = []
      var functions: [FunctionAPI] = []
      var globalVariables: [VariableAPI] = []
      var operators: [OperatorAPI] = []
      var precedenceGroups: [PrecedenceAPI] = []
      for module in modules {
        APIElement.module(module).homeProduct = Weak(
          libraries.first(where: { $0.modules.contains(module) })
        )
        for element in module.children {
          element.homeModule = Weak(module)

          switch element {
          case .package,  // @exempt(from: tests)
            .library,
            .module,
            .case,
            .initializer,
            .subscript,
            .conformance:
            break  // @exempt(from: tests) Should never occur.
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
          case .operator(let `operator`):
            operators.append(`operator`)
          case .precedence(let precedence):
            precedenceGroups.append(precedence)
          }
        }
      }

      var extensions: [ExtensionAPI] = []
      for `extension` in unprocessedExtensions {
        if ¬types.contains(where: { `extension`.isExtension(of: $0) }),
          ¬protocols.contains(where: { `extension`.isExtension(of: $0) }),
          ¬extensions.contains(where: { `extension`.extendsSameType(as: $0) })
        {
          extensions.append(`extension`)
        }
      }

      self.types = types.sorted()
      self.uniqueExtensions = extensions.sorted()
      self.protocols = protocols.sorted()
      self.functions = functions.sorted()
      self.globalVariables = globalVariables.sorted()
      self.operators = operators.sorted()
      self.precedenceGroups = precedenceGroups.sorted()
    }

    internal var types: [TypeAPI] {
      get {
        return APIElement.package(self).extendedProperties[.types]
          as? [TypeAPI] ?? []  // @exempt(from: tests) Should never be nil.
      }
      set {
        APIElement.package(self).extendedProperties[.types] = newValue
      }
    }

    internal var uniqueExtensions: [ExtensionAPI] {
      get {
        return APIElement.package(self).extendedProperties[.extensions]
          as? [ExtensionAPI] ?? []  // @exempt(from: tests) Should never be nil.
      }
      set {
        APIElement.package(self).extendedProperties[.extensions] = newValue
      }
    }

    internal var allExtensions: AnyBidirectionalCollection<ExtensionAPI> {
      return AnyBidirectionalCollection(modules.map({ $0.extensions }).joined())
    }

    internal var protocols: [ProtocolAPI] {
      get {
        return APIElement.package(self).extendedProperties[.protocols]
          as? [ProtocolAPI] ?? []  // @exempt(from: tests) Should never be nil.
      }
      set {
        APIElement.package(self).extendedProperties[.protocols] = newValue
      }
    }

    internal var functions: [FunctionAPI] {
      get {
        return APIElement.package(self).extendedProperties[.functions]
          as? [FunctionAPI] ?? []  // @exempt(from: tests) Should never be nil.
      }
      set {
        APIElement.package(self).extendedProperties[.functions] = newValue
      }
    }

    internal var globalVariables: [VariableAPI] {
      get {
        return APIElement.package(self).extendedProperties[.globalVariables] as? [VariableAPI]
          ?? []  // @exempt(from: tests) Should never be nil.
      }
      set {
        APIElement.package(self).extendedProperties[.globalVariables] = newValue
      }
    }

    internal var operators: [OperatorAPI] {
      get {
        return APIElement.package(self).extendedProperties[.operators]
          as? [OperatorAPI] ?? []  // @exempt(from: tests) Should never be nil.
      }
      set {
        APIElement.package(self).extendedProperties[.operators] = newValue
      }
    }

    internal var precedenceGroups: [PrecedenceAPI] {
      get {
        return APIElement.package(self).extendedProperties[.precedenceGroups]
          as? [PrecedenceAPI] ?? []  // @exempt(from: tests) Should never be nil.
      }
      set {
        APIElement.package(self).extendedProperties[.precedenceGroups] = newValue
      }
    }
  }
#endif
