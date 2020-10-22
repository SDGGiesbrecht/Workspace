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
import SDGText
import SDGLocalization

import SDGCommandLine

import SDGSwift

import WorkspaceLocalizations

// #workaround(SwiftSyntax 0.50200.0, Cannot build.)
#if !(os(Windows) || os(WASI) || os(Android))
  import SwiftSyntax
#endif
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

  private static let libraryMessage = UserFacing<StrictString, InterfaceLocalization>(
    { localization in
      switch localization {
      case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
        return "Every symbol in a library should have access control."
      case .deutschDeutschland:
        return "Jedes Symbol in einer Bibliotek soll Zugriffskontrolle haben."
      }
    })

  private static let otherMessage = UserFacing<StrictString, InterfaceLocalization>(
    { localization in
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
      guard ¬context.isFragmented() else {
        return  // Documentation example
      }

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
        ¬node.ancestors().contains(where: { ancestor in
          // Local variables don’t need access control.
          ancestor.is(FunctionDeclSyntax.self)
            ∨ ancestor.is(InitializerDeclSyntax.self)
            ∨ ancestor.is(DeinitializerDeclSyntax.self)
            ∨ ancestor.is(VariableDeclSyntax.self)
            ∨ ancestor.is(SubscriptDeclSyntax.self)
            // Protocol members cannot have access control.
            ∨ ancestor.is(ProtocolDeclSyntax.self)
        })
      {
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
    }
  #endif
}
