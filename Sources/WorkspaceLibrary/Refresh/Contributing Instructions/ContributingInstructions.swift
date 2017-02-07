/*
 ContributingInstructions.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace

 Copyright ©2017 Jeremy David Giesbrecht and the Workspace contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

struct ContributingInstructions {
    
    static let contributingInstructionsPath = RelativePath("CONTRIBUTING.md")
    
    private static let managementComment: String = {
        let managementWarning = File.managmentWarning(section: false, documentation: .contributingInstructions)
        return FileType.markdown.syntax.comment(contents: managementWarning)
    }()
    
    static let defaultContributingInstructions: String = {
        var instructions: [String] = [
            "# Contributing to [_Project_]",
            "",
            "Everyone is welcome to contribute to [_Project_]!",
            "",
            "## 1. ",
            ]
        
        return instructions
    }()
    
    static func refreshContributingInstructions() {
        
        func key(_ name: String) -> String {
            return "[_\(name)_]"
        }
        
        var body = Configuration.contributingInstructions
        
        var contributing = File(possiblyAt: contributingInstructionsPath)
        contributing.body = body
        require() { try contributing.write() }
    }
    
    static func relinquishControl() {
        var contributing = File(possiblyAt: contributingInstructionsPath)
        if contributing.contents.contains(managementComment) {
            
            printHeader(["Cancelling contributing instruction management..."])
            
            print(["Deleting \(contributingInstructionsPath)"])
            force() { try Repository.delete(contributingInstructionsPath) }
        }
    }
}
