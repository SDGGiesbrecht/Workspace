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

import SDGCaching

import SDGLogic

struct File {
    
    // MARK: - Initialization
    
    init(path: RelativePath, contents: String) {
        self.path = path
        self.contents = contents
    }
    
    // MARK: - Properties
    
    private class Cache {
        fileprivate var headerStart: String.Index?
        fileprivate var headerEnd: String.Index?
    }
    private var cache = Cache()
    
    var path: RelativePath
    var contents: String {
        willSet {
            cache = Cache()
        }
    }
    
    var fileType: FileType? {
        return FileType(filePath: path)
    }
    
    var syntax: FileSyntax? {
        return fileType?.syntax
    }
    
    // MARK: - File Headers
    
    var headerStart: String.Index {
        
        return cachedResult(cache: &cache.headerStart) {
            () -> String.Index in
            
            if let parser = syntax {
                return parser.headerStart(file: self)
            } else {
                return contents.startIndex
            }
        }
    }
    
    var headerEnd: String.Index {
        
        return cachedResult(cache: &cache.headerEnd) {
            () -> String.Index in
            
            if let parser = syntax {
                
                return parser.headerEnd(file: self)
                
            } else {
                return headerStart
            }
        }
    }
    
    func fatalFileTypeError() -> Never {
        fatalError(message: [
            "Unsupported filetype:",
            path.string,
            "",
            "This may indicate a bug in Workspace.",
            ])
    }
    
    var header: String {
        get {
            guard let parser = syntax else {
                fatalFileTypeError()
            }
            return parser.header(file: self)
        }
        set {
            guard let constructor = syntax else {
                fatalFileTypeError()
            }
            constructor.insert(header: newValue, into:
                &self)
        }
    }
    
    var body: String {
        return contents.substring(from: headerEnd)
    }
    
    // MARK: - Handling Parse Errors
    
    func requireAdvance(index: inout String.Index, past string: String) {
        
        guard contents.advance(&index, past: string) else {
            
            string.parseError(at: index, in: self)
        }
    }
    
    func missingContentError(content: String, range: Range<String.Index>) -> Never {
        
        var message: [String] = [
            "Expected “\(content)” in:",
            path.string,
        ]
        
        if (range.lowerBound == contents.startIndex ∧ range.upperBound == contents.endIndex) {
            // Whole file
            
            fatalError(message: message)
        }
        
        let appendix: [String] = [
            "Range:",
            content.locationInformation(for: range.lowerBound),
            content.locationInformation(for: range.upperBound),
        ]
        message.append(contentsOf: appendix)
        
        fatalError(message: message)
    }
    
    func requireRange(of searchTerm: String, in range: Range<String.Index>) -> Range<String.Index> {
        
        if let result = contents.range(of: searchTerm, in: range) {
            return result
        } else {
            missingContentError(content: searchTerm, range: range)
        }
    }
    
    private func require<T>(search: ((String, String)) -> T?, tokens: (String, String), range: Range<String.Index>?) -> T {
        
        if let result = search(tokens) {
            return result
        } else {
            missingContentError(content: "\(tokens.0)...\(tokens.1)", range: range ?? contents.startIndex ..< contents.endIndex)
        }
    }
    
    func requireRange(of tokens: (String, String), in searchRange: Range<String.Index>? = nil) -> Range<String.Index> {
        
        return require(search: { contents.range(of: $0, in: searchRange) }, tokens: tokens, range: searchRange)
    }
    
    func requireContents(of tokens: (String, String), in searchRange: Range<String.Index>? = nil) -> String {
        
        return require(search: { contents.contents(of: $0, in: searchRange) }, tokens: tokens, range: searchRange)
    }
}
