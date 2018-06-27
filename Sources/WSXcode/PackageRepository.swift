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

    private static let proofreadTargetName = UserFacing<StrictString, InterfaceLocalization>({ localization in
        switch localization {
        case .englishCanada:
            return "Proofread"
        }
    })

    private static let instructions = UserFacing<StrictString, InterfaceLocalization>({ localization in
        switch localization {
        case .englishCanada:
            return [
            "Install Workspace if you wish to receive in‐code reports of style errors for this project.",
            "See " + StrictString(Metadata.packageURL.absoluteString)
            ].joinedAsLines()
        }
    })

    private static let proofreadTargetIdentifier = "WORKSPACE_PROOFREAD_TARGET"
    private static let proofreadScriptIdentifier = "WORKSPACE_PROOFREAD_SCRIPT"

    private var aggregateTarget: String {
        return  [
            "        \(PackageRepository.proofreadTargetIdentifier) = {",
            "            isa = PBXAggregateTarget;",
            "            buildPhases = (",
            "                \(PackageRepository.proofreadScriptIdentifier),",
            "            );",
            "            name = \u{22}\(PackageRepository.proofreadTargetName.resolved())\u{22};",
            "            productName = \u{22}\(PackageRepository.proofreadTargetName.resolved())\u{22};",
            "        };",
            ].joinedAsLines()
    }

    private func script() throws -> String {
        if try isWorkspaceProject() {
            return "swift run workspace proofread •xcode"
        } else {
            return "export PATH=\u{5C}\u{22}$HOME/.SDG/Registry:$PATH\u{5C}\u{22} ; if which workspace > /dev/null ; then workspace proofread •xcode •use‐version " + Metadata.latestStableVersion.string() + " ; else echo \u{5C}\u{22}warning: \(PackageRepository.instructions.resolved())\u{5C}\u{22} ; fi"
        }
    }

    private func scriptObject() throws -> String {
        return  [
            "        \(PackageRepository.proofreadScriptIdentifier) = {",
            "            isa = PBXShellScriptBuildPhase;",
            "            shellPath = /bin/sh;",
            "            shellScript = \u{22}\(try script())\u{22};",
            "        };",
            ].joinedAsLines()
    }

    public func refreshXcodeProject(output: Command.Output) throws {
        try generateXcodeProject(reportProgress: { output.print($0) })
        resetFileCache(debugReason: "generate\u{2D}xcodeproj")
        output.print("")

        if let projectBundle = try xcodeProject() {
            var project = try TextFile(alreadyAt: projectBundle.appendingPathComponent("project.pbxproj"))

            let objectsLine = "objects = {"
            if let range = project.contents.scalars.firstMatch(for: objectsLine.scalars)?.range {
                project.contents.scalars.replaceSubrange(range, with: [
                    objectsLine,
                    aggregateTarget,
                    try scriptObject(),
                    ].joinedAsLines().scalars)
            }

            let targetsLine = "targets = ("
            if let range = project.contents.scalars.firstMatch(for: targetsLine.scalars)?.range {
                project.contents.scalars.replaceSubrange(range, with: [
                    targetsLine,
                    PackageRepository.proofreadTargetIdentifier + ",",
                    ].joinedAsLines().scalars)
            }

            try project.writeChanges(for: self, output: output)
        }
    }

    #endif
}
