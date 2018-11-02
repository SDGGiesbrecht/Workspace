/*
 Warning.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2017–2018 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import WSGeneralImports

import WSProject

internal protocol Warning : Rule {
    static var trigger: UserFacing<StrictString, InterfaceLocalization> { get }
    static func message(for details: StrictString, in project: PackageRepository, output: Command.Output) throws -> UserFacing<StrictString, InterfaceLocalization>?
}

extension Warning {

    internal static func check(file: TextFile, in project: PackageRepository, status: ProofreadingStatus, output: Command.Output) throws {
        if file.location.lastPathComponent == "ProofreadingRule.swift" {
            // @exempt(from: tests)
            return
        }

        for localizedTrigger in InterfaceLocalization.allCases.map({ trigger.resolved(for: $0) }) {

            let marker = ("#\(localizedTrigger)(", ")")

            var index = file.contents.scalars.startIndex
            while let match = file.contents.scalars[index ..< file.contents.scalars.endIndex].firstNestingLevel(startingWith: marker.0.scalars, endingWith: marker.1.scalars) {
                index = match.container.range.upperBound

                var details = StrictString(match.contents.contents)
                details.trimMarginalWhitespace()

                if let description = try message(for: details, in: project, output: output) {
                    reportViolation(in: file, at: match.container.range, message: description, status: status, output: output)
                }
            }
        }
    }
}
