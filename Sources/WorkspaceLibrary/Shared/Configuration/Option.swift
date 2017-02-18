/*
 Option.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace

 Copyright ©2017 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

enum Option: String, CustomStringConvertible {

    // MARK: - Initialization

    init?(key: String) {
        self.init(rawValue: key)
    }

    // MARK: - Cases

    case automaticallyTakeOnNewResponsibilites = "Automatically Take On New Responsibilities"

    case projectType = "Project Type"

    case supportMacOS = "Support macOS"
    case supportLinux = "Support Linux"
    case supportIOS = "Support iOS"
    case supportWatchOS = "Support watchOS"
    case supportTVOS = "Support tvOS"

    case skipSimulator = "Skip Simulator"

    case manageLicence = "Manage Licence"
    case licence = "Licence"

    case manageContributingInstructions = "Manage Contributing Instructions"
    case contributingInstructions = "Contributing Instructions"
    case administrators = "Administrators"
    case developmentNotes = "Development Notes"

    case manageXcode = "Manage Xcode"
    case primaryXcodeTarget = "Primary Xcode Target"

    case manageDependencyGraph = "Manage Dependency Graph"

    case manageFileHeaders = "Manage File Headers"
    case fileHeader = "File Header"
    case author = "Author"
    case projectWebsite = "Project Website"

    case disableProofreadingRules = "Disable Proofreading Rules"

    case manageContinuousIntegration = "Manage Continuous Integration"

    case ignoreFileTypes = "Ignore File Types"

    // SDG
    case sdg = "SDG"

    // Testing Workspace
    case nestedTest = "Nested Test"
    case testOption = "Test Option"
    case testLongOption = "Test Long Option"

    static let allPublic: [Option] = [
        .automaticallyTakeOnNewResponsibilites,

        .projectType,

        .supportMacOS,
        .supportLinux,
        .supportIOS,
        .supportWatchOS,
        .supportTVOS,

        .skipSimulator,

        .manageLicence,
        .licence,

        .manageContributingInstructions,
        .contributingInstructions,
        .administrators,
        .developmentNotes,

        .manageXcode,

        .manageDependencyGraph,

        .manageFileHeaders,
        .fileHeader,
        .projectWebsite,
        .author,

        .disableProofreadingRules,

        .manageContinuousIntegration,

        .primaryXcodeTarget,
        .ignoreFileTypes
        ]

    // MARK: - Properties

    var key: String {
        return rawValue
    }

    var defaultValue: String {
        switch self {
        case .automaticallyTakeOnNewResponsibilites:
            return Configuration.falseOptionValue

        case .projectType:
            return Configuration.noValue

        case .supportMacOS:
            return Configuration.trueOptionValue
        case .supportLinux:
            return Configuration.trueOptionValue
        case .supportIOS:
            return Configuration.trueOptionValue
        case .supportWatchOS:
            return Configuration.trueOptionValue
        case .supportTVOS:
            return Configuration.trueOptionValue

        case .skipSimulator:
            return Configuration.falseOptionValue

        case .manageLicence:
            return Configuration.falseOptionValue
        case .licence:
            return Configuration.noValue

        case .manageContributingInstructions:
            return Configuration.falseOptionValue
        case .contributingInstructions:
            return ContributingInstructions.defaultContributingInstructions
        case .administrators:
            return Configuration.emptyListOptionValue
        case .developmentNotes:
            return Configuration.noValue

        case .manageXcode:
            return Configuration.falseOptionValue
        case .primaryXcodeTarget:
            let target = Configuration.projectName
            if Configuration.projectType == .executable {
                return target + "Library"
            } else {
                return target
            }

        case .manageDependencyGraph:
            return Configuration.falseOptionValue

        case .manageFileHeaders:
            return Configuration.falseOptionValue
        case .fileHeader:
            return FileHeaders.defaultFileHeader

        case .projectWebsite:
            return Configuration.noValue
        case .author:
            return Configuration.noValue

        case .disableProofreadingRules:
            return Configuration.emptyListOptionValue

        case .manageContinuousIntegration:
            return Configuration.falseOptionValue

        case .ignoreFileTypes:
            return Configuration.emptyListOptionValue

        // SDG
        case .sdg:
            return Configuration.falseOptionValue

        // Tests
        case .nestedTest:
            return Configuration.falseOptionValue
        case .testOption:
            return "Default Value"
        case .testLongOption:
            return "Default\nValue"
        }
    }

    static let automaticResponsibilityDocumentationPage = DocumentationLink.responsibilities
    static let automaticRepsonsibilities: [(option: Option, automaticValue: String, documentationPage: DocumentationLink)] = [
        (.manageLicence, automaticValue: Configuration.trueOptionValue, DocumentationLink.licence),
        (.manageContributingInstructions, automaticValue: Configuration.trueOptionValue, DocumentationLink.contributingInstructions),
        (.manageXcode, automaticValue: Configuration.trueOptionValue, DocumentationLink.xcode),
        (.manageDependencyGraph, automaticValue: Configuration.trueOptionValue, DocumentationLink.dependencyGraph),
        (.manageFileHeaders, automaticValue: Configuration.trueOptionValue, DocumentationLink.fileHeaders),
        (.manageContinuousIntegration, automaticValue: Configuration.trueOptionValue, DocumentationLink.continuousIntegration)
        ]

    // MARK: - CustomStringConvertible

    var description: String {
        return key
    }
}
