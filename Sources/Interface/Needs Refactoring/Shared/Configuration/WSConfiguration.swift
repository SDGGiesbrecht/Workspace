/*
 WSConfiguration.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2017–2018 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

// [_Warning: Remove this._]

import SDGLogic
import SDGCollections
import GeneralImports

extension Configuration {

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
            entry = [
                startMultilineOption(option: option),
                value,
                endToken
                ].joinAsLines()
        } else {
            entry = option.key + colon + value
        }

        if let array = comment {
            let note = array.joinAsLines()

            let commentedNote: String
            if note.isMultiline {

                commentedNote = blockCommentSyntax.comment(contents: note)

            } else {

                commentedNote = lineCommentSyntax.comment(contents: note)

            }
            return [
                commentedNote,
                entry
                ].joinAsLines()

        } else {
            return entry
        }
    }

    static func configurationFileEntry(option: Option, value: Bool, comment: [String]?) -> String {
        return configurationFileEntry(option: option, value: String(value ? trueOptionValue : falseOptionValue), comment: comment)
    }

    static func addEntries(entries: [(option: Option, value: String, comment: [String]?)], to configuration: inout File) {

        let additions = entries.map { (entry: (option: Option, value: String, comment: [String]?)) -> String in

            return Configuration.configurationFileEntry(option: entry.option, value: entry.value, comment: entry.comment) + "\n\n"
        }

        configuration.body = additions.joined() + configuration.body
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
                Option.allPublic.map({ $0.key }).joinAsLines()
                ])
        }

        func syntaxError(description: [String]) -> Never {
            fatalError(message: [
                "Syntax error!",
                "",
                description.joinAsLines(),
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
            var result = string.components(separatedBy: token).map { String($0.contents) }
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

            } else if let url = line.scalars.firstNestingLevel(startingWith: importStatementTokens.0.scalars, endingWith: importStatementTokens.1.scalars),
                url.container.range == line.scalars.bounds {
                // Import statement

                let otherFile = parseConfigurationFile(fromLinkedRepositoryAt: String(url.contents.contents))
                for (option, value) in otherFile {
                    result[option] = value
                }

            } else if let multilineOption = line.scalars.firstNestingLevel(startingWith: startTokens.0.scalars, endingWith: startTokens.1.scalars),
                multilineOption.container.range == line.scalars.bounds {
                // Multiline option

                if let option = Option(key: String(multilineOption.contents.contents)) {
                    currentMultilineOption = option
                    result[option] = nil
                } else {
                    reportUnsupportedKey(String(multilineOption.contents.contents))
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
                comment.joinAsLines()
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
        return require { try Repository.packageRepository.configuration.options() }
    }

    static func parseConfigurationFile(fromLinkedRepositoryAt url: String) -> [Option: String] {

        let repositoryName = Repository.nameOfLinkedRepository(atURL: url)
        let otherConfiguration = require { try File(at: Repository.linkedRepository(named: repositoryName).subfolderOrFile(Configuration.fileName)) }

        return parse(configurationSource: otherConfiguration.contents)
    }

    // MARK: - Settings

    static let noValue = "[_None_]"
    static func optionIsDefined(_ option: Option) -> Bool {
        return configurationFile[option] ≠ nil
    }

    private static func invalidEnumValue(option: Option, value: String, valid: [StrictString]) -> Never {
        fatalError(message: [
            "Invalid option value:",
            "",
            "Option: \(option.key)",
            "Value: \(value)",
            "",
            "Valid values:",
            "",
            String(valid.joinAsLines())
            ])
    }

    private static func booleanValue(option: Option) -> Bool {
        if let value = configurationFile[option] {
            switch value {
            case String(trueOptionValue):
                return true
            case String(falseOptionValue):
                return false
            default:
                invalidEnumValue(option: option, value: value, valid: [
                    trueOptionValue,
                    falseOptionValue
                    ])
            }
        } else {
            return option.defaultValue == String(trueOptionValue)
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
                    configurationFile.keys.map({ $0.key }).sorted().joinAsLines()
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

    static func parseLocalizations(_ string: String, for option: Option) throws -> [String: String] {
        var currentLocalization: String?
        var result: [String: [String]] = [:]
        for line in string.lines.lazy.map({ String($0.line) }) {
            if let identifier = line.scalars.firstNestingLevel(startingWith: "[_".scalars, endingWith: "_]".scalars),
                identifier.container.range == line.scalars.bounds,
                ¬line.contains(" ") {
                var code = String(identifier.contents.contents)
                if let fromIcon = ContentLocalization.code(for: StrictString(code)) {
                    code = fromIcon
                }
                currentLocalization = code
            } else {
                guard let localization = currentLocalization else {
                    throw Command.Error(description: UserFacing<StrictString, InterfaceLocalization>({ (localization) in
                        switch localization {
                        case .englishCanada:
                            return [
                                StrictString("Localization syntax error in configuration option: \(option.key)")
                                ].joinAsLines()
                        }
                    }))
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
        var mapped: [String: String] = [:]
        for (key, value) in result {
            mapped[key] = value.joinAsLines()
        }
        return mapped
    }

    // Project Names

    static func moduleName(forProjectName projectName: String) -> String {
        return projectName.replacingOccurrences(of: " ", with: "")
    }

    // Responsibilities

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

    static var manageFileHeaders: Bool {
        return booleanValue(option: .manageFileHeaders)
    }
    static var fileHeader: String {
        return stringValue(option: .fileHeader)
    }
    static var requiredAuthor: String {
        return stringValue(option: .author)
    }
    static var requiredProjectWebsite: String {
        return stringValue(option: .projectWebsite)
    }

    static var manageXcode: Bool {
        return booleanValue(option: .manageXcode)
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
                        return [
                            "[_Begin \(option.key)_]",
                            actualValue,
                            "[_End_]"
                            ].joinAsLines()
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
                    "For more information, see \(link.url.in(Underline.underlined))"
                    ])
            }

            succeeding = false
            printValidationFailureDescription(description)
        }

        // Documentation Deployment

        if optionIsDefined(.encryptedTravisDeploymentKey) ∧ ¬optionIsDefined(.originalDocumentationCopyrightYear) {
            incompatibilityDetected(between: .encryptedTravisDeploymentKey, and: .originalDocumentationCopyrightYear, documentation: DocumentationLink.documentationGeneration)
        }

        return succeeding
    }
}
