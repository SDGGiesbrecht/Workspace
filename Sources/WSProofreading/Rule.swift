/*
 Rule.swift

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

internal enum Rule {

    case text(TextRule.Type)
    case syntax(SyntaxRule.Type)

    internal func check(file: TextFile, syntax: SourceFileSyntax?, in project: PackageRepository, status: ProofreadingStatus, output: Command.Output) throws {
        switch self {
        case .text(let textParser):
            return try textParser.check(file: file, in: project, status: status, output: output)
        case .syntax(let syntaxParser):
            return try syntaxParser.check(file: file, syntax: syntax, in: project, status: status, output: output)
        }
    }
}
