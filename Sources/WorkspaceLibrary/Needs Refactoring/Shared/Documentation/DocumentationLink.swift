/*
 DocumentationLink.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2017–2018 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGCornerstone

enum DocumentationLink : String, CustomStringConvertible {

    // MARK: - Configuration

    private static let repository = "https://github.com/SDGGiesbrecht/Workspace"
    static let reportIssueLink = repository + "/issues"

    private static let documentationFolder = "/blob/master/Documentation/"
    private var inDocumentationFolder: Bool {
        return ¬rawValue.hasPrefix("#")
    }

    // MARK: - Cases

    case installation = "#installation"
    case requiringOptions = "Configuring Workspace.md#requiring\u{2D}options"
    case projectTypes = "Project Types.md"
    case git = "Git.md"
    case readMe = "Read‐Me.md"
    case licence = "Licence.md"
    case contributingInstructions = "Contributing Instructions.md"
    case xcode = "Xcode.md"
    case fileHeaders = "File Headers.md"
    case resources = "Resources.md"
    case documentationGeneration = "Documentation Generation.md"
    case continuousIntegration = "Continuous Integration.md"
    case ignoringFileTypes = "Ignoring File Types.md"

    static var all: [DocumentationLink] {
        return [
            .projectTypes,
            .git,
            .readMe,
            .licence,
            .contributingInstructions,
            .xcode,
            .fileHeaders,
            .resources,
            .documentationGeneration,
            .continuousIntegration,
            .ignoringFileTypes
        ]
    }

    // MARK: - Properties

    var url: String {
        var result = DocumentationLink.repository

        if inDocumentationFolder {
            result.append(DocumentationLink.documentationFolder)
        }

        result.append(rawValue)

        return result
    }

    // MARK: - CustomStringConvertible

    var description: String {
        return url
    }
}
