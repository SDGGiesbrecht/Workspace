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
    
    static func copyright(fromHeader header: String) -> String {
        
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
        
        let template = Configuration.fileHeader
        
        let workspaceFiles: Set<String> = [
            "Refresh Workspace (macOS).command",
            "Refresh Workspace (Linux).sh",
            ]
        
        for path in Repository.sourceFiles.filter({ ¬workspaceFiles.contains($0.string) }) {
            
            if let _ = FileType(filePath: path)?.syntax {
                
                var file = require() { try File(at: path) }
                let oldHeader = file.header
                var header = template
                
                func key(_ name: String) -> String {
                    return "[_\(name)_]"
                }
                
                header = header.replacingOccurrences(of: key("Filename"), with: path.filename)
                header = header.replacingOccurrences(of: key("Project"), with: Configuration.projectName)
                header = header.replacingOccurrences(of: key("Copyright"), with: FileHeaders.copyright(fromHeader: oldHeader))
                
                file.header = header
                require() { try file.write() }
            }
        }
    }
}
