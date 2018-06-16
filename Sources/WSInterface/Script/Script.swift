/*
 Script.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2017–2018 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGLogic
import WSGeneralImports

import WorkspaceProjectConfiguration
import WSProject

enum Script : Int, IterableEnumeration {

    // MARK: - Cases

    case refreshMacOS
    case refreshLinux
    case validateMacOS
    case validateLinux

    // MARK: - Properties

    var fileName: StrictString {
        switch self {
        case .refreshMacOS:
            return refreshScriptMacOSFileName
        case .refreshLinux:
            return refreshScriptLinuxFileName
        case .validateMacOS:
            return "Validate (macOS).command"
        case .validateLinux:
            return "Validate (Linux).sh"
        }
    }
    private var deprecatedPre0_1_1FileName: StrictString? {
        switch self {
        case .refreshMacOS:
            return "Refresh Workspace (macOS).command"
        case .refreshLinux:
            return "Refresh Workspace (Linux).sh"
        case .validateMacOS:
            return "Validate Changes (macOS).command"
        case .validateLinux:
            return "Validate Changes (Linux).sh"
        }
    }
    private static let deprecatedFileNames: [StrictString] = {
        var deprecated: Set<StrictString> = []
        for script in Script.cases {
            if let pre0_1_1 = script.deprecatedPre0_1_1FileName,
                pre0_1_1 ≠ script.fileName {
                deprecated.insert(pre0_1_1)
            }
        }
        return deprecated.sorted()
    }()

    private var isRelevantOnCurrentDevice: Bool {
        switch self {
        case .refreshMacOS, .validateMacOS:
            #if os(macOS)
            return true
            #elseif os(Linux)
            return true // Linux scripts use the macOS ones internally.
            #endif
        case .refreshLinux, .validateLinux:
            #if os(macOS)
            return false
            #elseif os(Linux)
            return true
            #endif
        }
    }

    private var isCheckedIn: Bool {
        switch self {
        case .refreshMacOS, .refreshLinux:
            return true
        case .validateMacOS, .validateLinux:
            return false
        }
    }

    // MARK: - Refreshing

    static func refreshRelevantScripts(for project: PackageRepository, output: Command.Output) throws {

        for deprecated in Script.deprecatedFileNames {
            project.delete(project.location.appendingPathComponent(String(deprecated)), output: output)
        }

        for script in cases where script.isRelevantOnCurrentDevice ∨ script.isCheckedIn {
            try autoreleasepool {

                var file = try TextFile(possiblyAt: project.location.appendingPathComponent(String(script.fileName)), executable: true)
                file.contents.replaceSubrange(file.contents.startIndex ..< file.headerStart, with: String(script.shebang()))
                file.body = String(try script.source(for: project, output: output))
                try file.writeChanges(for: project, output: output)
            }
        }
    }

    // MARK: - Source

    func shebang() -> StrictString {
        return "#!/bin/bash" + "\n\n"
    }

    func stopOnFailure() -> StrictString {
        return "set \u{2D}e"
    }

    func findRepository() -> StrictString {
        // “REPOSITORY=\u{22}$(pwd)\u{22}”
        // Does not work for double‐click on macOS, or as a command on macOS or Linux from a different directory.

        // “REPOSITORY=\u{22}${0%/*}\u{22}”
        // Does not work for double‐click on Linux or as a command on macOS or Linux from a different directory.

        return "REPOSITORY=\u{22}$( cd \u{22}$( dirname \u{22}${BASH_SOURCE[0]}\u{22} )\u{22} \u{26}& pwd )\u{22}"
    }

    func enterRepository() -> StrictString {
        return "cd \u{22}${REPOSITORY}\u{22}"
    }

    func openTerminal(andExecute script: StrictString) -> StrictString {
        return "gnome\u{2D}terminal \u{2D}e \u{22}bash \u{2D}\u{2D}login \u{2D}c \u{5C}\u{22}source ~/.bashrc; ./" + script + "\u{5C} \u{5C}(macOS\u{5C}).command; exec bash\u{5C}\u{22}\u{22}"
    }

    func getWorkspace(andExecute command: StrictString, for project: PackageRepository, output: Command.Output) throws -> [StrictString] {
        let command = command.appending(contentsOf: " $1 $2")

        if try project.isWorkspaceProject() {
            return ["swift run workspace " + command]
        } else {
            let version = StrictString(Metadata.latestStableVersion.string())
            let arguments: StrictString = command + " •use‐version " + version

            let macOSCachePath: StrictString = "~/Library/Caches/ca.solideogloria.Workspace/Versions/" + version + "/"
            let linuxCachePath: StrictString = "~/.cache/ca.solideogloria.Workspace/Versions/" + version + "/"

            let buildLocation: StrictString = "/tmp/Workspace"

            return [
                ("if workspace version > /dev/null 2>&1 ; then") as StrictString,
                ("    echo \u{22}Using system install of Workspace...\u{22}") as StrictString,
                ("    workspace " + arguments) as StrictString,
                ("elif " + macOSCachePath + "workspace version > /dev/null 2>&1 ; then") as StrictString,
                ("    echo \u{22}Using cached build of Workspace...\u{22}") as StrictString,
                ("    " + macOSCachePath + "workspace " + arguments) as StrictString,
                ("elif " + linuxCachePath + "workspace version > /dev/null 2>&1 ; then") as StrictString,
                ("    echo \u{22}Using cached build of Workspace...\u{22}") as StrictString,
                ("    " + linuxCachePath + "workspace " + arguments) as StrictString,
                ("else") as StrictString,
                ("    echo \u{22}No cached build detected, fetching Workspace...\u{22}") as StrictString,
                ("    rm \u{2D}rf " + buildLocation) as StrictString,
                ("    git clone https://github.com/SDGGiesbrecht/Workspace " + buildLocation) as StrictString,
                ("    cd " + buildLocation) as StrictString,
                ("    swift build \u{2D}\u{2D}configuration release") as StrictString,
                ("    " + enterRepository()) as StrictString,
                ("    " + buildLocation + "/.build/release/workspace " + arguments) as StrictString,
                ("    rm \u{2D}rf " + buildLocation) as StrictString,
                ("fi") as StrictString
            ]
        }
    }

    func source(for project: PackageRepository, output: Command.Output) throws -> StrictString {
        var lines: [StrictString] = [
            stopOnFailure(),
            findRepository(),
            enterRepository()
        ]

        switch self {
        case .refreshLinux:
            lines.append(openTerminal(andExecute: "Refresh"))
        case .validateLinux:
            // [_Exempt from Test Coverage_] Unreachable from macOS.
            lines.append(openTerminal(andExecute: "Validate"))
        case .refreshMacOS:
            lines.append(contentsOf: try getWorkspace(andExecute: "refresh", for: project, output: output))
        case .validateMacOS:
            lines.append(contentsOf: try getWorkspace(andExecute: "validate", for: project, output: output))
        }

        return StrictString(lines.joined(separator: "\n".scalars))
    }
}
