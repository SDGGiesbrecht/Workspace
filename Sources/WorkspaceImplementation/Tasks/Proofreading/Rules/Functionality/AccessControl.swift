/*
 AccessControl.swift

 This source file is part of the Workspace open source project.
 Diese Quelldatei ist Teil des quelloffenen Arbeitsbereich‐Projekt.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2020–2023 Jeremy David Giesbrecht and the Workspace project contributors.
 Urheberrecht ©2020–2023 Jeremy David Giesbrecht und die Mitwirkenden des Arbeitsbereich‐Projekts.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

#if !PLATFORM_NOT_SUPPORTED_BY_WORKSPACE_WORKSPACE
  import SDGLogic
  import SDGMathematics
  import SDGCollections
  import SDGText
  import SDGLocalization

  import SDGCommandLine

  import SDGSwift

  import WorkspaceLocalizations

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

    private static func checkLibrary(
      _ node: SyntaxNode,
      context: ScanContext,
      file: TextFile,
      status: ProofreadingStatus
    ) {
      let modifiers: ModifierListSyntax?
      let declaration: SyntaxProtocol
      if node is Token,
        let parent = (context.globalAncestors.last?.node as? SwiftSyntaxNode),
        let token = parent.swiftSyntaxNode.as(TokenSyntax.self) {
        if let structure = token.parent(as: StructDeclSyntax.self, ifIsChildAt: \.identifier) {
          modifiers = structure.modifiers
          declaration = structure
        } else if let `class` = token.parent(as: ClassDeclSyntax.self, ifIsChildAt: \.identifier) {
          modifiers = `class`.modifiers
          declaration = `class`
        } else if let enumeration = token.parent(as: EnumDeclSyntax.self, ifIsChildAt: \.identifier) {
          modifiers = enumeration.modifiers
          declaration = enumeration
        } else if let typeAlias = token.parent(as: TypealiasDeclSyntax.self, ifIsChildAt: \.identifier) {
          modifiers = typeAlias.modifiers
          declaration = typeAlias
        } else if let `protocol` = token.parent(as: ProtocolDeclSyntax.self, ifIsChildAt: \.identifier) {
          modifiers = `protocol`.modifiers
          declaration = `protocol`
        } else if let function = token.parent(as: FunctionDeclSyntax.self, ifIsChildAt: \.identifier) {
          modifiers = function.modifiers
          declaration = function
        } else if let initializer = token.parent(as: InitializerDeclSyntax.self, ifIsChildAt: \.initKeyword) {
          modifiers = initializer.modifiers
          declaration = initializer
        } else if let `subscript` = token.parent(as: SubscriptDeclSyntax.self, ifIsChildAt: \.subscriptKeyword) {
          modifiers = `subscript`.modifiers
          declaration = `subscript`
        } else {
          return
        }
      } else if let syntax = node as? SwiftSyntaxNode,
        let bindings = syntax.swiftSyntaxNode.as(PatternBindingListSyntax.self) {
        if let variable = bindings.parent(as: VariableDeclSyntax.self, ifIsChildAt: \.bindings) {
          modifiers = variable.modifiers
          declaration = variable
        } else {
          return  // @exempt(from: tests)
        }
      } else {
        return
      }
      if ¬(modifiers?.contains(where: { $0.name.text ∈ allLevels }) ?? false),
        ¬declaration.ancestors.contains(where: { ancestor in
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
          at: context.location,
          message: libraryMessage,
          status: status
        )
      }
    }

    private static func checkOther(
      _ node: SyntaxNode,
      context: ScanContext,
      file: TextFile,
      status: ProofreadingStatus
    ) {
      if let modifier = (node as? SwiftSyntaxNode)?.swiftSyntaxNode.as(DeclModifierSyntax.self) {
        if modifier.name.text ∈ highLevels {
          let leadingTrivia = modifier.leadingTrivia
            .map({ TriviaNode($0) })?.text() ?? ""  // @exempt(from: tests)
          let trailingTrivia = modifier.trailingTrivia
            .map({ TriviaNode($0) })?.text() ?? ""  // @exempt(from: tests)
          let withoutTrivia = context.location.lowerBound + leadingTrivia.scalars.count
            ..< context.location.upperBound − trailingTrivia.scalars.count

          reportViolation(
            in: file,
            at: withoutTrivia,
            replacementSuggestion: StrictString(),
            message: otherMessage,
            status: status
          )
        }
      }
    }

    // MARK: - SyntaxRule

    internal static func check(
      _ node: SyntaxNode,
      context: ScanContext,
      file: TextFile,
      setting: Setting,
      project: PackageRepository,
      status: ProofreadingStatus,
      output: Command.Output
    ) {
      guard context.isCompiled() else {
        return  // Documentation example
      }

      switch setting {
      case .library:
        checkLibrary(node, context: context, file: file, status: status)
      case .topLevel:
        checkOther(node, context: context, file: file, status: status)
      case .unknown:
        break
      }
    }
  }
#endif
