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
  import SymbolKit

  extension PackageAPI {

    internal func computeMergedAPI(
      extensionStorage: inout [String: SymbolGraph.Symbol.ExtendedProperties]
    ) {
      var types: [SymbolGraph.Symbol] = []
      var unprocessedExtensions: Set<String> = []
      var protocols: [SymbolGraph.Symbol] = []
      var functions: [SymbolGraph.Symbol] = []
      var globalVariables: [SymbolGraph.Symbol] = []
      var operators: [Operator] = []
      var precedenceGroups: [PrecedenceGroup] = []
      for module in modules {
        extensionStorage[module.extendedPropertiesIndex, default: .default].homeProduct
        = libraries.first(where: { library in
          return library.modules.contains(where: { moduleName in
            return moduleName == module.names.title
          })
        })

        func handle<Child>(child: Child) where Child: SymbolLike {
          extensionStorage[child.extendedPropertiesIndex, default: .default].homeModule = module
        }
        for graph in module.symbolGraphs {
          for symbol in graph.symbols.values {
            handle(child: symbol)
            switch symbol.kind.identifier {
            case .associatedtype, .deinit, .case, .`init`, .ivar, .macro, .method, .property, .snippet, .snippetGroup, .subscript, .typeMethod, .typeProperty, .typeSubscript, .module, .unknown:
              break
            case .class, .enum, .struct, .typealias:
              types.append(symbol)
            case .func, .operator:
              functions.append(symbol)
            case .protocol:
              protocols.append(symbol)
            case .var:
              globalVariables.append(symbol)
            }
          }
          for relationship in graph.relationships
          where relationship.kind == .memberOf {
            unprocessedExtensions.insert(relationship.target)
          }
        }
        for `operator` in module.operators {
          handle(child: `operator`)
          operators.append(`operator`)
        }
        for precedenceGroup in module.precedenceGroups {
          handle(child: precedenceGroup)
          precedenceGroups.append(precedenceGroup)
        }
      }

      var extensions: Set<String> = unprocessedExtensions
      for type in [types, protocols].lazy.joined() {
        extensions.remove(type.identifier.precise)
      }

      {
        var storage = extensionStorage[extendedPropertiesIndex, default: .default]
        storage.packageTypes = types.sorted(by: { $0.names.title < $1.names.title })
        storage.packageExtensions = extensions.sorted()
        storage.packageProtocols = protocols.sorted(by: { $0.names.title < $1.names.title })
        storage.packageFunctions = functions.sorted(by: { $0.names.title < $1.names.title })
        storage.packageGlobalVariables = globalVariables.sorted(by: { $0.names.title < $1.names.title })
        storage.packageOperators = operators.sorted()
        storage.packagePrecedenceGroups = precedenceGroups.sorted()
        extensionStorage[extendedPropertiesIndex] = storage
      }()
    }
  }
#endif
