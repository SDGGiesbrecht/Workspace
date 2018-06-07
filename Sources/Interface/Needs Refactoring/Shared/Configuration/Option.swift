/*
 Option.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2017–2018 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

// [_Warning: Remove this._]

import GeneralImports

enum Option : String, CustomStringConvertible {

    // MARK: - Initialization

    init?(key: String) {
        self.init(rawValue: key)
    }

    // MARK: - Cases

    case skipSimulator = "Skip Simulator"

    case localizations = "Localizations"

    case provideScripts = "Provide Scripts"
    case manageReadMe = "Manage Read‐Me"
    case readMe = "Read‐Me"
    case documentationURL = "Documentation URL"
    case shortProjectDescription = "Short Project Description"
    case quotation = "Quotation"
    case quotationTranslation = "Quotation Translation"
    case quotationURL = "Quotation URL"
    case quotationChapter = "Quotation Chapter"
    case quotationTestament = "Quotation Testament"
    case citation = "Citation"
    case featureList = "Feature List"
    case relatedProjects = "Related Projects"
    case installationInstructions = "Installation Instructions"
    case repositoryURL = "Repository URL"
    case currentVersion = "Current Version"
    case exampleUsage = "Example Usage"
    case otherReadMeContent = "Other Read‐Me Content"
    case readMeAboutSection = "Read‐Me About Section"

    case manageLicence = "Manage Licence"
    case licence = "Licence"

    case manageContributingInstructions = "Manage Contributing Instructions"
    case contributingInstructions = "Contributing Instructions"
    case issueTemplate = "Issue Template"
    case pullRequestTemplate = "Pull Request Template"
    case administrators = "Administrators"
    case developmentNotes = "Development Notes"

    case manageXcode = "Manage Xcode"

    case manageFileHeaders = "Manage File Headers"
    case fileHeader = "File Header"
    case author = "Author"
    case projectWebsite = "Project Website"

    case disableProofreadingRules = "Disable Proofreading Rules"

    case prohibitCompilerWarnings = "Prohibit Compiler Warnings"

    case enforceTestCoverage = "Enforce Test Coverage"
    case testCoverageExemptionTokensForSameLine = "Test Coverage Exemption Tokens for the Same Line"
    case testCoverageExemptionTokensForPreviousLine = "Test Coverage Exemption Tokens for the Previous Line"

    case generateDocumentation = "Generate Documentation"
    case enforceDocumentationCoverage = "Enforce Documentation Coverage"
    case documentationCopyright = "Documentation Copyright"
    case originalDocumentationCopyrightYear = "Original Documentation Copyright Year"
    case encryptedTravisDeploymentKey = "Encrypted Travis Deployment Key"

    case manageContinuousIntegration = "Manage Continuous Integration"

    case ignoreFileTypes = "Ignore File Types"

    // SDG
    case sdg = "SDG"

    // Testing Workspace
    case nestedTest = "Nested Test"
    case testOption = "Test Option"
    case testLongOption = "Test Long Option"

    static let allPublic: [Option] = [
        .skipSimulator,

        .localizations,

        .manageReadMe,
        .readMe,
        .documentationURL,
        .shortProjectDescription,
        .quotation,
        .quotationTranslation,
        .quotationURL,
        .citation,
        .featureList,
        .relatedProjects,
        .installationInstructions,
        .repositoryURL,
        .currentVersion,
        .exampleUsage,
        .otherReadMeContent,
        .readMeAboutSection,

        .manageLicence,
        .licence,

        .manageContributingInstructions,
        .contributingInstructions,
        .issueTemplate,
        .pullRequestTemplate,
        .administrators,
        .developmentNotes,

        .manageXcode,

        .manageFileHeaders,
        .fileHeader,
        .projectWebsite,
        .author,

        .disableProofreadingRules,

        .prohibitCompilerWarnings,

        .enforceTestCoverage,
        .testCoverageExemptionTokensForSameLine,
        .testCoverageExemptionTokensForPreviousLine,

        .generateDocumentation,
        .documentationCopyright,
        .originalDocumentationCopyrightYear,
        .encryptedTravisDeploymentKey,

        .manageContinuousIntegration,
        .enforceDocumentationCoverage,

        .ignoreFileTypes
        ]

    // MARK: - Properties

    var key: String {
        return rawValue
    }

    var defaultValue: String {
        switch self {
        case .skipSimulator:
            return String(Configuration.falseOptionValue)

        case .localizations:
            return String(Configuration.emptyListOptionValue)

        case .provideScripts:
            return String(Configuration.trueOptionValue)

        case .manageReadMe:
            return String(Configuration.falseOptionValue)
        case .readMe:
            return Configuration.noValue
        case .documentationURL:
            return Configuration.noValue
        case .shortProjectDescription:
            return Configuration.noValue
        case .quotation:
            return Configuration.noValue
        case .quotationTranslation:
            return Configuration.noValue
        case .quotationURL:
            return Configuration.noValue
        case .quotationChapter:
            return Configuration.noValue
        case .quotationTestament:
            return Configuration.noValue
        case .citation:
            return Configuration.noValue
        case .featureList:
            return Configuration.noValue
        case .relatedProjects:
            return Configuration.emptyListOptionValue
        case .installationInstructions:
            return Configuration.noValue
        case .repositoryURL:
            return Configuration.noValue
        case .currentVersion:
            return Configuration.noValue
        case .exampleUsage:
            return Configuration.noValue
        case .otherReadMeContent:
            return Configuration.noValue
        case .readMeAboutSection:
            return Configuration.noValue

        case .manageLicence:
            return String(Configuration.falseOptionValue)
        case .licence:
            return Configuration.noValue

        case .manageContributingInstructions:
            return String(Configuration.falseOptionValue)
        case .contributingInstructions:
            return ContributingInstructions.defaultContributingInstructions
        case .issueTemplate:
            return (try? ContributingInstructions.defaultIssueTemplate())!
        case .pullRequestTemplate:
            return ContributingInstructions.defaultPullRequestTemplate
        case .administrators:
            return Configuration.emptyListOptionValue
        case .developmentNotes:
            return Configuration.noValue

        case .manageXcode:
            return String(Configuration.falseOptionValue)

        case .manageFileHeaders:
            return String(Configuration.falseOptionValue)
        case .fileHeader:
            return FileHeaders.defaultFileHeader

        case .projectWebsite:
            return Configuration.noValue
        case .author:
            return Configuration.noValue

        case .disableProofreadingRules:
            return Configuration.emptyListOptionValue

        case .prohibitCompilerWarnings:
            return String(Configuration.trueOptionValue)

        case .enforceTestCoverage:
            return String(Configuration.trueOptionValue)
        case .testCoverageExemptionTokensForSameLine:
            return Configuration.emptyListOptionValue
        case .testCoverageExemptionTokensForPreviousLine:
            return Configuration.emptyListOptionValue

        case .generateDocumentation:
            return String(Configuration.trueOptionValue)
        case .enforceDocumentationCoverage:
            return String(Configuration.trueOptionValue)
        case .documentationCopyright:
            return String((try? Repository.packageRepository.configuration.documentationCopyright())!.text)
        case .originalDocumentationCopyrightYear:
            return Configuration.noValue
        case .encryptedTravisDeploymentKey:
            return Configuration.noValue

        case .manageContinuousIntegration:
            return String(Configuration.falseOptionValue)

        case .ignoreFileTypes:
            return Configuration.emptyListOptionValue

        // SDG
        case .sdg:
            return String(Configuration.falseOptionValue)

        // Tests
        case .nestedTest:
            return String(Configuration.falseOptionValue)
        case .testOption:
            return "Default Value"
        case .testLongOption:
            return "Default\nValue"
        }
    }

    // MARK: - CustomStringConvertible

    var description: String {
        return key
    }
}
