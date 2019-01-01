/*
 DeprecatedConfiguration.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2018–2019 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import WSGeneralImports

import WSProject

internal struct DeprecatedConfiguration : TextRule {
    // Deprecated in 0.8.0 (2018‐06‐21)

    internal static let name = UserFacing<StrictString, InterfaceLocalization>({ (localization) in
        switch localization {
        case .englishCanada:
            return "deprecatedConfiguration"
        }
    })

    private static let message = UserFacing<StrictString, InterfaceLocalization>({ (localization) in
        switch localization {
        case .englishCanada:
            return "“.Workspace Configuration.txt” is no longer used. It has been replaced by “Workspace.swift”."
        }
    })

    internal static func check(file: TextFile, in project: PackageRepository, status: ProofreadingStatus, output: Command.Output) {
        if file.location.lastPathComponent == ".Workspace Configuration.txt" {
            reportViolation(in: file, at: file.contents.bounds, message: message, status: status, output: output)
        }
    }
}
