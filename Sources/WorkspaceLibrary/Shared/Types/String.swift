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

import Foundation

import SDGLogic
import SDGMathematics

extension String {
    
    static var CR_LF: String {
        return "\u{D}\u{A}"
    }
    
    var lines: UnfoldSequence<String, String?> {
        return sequence(state: self, next: {
            (possibleRemainder: inout String?) -> String? in
            
            guard let remainder = possibleRemainder else {
                return nil
            }
            
            guard let endOfLine = remainder.rangeOfCharacter(from: CharacterSet.newlines) else {
                // End of string
                
                possibleRemainder = nil
                return remainder
            }
            
            let line = remainder.substring(to: endOfLine.lowerBound)
            
            var newRemainder = remainder.substring(from: endOfLine.lowerBound)
            if newRemainder.hasPrefix(String.CR_LF) {
                // CR + LF
                newRemainder.unicodeScalars.removeFirst(2)
            } else {
                newRemainder.unicodeScalars.removeFirst(1)
            }
            
            possibleRemainder = newRemainder
            return line
        })
    }
    
    var isMultiline: Bool {
        var result: Bool = false
        var firstLineRead: Bool = false
        for _ in lines {
            
            if ¬firstLineRead {
                firstLineRead = true
            } else {
                result = true
                break
            }
        }
        return result
    }
    
    // MARK: - Searching
    
    func range(of searchTerm: String) -> Range<Index>? {
        return range(of: searchTerm, in: startIndex ..< endIndex)
    }
    
    func range(of searchTerm: String, in searchRange: Range<Index>) -> Range<Index>? {
        return range(of: searchTerm, options: String.CompareOptions.literal, range: searchRange)
    }
    
    // MARK: - Splitting at Tokens
    
    func split(at token: String) -> (before: String, after: String)? {
        guard let tokenRange = range(of: token) else {
            return nil
        }
        return (substring(to: tokenRange.lowerBound), substring(from: tokenRange.upperBound))
    }
    
    // MARK: - Searching for Token Pairs
    
    private func ranges(of tokens: (start: String, end: String), in searchRange: Range<Index>? = nil, requireWholeStringToMatch: Bool = false) -> (start: Range<Index>, end: Range<Index>)? {
        
        let actualSearchRange: Range<Index>
        if let boundedSearch = searchRange {
            actualSearchRange = boundedSearch
        } else {
            actualSearchRange = startIndex ..< endIndex
        }
        
        guard let startTokenRange = range(of: tokens.start, in: actualSearchRange) else {
            return nil
        }
        
        guard let endTokenRange = range(of: tokens.end, in: startTokenRange.upperBound ..< actualSearchRange.upperBound) else {
            return nil
        }
        
        let result = (start: startTokenRange, end: endTokenRange)
        if requireWholeStringToMatch {
            if startTokenRange.lowerBound == startIndex ∧ endTokenRange.upperBound == endIndex {
                return result
            } else {
                return nil
            }
        } else {
            return result
        }
    }
    
    func range(of tokens: (start: String, end: String), in searchRange: Range<Index>? = nil, requireWholeStringToMatch: Bool = false) -> Range<String.Index>? {
        
        guard let both = ranges(of: tokens, in: searchRange, requireWholeStringToMatch: requireWholeStringToMatch) else {
            return nil
        }
        
        return both.start.lowerBound ..< both.end.upperBound
    }
    
    func rangeOfContents(of tokens: (start: String, end: String), in searchRange: Range<Index>? = nil, requireWholeStringToMatch: Bool = false) -> Range<String.Index>? {
        
        guard let both = ranges(of: tokens, in: searchRange, requireWholeStringToMatch: requireWholeStringToMatch) else {
            return nil
        }
        
        return both.start.upperBound ..< both.end.lowerBound
    }
    
    func contents(of tokens: (start: String, end: String), in searchRange: Range<Index>? = nil, requireWholeStringToMatch: Bool = false) -> String? {
        
        guard let targetRange = rangeOfContents(of: tokens, in: searchRange, requireWholeStringToMatch: requireWholeStringToMatch) else {
            return nil
        }
        
        return substring(with: targetRange)
    }
    
    // MARK: - Moving Indices
    
    func advance(_ index: inout Index, past string: String) -> Bool {
        
        var indexCopy = index
        for (ownCharacter, stringCharacter) in zip(characters.lazy, string.characters.lazy) {
            
            if ownCharacter == stringCharacter {
                indexCopy = self.index(indexCopy, offsetBy: 1)
            } else {
                return false
            }
        }
        
        index = indexCopy
        return true
    }
    
    func advance(_ index: inout Index, past characters: CharacterSet, limit: Int? = nil) {
        
        var scalarIndex = index.samePosition(in: unicodeScalars)
        
        var iterationsCompleted = 0
        func notAtLimit() -> Bool {
            if let theLimit = limit {
                return iterationsCompleted < theLimit
            } else {
                return true
            }
        }
        while notAtLimit() ∧ index ≠ endIndex ∧ characters.contains(unicodeScalars[scalarIndex]) {
            scalarIndex = unicodeScalars.index(scalarIndex, offsetBy: 1)
            iterationsCompleted += 1
        }
    }
}
