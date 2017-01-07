// File.swift
//
// This source file is part of the Workspace open source project.
//
// Copyright ©2017 Jeremy David Giesbrecht and the Workspace contributors.
//
// Soli Deo gloria
//
// Licensed under the Apache License, Version 2.0
// See http://www.apache.org/licenses/LICENSE-2.0 for licence information.

struct File {
    
    // MARK: - Initialization
    
    init(path: String, contents: String) {
        self.path = path
        self.contents = contents
    }
    
    // MARK: - Properties
    
    var path: String
    var contents: String
    
    // MARK: - Parsing
    
    func requireContents(of tokens: (String, String)) -> String {
        
        if let result = contents.contents(of: tokens) {
            return result
        } else {
            fatalError(message: [
                "Expected “\(tokens.0)...\(tokens.1)” in “\(path)”",
                ])
        }
    }
}
