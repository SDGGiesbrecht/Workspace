/*
 SyntaxColouring.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2017–2018 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGCornerstone
import SDGCommandLine

struct SyntaxColouring : Rule {

    static let name = UserFacingText<InterfaceLocalization>({ (localization) in
        switch localization {
        case .englishCanada:
            return "Syntax Colouring"
        }
    })

    static let message = UserFacingText<InterfaceLocalization>({ (localization) in
        switch localization {
        case .englishCanada:
            return "Language specifier missing. Specify a language for syntax colouring."
        }
    })

    static func check(file: TextFile, in project: PackageRepository, status: ProofreadingStatus, output: inout Command.Output) {

        var occurrenceCount: [String: Bool] = [:]

        for match in file.contents.scalars.matches(for: "```".scalars) {
            let indent = String(fromStartOfLine(to: match, in: file))

            var isOdd = occurrenceCount[indent] ?? false
            isOdd¬=
            occurrenceCount[indent] = isOdd

            if isOdd ∧ file.contents.scalars[match.range.upperBound...].hasPrefix("\n".scalars) {
                reportViolation(in: file, at: match.range, message: message, status: status, output: &output)
            }
        }
    }
}
