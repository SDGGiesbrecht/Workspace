/*
 DocumentationLink.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2017–2018 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGLogic

enum DocumentationLink : String, CustomStringConvertible {

    // MARK: - Configuration

    private static let repository = "https://github.com/SDGGiesbrecht/Workspace"

    private static let documentationFolder = "/blob/master/Documentation/"
    private var inDocumentationFolder: Bool {
        return ¬rawValue.hasPrefix("#")
    }

    // MARK: - Cases

    case installation = "#installation"
    case resources = "Resources.md"

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
