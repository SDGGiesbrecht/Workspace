
import SDGCollections
import WSGeneralImports
import WorkspaceProjectConfiguration

public enum FileType {

    // MARK: - Static Properties

    private static var unsupportedFileTypesEncountered: [String: URL] = [:]
    public static func unsupportedTypesWarning(for project: PackageRepository) throws -> StrictString? {

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

        let pathExtension = url.pathExtension
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

    case css
    case gitIgnore
    case html
    case javaScript
    case json
    case markdown
    case shell
    case swift
    case swiftPackageManifest
    case xcodeProject
    case yaml

    // Deprecated (Only exists so proofreading can detect it.)
    case deprecatedWorkspaceConfiguration

    private static let specialNames: [String: FileType] = [
        ".gitattributes": .gitIgnore,
        ".gitignore": .gitIgnore,
        "Package.swift": .swiftPackageManifest,
        ".Workspace Configuration.txt": .deprecatedWorkspaceConfiguration,
    ]

    private static let fileExtensions: [String: FileType] = [
        "command": .shell,
        "css": .css,
        "htm": html,
        "html": .html,
        "js": .javaScript,
        "json": .json,
        "md": .markdown,
        "pbxproj": .xcodeProject,
        "sh": .shell,
        "swift": .swift,
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

        case  .swift, .css, .javaScript:
            return FileSyntax(blockCommentSyntax: FileType.swiftBlockCommentSyntax, lineCommentSyntax: FileType.swiftLineCommentSyntax)
        case .swiftPackageManifest:
            return FileSyntax(blockCommentSyntax: FileType.swiftBlockCommentSyntax, lineCommentSyntax: FileType.swiftLineCommentSyntax, requiredFirstLineToken: "/\u{2F} swift\u{2D}tools\u{2D}version:")

        case .gitIgnore, .yaml:
            return FileSyntax(blockCommentSyntax: nil, lineCommentSyntax: LineCommentSyntax(start: "#"))
        case .html:
            return FileSyntax(blockCommentSyntax: FileType.htmlBlockComment, lineCommentSyntax: nil, requiredFirstLineToken: "<\u{21}DOCTYPE")
        case .json:
            return FileSyntax(blockCommentSyntax: nil, lineCommentSyntax: nil)
        case .markdown:
            return FileSyntax(blockCommentSyntax: FileType.htmlBlockComment, lineCommentSyntax: nil, semanticLineTerminalWhitespace: ["  "])
        case .shell:
            return FileSyntax(blockCommentSyntax: nil, lineCommentSyntax: LineCommentSyntax(start: "#"), requiredFirstLineToken: "#!")
        case .xcodeProject:
            return FileSyntax(blockCommentSyntax: FileType.swiftBlockCommentSyntax, lineCommentSyntax: FileType.swiftLineCommentSyntax)

        case .deprecatedWorkspaceConfiguration:
            return FileSyntax(blockCommentSyntax: nil, lineCommentSyntax: nil, requiredFirstLineToken: nil, semanticLineTerminalWhitespace: [])
        }
    }
}
