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

struct FileHeaders {
    
    static func refreshFileHeaders() {
        
        let template = Configuration.fileHeader
        
        for path in Repository.trackedFiles {
            
            var file = require() { try File(at: path) }
            
            file.header = template
            
            require() { try file.write() }
        }
    }
    
}
