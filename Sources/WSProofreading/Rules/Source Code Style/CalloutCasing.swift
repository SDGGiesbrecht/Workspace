/*
 CalloutCasing.swift

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

internal struct CalloutCasing : SyntaxRule {

    internal static let name = UserFacing<StrictString, InterfaceLocalization>({ (localization) in
        switch localization {
        case .englishCanada:
            return "calloutCasing"
        }
    })

    private static let message = UserFacing<StrictString, InterfaceLocalization>({ (localization) in
        switch localization {
        case .englishCanada:
            return "Callouts should be capitalized."
        }
    })

    internal static func check(_ node: ExtendedSyntax, context: ExtendedSyntaxContext, file: TextFile, project: PackageRepository, status: ProofreadingStatus, output: Command.Output) {

        if let token = node as? ExtendedTokenSyntax,
            token.kind == .callout,
            let first = token.text.scalars.first,
            first ∈ CharacterSet.lowercaseLetters {

            var replacement = token.text
            let first = replacement.removeFirst()
            replacement.prepend(contentsOf: String(first).uppercased())

            reportViolation(in: file, at: token.range(in: context), replacementSuggestion: StrictString(replacement), message: message, status: status, output: output)
        }
    }
}
