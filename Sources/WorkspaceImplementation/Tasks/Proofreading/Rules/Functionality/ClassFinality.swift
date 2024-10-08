/*
 ClassFinality.swift

 This source file is part of the Workspace open source project.
 Diese Quelldatei ist Teil des quelloffenen Arbeitsbereich‐Projekt.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2020–2024 Jeremy David Giesbrecht and the Workspace project contributors.
 Urheberrecht ©2020–2024 Jeremy David Giesbrecht und die Mitwirkenden des Arbeitsbereich‐Projekts.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

#if !PLATFORM_NOT_SUPPORTED_BY_WORKSPACE_WORKSPACE
  import SDGLogic
  import SDGCollections
  import SDGText
  import SDGLocalization

  import SDGCommandLine

  import SDGSwift
  import SwiftSyntax
  import SDGSwiftSource

  import WorkspaceLocalizations

  internal struct ClassFinality: SyntaxRule {

    internal static let identifier = UserFacing<StrictString, InterfaceLocalization>(
      { localization in
        switch localization {
        case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
          return "classFinality"
        case .deutschDeutschland:
          return "klassenentgültigkeit"
        }
      })

    private static let message = UserFacing<StrictString, InterfaceLocalization>(
      { localization in
        switch localization {
        case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
          return "Public classes should be open, final or explicitly exempt."
        case .deutschDeutschland:
          return
            "Öffentliche (public) Klassen sollen als offen (open), entgültig (final), oder ausdrückliche Ausnahme markiert."
        }
      })

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

      switch setting {
      case .library:
        if node is Token,
          let `public` = (context.globalAncestors.last?.node as? SwiftSyntaxNode)?.swiftSyntaxNode.as(TokenSyntax.self),
          `public`.tokenKind == .publicKeyword,
          let modifier = `public`.parent(as: DeclModifierSyntax.self, ifIsChildAt: \.name),
          let modifiers = modifier.parent?.as(ModifierListSyntax.self),
          let _ = modifiers.parent(as: ClassDeclSyntax.self, ifIsChildAt: \.modifiers),
          ¬modifiers.contains(where: { $0.name.text == "final" }) {

          reportViolation(
            in: file,
            at: context.location,
            message: message,
            status: status
          )
        }
      case .topLevel, .unknown:
        break
      }
    }
  }
#endif
