// FileHeaders.swift
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

struct FileHeaders {
    
    private static func copyright(fromHeader header: String) -> String {
        
        var oldStartDate: String?
        for symbol in ["©", "(C)", "(c)"] {
            for space in ["", " "] {
                if let range = header.range(of: symbol + space) {
                    var numberEnd = range.upperBound
                    header.advance(&numberEnd, past: CharacterSet.decimalDigits, limit: 4)
                    let number = header.substring(with: range.upperBound ..< numberEnd)
                    if number.unicodeScalars.count == 4 {
                        oldStartDate = number
                        break
                    }
                }
            }
        }
        let currentDate = Date()
        let calendar = NSCalendar(identifier: NSCalendar.Identifier.gregorian)!
        let currentYear = "\(calendar.component(.year, from: currentDate))"
        let copyrightStart = oldStartDate ?? currentYear
        
        var copyright = "©"
        if currentYear == copyrightStart {
            copyright.append(currentYear)
        } else {
            copyright.append(copyrightStart + "–" + currentYear)
        }

        return copyright
    }
    
    static func refreshFileHeaders() {
        
        func key(_ name: String) -> String {
            return "[_\(name)_]"
        }
        
        let template = Configuration.fileHeader
        
        var possibleAuthor: String?
        if template.contains(key("Author")) {
            possibleAuthor = Configuration.author
        }
        
        var possibleLicence: String?
        if template.contains(key("Licence")) {
            possibleLicence = Configuration.requiredLicence.notice
        }
        
        let workspaceFiles: Set<String> = [
            "Refresh Workspace (macOS).command",
            "Refresh Workspace (Linux).sh",
            ]
        
        var skippedFiles: Set<String> = workspaceFiles
        skippedFiles.insert("LICENSE.md")
        
        func shouldManageHeader(path: RelativePath) -> Bool {
            if skippedFiles.contains(path.string) {
                return false
            }
            
            if Configuration.projectName == "Workspace" ∧ path.string.hasPrefix(Licence.licenceFolder) {
                return false
            }
            
            return true
        }
        
        for path in Repository.sourceFiles.filter({ shouldManageHeader(path: $0) }) {
            
            if let _ = FileType(filePath: path)?.syntax {
                
                var file = require() { try File(at: path) }
                let oldHeader = file.header
                var header = template
                
                header = header.replacingOccurrences(of: key("Filename"), with: path.filename)
                header = header.replacingOccurrences(of: key("Project"), with: Configuration.projectName)
                header = header.replacingOccurrences(of: key("Copyright"), with: FileHeaders.copyright(fromHeader: oldHeader))
                if let author = possibleAuthor {
                    header = header.replacingOccurrences(of: key("Author"), with: author)
                }
                if let licence = possibleLicence {
                    header = header.replacingOccurrences(of: key("Licence"), with: licence)
                }
                
                
                file.header = header
                require() { try file.write() }
            }
        }
    }
}
