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

import SDGLogic

struct FileHeaders {
    
    static func refreshFileHeaders() {
        
        let template = Configuration.fileHeader
        
        let workspaceFiles: Set<String> = [
            "Refresh Workspace (macOS).command",
            "Refresh Workspace (Linux).sh",
            ]
        
        for path in Repository.sourceFiles.filter({ ¬workspaceFiles.contains($0.string) }) {
            
            if let _ = FileType(filePath: path)?.syntax {
                
                var file = require() { try File(at: path) }
                var header = template
                
                func key(_ name: String) -> String {
                    return "[_\(name)_]"
                }
                
                header = header.replacingOccurrences(of: key("Filename"), with: path.filename)
                header = header.replacingOccurrences(of: key("Project Name"), with: Configuration.projectName)
                
                file.header = header
                require() { try file.write() }
            }
        }
    }
}
