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
    
    private static let startTokens = (start: "[_Start ", end: "_]")
    private static let endToken = "[_End_]"
    private static let colon = ": "
    private static let commentToken = "("
    private static let optionalCommentEndToken = ")"
    
    private static func startMultilineOption(option: Option) -> String {
        return "\(startTokens.start)\(option)\(startTokens.end)"
    }
    
    static func configurationFileEntry(option: Option, value: String) -> String {
        var lineCount = 0
        var multiline = false
        value.enumerateLines() {
            (_: String, shouldStop: inout Bool) -> () in
            
            lineCount += 1
            
            if lineCount > 1 {
                multiline = true
                shouldStop = true
            }
        }
        
        if multiline {
            return "\(startMultilineOption(option: option))\n\(value)\n\(endToken)"
        } else {
            return "\(option)\(colon)\(value)"
        }
    }
    
    static func configurationFileEntry(option: Option, value: Bool) -> String {
        return configurationFileEntry(option: option, value: value ? trueOptionValue : falseOptionValue)
    }
    
    // MARK: - Properties
    
    private static var configurationFile: [Option: String] {
        return cachedResult(cache: &cache.configurationFile) {
            () -> [Option: String] in
            
            let file: File
            do {
                file = try Repository.read(file: configurationFilePath)
            } catch {
                print(["Found no configuration file.", "Following the default configuration."])
                file = File(path: configurationFilePath, contents: "")
            }
            
            func reportUnsupportedKey(_ key: String) -> Never {
                fatalError(message: ["Unsupported configuration key:", key])
            }
            
            var result: [Option: String] = [:]
            var currentMultilineOption: Option?
            file.contents.enumerateLines() {
                (line: String, shouldStop: inout Bool) -> () in
                
                if let option = currentMultilineOption {
                    
                    if line == endToken {
                        currentMultilineOption = nil
                    } else {
                        var appended = result[option] ?? ""
                        appended.append("\n" + line)
                        result[option] = appended
                    }
                    
                } else {
                    if line.hasPrefix(commentToken) ∨ line == "" {
                        // Ignore
                    } else {
                        
                        if let multilineOption = line.contents(of: startTokens, requireWholeStringToMatch: true) {
                            
                            if let option = Option(key: multilineOption) {
                                currentMultilineOption = option
                            } else {
                                reportUnsupportedKey(multilineOption)
                            }
                            
                        } else if let (optionKey, value) = line.split(at: colon) {
                            
                            if let option = Option(key: optionKey) {
                                result[option] = value
                            } else {
                                reportUnsupportedKey(optionKey)
                            }
                            
                        } else {
                            
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
                                "\(commentToken)Comment\(optionalCommentEndToken)"
                                ])
                        }
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
    
    private static var automaticallyTakeOnNewResponsibilites: Bool {
        return booleanValue(option: .automaticallyTakeOnNewResponsibilites)
    }
}
