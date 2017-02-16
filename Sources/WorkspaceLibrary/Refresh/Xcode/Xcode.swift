/*
 Xcode.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace

 Copyright ©2017 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGLogic

struct Xcode {

    static func refreshXcodeProjects() {

        let path = RelativePath("\(Configuration.projectName).xcodeproj")
        force() { try Repository.delete(path) }

        var script = ["swift", "package", "generate-xcodeproj", "--output", path.string]
        if ¬Environment.isInContinuousIntegration {
            script.append("--enable-code-coverage")
        }
        requireBash(script)

        var file = require() { try File(at: path.subfolderOrFile("project.pbxproj")) }
        file.contents.replaceContentsOfEveryPair(of: ("LD_RUNPATH_SEARCH_PATHS = (", ");"), with: join(lines: [
            "",
            "$(inherited)",
            "@executable_path/Frameworks",
            "@loader_path/Frameworks",
            "@executable_path/../Frameworks",
            "@loader_path/../Frameworks"
            ].map({ "\u{22}\($0)\u{22}," })))

        require() { try file.write() }
    }

    private static func modifyProject(condition shouldModify: (String) -> Bool, modification modify: (inout File) -> Void) {
        let path = RelativePath("\(Configuration.projectName).xcodeproj/project.pbxproj")

        do {
            var file = try File(at: path)

            if shouldModify(file.contents) {

                modify(&file)
                require() { try file.write() }
            }
        } catch {
            return
        }
    }

    static let scriptObjectName = "PROOFREAD"
    static let scriptActionEntry = scriptObjectName + ","

    static func enableProofreading() {

        modifyProject(condition: {
            return ¬$0.contains("workspace proofread")

        }, modification: { (file: inout File) -> Void in

            let scriptInsertLocation = file.requireRange(of: "objects = {\n").upperBound
            file.contents.replaceSubrange(scriptInsertLocation ..< scriptInsertLocation, with: join(lines: [
                "\(scriptObjectName) = {",
                "    isa = PBXShellScriptBuildPhase;",
                "    shellPath = /bin/bash;",
                "    shellScript = \u{22}.Workspace/.build/release/workspace proofread\u{22};",
                "};",
                "" // Final line break.
                ]))

            let phaseInsertLocation = file.requireRange(of: "buildPhases = (\n").upperBound
            file.contents.replaceSubrange(phaseInsertLocation ..< phaseInsertLocation, with: join(lines: [
                scriptActionEntry,
                "" // Final line break.
                ]))
        })
    }

    static let disabledScriptActionEntry = "/* " + scriptObjectName + " */"

    static func temporarilyDisableProofreading() {

        modifyProject(condition: { (_) -> Bool in
            return true
        }, modification: { (file: inout File) -> Void in

            file.contents = file.contents.replacingOccurrences(of: scriptActionEntry, with: disabledScriptActionEntry)
        })
    }

    static func reEnableProofreading() {

        modifyProject(condition: { (_) -> Bool in
            return true
        }, modification: { (file: inout File) -> Void in

            file.contents = file.contents.replacingOccurrences(of: disabledScriptActionEntry, with: scriptActionEntry)
        })
    }
}
