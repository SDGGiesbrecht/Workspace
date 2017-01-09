// LineCommentSyntax.swift
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

struct LineCommentSyntax {
    
    // MARK: - Initialization
    
    init(start: String, stylisticEnd: String? = nil) {
        self.start = start
        self.stylisticEnd = stylisticEnd
    }
    
    // MARK: - Properties
    
    let start: String
    let stylisticEnd: String?
    
    // MARK: - Output
    
    func comment(contents: String) -> String {
        assert(¬contents.isMultiline, "Attempted to use line comment syntax for a multiline comment.")
        
        var result = start + contents
        if let end = stylisticEnd {
            result += end
        }
        result += "\n"
        return result
    }
    
    // MARK: - Parsing
    
    func commentExists(at location: String.Index, in string: String) -> Bool {
        
        return string.substring(from: location).hasPrefix(start)
    }
    
    func requireRangeOfConsecutiveComments(at location: String.Index, in file: File) -> Range<String.Index> {
        
        var endIndex = location
        
        for line in file.contents.substring(from: location).lines {
            
            var indent: String.Index = location
            line.advance(&indent, past: CharacterSet.whitespaces)
            
            let text = line.substring(from: indent)
            if text.hasPrefix(start) {
                // Is a Comment.
                
                file.requireAdvance(index: &endIndex, past: line)
                if endIndex ≠ file.contents.endIndex {
                    if file.contents.substring(from: endIndex).hasPrefix(String.CR_LF) {
                        file.requireAdvance(index: &endIndex, past: String.CR_LF)
                    } else {
                        file.contents.advance(&endIndex, past: CharacterSet.newlines, limit: 1)
                    }
                }
            } else {
                // Is not a comment.
                break
            }
        }
        
        return location ..< endIndex
    }
}
