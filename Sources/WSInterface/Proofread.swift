/*
 Proofread.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2017–2019 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import WSGeneralImports
import WSValidation
import WSProofreading

extension Workspace {
    enum Proofread {

        private static let name = UserFacing<StrictString, InterfaceLocalization>({ localization in
            switch localization {
            case .englishCanada:
                return "proofread"
            }
        })

        private static let description = UserFacing<StrictString, InterfaceLocalization>({ localization in
            switch localization {
            case .englishCanada:
                return "proofreads the project’s source for style violations."
            }
        })

        static let runAsXcodeBuildPhase = SDGCommandLine.Option(name: UserFacing<StrictString, InterfaceLocalization>({ localization in
            switch localization {
            case .englishCanada:
                return "xcode"
            }
        }), description: UserFacing<StrictString, InterfaceLocalization>({ localization in
            switch localization {
            case .englishCanada:
                return "behaves as an xcode build phase."
            }
        }), type: ArgumentType.boolean)

        static let command = Command(name: name, description: description, directArguments: [], options: standardOptions + [runAsXcodeBuildPhase], execution: { (_: DirectArguments, options: Options, output: Command.Output) throws in
            var validationStatus = ValidationStatus()
            try executeAsStep(normalizingFirst: true, options: options, validationStatus: &validationStatus, output: output)

            if ¬options.runAsXcodeBuildPhase { // Xcode should keep building anyway.
                try validationStatus.reportOutcome(project: options.project, output: output)
            }
        })

        static func executeAsStep(normalizingFirst: Bool, options: Options, validationStatus: inout ValidationStatus, output: Command.Output) throws {

            try Workspace.Normalize.executeAsStep(options: options, output: output)

            let section = validationStatus.newSection()

            if ¬options.runAsXcodeBuildPhase {
                output.print(UserFacing<StrictString, InterfaceLocalization>({ localization in
                    switch localization {
                    case .englishCanada:
                        return "Proofreading source code..." + section.anchor
                    }
                }).resolved().formattedAsSectionHeader())
            }

            let reporter: ProofreadingReporter
            if options.runAsXcodeBuildPhase {
                reporter = XcodeProofreadingReporter.default
            } else {
                reporter = CommandLineProofreadingReporter.default
            }

            if try options.project.proofread(reporter: reporter, output: output) {
                validationStatus.passStep(message: UserFacing<StrictString, InterfaceLocalization>({ localization in
                    switch localization {
                    case .englishCanada:
                        return "Source code passes proofreading."
                    }
                }))
            } else {
                validationStatus.failStep(message: UserFacing<StrictString, InterfaceLocalization>({ localization in
                    switch localization {
                    case .englishCanada:
                        return "Source code fails proofreading." + section.crossReference.resolved(for: localization)
                    }
                }))
            }
        }
    }
}
