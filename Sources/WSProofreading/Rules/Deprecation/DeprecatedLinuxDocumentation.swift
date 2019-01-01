/*
 DeprecatedLinuxDocumentation.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2017–2019 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import WSGeneralImports

import WSProject

internal struct DeprecatedLinuxDocumentation : TextRule {
    // Deprecated in 0.3.0 (2017‐11‐22)

    internal static let name = UserFacing<StrictString, InterfaceLocalization>({ (localization) in
        switch localization {
        case .englishCanada:
            return "deprecatedLinuxDocumentation"
        }
    })

    private static let message = UserFacing<StrictString, InterfaceLocalization>({ (localization) in
        switch localization {
        case .englishCanada:
            return "Special compilation conditions are no longer necessary for Linux documentation."
        }
    })

    internal static func check(file: TextFile, in project: PackageRepository, status: ProofreadingStatus, output: Command.Output) {
        for match in file.contents.scalars.matches(for: "\u{4C}inuxDocs".scalars) {
            reportViolation(in: file, at: match.range, message: message, status: status, output: output)
        }
    }
}
