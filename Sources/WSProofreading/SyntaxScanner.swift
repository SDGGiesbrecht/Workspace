/*
 SyntaxScanner.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2018–2019 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import WSGeneralImports

import SwiftSyntax
import SDGSwiftSource

import WSProject

internal class RuleSyntaxScanner : SyntaxScanner {

    // MARK: - Initialization

    internal init(
        rules: [SyntaxRule.Type],
        file: TextFile,
        project: PackageRepository,
        status: ProofreadingStatus,
        output: Command.Output) {

        self.rules = rules
        self.file = file
        self.project = project
        self.status = status
        self.output = output
    }

    // MARK: - Properties

    private let rules: [SyntaxRule.Type]
    private let file: TextFile
    private let project: PackageRepository
    private let status: ProofreadingStatus
    private let output: Command.Output

    // MARK: - SyntaxScanner

    internal override func visit(_ node: Syntax, context: SyntaxContext) -> Bool {
        for rule in rules {
            rule.check(node, context: context, file: file, project: project, status: status, output: output)
        }
        return true
    }

    internal override func visit(_ node: ExtendedSyntax, context: ExtendedSyntaxContext) -> Bool {
        for rule in rules {
            rule.check(node, context: context, file: file, project: project, status: status, output: output)
        }
        return true
    }

    internal override func visit(_ node: Trivia, context: TriviaContext) -> Bool {
        for rule in rules {
            rule.check(node, context: context, file: file, project: project, status: status, output: output)
        }
        return true
    }

    internal override func visit(_ node: TriviaPiece, context: TriviaPieceContext) -> Bool {
        for rule in rules {
            rule.check(node, context: context, file: file, project: project, status: status, output: output)
        }
        return true
    }
}
