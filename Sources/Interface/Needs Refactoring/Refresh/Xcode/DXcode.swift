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

struct DXcode {

    static func refreshXcodeProjects(output: Command.Output) throws {
        let script = ["swift", "package", "generate\u{2D}xcodeproj", "\u{2D}\u{2D}enable\u{2D}code\u{2D}coverage"]
        requireBash(script)

        // Allow dependencies to be found by the executable.

        let path = RelativePath("\(try Repository.packageRepository.xcodeProject()!.lastPathComponent)")
        var file = require { try File(at: path.subfolderOrFile("project.pbxproj")) }

        let allTargets = try Repository.packageRepository.targets().map { $0.name }
        let primaryProductName = allTargets.first(where: { $0.scalars.first! ∈ CharacterSet.uppercaseLetters ∧ ¬$0.hasPrefix("Tests") })!
        let applicationExecutableName = primaryProductName
        let xcodeTestTarget = primaryProductName + "Tests"

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

        if try Repository.packageRepository.configuration.projectType() == .application {
            var project = file.contents

            // Change product type from framework to application.

            let productMarkerSearchString = "productName = \u{22}\(primaryProductName)\u{22}"
            guard let productMarker = project.range(of: productMarkerSearchString),
                let rangeOfProductType = project.scalars.firstMatch(for: ".framework".scalars, in: (productMarker.upperBound ..< project.endIndex).sameRange(in: project.scalars))?.range.clusters(in: project.clusters) else {
                    fatalError(message: [
                        "Cannot find primary product in Xcode project.",
                        "Expected “.framework” after “\(productMarkerSearchString)”."
                        ])
            }
            project.replaceSubrange(rangeOfProductType, with: ".application")

            // Application bundle name should be .app not .framework.

            project = project.replacingOccurrences(of: "\(primaryProductName).framework", with: "\(primaryProductName).app")

            // Remove .app from the list of frameworks that tests link against.

            var possibleFrameworksList: Range<String.Index>?
            var searchLocation = project.startIndex
            let frameworkPhaseSearchString = "isa = \u{22}PBXFrameworksBuildPhase\u{22}"
            let fileListTokens = ("files = (", ");")
            while let frameworkPhase = project.scalars.firstMatch(for: frameworkPhaseSearchString.scalars, in: (searchLocation ..< project.endIndex).sameRange(in: project.scalars))?.range.clusters(in: project.clusters) {
                searchLocation = frameworkPhase.upperBound

                if let fileList = project.scalars.firstNestingLevel(startingWith: fileListTokens.0.scalars, endingWith: fileListTokens.1.scalars, in: (frameworkPhase.upperBound ..< project.endIndex).sameRange(in: project.scalars))?.contents.range.clusters(in: project.clusters) {
                    if let existing = possibleFrameworksList {
                        if project.distance(from: fileList.lowerBound, to: fileList.upperBound) > project.distance(from: existing.lowerBound, to: existing.upperBound) {
                            possibleFrameworksList = fileList
                        }
                    } else {
                        possibleFrameworksList = fileList
                    }
                }
            }
            guard let frameworksList = possibleFrameworksList else {
                fatalError(message: [
                    "Cannot find test dependency list in Xcode project.",
                    "Expected “\(fileListTokens.0)”...“\(fileListTokens.1)” after “\(frameworkPhaseSearchString)”."
                    ])
            }
            var frameworkLines = String(project[frameworksList]).lines.map({ String($0.line) })
            for index in frameworkLines.indices.reversed() where ¬frameworkLines[index].isWhitespace {
                frameworkLines.remove(at: index)
                break
            }
            project.replaceSubrange(frameworksList, with: frameworkLines.joinAsLines())

            // Provide test linking information.

            let testMarker = "TARGET_NAME = \u{22}\(xcodeTestTarget)\u{22};"
            let testInfo = [
                "\u{22}TEST_HOST[sdk=macosx*]\u{22} = \u{22}$(BUILT_PRODUCTS_DIR)/\(primaryProductName).app/Contents/MacOS/\(applicationExecutableName)\u{22};",
                "TEST_HOST = \u{22}$(BUILT_PRODUCTS_DIR)/\(primaryProductName).app/\(applicationExecutableName)\u{22};",
                "BUNDLE_LOADER = \u{22}$(TEST_HOST)\u{22};"
            ]
            project = project.replacingOccurrences(of: testMarker, with: ([testMarker] + testInfo).joinAsLines())

            file.contents = project
        }

        require { try file.write(output: output) }

        if try Repository.packageRepository.configuration.projectType() == .application {

            // Denote principal class in Info.plist for @NSApplicationMain to work.

            var info = require { try File(at: path.subfolderOrFile("\(primaryProductName)_Info.plist")) }

            info.contents = info.contents.replacingOccurrences(of: "<key>NSPrincipalClass</key>\n  <string></string>", with: "<key>NSPrincipalClass</key>\n  <string>\(Configuration.moduleName).Application</string>")

            require { try info.write(output: output) }
        }
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
        if try Repository.packageRepository.isWorkspaceProject(output: output) {
            script = "if [ \u{2D}z ${SKIP_PROOFREADING+set} ] ; then swift run workspace proofread •xcode ; fi"
        } else {
            script = "if [ \u{2D}z ${SKIP_PROOFREADING+set} ] ; then export PATH=\u{5C}\u{22}$HOME/.SDG/Registry:$PATH\u{5C}\u{22} ; if which workspace > /dev/null ; then workspace proofread •xcode •use‐version " + latestStableWorkspaceVersion.string() + " ; else echo \u{5C}\u{22}warning: Install Workspace if you wish to receive in‐code reports of style errors for this project. See https://github.com/SDGGiesbrecht/Workspace\u{5C}\u{22} ; fi ; fi"
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
