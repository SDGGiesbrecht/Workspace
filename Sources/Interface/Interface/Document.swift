/*
 Document.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2017–2018 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import GeneralImports

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
                return "generates API documentation for each library product."
            }
        })

        static let command = Command(name: name, description: description, directArguments: [], options: [], execution: { (_, options: Options, output: Command.Output) throws in

            #if os(Linux)
                throw linuxJazzyError()
            #else

                var validationStatus = ValidationStatus()
                let outputDirectory = Documentation.defaultDocumentationDirectory(for: options.project)
                try executeAsStep(outputDirectory: outputDirectory, options: options, validationStatus: &validationStatus, output: output)

                guard validationStatus.validatedSomething else {
                    throw Command.Error(description: UserFacing<StrictString, InterfaceLocalization>({ localization in
                        switch localization {
                        case .englishCanada:
                            return [
                                "Nothing to document.",
                                "The package manifest does not define any library products."
                                ].joinedAsLines()
                        }
                    }))
                }
                try validationStatus.reportOutcome(projectName: try options.project.projectName(), output: output)

            #endif
        })

        #if !os(Linux)
        static func executeAsStep(outputDirectory: URL, options: Options, validationStatus: inout ValidationStatus, output: Command.Output) throws {
            try options.project.document(outputDirectory: outputDirectory, validationStatus: &validationStatus, output: output)
        }
        #endif
    }
}
