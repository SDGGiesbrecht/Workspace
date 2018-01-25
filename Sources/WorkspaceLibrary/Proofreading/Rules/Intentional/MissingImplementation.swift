/*
 MissingImplementation.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2017–2018 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGCornerstone
import SDGCommandLine

struct MissingImplementation : Rule {

    static let name = UserFacingText<InterfaceLocalization, Void>({ (localization, _) in
        switch localization {
        case .englishCanada:
            return "Missing Implementation"
        }
    })

    static let message = UserFacingText<InterfaceLocalization, Void>({ (localization, _) in
        switch localization {
        case .englishCanada:
            return "Missing implementation."
        }
    })

    static func check(file: TextFile, in project: PackageRepository, status: ProofreadingStatus, output: inout Command.Output) {
        for match in file.contents.scalars.matches(for: "\u{6E}otImplementedYet".scalars) {
            if ¬fromStartOfFile(to: match, in: file).hasSuffix("func ".scalars) {
                reportViolation(in: file, at: match.range, message: message, status: status, output: &output)
            }
        }
    }
}
