/*
 SyntaxRule.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2019 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import WSGeneralImports

import SDGSwiftSource

import WSProject

internal protocol SyntaxRule : RuleProtocol {
    static func check(_ node: Syntax, context: SyntaxContext, file: TextFile, project: PackageRepository, status: ProofreadingStatus, output: Command.Output)
    static func check(_ node: ExtendedSyntax, context: ExtendedSyntaxContext, file: TextFile, project: PackageRepository, status: ProofreadingStatus, output: Command.Output)
    static func check(_ node: Trivia, context: TriviaContext, file: TextFile, project: PackageRepository, status: ProofreadingStatus, output: Command.Output)
    static func check(_ node: TriviaPiece, context: TriviaPieceContext, file: TextFile, project: PackageRepository, status: ProofreadingStatus, output: Command.Output)
}

extension SyntaxRule {
    static func check(_ node: Syntax, context: SyntaxContext, file: TextFile, project: PackageRepository, status: ProofreadingStatus, output: Command.Output) {}
    static func check(_ node: ExtendedSyntax, context: ExtendedSyntaxContext, file: TextFile, project: PackageRepository, status: ProofreadingStatus, output: Command.Output) {}
    static func check(_ node: Trivia, context: TriviaContext, file: TextFile, project: PackageRepository, status: ProofreadingStatus, output: Command.Output) {}
    static func check(_ node: TriviaPiece, context: TriviaPieceContext, file: TextFile, project: PackageRepository, status: ProofreadingStatus, output: Command.Output) {}
}
