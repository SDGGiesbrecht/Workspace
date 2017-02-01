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
    
    func comment(contents: [String]) -> String {
        return comment(contents: join(lines: contents))
    }
    
    func comment(contents: String) -> String {
        if let blockSyntax = blockCommentSyntax {
            return blockSyntax.comment(contents: contents)
        } else if let lineSyntax = lineCommentSyntax {
            return lineSyntax.comment(contents: contents)
        } else {
            fatalError(message: ["No comment syntax available."])
        }
    }
    
    func generateHeader(contents: [String]) -> String {
        return comment(contents: contents)
    }
    
    func generateHeader(contents: String) -> String {
        return comment(contents: contents)
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
    
    private static func advance(_ index: inout String.Index, pastLayoutSpacingIn string: String) {
        string.advance(&index, pastNewlinesWithLimit: 1)
        string.advance(&index, past: CharacterSet.whitespaces)
        string.advance(&index, pastNewlinesWithLimit: 1)
    }
    
    func headerStart(file: File) -> String.Index {
        
        var index = file.contents.startIndex
        
        if let required = requiredFirstLineTokens {
            
            index = file.requireRange(of: required).upperBound
            FileSyntax.advance(&index, pastLayoutSpacingIn: file.contents)
        }
        
        return index
    }
    
    private func headerEndWithoutSpacing(file: File) -> String.Index {
        
        let start = file.headerStart
        
        if let blockSyntax = blockCommentSyntax {
            
            if blockSyntax.startOfCommentExists(at: start, in: file.contents, countDocumentationMarkup: false) {
                
                return blockSyntax.requireRangeOfFirstComment(in: start ..< file.contents.endIndex, of: file).upperBound
            }
        }
        
        if let lineSyntax = lineCommentSyntax {
            
            if lineSyntax.commentExists(at: start, in: file.contents, countDocumentationMarkup: false) {
                
                return lineSyntax.requireRangeOfFirstComment(in: start ..< file.contents.endIndex, of: file).upperBound
            }
        }
        
        return start
    }
    
    func headerEnd(file: File) -> String.Index {
        var result = headerEndWithoutSpacing(file: file)
        FileSyntax.advance(&result, pastLayoutSpacingIn: file.contents)
        return result
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
            "Malformed header in \(file.path.filename):",
            "",
            "",
            "“" + markup + "”",
            "",
            "",
            "This may indicate a bug in Workspace.",
            ])
    }
}
