/*
 AutoindentResilience.swift

 This source file is part of the Workspace open source project.
 Diese Quelldatei ist Teil des qeulloffenen Workspace‐Projekt.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2017–2019 Jeremy David Giesbrecht and the Workspace project contributors.
 Urheberrecht ©2017–2019 Jeremy David Giesbrecht und die Mitwirkenden des Workspace‐Projekts.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGLogic
import SDGCollections
import WSGeneralImports

import WSProject

import SwiftSyntax
import SDGSwiftSource

internal struct AutoindentResilience : SyntaxRule {

    internal static let name = UserFacing<StrictString, InterfaceLocalization>({ (localization) in
        switch localization {
        case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
            return "autoindentResilience"
        case .deutschDeutschland:
            return "widerstandGegenAutomatischenEinzug"
        }
    })

    private static let message = UserFacing<StrictString, InterfaceLocalization>({ (localization) in
        switch localization {
        case .englishUnitedKingdom:
            return "‘/*\u{2A}’ may not survive autoindent (⌃I). Use ‘///’ instead."
        case .englishUnitedStates, .englishCanada:
            return "“/*\u{2A}” may not survive autoindent (⌃I). Use “///” instead."
        case .deutschDeutschland:
            return "„/*\u{2A}“ widersteht automatische Einzüge (⌃I) nicht. Stattdessen „///“ verwenden."
        }
    })

    static func check(_ node: TriviaPiece, context: TriviaPieceContext, file: TextFile, project: PackageRepository, status: ProofreadingStatus, output: Command.Output) {
        switch node {
        case .docBlockComment:
            if file.location.lastPathComponent ≠ "FileHeaderConfiguration.swift" {
                let start = node.lowerBound(in: context)
                let end = file.contents.scalars.index(start, offsetBy: 3)
                reportViolation(in: file, at: start ..< end, message: message, status: status, output: output)
            }
        default:
            break
        }
    }
}
