/*
 Configuration.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2017 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGCornerstone

struct Configuration {

    // MARK: - Cache

    private struct Cache {

        // MARK: - Properties

        fileprivate var file: File?
        fileprivate var configurationFile: [Option: String]?
        fileprivate var packageName: String?

        // MARK: - Settings

        fileprivate var localizations: [ArbitraryLocalization]?

        fileprivate var automaticallyTakeOnNewResponsibilites: Bool?
    }
    private static var cache = Cache()

    // MARK: - Interface

    static func resetCache() {
        cache = Cache()
    }

    static let configurationFilePath: RelativePath = ".Workspace Configuration.txt"
    static var file: File {
        return cached(in: &cache.file) {
            () -> File in

            do {
                return try File(at: configurationFilePath)
            } catch {
                print([
                    "Found no configuration file.",
                    "Following the default configuration."
                    ])
                return File(possiblyAt: configurationFilePath)
            }
        }
    }

    private static let startTokens = (start: "[_Begin ", end: "_]")
    private static func startMultilineOption(option: Option) -> String {
        return "\(startTokens.start)\(option)\(startTokens.end)"
    }
    private static let endToken = "[_End_]"
    private static let colon = ": "

    private static let lineCommentSyntax = LineCommentSyntax(start: "(", stylisticSpacing: false, stylisticEnd: ")")
    private static let blockCommentSyntax = BlockCommentSyntax(start: "((", end: "))", stylisticIndent: "    ")
    static let syntax = FileSyntax(blockCommentSyntax: blockCommentSyntax, lineCommentSyntax: lineCommentSyntax)

    private static let importStatementTokens = (start: "[_Import ", end: "_]")

    static func configurationFileEntry(option: Option, value: String, comment: [String]?) -> String {

        print(["Adding “\(option.key)” to configuration..."])

        let entry: String
        if value.isMultiline {
            entry = join(lines: [
                startMultilineOption(option: option),
                value,
                endToken
                ])
        } else {
            entry = option.key + colon + value
        }

        if let array = comment {
            let note = join(lines: array)

            let commentedNote: String
            if note.isMultiline {

                commentedNote = blockCommentSyntax.comment(contents: note)

            } else {

                commentedNote = lineCommentSyntax.comment(contents: note)

            }
            return join(lines: [
                commentedNote,
                entry
                ])

        } else {
            return entry
        }
    }

    static func configurationFileEntry(option: Option, value: Bool, comment: [String]?) -> String {
        return configurationFileEntry(option: option, value: value ? trueOptionValue : falseOptionValue, comment: comment)
    }

    static func addEntries(entries: [(option: Option, value: String, comment: [String]?)], to configuration: inout File) {

        let additions = entries.map() { (entry: (option: Option, value: String, comment: [String]?)) -> String in

            return Configuration.configurationFileEntry(option: entry.option, value: entry.value, comment: entry.comment) + "\n\n"
        }

        configuration.body = additions.joined() + configuration.body
    }

    static func addEntries(entries: [(option: Option, value: String, comment: [String]?)]) {
        var configuration = file
        addEntries(entries: entries, to: &configuration)
        require() { try configuration.write() }
    }

    // MARK: - Properties

    static func parse(configurationSource: String) -> [Option: String] {
        func reportUnsupportedKey(_ key: String) -> Never {
            fatalError(message: [
                "Unsupported configuration key:",
                key,
                "",
                "Supported keys:",
                "",
                join(lines: Option.allPublic.map({ $0.key }))
                ])
        }

        func syntaxError(description: [String]) -> Never {
            fatalError(message: [
                "Syntax error!",
                "",
                join(lines: description),
                "",
                "Valid syntax:",
                "",
                "Option A\(colon)Simple Value",
                "",
                "\(startTokens.start)Option B\(startTokens.end)",
                "Multiline",
                "Value",
                endToken,
                "",
                lineCommentSyntax.comment(contents: "Comment"),
                "",
                blockCommentSyntax.comment(contents: [
                    "Multiline",
                    "Comment"
                    ]),
                "",
                "\(importStatementTokens.start)https://github.com/user/repository\(importStatementTokens.end)"
                ])
        }

        func split(_ string: String, at token: String) -> (before: String, after: String)? {
            var result = string.components(separatedBy: token)
            guard result.count > 1 else {
                return nil
            }
            let before = result.removeFirst()
            let after = result.joined(separator: token)
            return (before, after)
        }

        var result: [Option: String] = [:]
        var currentMultilineOption: Option?
        var currentMultilineComment: [String]?
        for line in configurationSource.lines.map({ String($0.line) }) {

            if let option = currentMultilineOption {
                // In multiline value

                if line == endToken {
                    currentMultilineOption = nil
                } else {
                    var content: String
                    if let existing = result[option] {
                        content = existing
                        content.append("\n" + line)
                    } else {
                        content = line
                    }

                    result[option] = content
                }

            } else if currentMultilineComment ≠ nil {
                // In multiline comment

                if line.hasSuffix(blockCommentSyntax.end) {
                    currentMultilineComment = nil
                } else {
                    currentMultilineComment?.append(line)
                }

            } else if blockCommentSyntax.startOfCommentExists(at: line.startIndex, in: line) {
                // Multiline comment

                currentMultilineComment = [line]

            } else if line == "" ∨ lineCommentSyntax.commentExists(at: line.startIndex, in: line) {
                // Comment or whitespace

            } else if let url = line.contents(of: importStatementTokens, requireWholeStringToMatch: true) {
                // Import statement

                let otherFile = parseConfigurationFile(fromLinkedRepositoryAt: url)
                for (option, value) in otherFile {
                    result[option] = value
                }

            } else if let multilineOption = line.contents(of: startTokens, requireWholeStringToMatch: true) {
                // Multiline option

                if let option = Option(key: multilineOption) {
                    currentMultilineOption = option
                } else {
                    reportUnsupportedKey(multilineOption)
                }

            } else if let (optionKey, value) = split(line, at: colon) {
                // Simple option

                if let option = Option(key: optionKey) {
                    result[option] = value
                } else {
                    reportUnsupportedKey(optionKey)
                }

            } else {
                // Syntax error

                syntaxError(description: [
                    "Invalid Option:",
                    line
                    ])
            }
        }

        if let comment = currentMultilineComment {
            syntaxError(description: [
                "Unterminated Comment:",
                join(lines: comment)
                ])
        }
        if let option = currentMultilineOption {
            syntaxError(description: [
                "Unterminated Multiline Value:",
                result[option] ?? ""
                ])
        }

        return result
    }

    private static var configurationFile: [Option: String] {
        return cached(in: &cache.configurationFile) {
            () -> [Option: String] in

            return parse(configurationSource: file.contents)
        }
    }

    static func parseConfigurationFile(fromLinkedRepositoryAt url: String) -> [Option: String] {

        let repositoryName = Repository.nameOfLinkedRepository(atURL: url)
        let otherConfiguration = require() { try File(at: Repository.linkedRepository(named: repositoryName).subfolderOrFile(configurationFilePath.string)) }

        return parse(configurationSource: otherConfiguration.contents)
    }

    // MARK: - Settings

    static let noValue = "[_None_]"
    static func optionIsDefined(_ option: Option) -> Bool {
        return configurationFile[option] ≠ nil
    }

    private static func invalidEnumValue(option: Option, value: String, valid: [String]) -> Never {
        fatalError(message: [
            "Invalid option value:",
            "",
            "Option: \(option.key)",
            "Value: \(value)",
            "",
            "Valid values:",
            "",
            join(lines: valid)
            ])
    }

    static let trueOptionValue = "True"
    static let falseOptionValue = "False"
    private static func booleanValue(option: Option) -> Bool {
        if let value = configurationFile[option] {
            switch value {
            case trueOptionValue:
                return true
            case falseOptionValue:
                return false
            default:
                invalidEnumValue(option: option, value: value, valid: [
                    trueOptionValue,
                    falseOptionValue
                    ])
            }
        } else {
            return option.defaultValue == trueOptionValue
        }
    }

    private static func stringValue(option: Option) -> String {
        if let result = configurationFile[option] {
            return result
        } else {
            if option.defaultValue ≠ Configuration.noValue {
                return option.defaultValue
            } else {
                fatalError(message: [
                    "Missing configuration option:",
                    "",
                    option.key,
                    "",
                    "Detected options:",
                    "",
                    join(lines: configurationFile.keys.map({ $0.key }).sorted())
                    ])
            }
        }
    }

    private static func possibleStringValue(option: Option) -> String? {
        let result = configurationFile[option] ?? option.defaultValue
        if result ≠ Configuration.noValue {
            return result
        }
        return nil
    }

    static let emptyListOptionValue = ""
    private static func parseList(value: String) -> [String] {
        if value == "" {
            return []
        } else {
            return value.lines.map({ String($0.line) })
        }
    }
    private static func listValue(option: Option) -> [String] {
        let string = stringValue(option: option)
        return parseList(value: string)
    }

    static func parseLocalizations(_ string: String) -> [ArbitraryLocalization: String]? {
        var currentLocalization: String?
        var result: [String: [String]] = [:]
        for line in string.lines.lazy.map({ String($0.line) }) {
            if let identifier = line.contents(of: ("[_", "_]"), requireWholeStringToMatch: true) {
                currentLocalization = identifier
            } else {
                guard let localization = currentLocalization else {
                    return nil
                }
                var text: [String]
                if let existing = result[localization] {
                    text = existing
                } else {
                    text = []
                }
                text.append(line)
                result[localization] = text
            }
        }
        var mapped: [ArbitraryLocalization: String] = [:]
        for (key, value) in result {
            mapped[ArbitraryLocalization(code: key)] = join(lines: value)
        }
        return mapped
    }
    private static func localizedOptionValues(option: Option, configuration: [Option: String]? = nil) -> [ArbitraryLocalization: String]? {
        var file = configuration ?? configurationFile

        guard let string = file[option] else {
            return nil
        }
        guard let localized = parseLocalizations(string) else {
            return nil
        }
        return localized
    }
    static func localizedOptionValue(option: Option, localization: ArbitraryLocalization?, configuration: [Option: String]? = nil) -> String? {
        var file = configuration ?? configurationFile

        guard let localized = localizedOptionValues(option: option, configuration: file) else {
            return file[option]
        }
        guard let specific = localization else {
            guard let development = developmentLocalization else {
                return file[option]
            }
            return localized[development]
        }
        return localized[specific]
    }
    private static func missingLocalizationError(option: Option, localization: ArbitraryLocalization?) -> Never {
        fatalError(message: [
            "Missing configuration option:",
            "",
            option.key,
            "",
            "Localization:",
            "",
            localization?.code ?? "[Unlocalized]",
            "",
            "Detected options:",
            "",
            join(lines: configurationFile.keys.map({ $0.key }).sorted())
            ])
    }
    private static func requiredLocalizedOptionValue(option: Option, localization: ArbitraryLocalization?) -> String {
        guard let result = localizedOptionValue(option: option, localization: localization) else {
            missingLocalizationError(option: option, localization: localization)
        }
        return result
    }

    // Workspace Behaviour

    static var automaticallyTakeOnNewResponsibilites: Bool {
        return booleanValue(option: .automaticallyTakeOnNewResponsibilites)
    }

    // Project Type

    static var projectType: ProjectType {
        let key = stringValue(option: .projectType)

        guard let result = ProjectType(key: key) else {
            invalidEnumValue(option: .projectType, value: key, valid: ProjectType.all.map({ $0.key }))
        }

        return result
    }
    static var requiredOptions: [String] {
        return listValue(option: .requireOptions)
    }

    static var supportMacOS: Bool {
        return booleanValue(option: .supportMacOS)
    }

    static var supportLinux: Bool {
        return booleanValue(option: .supportLinux) ∧ projectType ≠ ProjectType.application
    }

    static var supportIOS: Bool {
        return booleanValue(option: .supportIOS) ∧ projectType ≠ ProjectType.executable
    }

    static var supportWatchOS: Bool {
        return booleanValue(option: .supportWatchOS) ∧ projectType ≠ ProjectType.application ∧ projectType ≠ ProjectType.executable
    }

    static var supportTVOS: Bool {
        return booleanValue(option: .supportTVOS) ∧ projectType ≠ ProjectType.executable
    }

    static var supportOnlyLinux: Bool {
        return ¬supportMacOS ∧ ¬supportIOS ∧ ¬supportWatchOS ∧ ¬supportTVOS
    }

    static var skipSimulators: Bool {
        if Environment.isInContinuousIntegration {
            return false
        } else {
            return booleanValue(option: .skipSimulator)
        }
    }

    static var localizations: [ArbitraryLocalization] {
        return cached(in: &cache.localizations) {
            return listValue(option: .localizations).map { ArbitraryLocalization(code: $0) }
        }
    }
    static var developmentLocalization: ArbitraryLocalization? {
        return localizations.first
    }
    static func resolvedLocalization(for localization: ArbitraryLocalization?) -> ArbitraryLocalization {
        if let specific = localization {
            return specific
        } else {
            if let development = Configuration.developmentLocalization {
                return development
            } else {
                return .compatible(.englishCanada)
            }
        }
    }

    // Project Names

    static var projectName: String {
        return stringValue(option: .projectName)
    }

    static func packageName(forProjectName projectName: String) -> String {
        return projectName
    }
    static var defaultPackageName: String {
        let tokens = ("name: \u{22}", "\u{22}")
        if let name = Repository.packageDescription.contents.contents(of: tokens) {
            return name
        } else {
            return packageName(forProjectName: Repository.folderName)
        }
    }
    static var packageName: String {
        return cached(in: &cache.packageName) {
            () -> String in

            return stringValue(option: .packageName)
        }
    }

    static func moduleName(forProjectName projectName: String) -> String {
        return projectName.replacingOccurrences(of: " ", with: "")
    }
    static var defaultModuleName: String {
        switch projectType {
        case .library, .application:
            return moduleName(forProjectName: projectName)
        default:
            return executableLibraryName(forProjectName: projectName)
        }
    }
    static var moduleName: String {
        return stringValue(option: .moduleName)
    }

    static func executableName(forProjectName projectName: String) -> String {
        return moduleName(forProjectName: projectName).lowercased()
    }
    static func executableLibraryName(forProjectName projectName: String) -> String {
        return moduleName(forProjectName: projectName) + "Library"
    }
    static func testModuleName(forProjectName projectName: String) -> String {
        return moduleName(forProjectName: projectName) + "Tests"
    }

    // Responsibilities

    static var manageReadMe: Bool {
        return booleanValue(option: .manageReadMe)
    }
    static func readMe(localization: ArbitraryLocalization?) -> String {
        return localizedOptionValue(option: .readMe, localization: localization) ?? ReadMe.defaultReadMeTemplate(localization: localization)
    }
    static var documentationURL: String? {
        return possibleStringValue(option: .documentationURL)
    }
    static var requiredDocumentationURL: String {
        return stringValue(option: .documentationURL)
    }
    static func shortProjectDescription(localization: ArbitraryLocalization?) -> String? {
        return localizedOptionValue(option: .shortProjectDescription, localization: localization)
    }
    static func requiredShortProjectDescription(localization: ArbitraryLocalization?) -> String {
        return requiredLocalizedOptionValue(option: .shortProjectDescription, localization: localization)
    }
    static var quotation: String? {
        return possibleStringValue(option: .quotation)
    }
    static var requiredQuotation: String {
        return stringValue(option: .quotation)
    }
    static func quotationTranslation(localization: ArbitraryLocalization?) -> String? {
        return localizedOptionValue(option: .quotationTranslation, localization: localization)
    }
    static func quotationURL(localization: ArbitraryLocalization?) -> String? {
        return localizedOptionValue(option: .quotationURL, localization: localization) ?? ReadMe.defaultQuotationURL(localization: localization)
    }
    static var quotationChapter: String? {
        return possibleStringValue(option: .quotationChapter)
    }
    static var quotationOriginalKey: String {
        let value = stringValue(option: .quotationTestament)
        let old = "Old"
        let new = "New"
        switch value {
        case old:
            return "WLC"
        case new:
            return "SBLGNT"
        default:
            invalidEnumValue(option: .quotationTestament, value: value, valid: [old, new])
        }
    }
    static func citation(localization: ArbitraryLocalization?) -> String? {
        return localizedOptionValue(option: .citation, localization: localization)
    }
    static func featureList(localization: ArbitraryLocalization?) -> String? {
        return localizedOptionValue(option: .featureList, localization: localization)
    }
    static func requiredFeatureList(localization: ArbitraryLocalization?) -> String {
        return requiredLocalizedOptionValue(option: .featureList, localization: localization)
    }
    static func installationInstructions(localization: ArbitraryLocalization?) -> String? {
        return localizedOptionValue(option: .installationInstructions, localization: localization) ?? ReadMe.defaultInstallationInstructions(localization: localization)
    }
    static func requiredInstallationInstructions(localization: ArbitraryLocalization?) -> String {
        guard let result = installationInstructions(localization: localization) else {
            missingLocalizationError(option: .installationInstructions, localization: localization)
        }
        return result
    }
    static var repositoryURL: String? {
        return possibleStringValue(option: .repositoryURL)
    }
    static var requiredRepositoryURL: String {
        return stringValue(option: .repositoryURL)
    }
    static var currentVersion: Version? {
        if let version = possibleStringValue(option: .currentVersion) {
            return Version(version)
        } else {
            return nil
        }
    }
    static var requiredCurrentVersion: Version {
        guard let result = Version(stringValue(option: .currentVersion)) else {
            failTests(message: [
                "Invalid version identifier: " + stringValue(option: .currentVersion)
                ])
        }
        return result
    }
    static var otherReadMeContent: String? {
        return possibleStringValue(option: .otherReadMeContent)
    }
    static var requiredOtherReadMeContent: String {
        return stringValue(option: .otherReadMeContent)
    }

    static var manageLicence: Bool {
        return booleanValue(option: .manageLicence)
    }
    static var licence: Licence? {
        if let key = possibleStringValue(option: .licence) {
            if let result = Licence(key: key) {
                return result
            } else {
                invalidEnumValue(option: .licence, value: key, valid: Licence.all.map({ $0.key }))
            }
        } else {
            return nil
        }
    }
    static var requiredLicence: Licence {
        let key = stringValue(option: .licence)

        if let result = Licence(key: key) {
            return result
        } else {
            invalidEnumValue(option: .licence, value: key, valid: Licence.all.map({ $0.key }))
        }
    }

    static var manageContributingInstructions: Bool {
        return booleanValue(option: .manageContributingInstructions)
    }
    static var contributingInstructions: String {
        return stringValue(option: .contributingInstructions)
    }
    static var issueTemplate: String {
        return stringValue(option: .issueTemplate)
    }
    static var pullRequestTemplate: String {
        return stringValue(option: .pullRequestTemplate)
    }
    static var administrators: [String] {
        return listValue(option: .administrators)
    }
    static var developmentNotes: String? {
        return possibleStringValue(option: .developmentNotes)
    }
    static var requiredDevelopmentNotes: String {
        return possibleStringValue(option: .developmentNotes) ?? ""
    }
    static func relatedProjects(localization: ArbitraryLocalization?) -> [String] {
        if let result = localizedOptionValue(option: .relatedProjects, localization: localization) {
            if result.contains("[_") { // The main project is not localized, but the linked configuration is.
                if let parsedLocalizations = parseLocalizations(result) {
                    if let english = parsedLocalizations[.compatible(.englishCanada)] ?? parsedLocalizations[.compatible(.englishUnitedStates)] {
                        return parseList(value: english)
                    } else {
                        return parseList(value: parsedLocalizations.first?.value ?? "")
                    }
                }
            }
            return parseList(value: result)
        } else {
            return listValue(option: .relatedProjects)
        }
    }

    static var manageFileHeaders: Bool {
        return booleanValue(option: .manageFileHeaders)
    }
    static var fileHeader: String {
        return stringValue(option: .fileHeader)
    }
    static var author: String? {
        return possibleStringValue(option: .author)
    }
    static var requiredAuthor: String {
        return stringValue(option: .author)
    }
    static var projectWebsite: String? {
        return possibleStringValue(option: .projectWebsite)
    }
    static var requiredProjectWebsite: String {
        return stringValue(option: .projectWebsite)
    }

    static var manageXcode: Bool {
        return booleanValue(option: .manageXcode)
    }
    static var xcodeSchemeName: String {
        return stringValue(option: .xcodeSchemeName)
    }
    static var primaryXcodeTarget: String {
        return stringValue(option: .primaryXcodeTarget)
    }
    static var xcodeTestTarget: String {
        return stringValue(option: .xcodeTestTarget)
    }

    static var disableProofreadingRules: Set<String> {
        return Set(listValue(option: .disableProofreadingRules))
    }

    static var prohibitCompilerWarnings: Bool {
        return booleanValue(option: .prohibitCompilerWarnings)
    }

    static var enforceCodeCoverage: Bool {
        return booleanValue(option: .enforceCodeCoverage)
    }
    static var codeCoverageExemptionTokensForSameLine: [String] {
        return listValue(option: .codeCoverageExemptionTokensForSameLine)
    }
    static var codeCoverageExemptionTokensForPreviousLine: [String] {
        return listValue(option: .codeCoverageExemptionTokensForPreviousLine)
    }

    static var generateDocumentation: Bool {
        return booleanValue(option: .generateDocumentation)
    }
    static var enforceDocumentationCoverage: Bool {
        return booleanValue(option: .enforceDocumentationCoverage)
    }
    static var documentationCopyright: String {
        return stringValue(option: .documentationCopyright)
    }

    static var manageContinuousIntegration: Bool {
        return booleanValue(option: .manageContinuousIntegration)
    }

    // Miscellaneous

    static var ignoreFileTypes: Set<String> {
        return Set(listValue(option: .ignoreFileTypes))
    }

    // SDG
    static var sdg: Bool {
        return booleanValue(option: .sdg)
    }

    // Testing
    static var nestedTest: Bool {
        return booleanValue(option: .nestedTest)
    }

    static func validate() -> Bool {

        var succeeding = true

        func incompatibilityDetected(between firstOption: Option, and secondOption: Option, documentation: DocumentationLink?) {

            let firstValue = configurationFile[firstOption]
            let secondValue = configurationFile[secondOption]

            func describe(option: Option, value: String?) -> String {
                if let actualValue = value {
                    if ¬actualValue.isMultiline {
                        return "\(option.key): \(actualValue)"
                    } else {
                        return join(lines: [
                            "[_Begin \(option.key)_]",
                            actualValue,
                            "[_End_]"
                            ])
                    }
                } else {
                    return "\(option.key): [Not specified.]"
                }
            }

            var description: [String] = [
                "The options...",
                describe(option: firstOption, value: firstValue),
                "...and...",
                describe(option: secondOption, value: secondValue),
                "...are incompatible."
            ]

            if let link = documentation {
                description.append(contentsOf: [
                    "For more information, see:",
                    link.url
                    ])
            }

            succeeding = false
            printValidationFailureDescription(description)
        }

        // Project Type vs Operating System

        func check(forIncompatibleOperatingSystem option: Option) {
            if configurationFile[option] == Configuration.trueOptionValue {
                incompatibilityDetected(between: .projectType, and: option, documentation: .platforms)
            }
        }

        if projectType == .application {

            check(forIncompatibleOperatingSystem: .supportLinux)
            check(forIncompatibleOperatingSystem: .supportWatchOS)
        }

        if projectType == .executable {

            check(forIncompatibleOperatingSystem: .supportIOS)
            check(forIncompatibleOperatingSystem: .supportWatchOS)
            check(forIncompatibleOperatingSystem: .supportTVOS)
        }

        // Manage Licence

        if manageLicence ∧ configurationFile[.licence] == nil {
            incompatibilityDetected(between: .manageLicence, and: .licence, documentation: .licence)
        }

        // Custom

        let requiredEntries = requiredOptions
        let requiredDefinitions = requiredEntries.map() { (entry: String) -> (option: Option, types: Set<ProjectType>) in

            func option(forKey key: String) -> Option {
                if let option = Option(key: key) {
                    return option
                } else {
                    fatalError(message: [
                        "Invalide option key in “Required Options”.",
                        "",
                        key,
                        "",
                        "Available Keys:",
                        "",
                        join(lines: Option.allPublic.map({ $0.key }))
                        ])
                }
            }

            let components = entry.components(separatedBy: ": ")

            if components.count == 1 {
                return (option: option(forKey: components[0]), types: Set(ProjectType.all))
            } else {
                guard let type = ProjectType(key: components[0]) else {
                    fatalError(message: [
                        "Invalid project type in “Required Options”:",
                        "",
                        components[0],
                        "",
                        "Available Types:",
                        "",
                        join(lines: ProjectType.all.map({ $0.key }))
                        ])
                }
                return (option: option(forKey: components[1]), types: [type])
            }
        }
        var required: [Option: Set<ProjectType>] = [:]
        for (key, types) in requiredDefinitions {
            if let existing = required[key] {
                required[key] = existing ∪ types
            } else {
                required[key] = types
            }
        }

        for (option, types) in required where configurationFile[option] == nil ∧ Configuration.projectType ∈ types {
            incompatibilityDetected(between: option, and: .requireOptions, documentation: DocumentationLink.requiringOptions)
        }

        return succeeding
    }
}
