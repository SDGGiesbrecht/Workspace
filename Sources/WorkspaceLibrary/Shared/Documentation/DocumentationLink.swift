/*
 DocumentationLink.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace

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
        case .platforms, .setUp:
            return false
        default:
            return true
        }
    }
    
    // MARK: - Cases
    
    case platforms = "README.md#platforms"
    case setUp = "README.md#setup"
    case responsibilities = "Responsibilities.md"
    case git = "Git.md"
    case licence = "Licence.md"
    case contributingInstructions = "Contributing Instructions.md"
    case xcode = "Xcode.md"
    case fileHeaders = "File Headers.md"
    case continuousIntegration = "Continuous Integration.md"
    case ignoringFileTypes = "Ignoring File Types.md"
    
    static var all: [DocumentationLink] {
        return [
            .platforms,
            .setUp,
            .responsibilities,
            .git,
            .licence,
            .contributingInstructions,
            .xcode,
            .fileHeaders,
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
