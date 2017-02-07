/*
 StringUnicodeScalarViewIndex.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace

 Copyright ©2017 Jeremy David Giesbrecht and the Workspace contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGLogic
import SDGMathematics

extension String.UnicodeScalarView.Index {
    
    func positionOfExtendedGraphemeCluster(in string: String) -> String.CharacterView.Index {
        var copy = self
        while samePosition(in: string) == nil {
            copy = string.unicodeScalars.index(before: copy)
        }
        guard let result = copy.samePosition(in: string) else {
            
            let scalar = string.unicodeScalars[copy]
            var context = String(scalar)
            if copy ≠ string.unicodeScalars.startIndex {
                let predecessor = string.unicodeScalars.index(before: copy)
                context = String(string.unicodeScalars[predecessor]) + context
            }
            
            fatalError(message: [
                "Error reading Unicode:",
                context,
                "",
                "This may indicate a bug in Workspace.",
                ])
        }
        
        return result
    }
}
