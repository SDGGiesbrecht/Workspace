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

typealias ScalarIndex = String.UnicodeScalarView.Index

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
            newRemainder.removeOneNewline(at: newRemainder.startIndex)
            
            possibleRemainder = newRemainder
            return line
        })
    }
    
    var linesArray: [String] {
        return Array<String>(lines)
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
    
    var isWhitespace: Bool {
        var index = startIndex
        advance(&index, past: CharacterSet.whitespaces)
        return index == endIndex
    }
    
    // MARK: - Searching
    
    func range(of searchTerm: String) -> Range<Index>? {
        return range(of: searchTerm, in: startIndex ..< endIndex)
    }
    
    func range(of searchTerm: String, in searchRange: Range<Index>) -> Range<Index>? {
        return range(of: searchTerm, options: String.CompareOptions.literal, range: searchRange)
    }
    
    
    func range(of characters: CharacterSet, in searchRange: Range<Index>) -> Range<Index>? {
        
        var location = searchRange.lowerBound.samePosition(in: unicodeScalars)
        let end = searchRange.upperBound.samePosition(in: unicodeScalars)
        while location < end ∧ ¬characters.contains(unicodeScalars[location]) {
            location = unicodeScalars.index(after: location)
        }
        if location == end {
            return nil
        } else {
            let position = location.positionOfExtendedGraphemeCluster(in: self)
            return position ..< index(after: position)
        }
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
        for (ownCharacter, stringCharacter) in zip(substring(from: index).characters.lazy, string.characters.lazy) {
            
            if ownCharacter == stringCharacter {
                indexCopy = self.index(after: indexCopy)
            } else {
                return false
            }
        }
        
        index = indexCopy
        return true
    }
    
    private func advance(_ index: inout Index, past characters: CharacterSet, limit: Int?, advanceOne: (inout UnicodeScalarView.Index) -> ()) {
        /*
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
            advanceOne(&scalarIndex)
            iterationsCompleted += 1
        }
        
        guard let converted = scalarIndex.samePosition(in: self) else {
            
            parseError(at: index, in: nil)
        }
        
        index = converted
        */
    }
    
    func advance(_ index: inout Index, past characters: CharacterSet, limit: Int? = nil) {
        assert(characters ≠ CharacterSet.newlines ∨ limit == nil, "Use advance(_:pastNewlinesWithLimit:) instead.")
        
        advance(&index, past: characters, limit: limit, advanceOne: { $0 = unicodeScalars.index(after: $0) })
    }
    
    func advance(_ index: inout Index, pastNewlinesWithLimit limit: Int?) {
        
        advance(&index, past: CharacterSet.newlines, limit: limit, advanceOne: {
            (mobileIndex: inout ScalarIndex) -> () in
            
            if substring(with: mobileIndex.positionOfExtendedGraphemeCluster(in: self) ..< endIndex).hasPrefix(String.CR_LF) {
                mobileIndex = unicodeScalars.index(mobileIndex, offsetBy: 2)
            } else {
                mobileIndex = unicodeScalars.index(after: mobileIndex)
            }
        })
    }
    
    @discardableResult mutating func removeOneNewline(at index: Index) -> Bool {
        var position = index
        advance(&position, pastNewlinesWithLimit: 1)
        if position ≠ index {
            removeSubrange(index ..< position)
            return true
        } else {
            return false
        }
    }
    
    // MARK: - Errors
    
    func lineNumber(for index: String.UnicodeScalarView.Index) -> Int {
        let before = substring(to: index.positionOfExtendedGraphemeCluster(in: self))
        return before.linesArray.count
    }
    
    func columnNumber(for index: String.UnicodeScalarView.Index) -> Int {
        let location = index.positionOfExtendedGraphemeCluster(in: self)
        let line = lineRange(for: location ..< location)
        return distance(from: line.lowerBound, to: location)
    }
    
    func locationInformation(for index: String.UnicodeScalarView.Index) -> String {
        return "Line \(lineNumber(for: index)), Column \(columnNumber(for: index))"
    }
    
    func locationInformation(for index: String.CharacterView.Index) -> String {
        return locationInformation(for: index.samePosition(in: unicodeScalars))
    }
    
    func parseError(at index: String.Index, in file: File?) -> Never {
        
        var duplicate = self
        duplicate.insert(contentsOf: "[Here]".characters, at: index)
        let range = duplicate.lineRange(for: index ..< index)
        let exerpt = duplicate.substring(with: range)
        
        var message: [String] = [
            "A parse error occurred:",
            exerpt,
        ]
        
        if let fileInfo = file {
            message.append(fileInfo.path.string)
        }
        
        message.append(contentsOf: [
            "",
            "This may indicate a bug in Workspace.",
            ])
        
        fatalError(message: message)
    }
}
