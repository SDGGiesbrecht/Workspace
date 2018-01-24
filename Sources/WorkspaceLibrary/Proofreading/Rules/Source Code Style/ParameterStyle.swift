/*
 ParameterStyle.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2017–2018 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGCornerstone
import SDGCommandLine

struct ParametersStyle : Rule {

    static let name = UserFacingText<InterfaceLocalization, Void>({ (localization, _) in
        switch localization {
        case .englishCanada:
            return "Parameter Style"
        }
    })

    static let message = UserFacingText<InterfaceLocalization, Void>({ (localization, _) in
        switch localization {
        case .englishCanada:
            return "Parameters should be grouped under a single callout."
        }
    })

    static func check(file: TextFile, status: ProofreadingStatus, output: inout Command.Output) {
        if file.fileType == .swift {
            for match in file.contents.scalars.matches(for: "//\u{2F} \u{2D} Parameter ".scalars) {
                reportViolation(in: file, at: match.range, message: message, status: status, output: &output)
            }
        }
    }
}
