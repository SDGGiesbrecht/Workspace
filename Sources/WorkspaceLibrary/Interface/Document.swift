/*
 Document.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2017 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGCornerstone
import SDGCommandLine

extension Workspace {
    enum Document {

        private static let name = UserFacingText<InterfaceLocalization, Void>({ (localization: InterfaceLocalization, _) -> StrictString in
            switch localization {
            case .englishCanada:
                return "document"
            }
        })

        private static let description = UserFacingText<InterfaceLocalization, Void>({ (localization: InterfaceLocalization, _) -> StrictString in
            switch localization {
            case .englishCanada:
                return "generates API documentation for the project."
            }
        })

        static let command = Command(name: name, description: description, directArguments: [], options: [], execution: { (directArguments: DirectArguments, options: Options, output: inout Command.Output) throws in

            guard try options.project.configuration.shouldGenerateDocumentation() else {
                throw Command.Error(description: UserFacingText({(localization: InterfaceLocalization, _: Void) in
                    switch localization {
                    case .englishCanada:
                        return "The Workspace configuration prevents documentation generation."
                    }
                }))
            }

            var validationStatus = ValidationStatus()
            try executeAsStep(directArguments: directArguments, options: options, validationStatus: &validationStatus, output: &output)

            guard validationStatus.validatedSomething else {
                throw Command.Error(description: UserFacingText({(localization: InterfaceLocalization, _: Void) in
                    switch localization {
                    case .englishCanada:
                        return StrictString(join(lines: [
                            "Nothing to document.",
                            "The package manifest does not define any library products."
                            ]))
                    }
                }))
            }
            try validationStatus.reportOutcome(projectName: try options.project.configuration.projectName(), output: &output)
        })

        static func executeAsStep(directArguments: DirectArguments, options: Options, validationStatus: inout ValidationStatus, output: inout Command.Output) throws {
            if try options.project.configuration.shouldGenerateDocumentation() {
                try options.project.document(validationStatus: &validationStatus, output: &output)
            }
        }
    }
}
