// Configuration.swift
//
// This source file is part of the Workspace open source project.
//
// Copyright ©2017 Jeremy David Giesbrecht and the Workspace contributors.
//
// Soli Deo gloria
//
// Licensed under the Apache License, Version 2.0
// See http://www.apache.org/licenses/LICENSE-2.0 for licence information.

import SDGCaching
import SDGLogic

struct Configuration {
    
    // MARK: - Cache
    
    private struct Cache {
        
        // MARK: - Properties
        
        fileprivate var file: File?
        fileprivate var configurationFile: [Option: String]?
        fileprivate var projectName: String?
        
        // MARK: - Settings
        
        fileprivate var automaticallyTakeOnNewResponsibilites: Bool?
    }
    private static var cache = Cache()
    
    // MARK: - Interface
    
    static func resetCache() {
        cache = Cache()
    }
    
    static let configurationFilePath: RelativePath = ".Workspace Configuration.txt"
    static var file: File {
        return cachedResult(cache: &cache.file) {
            () -> File in
            
            do {
                return try Repository.read(file: configurationFilePath)
            } catch {
                print([
                    "Found no configuration file.",
                    "Following the default configuration."
                    ])
                return File(path: configurationFilePath, contents: "")
            }
        }
    }
    
    private static let startTokens = (start: "[_Begin ", end: "_]")
    private static let endToken = "[_End_]"
    private static let colon = ": "
    
    private static let lineCommentSyntax = LineCommentSyntax(start: "(", stylisticSpacing: false, stylisticEnd: ")")
    private static let blockCommentSyntax = BlockCommentSyntax(start: "((", end: "))", stylisticIndent: "    ")
    static let syntax = FileSyntax(blockCommentSyntax: blockCommentSyntax, lineCommentSyntax: lineCommentSyntax)
    
    private static func startMultilineOption(option: Option) -> String {
        return "\(startTokens.start)\(option)\(startTokens.end)"
    }
    
    static func configurationFileEntry(option: Option, value: String, comment: [String]?) -> String {
        
        print(["Adding “\(option.key)” to configuration..."])
        
        let entry: String
        if value.isMultiline {
            entry = join(lines: [
                startMultilineOption(option: option),
                value,
                endToken,
                ])
        } else {
            entry = option.key + colon + value
        }
        
        if let array = comment {
            let note = join(lines: array)
            
            let commentedNote: String
            if note.isMultiline {
                
                commentedNote = blockCommentSyntax.comment(contents: note)
                
            } else {
                
                commentedNote = lineCommentSyntax.comment(contents: note)
                
            }
            return join(lines: [
                commentedNote,
                entry
                ])
            
        } else {
            return entry
        }
    }
    
    static func configurationFileEntry(option: Option, value: Bool, comment: [String]?) -> String {
        return configurationFileEntry(option: option, value: value ? trueOptionValue : falseOptionValue, comment: comment)
    }
    
    static func addEntries(entries: [(option: Option, value: String, comment: [String]?)], to configuration: inout File) {
        
        var additions = ""
        for entry in entries {
            additions.append(Configuration.configurationFileEntry(option: entry.option, value: entry.value, comment: entry.comment))
            additions.append("\n\n")
        }
        
        if additions ≠ "" {
            if configuration.headerStart == configuration.headerEnd {
                // No header
                
                // Prevent comment from disappearing when headers are generated.
                additions = "\n" + additions
            }
            configuration.body = additions + configuration.body
            
        }
    }
    
    static func addEntries(entries: [(option: Option, value: String, comment: [String]?)]) {
        var configuration = file
        addEntries(entries: entries, to: &configuration)
        require() { try Repository.write(file: configuration) }
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
                join(lines: Option.allPublic.map({ $0.key })),
                ])
        }
        
        func syntaxError(description: [String]) -> Never {
            fatalError(message: [
                "Syntax error!",
                "",
                join(lines: description),
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
                    "Comment",
                    ])
                ])
        }
        
        var result: [Option: String] = [:]
        var currentMultilineOption: Option?
        var currentMultilineComment: [String]?
        for line in configurationSource.lines {
            
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
                
            } else if let multilineOption = line.contents(of: startTokens, requireWholeStringToMatch: true) {
                // Multiline option
                
                if let option = Option(key: multilineOption) {
                    currentMultilineOption = option
                } else {
                    reportUnsupportedKey(multilineOption)
                }
                
            } else if let (optionKey, value) = line.split(at: colon) {
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
                join(lines: comment),
                ])
        }
        if let option = currentMultilineOption {
            syntaxError(description: [
                "Unterminated Multiline Value:",
                result[option] ?? "",
                ])
        }
        
        return result
    }
    
    private static var configurationFile: [Option: String] {
        return cachedResult(cache: &cache.configurationFile) {
            () -> [Option: String] in
            
            return parse(configurationSource: file.contents)
        }
    }
    
    static var projectName: String {
        return cachedResult(cache: &cache.projectName) {
            () -> String in
            
            let tokens = ("name: \u{22}", "\u{22}")
            return Repository.packageDescription.requireContents(of: tokens)
        }
    }
    
    // MARK: - Settings
    
    static func optionIsDefined(_ option: Option) -> Bool {
        return configurationFile[option] ≠ nil
    }
    
    static let trueOptionValue = "True"
    static let falseOptionValue = "False"
    private static func booleanValue(option: Option) -> Bool {
        if let value = configurationFile[option] {
            switch value {
            case trueOptionValue:
                return true
            case falseOptionValue:
                return false
            default:
                fatalError(message: [
                    "Invalid option value:",
                    "",
                    "Option: \(option)",
                    "Value: \(value)",
                    "",
                    "Valid values:",
                    "",
                    trueOptionValue,
                    falseOptionValue,
                    ])
            }
        } else {
            return option.defaultValue == trueOptionValue
        }
    }
    
    static var automaticallyTakeOnNewResponsibilites: Bool {
        return booleanValue(option: .automaticallyTakeOnNewResponsibilites)
    }
    
    // Testing
    static var nestedTest: Bool {
        return booleanValue(option: .nestedTest)
    }
}
