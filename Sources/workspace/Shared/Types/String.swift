// String.swift
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

extension String {
    
    var lines: [String] {
        var result: [String] = []
        enumerateLines() {
            (line: String, _: inout Bool) -> () in
            
            result.append(line)
        }
        return result
    }
    
    var isMultiline: Bool {
        var result: Bool = false
        var firstLineRead: Bool = false
        enumerateLines() {
            (line: String, shouldStop: inout Bool) -> () in
            
            if ¬firstLineRead {
                firstLineRead = true
            } else {
                result = true
                shouldStop = true
            }
        }
        return result
    }
    
    func contents(of tokens: (start: String, end: String), requireWholeStringToMatch: Bool = false) -> String? {
        
        guard let startTokenRange = range(of: tokens.start) else {
            return nil
        }
        
        guard let endTokenRange = range(of: tokens.end, in: startTokenRange.upperBound ..< endIndex) else {
            return nil
        }
        
        let result = substring(with: startTokenRange.upperBound ..< endTokenRange.lowerBound)
        
        if requireWholeStringToMatch {
            if self == tokens.start + result + tokens.end {
                return result
            } else {
                return nil
            }
        } else {
            return result
        }
    }
    
    func split(at token: String) -> (before: String, after: String)? {
        guard let tokenRange = range(of: token) else {
            return nil
        }
        return (substring(to: tokenRange.lowerBound), substring(from: tokenRange.upperBound))
    }
    
    func range(of searchTerm: String) -> Range<Index>? {
        return range(of: searchTerm, in: startIndex ..< endIndex)
    }
    
    func range(of searchTerm: String, in searchRange: Range<Index>) -> Range<Index>? {
        return range(of: searchTerm, options: String.CompareOptions.literal, range: searchRange)
    }
}
