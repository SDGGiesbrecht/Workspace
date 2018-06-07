/*
 DXcode.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2017–2018 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

#if !os(Linux)

import SDGLogic
import SDGCollections
import GeneralImports

import Metadata

struct DXcode {

    static func refreshXcodeProjects(output: Command.Output) throws {
        let script = ["swift", "package", "generate\u{2D}xcodeproj", "\u{2D}\u{2D}enable\u{2D}code\u{2D}coverage"]
        requireBash(script)

        // Allow dependencies to be found by the executable.

        let path = RelativePath("\(try Repository.packageRepository.xcodeProject()!.lastPathComponent)")
        var file = require { try File(at: path.subfolderOrFile("project.pbxproj")) }

        let startToken = "LD_RUNPATH_SEARCH_PATHS = ("
        let endToken = ");"
        let illegal = endToken.scalars.first!
        let paths = [
            "",
            "$(inherited)",
            "@executable_path/Frameworks",
            "@loader_path/Frameworks",
            "@executable_path/../Frameworks",
            "@loader_path/../Frameworks"
            ].map({ "\u{22}\($0)\u{22}," }).joinAsLines()
        let replacement = (startToken + paths + endToken).scalars

        file.contents.scalars.replaceMatches(for: [
            LiteralPattern(startToken.scalars),
            ConditionalPattern({ $0 ≠ illegal }),
            LiteralPattern(startToken.scalars)
            ], with: replacement)

        require { try file.write(output: output) }
    }

    private static func modifyProject(condition shouldModify: (String) -> Bool, modification modify: (inout File) -> Void, output: Command.Output) throws {

        let path = RelativePath("\(try Repository.packageRepository.xcodeProject()!.lastPathComponent)/project.pbxproj")

        do {
            var file = try File(at: path)

            if shouldModify(file.contents) {

                modify(&file)
                require { try file.write(output: output) }
            }
        } catch {
            return
        }
    }

    static let scriptObjectName = "PROOFREAD"
    static let scriptActionEntry = scriptObjectName + ","

    static let skipProofreadingEnvironmentVariable = "SKIP_PROOFREADING"

    static func enableProofreading(output: Command.Output) throws {

        let script: String
        if try Repository.packageRepository.isWorkspaceProject() {
            script = "if [ \u{2D}z ${SKIP_PROOFREADING+set} ] ; then swift run workspace proofread •xcode ; fi"
        } else {
            script = "if [ \u{2D}z ${SKIP_PROOFREADING+set} ] ; then export PATH=\u{5C}\u{22}$HOME/.SDG/Registry:$PATH\u{5C}\u{22} ; if which workspace > /dev/null ; then workspace proofread •xcode •use‐version " + Metadata.latestStableVersion.string() + " ; else echo \u{5C}\u{22}warning: Install Workspace if you wish to receive in‐code reports of style errors for this project. See https://github.com/SDGGiesbrecht/Workspace\u{5C}\u{22} ; fi ; fi"
        }

        let allTargets = try Repository.packageRepository.targets().map { $0.name }
        let primaryXcodeTarget = allTargets.first(where: { $0.scalars.first! ∈ CharacterSet.uppercaseLetters ∧ ¬$0.hasPrefix("Tests") })!

        try modifyProject(condition: {
            return ¬$0.contains("workspace proofread")

        }, modification: { (file: inout File) -> Void in

            let scriptInsertLocation = file.requireRange(of: "objects = {\n").upperBound
            file.contents.replaceSubrange(scriptInsertLocation ..< scriptInsertLocation, with: [
                "\(scriptObjectName) = {",
                "    isa = PBXShellScriptBuildPhase;",
                "    shellPath = /bin/bash;",
                "    shellScript = \u{22}\(script)\u{22};",
                "};",
                "" // Final line break.
                ].joinAsLines())

            var searchRange = file.contents.startIndex ..< file.contents.endIndex
            var discoveredPhaseInsertLocation: String.Index?
            while let possiblePhaseInsertLocation = file.contents.scalars.firstMatch(for: "buildPhases = (\n".scalars, in: searchRange.sameRange(in: file.contents.scalars))?.range.upperBound.cluster(in: file.contents.clusters) {
                searchRange = possiblePhaseInsertLocation ..< file.contents.endIndex

                let name = file.requireContents(of: ("name = \u{22}", "\u{22};"), in: searchRange)
                if name == primaryXcodeTarget {
                    discoveredPhaseInsertLocation = possiblePhaseInsertLocation
                    break
                }
            }

            guard let phaseInsertLocation = discoveredPhaseInsertLocation else {

                fatalError(message: [
                    "Failed to find a target with the following name:",
                    primaryXcodeTarget
                    ])
            }

            file.contents.replaceSubrange(phaseInsertLocation ..< phaseInsertLocation, with: [
                scriptActionEntry,
                "" // Final line break.
                ].joinAsLines())
        }, output: output)
    }

    static let disabledScriptActionEntry = "/* " + scriptObjectName + " */"

    static func temporarilyDisableProofreading(output: Command.Output) throws {

        try modifyProject(condition: { (_) -> Bool in
            return true
        }, modification: { (file: inout File) -> Void in

            file.contents = file.contents.replacingOccurrences(of: scriptActionEntry, with: disabledScriptActionEntry)
        }, output: output)
    }

    static func reEnableProofreading(output: Command.Output) throws {

        try modifyProject(condition: { (_) -> Bool in
            return true
        }, modification: { (file: inout File) -> Void in

            file.contents = file.contents.replacingOccurrences(of: disabledScriptActionEntry, with: scriptActionEntry)
        }, output: output)
    }
}

#endif
