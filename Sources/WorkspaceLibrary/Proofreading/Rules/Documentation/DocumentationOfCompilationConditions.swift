/*
 DocumentationOfCompilationConditions.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2017–2018 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGCommandLine

struct DocumentationOfCompilationConditions : Rule {

    static let name = UserFacing<StrictString, InterfaceLocalization>({ (localization) in
        switch localization {
        case .englishCanada:
            return "Documentation of Compilation Conditions"
        }
    })

    static let message = UserFacing<StrictString, InterfaceLocalization>({ (localization) in
        switch localization {
        case .englishCanada:
            return StrictString("Undocumented compilation condition. Add “\(Mark.expectedSyntax)\u{23}if...” on the next line.")
        }
    })

    static let markSearchToken = "MAR\u{4B}".scalars

    static func check(file: TextFile, for conditionalCompilationToken: String, status: ProofreadingStatus, output: Command.Output) {
        for match in file.contents.scalars.matches(for: conditionalCompilationToken.scalars) where
            ¬line(of: match, in: file).contains(markSearchToken)
            ∧ ¬line(after: match, in: file).contains(markSearchToken)
            ∧ from(match, toNext: "#e" /* “else” or “end”, but not “if” */, in: file).contains("public".scalars) {

                reportViolation(in: file, at: match.range, message: message, status: status, output: output)
        }
    }

    static func check(file: TextFile, in project: PackageRepository, status: ProofreadingStatus, output: Command.Output) {
        if file.fileType == .swift {
            check(file: file, for: "\u{23}if", status: status, output: output)
            check(file: file, for: "\u{23}else", status: status, output: output)
        }
    }
}
