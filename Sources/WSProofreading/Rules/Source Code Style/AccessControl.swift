/*
 AccessControl.swift

 This source file is part of the Workspace open source project.
 Diese Quelldatei ist Teil des quelloffenen Arbeitsbereich‐Projekt.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2020 Jeremy David Giesbrecht and the Workspace project contributors.
 Urheberrecht ©2020 Jeremy David Giesbrecht und die Mitwirkenden des Arbeitsbereich‐Projekts.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGLogic
import SDGCollections
import WSGeneralImports

import WSProject

import SwiftSyntax
import SDGSwiftSource

internal struct AccessControl: SyntaxRule {

  internal static let identifier = UserFacing<StrictString, InterfaceLocalization>(
    { localization in
      switch localization {
      case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
        return "accessControl"
      case .deutschDeutschland:
        return "zugriffskontrolle"
      }
    })

  private static let libraryMessage = UserFacing<StrictString, InterfaceLocalization>({
    localization in
    switch localization {
    case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
      return "Every symbol in a library should have access control."
    case .deutschDeutschland:
      return "Jedes Symbol in einer Bibliotek soll Zugriffskontrolle haben."
    }
  })

  private static let extensionMessage = UserFacing<StrictString, InterfaceLocalization>({
    localization in
    switch localization {
    case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
      return "Access control belongs on individual symbols, not extensions."
    case .deutschDeutschland:
      return "Zugriffskontrolle gehört bei einzelne Sombole, nicht bei Erweiterungen."
    }
  })

  private static let otherMessage = UserFacing<StrictString, InterfaceLocalization>({
    localization in
    switch localization {
    case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
      return "Executables and tests should not contain access control."
    case .deutschDeutschland:
      return "Ausfürbare Dateien und Testen sollen keine Zugriffskontrolle enthalten."
    }
  })

  private static let highLevels: Set<String> = ["open", "public", "internal"]
  private static let lowLevels: Set<String> = ["fileprivate", "private"]
  private static let allLevels = highLevels ∪ lowLevels

  // #workaround(SwiftSyntax 0.50200.0, Cannot build.)
  #if !(os(Windows) || os(WASI) || os(Android))

    private static func checkLibrary(
      _ node: Syntax,
      context: SyntaxContext,
      file: TextFile,
      status: ProofreadingStatus
    ) {
      let modifiers: ModifierListSyntax?
      let anchor: Syntax
      if let structure = node.as(StructDeclSyntax.self) {
        modifiers = structure.modifiers
        anchor = Syntax(structure.identifier)
      } else if let `class` = node.as(ClassDeclSyntax.self) {
        modifiers = `class`.modifiers
        anchor = Syntax(`class`.identifier)
      } else if let enumeration = node.as(EnumDeclSyntax.self) {
        modifiers = enumeration.modifiers
        anchor = Syntax(enumeration.identifier)
      } else if let alias = node.as(TypealiasDeclSyntax.self) {
        modifiers = alias.modifiers
        anchor = Syntax(alias.identifier)
      } else if let `protocol` = node.as(ProtocolDeclSyntax.self) {
        modifiers = `protocol`.modifiers
        anchor = Syntax(`protocol`.identifier)
      } else if let function = node.as(FunctionDeclSyntax.self) {
        modifiers = function.modifiers
        anchor = Syntax(function.identifier)
      } else if let initializer = node.as(InitializerDeclSyntax.self) {
        modifiers = initializer.modifiers
        anchor = Syntax(initializer.initKeyword)
      } else if let variable = node.as(VariableDeclSyntax.self) {
        modifiers = variable.modifiers
        anchor = Syntax(variable.bindings)
      } else if let `subscript` = node.as(SubscriptDeclSyntax.self) {
        modifiers = `subscript`.modifiers
        anchor = Syntax(`subscript`.subscriptKeyword)
      } else {
        return
      }
      if ¬(modifiers?.contains(where: { $0.name.text ∈ allLevels }) ?? false),
        // Check if it is local...
        ¬node.ancestors().contains(where: { ancestor in
          ancestor.is(FunctionDeclSyntax.self)
            ∨ ancestor.is(InitializerDeclSyntax.self)
            ∨ ancestor.is(VariableDeclSyntax.self)
            ∨ ancestor.is(SubscriptDeclSyntax.self)
        }){
        reportViolation(
          in: file,
          at: anchor.syntaxRange(in: context),
          message: libraryMessage,
          status: status
        )
      }
    }

    private static func checkOther(
      _ node: Syntax,
      context: SyntaxContext,
      file: TextFile,
      status: ProofreadingStatus
    ) {
      if let modifier = node.as(DeclModifierSyntax.self) {
        if modifier.name.text ∈ highLevels {
          reportViolation(
            in: file,
            at: modifier.name.syntaxRange(in: context),
            replacementSuggestion: "",
            message: otherMessage,
            status: status
          )
        }
      }
    }

    private static func checkExtension(
      _ node: Syntax,
      context: SyntaxContext,
      file: TextFile,
      status: ProofreadingStatus
    ) {
      if let `extension` = node.as(ExtensionDeclSyntax.self),
        let modifiers = `extension`.modifiers
      {
        for modifier in modifiers {
          if modifier.name.text ∈ allLevels {
            reportViolation(
              in: file,
              at: modifier.name.syntaxRange(in: context),
              replacementSuggestion: "",
              message: extensionMessage,
              status: status
            )
          }
        }
      }
    }

    // MARK: - SyntaxRule

    internal static func check(
      _ node: Syntax,
      context: SyntaxContext,
      file: TextFile,
      setting: Setting,
      project: PackageRepository,
      status: ProofreadingStatus,
      output: Command.Output
    ) {

      switch setting {
      case .library:
        checkLibrary(node, context: context, file: file, status: status)
      case .topLevel:
        checkOther(node, context: context, file: file, status: status)
      case .unknown:
        break
      }

      checkExtension(node, context: context, file: file, status: status)
    }
  #endif
}
