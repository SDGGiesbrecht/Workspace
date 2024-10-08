/*
 Script.swift

 This source file is part of the Workspace open source project.
 Diese Quelldatei ist Teil des quelloffenen Arbeitsbereich‐Projekt.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2017–2024 Jeremy David Giesbrecht and the Workspace project contributors.
 Urheberrecht ©2017–2024 Jeremy David Giesbrecht und die Mitwirkenden des Arbeitsbereich‐Projekts.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

#if !PLATFORM_NOT_SUPPORTED_BY_WORKSPACE_WORKSPACE
  import SDGLogic
  import SDGText
  import SDGLocalization

  import SDGCommandLine

  import SDGSwift

  import WorkspaceLocalizations
  import WorkspaceConfiguration
  import WorkspaceProjectConfiguration

  internal enum Script: Int, CaseIterable {

    // MARK: - Cases

    case refreshMacOS
    case refreshLinux
    case validateMacOS
    case validateLinux

    // MARK: - Properties

    internal func fileName(localization: InterfaceLocalization) -> StrictString {
      switch self {
      case .refreshMacOS:
        return RepositoryConfiguration._refreshScriptMacOSFileName(localization: localization)
      case .refreshLinux:
        return RepositoryConfiguration._refreshScriptLinuxFileName(localization: localization)
      case .validateMacOS:
        switch localization {
        case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
          return "Validate (macOS).command"
        case .deutschDeutschland:
          return "Prüfen (macOS).command"
        }
      case .validateLinux:
        switch localization {
        case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
          return "Validate (Linux).sh"
        case .deutschDeutschland:
          return "Prüfen (Linux).sh"
        }
      }
    }

    internal var isRelevantOnCurrentDevice: Bool {
      #if os(Windows) || os(WASI) || os(tvOS) || os(iOS) || os(Android) || os(watchOS)
        // #workaround(Swift 5.8.0, Until Workspace works on these platforms.)
        return false
      #else
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
      #endif
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

    private static let usingSystemInstall = UserFacing<StrictString, InterfaceLocalization>(
      { localization in
        switch localization {
        case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
          return "Using system install of Workspace..."
        case .deutschDeutschland:
          return "Systeminstallation von Arbeitsbereich wird verwendet ..."
        }
      })

    private static let usingSystemCache = UserFacing<StrictString, InterfaceLocalization>(
      { localization in
        switch localization {
        case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
          return "Using system cache of Workspace..."
        case .deutschDeutschland:
          return "Systemzwischenspeicher von Arbeitsbereich wird verwendet ..."
        }
      })

    private static let usingRepositoryCache = UserFacing<StrictString, InterfaceLocalization>(
      { localization in
        switch localization {
        case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
          return "Using repository cache of Workspace..."
        case .deutschDeutschland:
          return "Lagerzwischenspeicher von Arbeitsbereich wird verwendet ..."
        }
      })

    private static let fetching = UserFacing<StrictString, InterfaceLocalization>(
      { localization in
        switch localization {
        case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
          return "No cached build detected; fetching Workspace..."
        case .deutschDeutschland:
          return "Keinen Zwischenspeicher gefunden; Arbeitsbereich wird geholt ..."
        }
      })

    internal static func getWorkspace(
      andExecute command: StrictString,
      for project: PackageRepository,
      useSystemCache: Bool = true,
      forwardingArguments: Bool = true,
      output: Command.Output
    ) throws -> [StrictString] {
      var command = command
      if forwardingArguments {
        command.append(contentsOf: " $1 $2 $3 $4")
      }
      let localization = try project.configuration(output: output)
        .developmentInterfaceLocalization()

      if try project.isWorkspaceProject() {
        return ["swift run workspace " + command]
      } else {
        let version = StrictString(Metadata.latestStableVersion.string())
        let arguments: StrictString = command + " •use‐version " + version

        let macOSCachePath: StrictString =
          "~/Library/Caches/ca.solideogloria.Workspace/Versions/"
          + version + "/"
        let linuxCachePath: StrictString =
          "~/.cache/ca.solideogloria.Workspace/Versions/"
          + version + "/"

        var result: [StrictString] = [
          "if workspace version > /dev/null 2>&1 ; then",
          "    echo \u{22}\(usingSystemInstall.resolved(for: localization))\u{22}",
          "    workspace \(arguments)",
        ]
        if useSystemCache {
          result.append(contentsOf: [
            "elif \(macOSCachePath)workspace version > /dev/null 2>&1 ; then",
            "    echo \u{22}\(usingSystemCache.resolved(for: localization))\u{22}",
            "    \(macOSCachePath)workspace \(arguments)",
            "elif \(linuxCachePath)workspace version > /dev/null 2>&1 ; then",
            "    echo \u{22}\(usingSystemCache.resolved(for: localization))\u{22}",
            "    \(linuxCachePath)workspace \(arguments)",
          ])
        }
        result.append(contentsOf: [
          "elif \(PackageRepository.repositoryWorkspaceCacheDirectory)/workspace version > /dev/null 2>&1 ; then",
          "    echo \u{22}\(usingRepositoryCache.resolved(for: localization))\u{22}",
          "    \(PackageRepository.repositoryWorkspaceCacheDirectory)/workspace \(arguments)",
          "else",
          "    echo \u{22}\(fetching.resolved(for: localization))\u{22}",
          "    export OVERRIDE_INSTALLATION_DIRECTORY=\(PackageRepository.repositorySDGDirectory)",
          "    curl \u{2D}sL https://gist.github.com/SDGGiesbrecht/4d76ad2f2b9c7bf9072ca1da9815d7e2/raw/update.sh | bash \u{2D}s Workspace \u{22}https://github.com/SDGGiesbrecht/Workspace\u{22} \(version) \u{22}\u{22} workspace",
          "    \(PackageRepository.repositoryWorkspaceCacheDirectory)/workspace \(arguments)",
          "fi",
        ])
        return result
      }
    }

    internal func source(
      for project: PackageRepository,
      output: Command.Output
    ) throws -> StrictString {
      var lines: [StrictString] = [
        stopOnFailure(),
        findRepository(),
        enterRepository(),
      ]

      switch self {
      case .refreshLinux:
        lines.append(openTerminal(andExecute: "Refresh"))
      case .validateLinux:  // @exempt(from: tests)
        // @exempt(from: tests) Unreachable from macOS.
        lines.append(openTerminal(andExecute: "Validate"))
      case .refreshMacOS:
        lines.append(
          contentsOf: try Script.getWorkspace(andExecute: "refresh", for: project, output: output)
        )
      case .validateMacOS:
        lines.append(
          contentsOf: try Script.getWorkspace(
            andExecute: "validate",
            for: project,
            output: output
          )
        )
      }

      return lines.joined(separator: "\n")
    }
  }
#endif
