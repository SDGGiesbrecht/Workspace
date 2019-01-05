/*
 AutoindentResilience.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2017–2019 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGLogic
import SDGCollections
import WSGeneralImports

import WSProject

import SDGSwiftSource

internal struct AutoindentResilience : SyntaxRule {

    internal static let name = UserFacing<StrictString, InterfaceLocalization>({ (localization) in
        switch localization {
        case .englishCanada:
            return "autoindentResilience"
        }
    })

    private static let message = UserFacing<StrictString, InterfaceLocalization>({ (localization) in
        switch localization {
        case .englishCanada:
            return "“/*\u{2A}” may not survive autoindent (⌃I). Use “///” instead."
        }
    })

    static func check(_ node: TriviaPiece, token: TokenSyntax, triviaPosition: TriviaPosition, index: Trivia.Index, in file: TextFile, in project: PackageRepository, status: ProofreadingStatus, output: Command.Output) {
        switch node {
        case .docBlockComment:
            if file.location.lastPathComponent ≠ "FileHeaderConfiguration.swift" {
                let start = node.lowerBound(in: file.contents, token: token, triviaPosition: triviaPosition, index: index)
                let end = file.contents.scalars.index(start, offsetBy: 3)
                reportViolation(in: file, at: start ..< end, message: message, status: status, output: output)
            }
        default:
            break
        }
    }
}
