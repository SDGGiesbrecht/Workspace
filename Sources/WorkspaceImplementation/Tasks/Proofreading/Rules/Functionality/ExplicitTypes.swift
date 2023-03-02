/*
 ExplicitTypes.swift

 This source file is part of the Workspace open source project.
 Diese Quelldatei ist Teil des quelloffenen Arbeitsbereich‐Projekt.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2022–2023 Jeremy David Giesbrecht and the Workspace project contributors.
 Urheberrecht ©2022–2023 Jeremy David Giesbrecht und die Mitwirkenden des Arbeitsbereich‐Projekts.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

#if !PLATFORM_NOT_SUPPORTED_BY_WORKSPACE_WORKSPACE

  import SDGLogic
  import SDGText
  import SDGLocalization

  import SDGCommandLine

  import SDGSwift

  import SwiftSyntax
  import SDGSwiftSource

  import WorkspaceLocalizations

  internal struct ExplicitTypes: SyntaxRule {

    internal static let identifier = UserFacing<StrictString, InterfaceLocalization>(
      { localization in
        switch localization {
        case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
          return "explicitTypes"
        case .deutschDeutschland:
          return "ausdrücklicheTypen"
        }
      })

    private static let message = UserFacing<StrictString, InterfaceLocalization>(
      { localization in
        switch localization {
        case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
          return "Public variables should have explicit types."
        case .deutschDeutschland:
          return
            "Öffentliche (public) Variablen sollen ausdrückliche Typen haben."
        }
      }
    )

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

      if let variable = node.as(VariableDeclSyntax.self),
        variable.modifiers?.contains(where: { $0.name.text == "public" }) == true,
        variable.bindings.first?.typeAnnotation?.isMissing ≠ false
      {
        reportViolation(
          in: file,
          at: variable.syntaxRange(in: context),
          message: message,
          status: status
        )
      }
    }
  }
#endif
