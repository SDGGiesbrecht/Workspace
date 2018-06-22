/*
 FileType.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2018 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGCollections
import WSGeneralImports
import WorkspaceProjectConfiguration

public enum FileType {

    // MARK: - Static Properties

    private static var unsupportedFileTypesEncountered: [String: URL] = [:]
    public static func unsupportedTypesWarning(for project: PackageRepository) throws -> StrictString? { // [_Exempt from Test Coverage_] [_Workaround: Until headers are testable._]

        let expected = try project.configuration().repository.ignoredFileTypes
        var unexpectedTypes = unsupportedFileTypesEncountered.filter { key, _ in
            return key ∉ expected
        }

        if unexpectedTypes.isEmpty {
            return nil
        } else {

            var warning: [StrictString] = [
                UserFacing<StrictString, InterfaceLocalization>({ localization in
                    switch localization {
                    case .englishCanada:
                        return "Workspace encountered unsupported file types:"
                    }
                }).resolved()
            ]

            warning.append("")

            let types = unexpectedTypes.keys.sorted().map { key in
                return StrictString("\(key) (\(unexpectedTypes[key]!.path(relativeTo: project.location))")
            }
            warning.append(contentsOf: types)

            warning.append("")

            warning.append(UserFacing<StrictString, InterfaceLocalization>({ localization in
                switch localization {
                case .englishCanada:
                    return ["All such files were skipped.",
                            "If these are standard file types, please report them at",
                            StrictString(Metadata.issuesURL.absoluteString.in(Underline.underlined)),
                            "To silence this warning for non‐standard file types, configure “repository.ignoredFileTypes”."
                    ].joinedAsLines()
                }
            }).resolved())

            return warning.joinedAsLines()
        }
    }

    // MARK: - Initialization

    public init?(url: URL) {

        if let special = FileType.specialNames[url.lastPathComponent] {
            self = special
            return
        }

        var pathExtension = url.pathExtension
        if pathExtension.isEmpty {
            let components = url.lastPathComponent.components(separatedBy: ".") as [String]
            if components.count > 1 {
                pathExtension = components.last!
            } else {
                return nil // File with no extension information.
            }
        }

        if let supported = FileType.fileExtensions[pathExtension] {
            self = supported
            return
        }

        if FileType.unsupportedFileTypesEncountered[pathExtension] == nil {
            FileType.unsupportedFileTypesEncountered[pathExtension] = url
        }
        return nil
    }

    // MARK: - Cases

    case c
    case css
    case gitIgnore
    case html
    case javaScript
    case json
    case lisp
    case markdown
    case objectiveC
    case shell
    case swift
    case swiftPackageManifest
    case xcodeProject
    case xml
    case yaml

    // Deprecated (Only exists so proofreading can detect it.)
    case deprecatedWorkspaceConfiguration

    private static let specialNames: [String: FileType] = [
        "Package.swift": .swiftPackageManifest,
        ".Workspace Configuration.txt": .deprecatedWorkspaceConfiguration
    ]

    private static let fileExtensions: [String: FileType] = [
        "c": .c,
        "command": .shell,
        "css": .css,
        "el": .lisp,
        "gitattributes": .gitIgnore,
        "gitignore": .gitIgnore,
        "h": .objectiveC,
        "htm": html,
        "html": .html,
        "js": .javaScript,
        "json": .json,
        "m": .objectiveC,
        "md": .markdown,
        "pbxproj": .xcodeProject,
        "sh": .shell,
        "swift": .swift,
        "xcscheme": .xml,
        "xml": .xml,
        "yaml": .yaml,
        "yml": .yaml
    ]

    // MARK: - Syntax

    private static let htmlBlockComment = BlockCommentSyntax(start: "<\u{21}\u{2D}\u{2D}", end: "\u{2D}\u{2D}>", stylisticIndent: " ")

    private static let swiftBlockCommentSyntax = BlockCommentSyntax(start: "/*", end: "*/", stylisticIndent: " ")
    private static let swiftLineCommentSyntax = LineCommentSyntax(start: "//")
    public static let swiftDocumentationSyntax = FileSyntax(blockCommentSyntax: BlockCommentSyntax(start: "/*" + "*", end: "*/", stylisticIndent: " "), lineCommentSyntax: LineCommentSyntax(start: "///"))

    public var syntax: FileSyntax {
        switch self {

        case  .swift, .c, .css, .javaScript, .objectiveC, .xcodeProject:
            return FileSyntax(blockCommentSyntax: FileType.swiftBlockCommentSyntax, lineCommentSyntax: FileType.swiftLineCommentSyntax)
        case .swiftPackageManifest:
            return FileSyntax(blockCommentSyntax: FileType.swiftBlockCommentSyntax, lineCommentSyntax: FileType.swiftLineCommentSyntax, requiredFirstLineToken: "/\u{2F} swift\u{2D}tools\u{2D}version:")

        case .shell:
            return FileSyntax(blockCommentSyntax: nil, lineCommentSyntax: LineCommentSyntax(start: "#"), requiredFirstLineToken: "#!")
        case .gitIgnore, .yaml:
            return FileSyntax(blockCommentSyntax: nil, lineCommentSyntax: LineCommentSyntax(start: "#"))

        case .html, .xml:
            return FileSyntax(blockCommentSyntax: FileType.htmlBlockComment, lineCommentSyntax: nil, requiredFirstLineToken: "<\u{21}DOCTYPE") // [_Exempt from Test Coverage_] [_Workaround: Until headers are testable._]
        case .markdown:
            return FileSyntax(blockCommentSyntax: FileType.htmlBlockComment, lineCommentSyntax: nil, semanticLineTerminalWhitespace: ["  "])

        case .lisp:
            return FileSyntax(blockCommentSyntax: BlockCommentSyntax(start: "#|", end: "|#"), lineCommentSyntax: LineCommentSyntax(start: ";")) // [_Exempt from Test Coverage_] [_Workaround: Until headers are testable._]

        case .json:
            return FileSyntax(blockCommentSyntax: nil, lineCommentSyntax: nil) // [_Exempt from Test Coverage_] [_Workaround: Until headers are testable._]

        case .deprecatedWorkspaceConfiguration: // Not actually used anymore.
            return FileSyntax(blockCommentSyntax: nil, lineCommentSyntax: nil)
        }
    }
}
