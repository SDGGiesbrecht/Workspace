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

    static var projectFilename: String {
        return Configuration.defaultPackageName + ".xcodeproj"
    }

    static var applicationProductName: String {
        return Configuration.defaultPackageName
    }

    static var defaultPrimaryTargetName: String {
        if Configuration.projectType == .executable {
            return Configuration.executableLibraryName(forProjectName: Configuration.projectName)
        } else {
            return Configuration.moduleName(forProjectName: Configuration.projectName)
        }
    }

    static func refreshXcodeProjects() {

        let path = RelativePath("\(Xcode.projectFilename)")
        force() { try Repository.delete(path) }

        var script = ["swift", "package", "generate\u{2D}xcodeproj", "\u{2D}\u{2D}output", path.string]
        if ¬Environment.isInContinuousIntegration {
            script.append("\u{2D}\u{2D}enable\u{2D}code\u{2D}coverage")
        }
        requireBash(script)

        require() { try Repository.delete(path.subfolderOrFile("xcshareddata/xcschemes")) }

        var file = require() { try File(at: path.subfolderOrFile("project.pbxproj")) }
        file.contents.replaceContentsOfEveryPair(of: ("LD_RUNPATH_SEARCH_PATHS = (", ");"), with: join(lines: [
            "",
            "$(inherited)",
            "@executable_path/Frameworks",
            "@loader_path/Frameworks",
            "@executable_path/../Frameworks",
            "@loader_path/../Frameworks"
            ].map({ "\u{22}\($0)\u{22}," })))

        if Configuration.projectType == .application {
            var project = file.contents

            guard let productMarker = project.range(of: "productName = \u{22}\(Xcode.applicationProductName)\u{22}"),
                let rangeOfProductType = project.range(of: ".framework", in: productMarker.upperBound ..< project.endIndex)else {
                    fatalError(message: ["Cannot find primary product in Xcode project."])
            }
            project.replaceSubrange(rangeOfProductType, with: ".application")

            project = project.replacingOccurrences(of: "\(Xcode.applicationProductName).framework", with: "\(Xcode.applicationProductName).app")

            file.contents = project
        }

        require() { try file.write() }

        if Configuration.projectType == .application {
            var info = require() { try File(at: path.subfolderOrFile("\(Xcode.applicationProductName)_Info.plist")) }

            info.contents = info.contents.replacingOccurrences(of: "<key>NSPrincipalClass</key>\n  <string></string>", with: "<key>NSPrincipalClass</key>\n  <string>\(Configuration.moduleName).Application</string>")

            require() { try info.write() }
        }
    }

    private static func modifyProject(condition shouldModify: (String) -> Bool, modification modify: (inout File) -> Void) {
        let path = RelativePath("\(Xcode.projectFilename)/project.pbxproj")

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
                "    shellScript = \u{22}~/.Workspace/Workspace/.build/release/workspace proofread\u{22};",
                "};",
                "" // Final line break.
                ]))

            var searchRange = file.contents.startIndex ..< file.contents.endIndex
            var discoveredPhaseInsertLocation: String.Index?
            while let possiblePhaseInsertLocation = file.contents.range(of: "buildPhases = (\n", in: searchRange)?.upperBound {
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
                    "...specifying one of the following:",
                    "",
                    join(lines: Repository.moduleNames)
                    ])
            }

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
