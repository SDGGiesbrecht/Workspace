// FileType.swift
//
// This source file is part of the Workspace open source project.
//
// Copyright ©2017 Jeremy David Giesbrecht and the Workspace contributors.
//
// Soli Deo gloria
//
// Licensed under the Apache License, Version 2.0
// See http://www.apache.org/licenses/LICENSE-2.0 for licence information.

enum FileType: CustomStringConvertible {
    
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
