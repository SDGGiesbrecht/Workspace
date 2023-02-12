/*
 SyntaxRule.swift

 This source file is part of the Workspace open source project.
 Diese Quelldatei ist Teil des quelloffenen Arbeitsbereich‐Projekt.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2019–2023 Jeremy David Giesbrecht and the Workspace project contributors.
 Urheberrecht ©2019–2023 Jeremy David Giesbrecht und die Mitwirkenden des Arbeitsbereich‐Projekts.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

#if !PLATFORM_NOT_SUPPORTED_BY_WORKSPACE_WORKSPACE
  import SDGCommandLine

  import SDGSwift
  import SwiftSyntax
  import SDGSwiftSource

  internal protocol SyntaxRule: RuleProtocol {
    static func check(
      _ node: Syntax,
      context: SyntaxContext,
      file: TextFile,
      setting: Setting,
      project: PackageRepository,
      status: ProofreadingStatus,
      output: Command.Output
    )
    static func check(
      _ node: ExtendedSyntax,
      context: ExtendedSyntaxContext,
      file: TextFile,
      setting: Setting,
      project: PackageRepository,
      status: ProofreadingStatus,
      output: Command.Output
    )
    static func check(
      _ node: Trivia,
      context: TriviaContext,
      file: TextFile,
      setting: Setting,
      project: PackageRepository,
      status: ProofreadingStatus,
      output: Command.Output
    )
    static func check(
      _ node: TriviaPiece,
      context: TriviaPieceContext,
      file: TextFile,
      setting: Setting,
      project: PackageRepository,
      status: ProofreadingStatus,
      output: Command.Output
    )
  }

  extension SyntaxRule {
    internal static func check(
      _ node: Syntax,
      context: SyntaxContext,
      file: TextFile,
      setting: Setting,
      project: PackageRepository,
      status: ProofreadingStatus,
      output: Command.Output
    ) {}
    internal static func check(
      _ node: ExtendedSyntax,
      context: ExtendedSyntaxContext,
      file: TextFile,
      setting: Setting,
      project: PackageRepository,
      status: ProofreadingStatus,
      output: Command.Output
    ) {}
    internal static func check(
      _ node: Trivia,
      context: TriviaContext,
      file: TextFile,
      setting: Setting,
      project: PackageRepository,
      status: ProofreadingStatus,
      output: Command.Output
    ) {}
    internal static func check(
      _ node: TriviaPiece,
      context: TriviaPieceContext,
      file: TextFile,
      setting: Setting,
      project: PackageRepository,
      status: ProofreadingStatus,
      output: Command.Output
    ) {}
  }
#endif
