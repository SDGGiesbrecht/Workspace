/*
 ValidateDocumentationCoverage.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2017 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import Foundation

import SDGCornerstone
import SDGCommandLine

extension Workspace.Validate {

    enum DocumentationCoverage {

        private static let name = UserFacingText<InterfaceLocalization, Void>({ (localization: InterfaceLocalization, _) -> StrictString in
            switch localization {
            case .englishCanada:
                return "documentation‐coverage"
            }
        })

        private static let description = UserFacingText<InterfaceLocalization, Void>({ (localization: InterfaceLocalization, _) -> StrictString in
            switch localization {
            case .englishCanada:
                return "validates documentation coverage, checking that every public symbol in every library product is documented."
            }
        })

        static let command = Command(name: name, description: description, directArguments: [], options: [], execution: { (_, options: Options, output: inout Command.Output) throws in

            #if os(Linux)
                throw linuxJazzyError()
            #else

            guard try options.project.configuration.shouldEnforceDocumentationCoverage() else {
                throw Command.Error(description: UserFacingText({(localization: InterfaceLocalization, _: Void) in
                    switch localization {
                    case .englishCanada:
                        return "The Workspace configuration prevents documentation coverage enforcement."
                    }
                }))
            }

            var validationStatus = ValidationStatus()
            try executeAsStepDocumentingFirst(options: options, validationStatus: &validationStatus, output: &output)

            if ¬validationStatus.validatedSomething {
                validationStatus.passStep(message: UserFacingText({(localization: InterfaceLocalization, _: Void) in
                    switch localization {
                    case .englishCanada:
                        return "No library products to document."
                    }
                }))
            }

            try validationStatus.reportOutcome(projectName: try options.project.projectName(output: &output), output: &output)

            #endif
        })

        #if !os(Linux)
        static func executeAsStepDocumentingFirst(options: Options, validationStatus: inout ValidationStatus, output: inout Command.Output) throws {
            if try options.project.configuration.shouldEnforceDocumentationCoverage() {

                // Refresh documentation so that results are meaningful.
                let outputDirectory: URL
                let outputIsTemporary: Bool
                if options.project.configuration.encryptedTravisDeploymentKey ≠ nil {
                    outputDirectory = FileManager.default.url(in: .temporary, at: "Documentation")
                    outputIsTemporary = true
                } else {
                    outputDirectory = Documentation.defaultDocumentationDirectory(for: options.project)
                    outputIsTemporary = false
                }
                defer {
                    if outputIsTemporary {
                        try? FileManager.default.removeItem(at: outputDirectory)
                    }
                }

                try Workspace.Document.executeAsStep(outputDirectory: outputDirectory, options: options, validationStatus: &validationStatus, output: &output)

                try options.project.validateDocumentationCoverage(outputDirectory: outputDirectory, validationStatus: &validationStatus, output: &output)
            }
        }
        #endif

        #if !os(Linux)
        static func executeAsStep(outputDirectory: URL, options: Options, validationStatus: inout ValidationStatus, output: inout Command.Output) throws {
            if try options.project.configuration.shouldEnforceDocumentationCoverage() {
                try options.project.validateDocumentationCoverage(outputDirectory: outputDirectory, validationStatus: &validationStatus, output: &output)
            }
        }
        #endif
    }
}
