// BlockCommentSyntax.swift
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

struct BlockCommentSyntax {
    
    // MARK: - Initialization
    
    init(start: String, end: String, stylisticIndent: String? = nil) {
        self.start = start
        self.end = end
        self.stylisticIndent = stylisticIndent
    }
    
    // MARK: - Properties
    
    let start: String
    let end: String
    let stylisticIndent: String?
    
    // MARK: - Output
    
    func comment(contents: [String]) -> String {
        return comment(contents: contents.joined(separator: "\n"))
    }
    
    func comment(contents: String) -> String {
        
        var newline = "\n"
        if let indent = stylisticIndent {
            newline += indent
        }
        let joined = contents.lines.joined(separator: newline)
        return start + newline + joined + newline + end
    }
    
    // MARK: - Parsing
    
    func startOfCommentExists(at location: String.Index, in string: String, countDocumentationMarkup: Bool = true) -> Bool {
        
        var index = location
        if ¬string.advance(&index, past: start) {
            return false
        } else {
            // Block comment
            
            if countDocumentationMarkup {
                return true
            } else {
                // Make shure this isn’t documentation.
                
                if let nextCharacter = string.substring(from: index).unicodeScalars.first {
                    
                    if CharacterSet.whitespacesAndNewlines.contains(nextCharacter) {
                        return true
                    }
                }
                return false
            }
        }
    }
    
    func requireRangeOfFirstComment(in range: Range<String.Index>, of file: File) -> Range<String.Index> {
        
        return file.requireRange(of: (start, end), in: range)
    }
}
