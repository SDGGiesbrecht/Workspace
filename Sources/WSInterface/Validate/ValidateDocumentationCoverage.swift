/*
 ValidateDocumentationCoverage.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2017–2018 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGLogic
import WSValidation
import WSGeneralImports

import WSDocumentation

extension Workspace.Validate {

    enum DocumentationCoverage {

        private static let name = UserFacing<StrictString, InterfaceLocalization>({ localization in
            switch localization {
            case .englishCanada:
                return "documentation‐coverage"
            }
        })

        private static let description = UserFacing<StrictString, InterfaceLocalization>({ localization in
            switch localization {
            case .englishCanada:
                return "validates documentation coverage, checking that every public symbol in every library product is documented."
            }
        })

        static let command = Command(name: name, description: description, directArguments: [], options: [], execution: { (_, options: Options, output: Command.Output) throws in

            #if os(Linux)
            throw linuxJazzyError()
            #else

            if try options.project.configuration(output: output).xcode.manage {
                try Workspace.Refresh.Xcode.executeAsStep(options: options, output: output)
            }

            var validationStatus = ValidationStatus()
            try executeAsStepDocumentingFirst(options: options, validationStatus: &validationStatus, output: output)

            if ¬validationStatus.validatedSomething {
                validationStatus.passStep(message: UserFacing<StrictString, InterfaceLocalization>({ localization in
                    switch localization {
                    case .englishCanada:
                        return "No library products to document."
                    }
                }))
            }

            try validationStatus.reportOutcome(project: options.project, output: output)

            #endif
        })

        #if !os(Linux)
        static func executeAsStepDocumentingFirst(options: Options, validationStatus: inout ValidationStatus, output: Command.Output) throws {

            // Refresh documentation so that results are meaningful.
            let outputDirectory: URL
            let outputIsTemporary: Bool
            if try options.project.configuration(output: output).documentation.api.encryptedTravisCIDeploymentKey ≠ nil
                ∨ ¬(try options.project.configuration(output: output).documentation.api.generate) {
                outputDirectory = FileManager.default.url(in: .temporary, at: "Documentation")
                outputIsTemporary = true
            } else {
                outputDirectory = options.project.defaultDocumentationDirectory
                outputIsTemporary = false
            }
            defer {
                if outputIsTemporary {
                    try? FileManager.default.removeItem(at: outputDirectory)
                }
            }

            try Workspace.Document.executeAsStep(outputDirectory: outputDirectory, options: options, validationStatus: &validationStatus, output: output)

            try executeAsStep(outputDirectory: outputDirectory, options: options, validationStatus: &validationStatus, output: output)
        }
        #endif

        #if !os(Linux)
        static func executeAsStep(outputDirectory: URL, options: Options, validationStatus: inout ValidationStatus, output: Command.Output) throws {
            try options.project.validateDocumentationCoverage(outputDirectory: outputDirectory, validationStatus: &validationStatus, output: output)
        }
        #endif
    }
}
