/*
 DeprecatedGitManagement.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2018 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import WSGeneralImports

import WSProject

internal struct DeprecatedGitManagement : Rule {
    // Deprecated in 0.8.0 (???)
    // (There is also clean‐up of the deprecated “.gitattributes” in WSGit.)

    internal static let name = UserFacing<StrictString, InterfaceLocalization>({ (localization) in
        switch localization {
        case .englishCanada:
            return "deprecatedGitManagement"
        }
    })

    private static let message = UserFacing<StrictString, InterfaceLocalization>({ (localization) in
        switch localization {
        case .englishCanada:
            return "Management sections are no longer used. Enable “git.manage” or remove the section markers."
        }
    })

    internal static func check(file: TextFile, in project: PackageRepository, status: ProofreadingStatus, output: Command.Output) {

        if file.location.lastPathComponent == ".gitignore" {
            if let range = file.contents.scalars.firstMatch(for: "[_Begin Workspace Section_]".scalars)?.range {
                reportViolation(in: file, at: range, message: message, status: status, output: output)
            }
        }
    }
}
