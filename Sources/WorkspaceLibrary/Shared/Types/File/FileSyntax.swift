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

import SDGLogic

struct FileSyntax {
    
    // MARK: - Initialization
    
    init(blockCommentSyntax: BlockCommentSyntax? = nil, lineCommentSyntax: LineCommentSyntax? = nil, requiredFirstLineTokens: (start: String, end: String)? = nil) {
        self.blockCommentSyntax = blockCommentSyntax
        self.lineCommentSyntax = lineCommentSyntax
        self.requiredFirstLineTokens = requiredFirstLineTokens
    }
    
    // MARK: - Properties
    
    let requiredFirstLineTokens: (start: String, end: String)?
    
    let blockCommentSyntax: BlockCommentSyntax?
    let lineCommentSyntax: LineCommentSyntax?
    
    // MARK: - Output
    
    func generateHeader(contents: [String]) -> String {
        return generateHeader(contents: join(lines: contents))
    }
    
    func generateHeader(contents: String) -> String {
        if let blockSyntax = blockCommentSyntax {
            return blockSyntax.comment(contents: contents)
        } else if let lineSyntax = lineCommentSyntax {
            return lineSyntax.comment(contents: contents)
        } else {
            fatalError(message: ["No comment syntax available."])
        }
    }
    
    func insert(header: String, into file: inout File) {
        
        var first = file.contents.substring(to: file.headerStart)
        if ¬first.isEmpty {
            var firstLines = first.linesArray
            while let last = firstLines.last, last.isWhitespace {
                firstLines.removeLast()
            }
            firstLines.append("")
            firstLines.append("") // Header starts in this line.
            first = join(lines: firstLines)
        }
        
        var body = file.contents.substring(from: file.headerEnd)
        while let firstCharacter = body.unicodeScalars.first, CharacterSet.whitespacesAndNewlines.contains(firstCharacter) {
            body.unicodeScalars.removeFirst()
        }
        body = join(lines: [
            "", // Line at end of header
            "",
            "", // Body starts in this line
            ]) + body
        
        let contents = first + generateHeader(contents: header) + body
        
        file.contents = contents
    }
    
    // MARK: - Parsing
    
    func headerStart(file: File) -> String.Index {
        
        var index = file.contents.startIndex
        
        if let required = requiredFirstLineTokens {
            
            index = file.requireRange(of: required).upperBound
            file.contents.advance(&index, pastNewlinesWithLimit: 1)
            file.contents.advance(&index, past: CharacterSet.whitespaces)
            file.contents.advance(&index, pastNewlinesWithLimit: 1)
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
                
                return lineSyntax.requireRangeOfFirstComment(in: start ..< file.contents.endIndex, of: file).upperBound
            }
        }
        
        return start
    }
    
    func header(file: File) -> String {
        let markup = file.contents.substring(with: file.headerStart ..< file.headerEnd)
        
        if markup.isEmpty {
            return markup
        }
        
        if let blockSyntax = blockCommentSyntax {
            if let result = blockSyntax.contentsOfFirstComment(in: markup) {
                return result
            }
        }
        if let lineSyntax = lineCommentSyntax {
            if let result = lineSyntax.contentsOfFirstComment(in: markup) {
                return result
            }
        }
        
        fatalError(message: [
            "Malformed header:",
            "",
            "",
            markup,
            "",
            "",
            "This may indicate a bug in Workspace.",
            ])
    }
}
