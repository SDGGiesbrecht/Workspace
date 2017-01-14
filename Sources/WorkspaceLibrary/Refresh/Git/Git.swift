// Git.swift
//
// This source file is part of the Workspace open source project.
//
// Copyright ©2017 Jeremy David Giesbrecht and the Workspace contributors.
//
// Soli Deo gloria
//
// Licensed under the Apache License, Version 2.0
// See http://www.apache.org/licenses/LICENSE-2.0 for licence information.

import Foundation

import SDGLogic

struct Git {
    
    static let ignoreEntriesForMacOS = [
        ".DS_Store",
        ]
    
    static let ignoreEntriesForSwiftProjectManager = [
        "/.build",
        "/Packages",
        ]
    
    static let ignoreEntriesForXcode = [
        "/*.xcodeproj",
        ]
    
    static let ignoreEntriesForWorkspace = [
        "/.Workspace",
        "/.Validate\\ Changes (macOS).command",
        "/.Validate\\ Changes (Linux).sh",
        "/.Test\\ Zone",
        ]
    
    static let requiredIgnoreEntries = ignoreEntriesForMacOS
        + ignoreEntriesForSwiftProjectManager
        + ignoreEntriesForXcode
        + ignoreEntriesForWorkspace
    
    static func refreshGitIgnore() {
        
        let startToken = "# [_Begin Workspace Section_]"
        let endToken = "# [_End Workspace Section]"
        
        var gitIngore = require() { try Repository.read(file: RelativePath(".gitignore")) }
        
        var managedRange: Range<String.Index>
        if let section = gitIngore.contents.range(of: (startToken, endToken)) {
            managedRange = section
        } else {
            managedRange = gitIngore.headerEnd ..< gitIngore.headerEnd
        }
        var endIndex = managedRange.upperBound
        gitIngore.contents.advance(&endIndex, past: CharacterSet.newlines)
        managedRange = managedRange.lowerBound ..< endIndex
        
        let managementWarning = File.managmentWarning(section: true, documentation: .git)
        let managementComment = FileType.gitignore.syntax.comment(contents: managementWarning)
        
        let precedingLines = gitIngore.contents.substring(to: managedRange.lowerBound)
        
        var updatedLines: [String] = []
        if precedingLines.isEmpty {
            // Prevent appearing like a header
            updatedLines += [""] // Empty first line
        } else if ¬precedingLines.hasSuffix("\n") {
            updatedLines += [""] // Last line of predecessor
            if ¬precedingLines.hasSuffix("\n\n") {
                updatedLines += [""] // Empty line
            }
        }
        updatedLines += [startToken]
        updatedLines += [""]
        updatedLines += [managementComment]
        updatedLines += [""]
        updatedLines += requiredIgnoreEntries
        updatedLines += [""]
        updatedLines += [endToken]
        updatedLines += [""]
        updatedLines += [""] // First line of body
        
        gitIngore.contents.replaceSubrange(managedRange, with: join(lines: updatedLines))
        require() { try Repository.write(file: gitIngore) }
    }
    
}
