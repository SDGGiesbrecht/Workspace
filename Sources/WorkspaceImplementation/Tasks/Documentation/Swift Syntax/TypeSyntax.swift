/*
 TypeSyntax.swift

 This source file is part of the Workspace open source project.
 Diese Quelldatei ist Teil des quelloffenen Arbeitsbereich‐Projekt.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2019–2021 Jeremy David Giesbrecht and the Workspace project contributors.
 Urheberrecht ©2019–2021 Jeremy David Giesbrecht und die Mitwirkenden des Arbeitsbereich‐Projekts.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

#if !PLATFORM_NOT_SUPPORTED_BY_WORKSPACE_WORKSPACE
import SDGLogic

  import SwiftSyntax
import SDGSwiftSource

  extension TypeSyntax {

    internal func parameterNames() -> [String] {
      if let simple = self.as(SimpleTypeIdentifierSyntax.self) {
        var result: [String] = []
        if let genericArgumentClause = simple.genericArgumentClause {
          for argument in genericArgumentClause.arguments {
            result.append(contentsOf: argument.argumentType.parameterNames())
          }
        }
        return result
      } else if let metatype = self.as(MetatypeTypeSyntax.self) {
        return metatype.baseType.parameterNames()
      } else if let member = self.as(MemberTypeIdentifierSyntax.self) {
        return member.baseType.parameterNames()
      } else if let optional = self.as(OptionalTypeSyntax.self) {
        return optional.wrappedType.parameterNames()
      } else if let implicitlyUnwrapped = self.as(ImplicitlyUnwrappedOptionalTypeSyntax.self) {
        return implicitlyUnwrapped.wrappedType.parameterNames()
      } else if let tuple = self.as(TupleTypeSyntax.self) {
        var result: [String] = []
        for element in tuple.elements {
          result.append(contentsOf: element.parameterNames())
        }
        return result
      } else if let composition = self.as(CompositionTypeSyntax.self) {
        var result: [String] = []
        for element in composition.elements {
          result.append(contentsOf: element.type.parameterNames())
        }
        return result
      } else if let array = self.as(ArrayTypeSyntax.self) {
        return array.elementType.parameterNames()
      } else if let dictionary = self.as(DictionaryTypeSyntax.self) {
        return dictionary.keyType.parameterNames() + dictionary.valueType.parameterNames()
      } else if let function = self.as(FunctionTypeSyntax.self) {
        var result: [String] = []
        for element in function.arguments {
          result.append(contentsOf: element.parameterNames())
        }
        return result
      } else if let attributed = self.as(AttributedTypeSyntax.self) {
        return attributed.baseType.parameterNames()
      } else {  // @exempt(from: tests)
        // @exempt(from: tests)
        warnUnidentified()
        return []
      }
    }
  }
#endif
