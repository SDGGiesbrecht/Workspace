/*
 DeprecatedWarnings.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2018 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import WSGeneralImports

import WSProject

internal struct DeprecatedWarnings : Rule {
    // Deprecated in 0.10.0 (???)

    internal static let name = UserFacing<StrictString, InterfaceLocalization>({ (localization) in
        switch localization {
        case .englishCanada:
            return "deprecatedWarnings"
        }
    })

    private static let warningMessage =  UserFacing<StrictString, InterfaceLocalization>({ (localization) in
        switch localization {
        case .englishCanada:
            return "This syntax is no longer recognized. Use “#warning” instead."
        }
    })

    private static let workaroundMessage =  UserFacing<StrictString, InterfaceLocalization>({ (localization) in
        switch localization {
        case .englishCanada:
            return "This syntax is no longer recognized. Use “#workaround” instead."
        }
    })

    internal static func check(file: TextFile, in project: PackageRepository, status: ProofreadingStatus, output: Command.Output) {
        for match in file.contents.scalars.matches(for: "[\u{5F}Warning".scalars) {
            reportViolation(in: file, at: match.range, message: warningMessage, status: status, output: output)
        }
        for match in file.contents.scalars.matches(for: "[\u{5F}Workaround".scalars) {
            reportViolation(in: file, at: match.range, message: workaroundMessage, status: status, output: output)
        }
    }
}
