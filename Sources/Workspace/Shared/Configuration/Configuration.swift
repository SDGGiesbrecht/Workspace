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
    
    private static let startTokens = (start: "[_Start ", end: "_]")
    private static let endToken = "[_End_]"
    private static let colon = ": "
    
    private static let lineCommentSyntax = LineCommentSyntax(start: "(", stylisticSpacing: false, stylisticEnd: ")")
    private static let blockCommentSyntax = BlockCommentSyntax(start: "((", end: "))", stylisticIndent: "    ")
    static let syntax = FileSyntax(blockCommentSyntax: blockCommentSyntax, lineCommentSyntax: lineCommentSyntax)
    
    private static func startMultilineOption(option: Option) -> String {
        return "\(startTokens.start)\(option)\(startTokens.end)"
    }
    
    static func configurationFileEntry(option: Option, value: String, comment: [String]?) -> String {
        
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
    
    static func addEntries(entries: [(option: Option, value: String, comment: [String]?)]) throws {
        var appendix = ""
        for entry in entries {
            appendix.append(Configuration.configurationFileEntry(option: entry.option, value: entry.value, comment: entry.comment))
            appendix.append("\n\n")
        }
        
        if appendix ≠ "" {
            var configurationFile = file
            
            //configurationFile.body = appendix + configurationFile.body
        }
        
    }
    
    // MARK: - Properties
    
    private static var configurationFile: [Option: String] {
        return cachedResult(cache: &cache.configurationFile) {
            () -> [Option: String] in
            
            func reportUnsupportedKey(_ key: String) -> Never {
                fatalError(message: [
                    "Unsupported configuration key:",
                    key
                    ])
            }
            
            var result: [Option: String] = [:]
            var currentMultilineOption: Option?
            var inMultilineComment = false
            for line in file.contents.lines {
                
                if let option = currentMultilineOption {
                    // In multiline value
                    
                    if line == endToken {
                        currentMultilineOption = nil
                    } else {
                        var appended = result[option] ?? ""
                        appended.append("\n" + line)
                        result[option] = appended
                    }
                    
                } else if inMultilineComment {
                    // In multiline comment
                    
                    if line.hasSuffix(blockCommentSyntax.end) {
                        inMultilineComment = false
                    }
                    
                } else if line == "" ∨ lineCommentSyntax.commentExists(at: line.startIndex, in: line) {
                    // Comment or whitespace
                    
                } else {
                    // New scope
                    
                    if let multilineOption = line.contents(of: startTokens, requireWholeStringToMatch: true) {
                        // Multiline option
                        
                        if let option = Option(key: multilineOption) {
                            currentMultilineOption = option
                        } else {
                            reportUnsupportedKey(multilineOption)
                        }
                        
                    } else if blockCommentSyntax.startOfCommentExists(at: line.startIndex, in: line) {
                        // Multiline comment
                        
                        inMultilineComment = true
                        
                    } else if let (optionKey, value) = line.split(at: colon) {
                        // Simple option
                        
                        if let option = Option(key: optionKey) {
                            result[option] = value
                        } else {
                            reportUnsupportedKey(optionKey)
                        }
                        
                    } else {
                        // Syntax error
                        
                        fatalError(message: [
                            "Syntax error!",
                            "",
                            line,
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
                }
            }
            
            return result
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
}
