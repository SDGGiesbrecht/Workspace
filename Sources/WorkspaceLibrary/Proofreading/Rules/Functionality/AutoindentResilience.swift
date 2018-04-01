/*
 AutoindentResilience.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2017–2018 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGCornerstone
import SDGCommandLine

struct AutoindentResilience : Rule {

    static let name = UserFacingText<InterfaceLocalization>({ (localization) in
        switch localization {
        case .englishCanada:
            return "Autoindent Resilience"
        }
    })

    static let message = UserFacingText<InterfaceLocalization>({ (localization) in
        switch localization {
        case .englishCanada:
            return "“/*\u{2A}” may not survive autoindent (⌃I). Use “///” instead."
        }
    })

    static func check(file: TextFile, in project: PackageRepository, status: ProofreadingStatus, output: inout Command.Output) {
        if file.fileType == .swift {
            for match in file.contents.scalars.matches(for: "/*\u{2A}".scalars) {
                reportViolation(in: file, at: match.range, message: message, status: status, output: &output)
            }
        }
    }
}
