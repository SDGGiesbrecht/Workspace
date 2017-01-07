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

extension String {
    
    func contents(of tokens: (String, String)) -> String? {
        
        guard let startTokenRange = range(of: tokens.0) else {
            return nil
        }
        
        guard let endTokenRange = range(of: tokens.1, in: startTokenRange.upperBound ..< endIndex) else {
            return nil
        }
        
        return substring(with: startTokenRange.upperBound ..< endTokenRange.lowerBound)
    }
    
    func range(of searchTerm: String) -> Range<Index>? {
        return range(of: searchTerm, in: startIndex ..< endIndex)
    }
    
    func range(of searchTerm: String, in searchRange: Range<Index>) -> Range<Index>? {
        return range(of: searchTerm, options: String.CompareOptions.literal, range: searchRange)
    }
}
