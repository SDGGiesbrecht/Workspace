/*
 Warning.swift
 
 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace
 
 Copyright ©2017–2018 Jeremy David Giesbrecht and the Workspace project contributors.
 
 Soli Deo gloria.
 
 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGCornerstone
import SDGCommandLine

protocol Warning : Rule {
    static var trigger: UserFacingText<InterfaceLocalization, Void> { get }
    static func message(for details: StrictString) -> UserFacingText<InterfaceLocalization, Void>?
}

let manualWarnings: [Warning.Type] = [
    GenericWarning.self,
    WorkaroundReminder.self
]

extension Warning {
    
    static func check(file: TextFile, status: ProofreadingStatus, output: inout Command.Output) {
        if file.location.path.hasSuffix("Documentation/Manual Warnings.md") {
            return
        }
        
        for localizedTrigger in InterfaceLocalization.cases.map({ trigger.resolved(for: $0) }) {
            
            let marker = ("[_\(localizedTrigger)", "_]")
            
            var index = file.contents.scalars.startIndex
            while let match = file.contents.scalars.firstNestingLevel(startingWith: marker.0.scalars, endingWith: marker.1.scalars, in: index ..< file.contents.scalars.endIndex) {
                index = match.container.range.upperBound
                
                var details = StrictString(match.contents.contents)
                if details.hasPrefix(":".scalars) {
                    details.removeFirst()
                }
                if details.hasPrefix(" ".scalars) {
                    details.removeFirst()
                }
                
                if let description = message(for: details) {
                    reportViolation(in: file, at: match.container.range, message: description, status: status, output: &output)
                }
            }
        }
    }
}
