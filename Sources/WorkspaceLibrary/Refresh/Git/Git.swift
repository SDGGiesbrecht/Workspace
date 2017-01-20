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
    
    static let ignoreEntriesForWorkspace = [
        "/.Workspace",
        "/Validate\\ Changes\\ (macOS).command",
        "/Validate\\ Changes\\ (Linux).sh",
        "/.Test\\ Zone",
        ]
    
    static let requiredIgnoreEntries = ignoreEntriesForMacOS
        + ignoreEntriesForSwiftProjectManager
        + ignoreEntriesForWorkspace
    
    static let ignoreEntriesForXcode = [
        "/*.xcodeproj",
        ]
    
    static func refreshGitIgnore() {
        
        let startToken = "# [_Begin Workspace Section_]"
        let endToken = "# [_End Workspace Section]"
        
        var gitIngore = require() { try File(at: RelativePath(".gitignore")) }
        var body = gitIngore.body
        
        var managedRange: Range<String.Index>
        if let section = body.range(of: (startToken, endToken)) {
            managedRange = section
        } else {
            managedRange = body.startIndex ..< body.endIndex
        }
        
        let managementWarning = File.managmentWarning(section: true, documentation: .git)
        let managementComment = FileType.gitignore.syntax.comment(contents: managementWarning)
        
        var updatedLines: [String] = []
        updatedLines += [startToken]
        updatedLines += [""]
        updatedLines += [managementComment]
        updatedLines += [""]
        updatedLines += requiredIgnoreEntries
        if Configuration.manageXcode {
            updatedLines += ignoreEntriesForXcode
        }
        updatedLines += [""]
        updatedLines += [endToken]
        
        body.replaceSubrange(managedRange, with: join(lines: updatedLines))
        gitIngore.body = body
        require() { try gitIngore.write() }
    }
    
}
