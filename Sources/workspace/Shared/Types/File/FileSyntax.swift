// FileSyntax.swift
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

struct FileSyntax {
    
    // MARK: - Initialization
    
    init(blockCommentSyntax: BlockCommentSyntax? = nil, lineCommentSyntax: LineCommentSyntax? = nil, requiredfirstLineTokens: (start: String, end: String)? = nil) {
        self.blockCommentSyntax = blockCommentSyntax
        self.lineCommentSyntax = lineCommentSyntax
        self.requiredfirstLineTokens = requiredfirstLineTokens
    }
    
    // MARK: - Properties
    
    let requiredfirstLineTokens: (start: String, end: String)?
    
    let blockCommentSyntax: BlockCommentSyntax?
    let lineCommentSyntax: LineCommentSyntax?
    
    // MARK: - Sections
    
    func headerStart(file: File) -> String.Index {
        
        var index = file.contents.startIndex
        
        if let required = requiredfirstLineTokens {
            
            index = file.requireRange(of: required).upperBound
            file.contents.advance(&index, past: CharacterSet.newlines, limit: 1)
            file.contents.advance(&index, past: CharacterSet.whitespaces)
            file.contents.advance(&index, past: CharacterSet.newlines, limit: 1)
        }
        
        return index
    }
    
    func headerEnd(file: File) -> String.Index {
        
        let start = file.headerStart
        
        if let blockSyntax = blockCommentSyntax {
            
            if blockSyntax.startOfCommentExists(at: start, in: file.contents, countDocumentationMarkup: false) {
                
                return blockSyntax.requireRangeOfFirstComment(in: start ..< file.contents.endIndex, of: file).upperBound
            }
        }
        
        if let lineSyntax = lineCommentSyntax {
            
            if lineSyntax.commentExists(at: start, in: file.contents) {
                
            }
        }
        
        return start
    }
}
