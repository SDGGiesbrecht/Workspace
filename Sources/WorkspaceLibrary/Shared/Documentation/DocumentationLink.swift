/*
 DocumentationLink.swift

 This source file is part of the Workspace open source project.

 Copyright ©2017 Jeremy David Giesbrecht and the Workspace contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

enum DocumentationLink: String, CustomStringConvertible {
    
    // MARK: - Configuration
    
    private static let repository = "https://github.com/SDGGiesbrecht/Workspace"
    static let reportIssueLink = repository + "/issues"

    private static let documentationFolder = "/blob/master/Documentation/"
    private var inDocumentationFolder: Bool {
        switch self {
        case .setUp:
            return false
        default:
            return true
        }
    }
    
    // MARK: - Cases
    
    case setUp = "README.md#setup"
    case responsibilities = "Responsibilities.md"
    case git = "Git.md"
    case licence = "Licence.md"
    case fileHeaders = "File Headers.md"
    case xcode = "Xcode.md"
    case continuousIntegration = "Continuous Integration.md"
    case ignoringFileTypes = "Ignoring File Types.md"
    
    static var all: [DocumentationLink] {
        return [
            .setUp,
            .responsibilities,
            .git,
            .licence,
            .fileHeaders,
            .xcode,
            .continuousIntegration,
            .ignoringFileTypes,
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
