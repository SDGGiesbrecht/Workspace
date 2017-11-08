/*
 Script.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2017 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import Foundation

import SDGCornerstone
import SDGCommandLine

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
            return "Refresh (macOS).command"
        case .refreshLinux:
            return "Refresh (Linux).sh"
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

    static func refreshRelevantScripts(for project: PackageRepository, output: inout Command.Output) throws {

        for deprecated in Script.deprecatedFileNames {
            try? FileManager.default.removeItem(at: project.url(for: String(deprecated)))
        }

        for script in cases where script.isRelevantOnCurrentDevice ∨ script.isCheckedIn {
            var file = try PackageRepository.TextFile(possiblyAt: project.url(for: String(script.fileName)), executable: true)
            file.contents.replaceSubrange(file.contents.startIndex ..< file.headerStart, with: String(script.shebang()))
            file.body = String(script.source())
            try file.writeChanges(for: project, output: &output)
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

    func getWorkspace(andExecute command: StrictString) -> [StrictString] {

        let version = StrictString(latestStableWorkspaceVersion.string)
        let arguments: StrictString = command + " •use‐version " + version

        let macOSCachePath: StrictString = "~/Library/Caches/ca.solideogloria.Workspace/Versions/" + version + "/"
        let linuxCachePath: StrictString = "~/.cache/ca.solideogloria.Workspace/Versions/" + version + "/"

        let buildLocation: StrictString = "/tmp/Workspace"

        return [
            ("if workspace version > /dev/null ; then") as StrictString,
            ("    workspace " + arguments) as StrictString,
            ("elif " + macOSCachePath + "workspace version > /dev/null ; then") as StrictString,
            ("    echo \u{22}Workspace not installed, searching for cached version...\u{22}") as StrictString,
            ("    " + macOSCachePath + "workspace " + arguments) as StrictString,
            ("elif " + linuxCachePath + "workspace version > /dev/null ; then") as StrictString,
            ("    " + linuxCachePath + "workspace " + arguments) as StrictString,
            ("else") as StrictString,
            ("    echo \u{22}No cached version detected, fetching Workspace...\u{22}") as StrictString,
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

    func source() -> StrictString {
        var lines: [StrictString] = [
            stopOnFailure(),
            findRepository(),
            enterRepository()
        ]

        switch self {
        case .refreshLinux:
            lines.append(openTerminal(andExecute: "Refresh"))
        case .validateLinux:
            lines.append(openTerminal(andExecute: "Validate"))
        case .refreshMacOS:
            lines.append(contentsOf: getWorkspace(andExecute: "refresh"))
        case .validateMacOS:
            lines.append(contentsOf: getWorkspace(andExecute: "validate"))
        }

        return StrictString(lines.joined(separator: "\n".scalars))
    }
}
