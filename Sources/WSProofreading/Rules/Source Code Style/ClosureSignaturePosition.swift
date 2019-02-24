/*
 ClosureSignaturePosition.swift

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

internal struct ClosureSignaturePosition : SyntaxRule {

    internal static let name = UserFacing<StrictString, InterfaceLocalization>({ (localization) in
        switch localization {
        case .englishCanada:
            return "closureSignaturePosition"
        }
    })

    private static let message = UserFacing<StrictString, InterfaceLocalization>({ (localization) in
        switch localization {
        case .englishCanada:
            return "A closure’s signature should be on the same line as its opening brace."
        }
    })

    internal static func check(_ node: Syntax, context: SyntaxContext, file: TextFile, project: PackageRepository, status: ProofreadingStatus, output: Command.Output) {

        if let signature = node as? ClosureSignatureSyntax,
            let closure = signature.parent as? ClosureExprSyntax, closure.signature?.indexInParent == signature.indexInParent,
            let leadingTrivia = signature.leadingTrivia { // Only nil if the signature does not really exist.

            if leadingTrivia.contains(where: { $0.isNewLine }) {
                reportViolation(in: file, at: signature.syntaxRange(in: context), message: message, status: status, output: output)
            }
        }
    }
}
