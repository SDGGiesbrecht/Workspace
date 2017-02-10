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
        
        while let range = file.contents.range(of: "½") {
            
            errorNotice(status: &status, file: file, range: range, replacement: "1⁄2", message: "This shouldn’t be here.")
        }
    }
}
