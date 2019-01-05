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

    internal override func visit(_ node: Syntax) -> Bool {
        // #workaround(SDGSwift 0.4.0, The necessary information is unavailable if left to SDGSwiftSource.)
        if let token = node as? TokenSyntax {
            for index in token.leadingTrivia.indices {
                let trivia = token.leadingTrivia[index]
                for rule in rules {
                    rule.check(trivia, token: token, triviaPosition: .leading, index: index, in: file, in: project, status: status, output: output)
                }
            }
        }

        for rule in rules {
            rule.check(node, in: file, in: project, status: status, output: output)
        }

        // #workaround(SDGSwift 0.4.0, The necessary information is unavailable if left to SDGSwiftSource.)
        if let token = node as? TokenSyntax {
            for index in token.trailingTrivia.indices {
                let trivia = token.trailingTrivia[index]
                for rule in rules {
                    rule.check(trivia, token: token, triviaPosition: .trailing, index: index, in: file, in: project, status: status, output: output)
                }
            }
        }

        return true
    }

    internal override func visit(_ node: ExtendedSyntax) -> Bool {
        for rule in rules {
            rule.check(node, in: file, in: project, status: status, output: output)
        }

        // #workaround(SDGSwift 0.4.0, Block comments broken into fragments can cause invalid index use.)
        if node is FragmentSyntax {
            return false
        }

        return true
    }

    internal override func visit(_ node: Trivia) -> Bool {
        for rule in rules {
            rule.check(node, in: file, in: project, status: status, output: output)
        }
        return true
    }

    internal override func visit(_ node: TriviaPiece) -> Bool {
        return true
    }
}
