/*
 SyntaxColouring.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2017–2019 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGLogic
import WSGeneralImports

import SDGSwiftSource

import WSProject

internal struct SyntaxColouring : SyntaxRule {

    internal static let name = UserFacing<StrictString, InterfaceLocalization>({ (localization) in
        switch localization {
        case .englishCanada:
            return "syntaxColouring"
        }
    })

    private static let message = UserFacing<StrictString, InterfaceLocalization>({ (localization) in
        switch localization {
        case .englishCanada:
            return "Language specifier missing. Specify a language for syntax colouring."
        }
    })

    internal static func check(_ node: ExtendedSyntax, context: ExtendedSyntaxContext, file: TextFile, project: PackageRepository, status: ProofreadingStatus, output: Command.Output) {

        if let codeDelimiter = node as? ExtendedTokenSyntax,
            codeDelimiter.kind == .codeDelimiter,
            let codeBlock = codeDelimiter.parent as? CodeBlockSyntax,
            codeBlock.openingDelimiter.indexInParent == codeDelimiter.indexInParent {

            if codeBlock.language == nil {
                reportViolation(in: file, at: codeDelimiter.range(in: context), message: message, status: status, output: output)
            }
        }
    }
}
