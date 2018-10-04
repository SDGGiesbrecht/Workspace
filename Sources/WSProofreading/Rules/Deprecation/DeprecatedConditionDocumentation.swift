/*
 DeprecatedConfiguration.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2018 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import WSGeneralImports

import WSProject

internal struct DeprecatedConditionDocumentation : Rule {
    // Deprecated in 0.12.0 (2018‐09‐06)

    internal static let name = UserFacing<StrictString, InterfaceLocalization>({ (localization) in
        switch localization {
        case .englishCanada:
            return "deprecatedConditionDocumentation"
        }
    })

    private static let message = UserFacing<StrictString, InterfaceLocalization>({ (localization) in
        switch localization {
        case .englishCanada:
            return "Such headings are no longer necessary for the generated documentation."
        }
    })

    internal static func check(file: TextFile, in project: PackageRepository, status: ProofreadingStatus, output: Command.Output) {
        for match in file.contents.scalars.matches(for: "MARK: \u{2D} #".scalars) {
            reportViolation(in: file, at: match.range, message: message, status: status, output: output)
        }
        for match in file.contents.scalars.matches(for: "MARK: \u{2D} where ".scalars) {
            reportViolation(in: file, at: match.range, message: message, status: status, output: output)
        }
    }
}
