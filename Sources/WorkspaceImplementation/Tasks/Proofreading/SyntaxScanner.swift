/*
 SyntaxScanner.swift

 This source file is part of the Workspace open source project.
 Diese Quelldatei ist Teil des quelloffenen Arbeitsbereich‐Projekt.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2018–2021 Jeremy David Giesbrecht and the Workspace project contributors.
 Urheberrecht ©2018–2021 Jeremy David Giesbrecht und die Mitwirkenden des Arbeitsbereich‐Projekts.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGCommandLine

import SDGSwift
// #workaround(SwiftSyntax 0.50300.0, Cannot build.)
#if !(os(Windows) || os(WASI) || os(Android))
  import SwiftSyntax
#endif
import SDGSwiftSource

// #workaround(SwiftSyntax 0.50300.0, Cannot build.)
#if !(os(Windows) || os(WASI) || os(Android))
  internal class RuleSyntaxScanner: SyntaxScanner {

    // MARK: - Initialization

    internal init(
      rules: [SyntaxRule.Type],
      file: TextFile,
      setting: Setting,
      project: PackageRepository,
      status: ProofreadingStatus,
      output: Command.Output
    ) {

      self.rules = rules
      self.file = file
      self.setting = setting
      self.project = project
      self.status = status
      self.output = output
    }

    // MARK: - Properties

    private let rules: [SyntaxRule.Type]
    private let file: TextFile
    private let setting: Setting
    private let project: PackageRepository
    private let status: ProofreadingStatus
    private let output: Command.Output

    // MARK: - SyntaxScanner

    internal func visit(_ node: Syntax, context: SyntaxContext) -> Bool {
      for rule in rules {
        rule.check(
          node,
          context: context,
          file: file,
          setting: setting,
          project: project,
          status: status,
          output: output
        )
      }
      return true
    }

    internal func visit(_ node: ExtendedSyntax, context: ExtendedSyntaxContext) -> Bool {
      for rule in rules {
        rule.check(
          node,
          context: context,
          file: file,
          setting: setting,
          project: project,
          status: status,
          output: output
        )
      }
      return true
    }

    internal func visit(_ node: Trivia, context: TriviaContext) -> Bool {
      for rule in rules {
        rule.check(
          node,
          context: context,
          file: file,
          setting: setting,
          project: project,
          status: status,
          output: output
        )
      }
      return true
    }

    internal func visit(_ node: TriviaPiece, context: TriviaPieceContext) -> Bool {
      for rule in rules {
        rule.check(
          node,
          context: context,
          file: file,
          setting: setting,
          project: project,
          status: status,
          output: output
        )
      }
      return true
    }
  }
#endif
