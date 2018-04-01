/*
 Warning.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2017–2018 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGCornerstone
import SDGCommandLine

protocol Warning : Rule {
    static var trigger: UserFacingText<InterfaceLocalization> { get }
    static func message(for details: StrictString, in project: PackageRepository, output: inout Command.Output) throws -> UserFacingText<InterfaceLocalization>?
}

let manualWarnings: [Warning.Type] = [
    GenericWarning.self,
    WorkaroundReminder.self
]

extension Warning {

    static func check(file: TextFile, in project: PackageRepository, status: ProofreadingStatus, output: inout Command.Output) throws {
        if file.location.path.hasSuffix("Documentation/Manual Warnings.md") { // [_Exempt from Test Coverage_]
            return
        }

        for localizedTrigger in InterfaceLocalization.cases.map({ trigger.resolved(for: $0) }) {

            let marker = ("[_\(localizedTrigger)", "_]")

            var index = file.contents.scalars.startIndex
            while let match = file.contents.scalars.firstNestingLevel(startingWith: marker.0.scalars, endingWith: marker.1.scalars, in: index ..< file.contents.scalars.endIndex) {
                index = match.container.range.upperBound

                var details = StrictString(match.contents.contents)
                if details.hasPrefix(":".scalars) {
                    details.removeFirst()
                }
                if details.hasPrefix(" ".scalars) {
                    details.removeFirst()
                }

                if let description = try message(for: details, in: project, output: &output) {
                    reportViolation(in: file, at: match.container.range, message: description, status: status, output: &output)
                }
            }
        }
    }
}
