/*
 PackageRepository.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2017–2018 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import WSGeneralImports

import SDGXcode

import WSProject
import WorkspaceProjectConfiguration

extension PackageRepository {

    #if !os(Linux)

    private static let instructions = UserFacing<StrictString, InterfaceLocalization>({ localization in
        switch localization {
        case .englishCanada:
            return [
            "Install Workspace if you wish to receive in‐code reports of style errors for this project.",
            "See " + StrictString(Metadata.packageURL.absoluteString)
            ].joinedAsLines()
        }
    })

    private static let scriptObjectName = "PROOFREAD"

    private func script() throws -> String {
        if try isWorkspaceProject() {
            return "swift run workspace proofread •xcode"
        } else {
            return "export PATH=\u{5C}\u{22}$HOME/.SDG/Registry:$PATH\u{5C}\u{22} ; if which workspace > /dev/null ; then workspace proofread •xcode •use‐version " + Metadata.latestStableVersion.string() + " ; else echo \u{5C}\u{22}warning: \(PackageRepository.instructions.resolved())\u{5C}\u{22} ; fi"
        }
    }

    public func refreshXcodeProject(output: Command.Output) throws {
        try generateXcodeProject(reportProgress: { output.print($0) })
        defer { resetFileCache(debugReason: "generate\u{2D}xcodeproj") }

        if let projectBundle = try xcodeProject() {
            let project = try TextFile(alreadyAt: projectBundle.appendingPathComponent("project.pbxproj"))



            try project.writeChanges(for: self, output: output)
        }
    }

    #endif

    /*
    #if !os(Linux)

    struct DXcode {

        static let scriptActionEntry = scriptObjectName + ","

        static let skipProofreadingEnvironmentVariable = "SKIP_PROOFREADING"

        static func enableProofreading(output: Command.Output) throws {

            let allTargets = try Repository.packageRepository.targets().map { $0.name }
            let primaryXcodeTarget = allTargets.first(where: { $0.scalars.first! ∈ CharacterSet.uppercaseLetters ∧ ¬$0.hasPrefix("Tests") })!

            try modifyProject(condition: {
                return ¬$0.contains("workspace proofread")

            }, modification: { (file: inout TextFile) -> Void in

                if let scriptInsertLocation = file.contents.firstMatch(for: "objects = {\n")?.range.upperBound {
                    file.contents.replaceSubrange(scriptInsertLocation ..< scriptInsertLocation, with: [
                        "\(scriptObjectName) = {",
                        "    isa = PBXShellScriptBuildPhase;",
                        "    shellPath = /bin/bash;",
                        "    shellScript = \u{22}\(script)\u{22};",
                        "};",
                        "" // Final line break.
                        ].joinedAsLines())

                    var searchRange = file.contents.startIndex ..< file.contents.endIndex
                    var discoveredPhaseInsertLocation: String.Index?
                    while let possiblePhaseInsertLocation = file.contents.scalars.firstMatch(for: "buildPhases = (\n".scalars, in: searchRange.sameRange(in: file.contents.scalars))?.range.upperBound.cluster(in: file.contents.clusters) {
                        searchRange = possiblePhaseInsertLocation ..< file.contents.endIndex

                        if let name = file.contents.firstNestingLevel(startingWith: "name = \u{22}", endingWith: "\u{22};", in: searchRange).flatMap({ String($0.contents.contents) }) {
                            if name == primaryXcodeTarget {
                                discoveredPhaseInsertLocation = possiblePhaseInsertLocation
                                break
                            }
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
                        ].joinedAsLines())
                }
            }, output: output)
        }

        static let disabledScriptActionEntry = "/* " + scriptObjectName + " */"

        static func temporarilyDisableProofreading(output: Command.Output) throws {

            try modifyProject(condition: { (_) -> Bool in
                return true
            }, modification: { (file: inout TextFile) -> Void in

                file.contents = file.contents.replacingOccurrences(of: scriptActionEntry, with: disabledScriptActionEntry)
            }, output: output)
        }

        static func reEnableProofreading(output: Command.Output) throws {

            try modifyProject(condition: { (_) -> Bool in
                return true
            }, modification: { (file: inout TextFile) -> Void in

                file.contents = file.contents.replacingOccurrences(of: disabledScriptActionEntry, with: scriptActionEntry)
            }, output: output)
        }
    }

    #endif */

}
