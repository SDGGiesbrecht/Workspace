/*
 Document.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2017–2018 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import WSGeneralImports
import WSValidation

import WSDocumentation

extension Workspace {
    enum Document {

        private static let name = UserFacing<StrictString, InterfaceLocalization>({ localization in
            switch localization {
            case .englishCanada:
                return "document"
            }
        })

        private static let description = UserFacing<StrictString, InterfaceLocalization>({ localization in
            switch localization {
            case .englishCanada:
                return "generates API documentation."
            }
        })

        static let command = Command(name: name, description: description, directArguments: [], options: standardOptions, execution: { (_, options: Options, output: Command.Output) throws in

            if options.jazzy {
                if try options.project.configuration(output: output).xcode.manage {
                    try Workspace.Refresh.Xcode.executeAsStep(options: options, output: output)
                }
            }

            var validationStatus = ValidationStatus()
            let outputDirectory = options.project.defaultDocumentationDirectory
            try executeAsStep(outputDirectory: outputDirectory, options: options, validationStatus: &validationStatus, output: output)

            guard validationStatus.validatedSomething else {
                throw Command.Error(description: UserFacing<StrictString, InterfaceLocalization>({ localization in
                    switch localization {
                    case .englishCanada:
                        return [
                            "Nothing to document.",
                            "The package manifest does not define any products."
                            ].joinedAsLines()
                    }
                }))
            }
            try validationStatus.reportOutcome(project: options.project, output: output)
        })

        static func executeAsStep(outputDirectory: URL, options: Options, validationStatus: inout ValidationStatus, output: Command.Output) throws {
            try options.project.document(outputDirectory: outputDirectory, validationStatus: &validationStatus, output: output)
        }
    }
}
