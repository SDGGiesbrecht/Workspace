/*
 Proofread.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2017–2018 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGCornerstone
import SDGCommandLine

extension Workspace {
    enum Proofread {

        private static let name = UserFacingText<InterfaceLocalization, Void>({ (localization: InterfaceLocalization, _) -> StrictString in
            switch localization {
            case .englishCanada:
                return "proofread"
            }
        })

        private static let description = UserFacingText<InterfaceLocalization, Void>({ (localization: InterfaceLocalization, _) -> StrictString in
            switch localization {
            case .englishCanada:
                return "proofreads the current project’s source for style violations."
            }
        })

        static let runAsXcodeBuildPhase = SDGCommandLine.Option(name: UserFacingText<InterfaceLocalization, Void>({ (localization: InterfaceLocalization, _) -> StrictString in
            switch localization {
            case .englishCanada:
                return "xcode"
            }
        }), description: UserFacingText<InterfaceLocalization, Void>({ (localization: InterfaceLocalization, _) -> StrictString in
            switch localization {
            case .englishCanada:
                return "behaves as an xcode build phase."
            }
        }), type: ArgumentType.boolean)

        static let command = Command(name: name, description: description, directArguments: [], options: [runAsXcodeBuildPhase], execution: { (_: DirectArguments, options: Options, output: inout Command.Output) throws in
            var validationStatus = ValidationStatus()
            try executeAsStep(normalizingFirst: true, options: options, validationStatus: &validationStatus, output: &output)

            if ¬options.runAsXcodeBuildPhase { // Xcode should keep building anyway.
                try validationStatus.reportOutcome(projectName: try options.project.projectName(output: &output), output: &output)
            }
        })

        static func executeAsStep(normalizingFirst: Bool, options: Options, validationStatus: inout ValidationStatus, output: inout Command.Output) throws {

            try Workspace.Normalize.executeAsStep(options: options, output: &output) // So that SwiftLint’s trailing_whitespace doesn’t trigger.

            let section = validationStatus.newSection()

            if ¬options.runAsXcodeBuildPhase {
                print(UserFacingText<InterfaceLocalization, Void>({ (localization: InterfaceLocalization, _) -> StrictString in
                    switch localization {
                    case .englishCanada:
                        return StrictString("Proofreading source code...") + section.anchor
                    }
                }).resolved().formattedAsSectionHeader(), to: &output)
            }

            let reporter: ProofreadingReporter
            if options.runAsXcodeBuildPhase {
                reporter = XcodeProofreadingReporter.default
            } else {
                reporter = CommandLineProofreadingReporter.default
            }

            if try Proofreading.proofread(project: options.project, reporter: reporter, output: &output) {
                validationStatus.passStep(message: UserFacingText({(localization: InterfaceLocalization, _: Void) in
                    switch localization {
                    case .englishCanada:
                        return "Source code passes proofreading."
                    }
                }))
            } else {
                validationStatus.failStep(message: UserFacingText({(localization: InterfaceLocalization, _: Void) in
                    switch localization {
                    case .englishCanada:
                        return StrictString("Source code fails proofreading.") + section.crossReference.resolved(for: localization)
                    }
                }))
            }
        }
    }
}
