/*
 Option.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace

 Copyright ©2017 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

enum Option : String, CustomStringConvertible {

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

    case manageReadMe = "Manage Read‐Me"
    case readMe = "Read‐Me"
    case shortProjectDescription = "Short Project Description"
    case quotation = "Quotation"
    case quotationURL = "Quotation URL"
    case quotationChapter = "Quotation Chapter"
    case quotationTestament = "Quotation Testament"
    case quotationTranslationKey = "Quotation Translation Key"
    case citation = "Citation"

    case manageLicence = "Manage Licence"
    case licence = "Licence"

    case manageContributingInstructions = "Manage Contributing Instructions"
    case contributingInstructions = "Contributing Instructions"
    case issueTemplate = "Issue Template"
    case pullRequestTemplate = "Pull Request Template"
    case administrators = "Administrators"
    case developmentNotes = "Development Notes"

    case manageXcode = "Manage Xcode"

    case manageDependencyGraph = "Manage Dependency Graph"

    case manageFileHeaders = "Manage File Headers"
    case fileHeader = "File Header"
    case author = "Author"
    case projectWebsite = "Project Website"

    case disableProofreadingRules = "Disable Proofreading Rules"

    case prohibitCompilerWarnings = "Prohibit Compiler Warnings"

    case enforceCodeCoverage = "Enforce Code Coverage"
    case codeCoverageExemptionTokensForSameLine = "Code Coverage Exemption Tokens for the Same Line"
    case codeCoverageExemptionTokensForPreviousLine = "Code Coverage Exemption Tokens for the Previous Line"

    case generateDocumentation = "Generate Documentation"
    case enforceDocumentationCoverage = "Enforce Documentation Coverage"
    case documentationCopyright = "Documentation Copyright"

    case manageContinuousIntegration = "Manage Continuous Integration"

    case projectName = "Project Name"
    case packageName = "Package Name"
    case moduleName = "Module Name"
    case xcodeSchemeName = "Xcode Scheme Name"
    case primaryXcodeTarget = "Primary Xcode Target"
    case xcodeTestTarget = "Xcode Test Target"

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

        .manageReadMe,
        .readMe,
        .shortProjectDescription,
        .quotation,
        .quotationURL,
        .citation,

        .manageLicence,
        .licence,

        .manageContributingInstructions,
        .contributingInstructions,
        .issueTemplate,
        .pullRequestTemplate,
        .administrators,
        .developmentNotes,

        .manageXcode,

        .manageDependencyGraph,

        .manageFileHeaders,
        .fileHeader,
        .projectWebsite,
        .author,

        .disableProofreadingRules,

        .prohibitCompilerWarnings,

        .enforceCodeCoverage,
        .codeCoverageExemptionTokensForSameLine,
        .codeCoverageExemptionTokensForPreviousLine,

        .generateDocumentation,
        .documentationCopyright,

        .manageContinuousIntegration,
        .enforceDocumentationCoverage,

        .projectName,
        .packageName,
        .moduleName,
        .xcodeSchemeName,
        .primaryXcodeTarget,
        .xcodeTestTarget,

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
            return ProjectType.library.key

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

        case .manageReadMe:
            return Configuration.falseOptionValue
        case .readMe:
            return ReadMe.defaultReadMeTemplate
        case .shortProjectDescription:
            return Configuration.noValue
        case .quotation:
            return Configuration.noValue
        case .quotationURL:
            print("default requested")
            return ReadMe.defaultQuotationURL
        case .quotationChapter:
            return Configuration.noValue
        case .quotationTestament:
            return Configuration.noValue
        case .quotationTranslationKey:
            return Configuration.noValue
        case .citation:
            return Configuration.noValue

        case .manageLicence:
            return Configuration.falseOptionValue
        case .licence:
            return Configuration.noValue

        case .manageContributingInstructions:
            return Configuration.falseOptionValue
        case .contributingInstructions:
            return ContributingInstructions.defaultContributingInstructions
        case .issueTemplate:
            return ContributingInstructions.defaultIssueTemplate
        case .pullRequestTemplate:
            return ContributingInstructions.defaultPullRequestTemplate
        case .administrators:
            return Configuration.emptyListOptionValue
        case .developmentNotes:
            return Configuration.noValue

        case .manageXcode:
            return Configuration.falseOptionValue

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

        case .prohibitCompilerWarnings:
            return Configuration.trueOptionValue

        case .enforceCodeCoverage:
            return Configuration.trueOptionValue
        case .codeCoverageExemptionTokensForSameLine:
            return Configuration.emptyListOptionValue
        case .codeCoverageExemptionTokensForPreviousLine:
            return Configuration.emptyListOptionValue

        case .generateDocumentation:
            return Configuration.falseOptionValue
        case .enforceDocumentationCoverage:
            return Configuration.trueOptionValue
        case .documentationCopyright:
            return FileHeaders.defaultCopyright + " All rights reserved."

        case .manageContinuousIntegration:
            return Configuration.falseOptionValue

        case .projectName:
            return Configuration.packageName
        case .packageName:
            return Configuration.defaultPackageName
        case .moduleName:
            return Configuration.defaultModuleName
        case .xcodeSchemeName:
            return Xcode.defaultXcodeSchemeName
        case .primaryXcodeTarget:
            return Xcode.defaultPrimaryTargetName
        case .xcodeTestTarget:
            return Xcode.defaultTestTargetName

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
        (.manageReadMe, automaticValue: Configuration.trueOptionValue, DocumentationLink.readMe),
        (.manageLicence, automaticValue: Configuration.trueOptionValue, DocumentationLink.licence),
        (.manageContributingInstructions, automaticValue: Configuration.trueOptionValue, DocumentationLink.contributingInstructions),
        (.manageXcode, automaticValue: Configuration.trueOptionValue, DocumentationLink.xcode),
        (.manageDependencyGraph, automaticValue: Configuration.trueOptionValue, DocumentationLink.dependencyGraph),
        (.manageFileHeaders, automaticValue: Configuration.trueOptionValue, DocumentationLink.fileHeaders),
        (.generateDocumentation, automaticValue: Configuration.trueOptionValue, DocumentationLink.documentationGeneration),
        (.manageContinuousIntegration, automaticValue: Configuration.trueOptionValue, DocumentationLink.continuousIntegration)
        ]

    // MARK: - CustomStringConvertible

    var description: String {
        return key
    }
}
