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
    
    var body: String {
        return contents.substring(from: headerEnd)
    }
    
    // MARK: - Handling Parse Errors
    
    func requireAdvance(index: inout String.Index, past string: String) {
        
        guard contents.advance(&index, past: string) else {
            
            var duplicate = contents
            duplicate.insert(contentsOf: "[Here]".characters, at: index)
            let range = duplicate.lineRange(for: index ..< index)
            let exerpt = duplicate.substring(with: range)
            
            fatalError(message: [
                "A parse error occurred:",
                path.string,
                exerpt,
                "",
                "This may indicate a bug in Workspace.",
                ])
        }
    }
    
    private func require<T>(search: ((String, String)) -> T?, tokens: (String, String)) -> T {
        
        if let result = search(tokens) {
            return result
        } else {
            fatalError(message: [
                "Expected “\(tokens.0)...\(tokens.1)” in “\(path)”",
                ])
        }
    }
    
    func requireRange(of tokens: (String, String), in searchRange: Range<String.Index>? = nil) -> Range<String.Index> {
        
        return require(search: { contents.range(of: $0, in: searchRange) }, tokens: tokens)
    }
    
    func requireContents(of tokens: (String, String), in searchRange: Range<String.Index>? = nil) -> String {
        
        return require(search: { contents.contents(of: $0, in: searchRange) }, tokens: tokens)
    }
}
