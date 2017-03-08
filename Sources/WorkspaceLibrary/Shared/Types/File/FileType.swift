/*
 FileType.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace

 Copyright ©2017 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGLogic

enum FileType : CustomStringConvertible {

    // MARK: - Static Properties

    private static var unsupportedTypesEncountered: Set<String> = []
    static var unsupportedTypesWarning: [String]? {

        if unsupportedTypesEncountered.isEmpty {
            return nil
        } else {

            var warning: [String] = [
                "Workspace encountered unsupported file types:"
            ]

            warning.append(contentsOf: unsupportedTypesEncountered.sorted())

            warning.append(contentsOf: [
                "All such files were skipped.",
                "If these are standard file types, please report them at:",
                DocumentationLink.reportIssueLink,
                "To silence this warning for non‐standard file types, see:",
                DocumentationLink.ignoringFileTypes.url
                ])

            return warning
        }
    }

    // MARK: - Initialization

    static let binaryFileTypes: Set<String> = [
        "dsidx",
        "nojekyll",
        "plist",
        "png",
        "svg",
        "tgz"
    ]

    init?<P : Path>(filePath: P) {

        var result: FileType?
        for (suffix, type) in FileType.fileNameSuffixes {
            if filePath.string.hasSuffix(suffix) {
                result = type
                break
            }
        }

        if let value = result {
            self = value
        } else {

            let filename = filePath.filename

            let identifier: String
            if let dotRange = filename.range(of: ".") {
                identifier = filename.substring(from: dotRange.upperBound)
            } else {
                identifier = filename
            }

            if ¬FileType.binaryFileTypes.contains(identifier)
                ∧ ¬Configuration.ignoreFileTypes.contains(identifier) {
                FileType.unsupportedTypesEncountered.insert(identifier)
            }

            return nil
        }
    }

    // MARK: - Cases

    // Workspace
    case workspaceConfiguration

    // Source
    case swift

    // Documentation
    case markdown

    // Repository
    case gitignore

    // Scripts
    case shell

    // Configuration of Components
    case json
    case yaml

    // Documentation
    case html
    case css
    case javaScript

    // MARK: - Filename Suffixes

    private static let fileNameSuffixes: [(suffix: String, type: FileType)] = [

        // Workspace
        (Configuration.configurationFilePath.string, .workspaceConfiguration),

        // Source
        (".swift", .swift),

        // Documentation
        (".md", .markdown),

        // Repository
        (".gitignore", .gitignore),
        (".gitattributes", .gitignore),

        // Scripts
        (".sh", .shell),
        (".command", .shell),

        // Configuration of Components
        (".json", .json),

        (".yaml", .yaml),
        (".yml", .yaml),

        // Documentation
        (".html", .html),
        (".htm", .html),

        (".css", .css),

        (".js", .javaScript)
    ]

    // MARK: - Syntax

    private static let htmlBlockComment = BlockCommentSyntax(start: "<\u{21}\u{2D}\u{2D}", end: "\u{2D}\u{2D}>", stylisticIndent: " ")

    var syntax: FileSyntax {
        switch self {
        case .workspaceConfiguration:
            return Configuration.syntax
        case .swift, .css, .javaScript:
            return FileSyntax(blockCommentSyntax: BlockCommentSyntax(start: "/*", end: "*/", stylisticIndent: " "), lineCommentSyntax: LineCommentSyntax(start: "//"))
        case .markdown:
            return FileSyntax(blockCommentSyntax: FileType.htmlBlockComment, lineCommentSyntax: nil, semanticLineTerminalWhitespace: ["  "])
        case .gitignore, .yaml:
            return FileSyntax(blockCommentSyntax: nil, lineCommentSyntax: LineCommentSyntax(start: "#"))
        case .shell:
            return FileSyntax(blockCommentSyntax: nil, lineCommentSyntax: LineCommentSyntax(start: "#"), requiredFirstLineTokens: (start: "#!", end: "sh"))
        case .json:
            return FileSyntax(blockCommentSyntax: nil, lineCommentSyntax: nil)
        case .html:
            return FileSyntax(blockCommentSyntax: FileType.htmlBlockComment, lineCommentSyntax: nil, requiredFirstLineTokens: (start: "<\u{21}DOCTYPE", end: ">"))
        }
    }

    // MARK: - CustomStringConvertible

    var description: String {
        switch self {
        case .workspaceConfiguration:
            return "Workspace Configuration"
        case .swift:
            return "Swift"
        case .markdown:
            return "Markdown"
        case .gitignore:
            return "Git Ignore"
        case .shell:
            return "Shell"
        case .json:
            return "JSON"
        case .yaml:
            return "YAML"
        case .html:
            return "HTML"
        case .css:
            return "CSS"
        case .javaScript:
            return "JavaScript"
        }
    }
}
