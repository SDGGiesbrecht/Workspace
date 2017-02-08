/*
 ContributingInstructions.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace

 Copyright ©2017 Jeremy David Giesbrecht and the Workspace contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGLogic

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
            "## Step 1: Report",
            "",
            "From the smallest typo to the severest crash, whether you are reporting a bug or requesting a new feature, whether you already have a solution in mind or not, please **always start by reporting it**.",
            "",
            "Please start by searching the [existing issues](../../issues) to see if something related has already been reported.",
            "",
            "- If there is already a related issue, please join that conversation and share any additional information you have.",
            "- Otherwise, open a [new issue](../../issues/new). Please provide as much of the following as you can:",
            "    - 1. A concise and specific description of the bug or feature.",
            "    - 2. If it is a bug, try to provide a demonstration of the problem:",
            "        - Optimally, provide a minimal example—a few short lines of source that trigger the problem when they are copied, pasted and run.",
            "        - As a fallback option, if your own code is public, you could provide a link to your source code at the point where the problem occurs.",
            "        - If neither of the above options is possible, please at least try to describe in words how to reproduce the problem.",
            "    - 3. Say whether or not you would like the honour of helping implement the fix or feature yourself.",
            "    - 4. Share any ideas you may have of possible solutions or designs.",
            "",
            "Even if you think you have the solution, please **do not start working on it** until you hear from one of the project administrators. This may save you some work in the event that someone else is already working on it, or if your idea ends up deemed beyond the scope of the project goals.",
            "",
            "## Step 2: Branch",
            "",
            "If you have [reported](#step-1.-report) your idea and an administrator has given you the green light, follow these steps to get a local copy you can work on.",
            "",
            "- 1. **Fork the repository** by clicking “Fork” in the top‐right of the repository page. (Skip this step if you have been given write access.)",
            "- 2. **Create a local clone**. `git clone https://github.com/`user`/[_Project_]`",
            "- 3. **Create a development branch**. `git checkout -b `branch-name` `",
            "- 4. **Set up the workspace** by double‐clicking `Refresh Workspace` in the root folder.",
            "",
            "Now you are all set to try out your idea.",
            "",
            "## Step 3: Submit",
            "",
            "Once you have your idea working properly, follow these steps to submit your changes.",
            "",
            "- 1. **Validate your changes** by double‐clicking `Validate Changes` in the root folder.",
            "- 2. **Commit your changes**. `git commit -m \u{22}`Description of changes.`\u{22}`",
            "- 3. **Push your changes**. `git push`",
            "- 4. **Submit a pull request** by clicking “New Pull Request” in the branch list on GitHub. In your description, please:",
            "        - Link to the original issue with `#`000`.",
            "        - State your agreement to licensing your contributions under the [project licence](LICENSE.md).",
            "- 5. **Wait for continuous integration** to complete its validation.",
            "- 6. **Request a review** from [_Administrators_] by clicking the gear in the top right of the pull request page.",
            ]
        
        if Configuration.developmentNotes ≠ nil {
            instructions.append(contentsOf: [
                "",
                "## Development Notes",
                "",
                "[_Development Notes_]",
                ])
        }
        
        return join(lines: instructions)
    }()
    
    static func refreshContributingInstructions() {
        
        func key(_ name: String) -> String {
            return "[_\(name)_]"
        }
        
        var body = join(lines: [
            managementComment,
            "",
            Configuration.contributingInstructions,
            ])
        
        body = body.replacingOccurrences(of: key("Project"), with: Configuration.projectName)
        
        var administrators = Configuration.administrators
        var administratorList: String
        if administrators.isEmpty {
            administratorList = "an administrator"
        } else if administrators.count == 1 {
            administratorList = administrators[0]
        } else {
            let last = administrators.removeLast()
            administratorList = administrators.joined(separator: ", ")
            administratorList += " or " + last
        }
        body = body.replacingOccurrences(of: key("Administrators"), with: administratorList)
        
        let developmentNotesKey = key("Development Notes")
        if body.contains(developmentNotesKey) {
            body = body.replacingOccurrences(of: developmentNotesKey, with: Configuration.requiredDevelopmentNotes)
        }
        
        var contributing = File(possiblyAt: contributingInstructionsPath)
        contributing.body = body
        require() { try contributing.write() }
    }
    
    static func relinquishControl() {
        var contributing = File(possiblyAt: contributingInstructionsPath)
        if contributing.contents.contains(managementComment) {
            
            printHeader(["Cancelling contributing instruction management..."])
            
            print(["Deleting \(contributingInstructionsPath)..."])
            force() { try Repository.delete(contributingInstructionsPath) }
        }
    }
}
