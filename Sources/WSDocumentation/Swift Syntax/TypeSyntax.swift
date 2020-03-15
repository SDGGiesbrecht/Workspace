/*
 TypeSyntax.swift

 This source file is part of the Workspace open source project.
 Diese Quelldatei ist Teil des quelloffenen Arbeitsbereich‐Projekt.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2019–2020 Jeremy David Giesbrecht and the Workspace project contributors.
 Urheberrecht ©2019–2020 Jeremy David Giesbrecht und die Mitwirkenden des Arbeitsbereich‐Projekts.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGLogic
import WSGeneralImports

#if !(os(Windows) || os(Android))  // #workaround(SwiftSyntax 0.50100.0, Cannot build.)
  import SwiftSyntax
#endif
import SDGSwiftSource

#if !(os(Windows) || os(Android))  // #workaround(SwiftSyntax 0.50100.0, Cannot build.)
  extension TypeSyntax {

    internal func parameterNames() -> [String] {
      switch self {
      case let simple as SimpleTypeIdentifierSyntax:
        var result: [String] = []
        if let genericArgumentClause = simple.genericArgumentClause {
          for argument in genericArgumentClause.arguments {
            result.append(contentsOf: argument.argumentType.parameterNames())
          }
        }
        return result
      case let metatype as MetatypeTypeSyntax:
        return metatype.baseType.parameterNames()
      case let member as MemberTypeIdentifierSyntax:
        return member.baseType.parameterNames()
      case let optional as OptionalTypeSyntax:
        return optional.wrappedType.parameterNames()
      case let implicitlyUnwrapped as ImplicitlyUnwrappedOptionalTypeSyntax:
        return implicitlyUnwrapped.wrappedType.parameterNames()
      case let tuple as TupleTypeSyntax:
        var result: [String] = []
        for element in tuple.elements {
          result.append(contentsOf: element.parameterNames())
        }
        return result
      case let composition as CompositionTypeSyntax:
        var result: [String] = []
        for element in composition.elements {
          result.append(contentsOf: element.type.parameterNames())
        }
        return result
      case let array as ArrayTypeSyntax:
        return array.elementType.parameterNames()
      case let dictionary as DictionaryTypeSyntax:
        return dictionary.keyType.parameterNames() + dictionary.valueType.parameterNames()
      case let function as FunctionTypeSyntax:
        var result: [String] = []
        for element in function.arguments {
          result.append(contentsOf: element.parameterNames())
        }
        return result
      case let attributed as AttributedTypeSyntax:
        return attributed.baseType.parameterNames()
      default:  // @exempt(from: tests)
        // @exempt(from: tests)
        warnUnidentified()
        return []
      }
    }
  }
#endif
