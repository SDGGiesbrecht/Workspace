/*
 FileType.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace

 Copyright ©2017 Jeremy David Giesbrecht and the Workspace contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGLogic

enum FileType: CustomStringConvertible {
    
    // MARK: - Static Properties
    
    private static var unsupportedTypesEncountered: Set<String> = []
    static var unsupportedTypesWarning: [String]? {
        
        if unsupportedTypesEncountered.isEmpty {
            return nil
        } else {
            
            var warning: [String] = [
                "Workspace encountered unsupported file types:",
                ]
            
            warning.append(contentsOf: unsupportedTypesEncountered.sorted())
            
            warning.append(contentsOf: [
                "All such files were skipped.",
                "If these are standard file types, please report them at:",
                DocumentationLink.reportIssueLink,
                "To silence this warning for non‐standard file types, see:",
                DocumentationLink.ignoringFileTypes.url,
                ])
            
            return warning
        }
    }
    
    // MARK: - Initialization
    
    init?(filePath: RelativePath) {
        
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
            
            if ¬Configuration.ignoreFileTypes.contains(identifier) {
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
    case yaml
    
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
        (".yaml", .yaml),
        (".yml", .yaml),
        
        ]
    
    // MARK: - Syntax
    
    var syntax: FileSyntax {
        switch self {
        case .workspaceConfiguration:
            return Configuration.syntax
        case .swift:
            return FileSyntax(blockCommentSyntax: BlockCommentSyntax(start: "/*", end: "*/", stylisticIndent: " "), lineCommentSyntax: LineCommentSyntax(start: "//"))
        case .markdown:
            return FileSyntax(blockCommentSyntax: BlockCommentSyntax(start: "<!--", end: "-->", stylisticIndent: " "), lineCommentSyntax: nil)
        case .gitignore:
            return FileSyntax(blockCommentSyntax: nil, lineCommentSyntax: LineCommentSyntax(start: "#"))
        case .shell:
            return FileSyntax(blockCommentSyntax: nil, lineCommentSyntax: LineCommentSyntax(start: "#"), requiredFirstLineTokens: (start: "#!", end: "sh"))
        case .yaml:
            return FileSyntax(blockCommentSyntax: nil, lineCommentSyntax: LineCommentSyntax(start: "#"), requiredFirstLineTokens: nil)
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
        case .yaml:
            return "YAML"
        }
    }
}
