/*
 Script.swift

 This source file is part of the Workspace open source project.
 Diese Quelldatei ist Teil des qeulloffenen Arbeitsbereich‐Projekt.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2017–2020 Jeremy David Giesbrecht and the Workspace project contributors.
 Urheberrecht ©2017–2020 Jeremy David Giesbrecht und die Mitwirkenden des Arbeitsbereich‐Projekts.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGLogic
import WSGeneralImports

import WorkspaceProjectConfiguration
import WSProject

internal enum Script: Int, CaseIterable {

  // MARK: - Cases

  case refreshMacOS
  case refreshLinux
  case validateMacOS
  case validateLinux

  // MARK: - Properties

  internal var fileName: StrictString {
    switch self {
    case .refreshMacOS:
      return RepositoryConfiguration._refreshScriptMacOSFileName
    case .refreshLinux:
      return RepositoryConfiguration._refreshScriptLinuxFileName
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
  internal static let deprecatedFileNames: [StrictString] = {
    var deprecated: Set<StrictString> = []
    for script in Script.allCases {
      if let pre0_1_1 = script.deprecatedPre0_1_1FileName,
        pre0_1_1 ≠ script.fileName
      {
        deprecated.insert(pre0_1_1)
      }
    }
    return deprecated.sorted()
  }()

  internal var isRelevantOnCurrentDevice: Bool {
    switch self {
    case .refreshMacOS, .validateMacOS:
      #if os(macOS)
        return true
      #elseif os(Linux)
        return true  // Linux scripts use the macOS ones internally.
      #endif
    case .refreshLinux, .validateLinux:
      #if os(macOS)
        return false
      #elseif os(Linux)
        return true
      #endif
    }
  }

  internal var isCheckedIn: Bool {
    switch self {
    case .refreshMacOS, .refreshLinux:
      return true
    case .validateMacOS, .validateLinux:
      return false
    }
  }

  // MARK: - Source

  internal func shebang() -> StrictString {
    return "#!/bin/bash" + "\n\n"
  }

  private func stopOnFailure() -> StrictString {
    return "set \u{2D}e"
  }

  private func findRepository() -> StrictString {
    // “REPOSITORY=\u{22}$(pwd)\u{22}”
    // Does not work for double‐click on macOS, or as a command on macOS or Linux from a different directory.

    // “REPOSITORY=\u{22}${0%/*}\u{22}”
    // Does not work for double‐click on Linux or as a command on macOS or Linux from a different directory.

    return
      "REPOSITORY=\u{22}$( cd \u{22}$( dirname \u{22}${BASH_SOURCE[0]}\u{22} )\u{22} \u{26}& pwd )\u{22}"
  }

  private func enterRepository() -> StrictString {
    return "cd \u{22}${REPOSITORY}\u{22}"
  }

  private func openTerminal(andExecute script: StrictString) -> StrictString {
    return
      "gnome\u{2D}terminal \u{2D}e \u{22}bash \u{2D}\u{2D}login \u{2D}c \u{5C}\u{22}source ~/.bashrc; ./"
      + script + "\u{5C} \u{5C}(macOS\u{5C}).command; exec bash\u{5C}\u{22}\u{22}"
  }

  private func getWorkspace(
    andExecute command: StrictString,
    for project: PackageRepository,
    output: Command.Output
  ) throws -> [StrictString] {
    let command = command.appending(contentsOf: " $1 $2 $3 $4")

    if try project.isWorkspaceProject() {
      return ["swift run workspace " + command]
    } else {
      let version = StrictString(Metadata.latestStableVersion.string())
      let arguments: StrictString = command + " •use‐version " + version

      let macOSCachePath: StrictString = "~/Library/Caches/ca.solideogloria.Workspace/Versions/"
        + version + "/"
      let linuxCachePath: StrictString = "~/.cache/ca.solideogloria.Workspace/Versions/"
        + version + "/"

      return [
        "if workspace version > /dev/null 2>&1 ; then",
        "    echo \u{22}Using system install of Workspace...\u{22}",
        "    workspace \(arguments)",
        "elif \(macOSCachePath)workspace version > /dev/null 2>&1 ; then",
        "    echo \u{22}Using system cache of Workspace...\u{22}",
        "    \(macOSCachePath)workspace \(arguments)",
        "elif \(linuxCachePath)workspace version > /dev/null 2>&1 ; then",
        "    echo \u{22}Using system cache of Workspace...\u{22}",
        "    \(linuxCachePath)workspace \(arguments)",
        "elif \(PackageRepository.repositoryCachePath)/workspace version > /dev/null 2>&1 ; then",
        "    echo \u{22}Using repository cache of Workspace...\u{22}",
        "    \(PackageRepository.repositoryCachePath)/workspace \(arguments)",
        "else",
        "    echo \u{22}No cached build detected, fetching Workspace...\u{22}",
        "    export OVERRIDE_INSTALLATION_DIRECTORY=\(PackageRepository.repositoryCacheDirectory)",
        "    curl \u{2D}sL https://gist.github.com/SDGGiesbrecht/4d76ad2f2b9c7bf9072ca1da9815d7e2/raw/update.sh | bash \u{2D}s Workspace \u{22}https://github.com/SDGGiesbrecht/Workspace\u{22} 0.28.0 \u{22}\u{22} workspace",
        "    \(PackageRepository.repositoryCachePath)/workspace \(arguments)",
        "fi"
      ]
    }
  }

  internal func source(for project: PackageRepository, output: Command.Output) throws
    -> StrictString
  {
    var lines: [StrictString] = [
      stopOnFailure(),
      findRepository(),
      enterRepository()
    ]

    switch self {
    case .refreshLinux:
      lines.append(openTerminal(andExecute: "Refresh"))
    case .validateLinux:  // @exempt(from: tests)
      // @exempt(from: tests) Unreachable from macOS.
      lines.append(openTerminal(andExecute: "Validate"))
    case .refreshMacOS:
      lines.append(
        contentsOf: try getWorkspace(andExecute: "refresh", for: project, output: output)
      )
    case .validateMacOS:
      lines.append(
        contentsOf: try getWorkspace(andExecute: "validate", for: project, output: output)
      )
    }

    return StrictString(lines.joined(separator: "\n".scalars))
  }
}
