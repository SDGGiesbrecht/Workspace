/*
 CompatibilityCharacters.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace

 Copyright ©2017 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import Foundation

struct CompatibilityCharacters: Rule {
    
    static func check(file: File, status: inout Bool) {
        
        // ½
        
        var location = file.contents.startIndex
        while let range = file.contents.range(of: CharacterSet.decomposables, in: location ..< file.contents.endIndex) {
            
            let character = file.contents[range]
            let normalized = character.decomposedStringWithCompatibilityMapping
            if character ≠ normalized {
                errorNotice(status: &status, file: file, range: range, replacement: normalized, message: "Some programs may lose “\(character)” in normalization. Use “\(normalized)” instead (with markup if necessary).")
            }
            
            location = range.upperBound
        }
    }
}
