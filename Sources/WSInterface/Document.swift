/*
 Document.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2017–2019 Jeremy David Giesbrecht and the Workspace project contributors.

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

        private static let discussion = UserFacing<StrictString, InterfaceLocalization>({ localization in
            switch localization {
            case .englishCanada:
                return [
                    "By default, the generated documentation will be placed in a “docs” folder at the project root. The GitHub settings described in the following link can be adjusted to automatically host the documentation directly from the repository.",
                   "",
                   "https://help.github.com/articles/configuring\u{2D}a\u{2D}publishing\u{2D}source\u{2D}for\u{2D}github\u{2D}pages/#publishing\u{2D}your\u{2D}github\u{2D}pages\u{2D}site\u{2D}from\u{2D}a\u{2D}docs\u{2D}folder\u{2D}on\u{2D}your\u{2D}master\u{2D}branch",
                    "",
                    "(If you wish to avoid checking generated files into “master”, see the documentation of the “encryptedTravisCIDeploymentKey” configuration option for a more advanced method.)"
                    ].joinedAsLines()
            }
        })

        static let command = Command(
            name: name,
            description: description,
            discussion: discussion,
            directArguments: [],
            options: standardOptions,
            execution: { (_, options: Options, output: Command.Output) throws in

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
