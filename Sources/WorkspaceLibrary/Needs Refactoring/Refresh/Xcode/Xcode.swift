/*
 Xcode.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2017 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGCornerstone
import SDGCommandLine

struct DXcode {

    static func refreshXcodeProjects(output: inout Command.Output) throws {

        let path = RelativePath("\(DXcode.projectFilename)")
        try? Repository.delete(path)

        let script = ["swift", "package", "generate\u{2D}xcodeproj", "\u{2D}\u{2D}enable\u{2D}code\u{2D}coverage", "\u{2D}\u{2D}output", path.string]
        requireBash(script)

        // Allow dependencies to be found by the executable.

        var file = require() { try File(at: path.subfolderOrFile("project.pbxproj")) }

        let startToken = "LD_RUNPATH_SEARCH_PATHS = ("
        let endToken = ");"
        let illegal = endToken.scalars.first!
        let paths = join(lines: [
            "",
            "$(inherited)",
            "@executable_path/Frameworks",
            "@loader_path/Frameworks",
            "@executable_path/../Frameworks",
            "@loader_path/../Frameworks"
            ].map({ "\u{22}\($0)\u{22}," }))
        let replacement = (startToken + paths + endToken).scalars

        file.contents.scalars.replaceMatches(for: [
            LiteralPattern(startToken.scalars),
            ConditionalPattern(condition: { $0 ≠ illegal }),
            LiteralPattern(startToken.scalars)
        ], with: replacement)

        if try Repository.packageRepository.configuration.projectType() == .application {
            var project = file.contents

            // Change product type from framework to application.

            let productMarkerSearchString = "productName = \u{22}\(DXcode.primaryProductName)\u{22}"
            guard let productMarker = project.range(of: productMarkerSearchString),
                let rangeOfProductType = project.scalars.firstMatch(for: ".framework".scalars, in: (productMarker.upperBound ..< project.endIndex).sameRange(in: project.scalars))?.range.clusters(in: project.clusters) else {
                    fatalError(message: [
                        "Cannot find primary product in Xcode project.",
                        "Expected “.framework” after “\(productMarkerSearchString)”."
                        ])
            }
            project.replaceSubrange(rangeOfProductType, with: ".application")

            // Application bundle name should be .app not .framework.

            project = project.replacingOccurrences(of: "\(DXcode.primaryProductName).framework", with: "\(DXcode.primaryProductName).app")

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
            project.replaceSubrange(frameworksList, with: join(lines: frameworkLines))

            // Provide test linking information.

            let testMarker = "TARGET_NAME = \u{22}\(Configuration.xcodeTestTarget)\u{22};"
            let testInfo = [
                "\u{22}TEST_HOST[sdk=macosx*]\u{22} = \u{22}$(BUILT_PRODUCTS_DIR)/\(Xcode.primaryProductName).app/Contents/MacOS/\(Xcode.applicationExecutableName)\u{22};",
                "TEST_HOST = \u{22}$(BUILT_PRODUCTS_DIR)/\(DXcode.primaryProductName).app/\(Xcode.applicationExecutableName)\u{22};",
                "BUNDLE_LOADER = \u{22}$(TEST_HOST)\u{22};"
            ]
            project = project.replacingOccurrences(of: testMarker, with: join(lines: [testMarker] + testInfo))

            file.contents = project
        }

        require() { try file.write(output: &output) }

        if try Repository.packageRepository.configuration.projectType() == .application {

            // Denote principal class in Info.plist for @NSApplicationMain to work.

            var info = require() { try File(at: path.subfolderOrFile("\(Xcode.primaryProductName)_Info.plist")) }

            info.contents = info.contents.replacingOccurrences(of: "<key>NSPrincipalClass</key>\n  <string></string>", with: "<key>NSPrincipalClass</key>\n  <string>\(Configuration.moduleName).Application</string>")

            require() { try info.write(output: &output) }
        }
    }

    private static func modifyProject(condition shouldModify: (String) -> Bool, modification modify: (inout File) -> Void, output: inout Command.Output) {
        let path = RelativePath("\(DXcode.projectFilename)/project.pbxproj")

        do {
            var file = try File(at: path)

            if shouldModify(file.contents) {

                modify(&file)
                require() { try file.write(output: &output) }
            }
        } catch {
            return
        }
    }

    static let scriptObjectName = "PROOFREAD"
    static let scriptActionEntry = scriptObjectName + ","

    static func enableProofreading(output: inout Command.Output) {

        modifyProject(condition: {
            return ¬$0.contains("workspace proofread")

        }, modification: { (file: inout File) -> Void in

            let scriptInsertLocation = file.requireRange(of: "objects = {\n").upperBound
            file.contents.replaceSubrange(scriptInsertLocation ..< scriptInsertLocation, with: join(lines: [
                "\(scriptObjectName) = {",
                "    isa = PBXShellScriptBuildPhase;",
                "    shellPath = /bin/bash;",
                "    shellScript = \u{22}export PATH=\u{5C}\u{22}$HOME/.SDG/Registry:$PATH\u{5C}\u{22} ; if which workspace > /dev/null ; then workspace proofread •use‐version " + latestStableWorkspaceVersion.string + " ; else echo \u{5C}\u{22}warning: Install Workspace if you wish to receive in‐code reports of style errors for this project. See https://github.com/SDGGiesbrecht/Workspace\u{5C}\u{22} ; fi\u{22};",
                "};",
                "" // Final line break.
                ]))

            var searchRange = file.contents.startIndex ..< file.contents.endIndex
            var discoveredPhaseInsertLocation: String.Index?
            while let possiblePhaseInsertLocation = file.contents.scalars.firstMatch(for: "buildPhases = (\n".scalars, in: searchRange.sameRange(in: file.contents.scalars))?.range.upperBound.cluster(in: file.contents.clusters) {
                searchRange = possiblePhaseInsertLocation ..< file.contents.endIndex

                let name = file.requireContents(of: ("name = \u{22}", "\u{22};"), in: searchRange)
                if name == Configuration.primaryXcodeTarget {
                    discoveredPhaseInsertLocation = possiblePhaseInsertLocation
                    break
                }
            }

            guard let phaseInsertLocation = discoveredPhaseInsertLocation else {

                fatalError(message: [
                    "Failed to find a target with the following name:",
                    Configuration.primaryXcodeTarget,
                    "Please configure the option...",
                    "\(Option.primaryXcodeTarget)",
                    "...specifying a valid target name."
                    ])
            }

            file.contents.replaceSubrange(phaseInsertLocation ..< phaseInsertLocation, with: join(lines: [
                scriptActionEntry,
                "" // Final line break.
                ]))
        }, output: &output)
    }

    static let disabledScriptActionEntry = "/* " + scriptObjectName + " */"

    static func temporarilyDisableProofreading(output: inout Command.Output) {

        modifyProject(condition: { (_) -> Bool in
            return true
        }, modification: { (file: inout File) -> Void in

            file.contents = file.contents.replacingOccurrences(of: scriptActionEntry, with: disabledScriptActionEntry)
        }, output: &output)
    }

    static func reEnableProofreading(output: inout Command.Output) {

        modifyProject(condition: { (_) -> Bool in
            return true
        }, modification: { (file: inout File) -> Void in

            file.contents = file.contents.replacingOccurrences(of: disabledScriptActionEntry, with: scriptActionEntry)
        }, output: &output)
    }
}
