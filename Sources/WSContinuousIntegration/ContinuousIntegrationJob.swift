/*
 ContinuousIntegrationJob.swift

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
import SDGCollections
import WSGeneralImports

import WSProject
import WSScripts
import WSDocumentation

public enum ContinuousIntegrationJob: Int, CaseIterable {

  // MARK: - Cases

  case macOS
  case windows
  case linux
  case tvOS
  case iOS
  case watchOS
  case miscellaneous
  case deployment

  public static let currentSwiftVersion = Version(5, 1, 3)
  public static let currentXcodeVersion = Version(11, 3, 0)

  #warning("Make dependent on repository cache path.")
  private static let experimentalDirectory = ".build/Windows"

  public static let simulatorJobs: Set<ContinuousIntegrationJob> = [
    .iOS,
    .tvOS
  ]

  // MARK: - Properties

  internal var name: UserFacing<StrictString, InterfaceLocalization> {
    switch self {
    case .macOS:
      return UserFacing({ (localization) in
        switch localization {
        case .englishUnitedKingdom, .englishUnitedStates, .englishCanada,
          .deutschDeutschland:
          return "macOS"
        }
      })
    case .windows:
      return UserFacing({ (localization) in
        switch localization {
        case .englishUnitedKingdom, .englishUnitedStates, .englishCanada,
          .deutschDeutschland:
          return "Windows"
        }
      })
    case .linux:
      return UserFacing({ (localization) in
        switch localization {
        case .englishUnitedKingdom, .englishUnitedStates, .englishCanada,
          .deutschDeutschland:
          return "Linux"
        }
      })
    case .tvOS:
      return UserFacing({ (localization) in
        switch localization {
        case .englishUnitedKingdom, .englishUnitedStates, .englishCanada,
          .deutschDeutschland:
          return "tvOS"
        }
      })
    case .iOS:
      return UserFacing({ (localization) in
        switch localization {
        case .englishUnitedKingdom, .englishUnitedStates, .englishCanada,
          .deutschDeutschland:
          return "iOS"
        }
      })
    case .watchOS:
      return UserFacing({ (localization) in
        switch localization {
        case .englishUnitedKingdom, .englishUnitedStates, .englishCanada,
          .deutschDeutschland:
          return "watchOS"
        }
      })
    case .miscellaneous:
      return UserFacing({ (localization) in
        switch localization {
        case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
          return "Miscellaneous"
        case .deutschDeutschland:
          return "Sonstiges"
        }
      })
    case .deployment:
      return UserFacing({ (localization) in
        switch localization {
        case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
          return "Deployment"
        case .deutschDeutschland:
          return "Verteilung"
        }
      })
    }
  }

  public var argumentName: UserFacing<StrictString, InterfaceLocalization> {
    switch self {
    case .macOS:
      return UserFacing({ (localization) in
        switch localization {
        case .englishUnitedKingdom, .englishUnitedStates, .englishCanada,
          .deutschDeutschland:
          return "macos"
        }
      })
    case .windows:
      return UserFacing({ (localization) in
        switch localization {
        case .englishUnitedKingdom, .englishUnitedStates, .englishCanada,
          .deutschDeutschland:
          return "windows"
        }
      })
    case .linux:
      return UserFacing({ (localization) in
        switch localization {
        case .englishUnitedKingdom, .englishUnitedStates, .englishCanada,
          .deutschDeutschland:
          return "linux"
        }
      })
    case .tvOS:
      return UserFacing({ (localization) in
        switch localization {
        case .englishUnitedKingdom, .englishUnitedStates, .englishCanada,
          .deutschDeutschland:
          return "tvos"
        }
      })
    case .iOS:
      return UserFacing({ (localization) in
        switch localization {
        case .englishUnitedKingdom, .englishUnitedStates, .englishCanada,
          .deutschDeutschland:
          return "ios"
        }
      })
    case .watchOS:
      return UserFacing({ (localization) in
        switch localization {
        case .englishUnitedKingdom, .englishUnitedStates, .englishCanada,
          .deutschDeutschland:
          return "watchos"
        }
      })
    case .miscellaneous:
      return UserFacing({ (localization) in
        switch localization {
        case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
          return "miscellaneous"
        case .deutschDeutschland:
          return "sonstiges"
        }
      })
    case .deployment:
      return UserFacing({ (localization) in
        switch localization {
        case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
          return "deployment"
        case .deutschDeutschland:
          return "verteilung"
        }
      })
    }
  }

  public func isRequired(by project: PackageRepository, output: Command.Output) throws -> Bool {
    switch self {
    case .macOS:
      return try .macOS ∈ project.configuration(output: output).supportedPlatforms
    case .windows:
      return try .windows ∈ project.configuration(output: output).supportedPlatforms
    case .linux:
      return try .linux ∈ project.configuration(output: output).supportedPlatforms
    case .tvOS:
      return try .tvOS ∈ project.configuration(output: output).supportedPlatforms
    case .iOS:
      return try .iOS ∈ project.configuration(output: output).supportedPlatforms
    case .watchOS:
      return try .watchOS ∈ project.configuration(output: output).supportedPlatforms
    case .miscellaneous:
      return true
    case .deployment:
      return try project.configuration(output: output).documentation.api.generate
        ∧ project.hasTargetsToDocument()
        ∧ (
          try project.configuration(output: output)
            .documentation.api.serveFromGitHubPagesBranch
        )
    }
  }

  public var platform: Platform {
    switch self {
    case .macOS, .tvOS, .iOS, .watchOS:
      return .macOS
    case .windows:
      return .windows
    case .linux, .miscellaneous, .deployment:
      return .linux
    }
  }

  // MARK: - Shared

  private func appendLanguage(to command: String, configuration: WorkspaceConfiguration) -> String {
    var command = command
    let languages = configuration.documentation.localisations
    if ¬languages.isEmpty {
      let argument = StrictString(languages.lazy.map({ $0._iconOrCode }).joined(separator: ";"))
      command.append(contentsOf: " •language \u{27}\(argument)\u{27}")
    }
    return command
  }
  private func refreshCommand(configuration: WorkspaceConfiguration) -> String {
    return appendLanguage(to: "\u{27}./Refresh (macOS).command\u{27}", configuration: configuration)
  }
  private func validateCommand(configuration: WorkspaceConfiguration) -> String {
    return appendLanguage(
      to:
        "\u{27}./Validate (macOS).command\u{27} •job \(argumentName.resolved(for: .englishCanada))",
      configuration: configuration
    )
  }

  func escapeCommand(_ command: String) -> String {
    var escapedCommand = command.replacingOccurrences(of: "\u{5C}", with: "\u{5C}\u{5C}")
    escapedCommand = escapedCommand.replacingOccurrences(of: "\u{22}", with: "\u{5C}\u{22}")
    return escapedCommand
  }

  // MARK: - GitHub Actions

  private var gitHubActionMachine: String {
    switch platform {
    case .macOS:
      // #workaround(workspace version 0.28.0, GitHub doesn’t provide version specificity.)
      return "macos\u{2D}latest"
    case .windows:
      // #workaround(workspace version 0.28.0, GitHub doesn’t provide version specificity.)
      return "windows\u{2D}latest"
    case .linux:
      return "ubuntu\u{2D}18.04"
    case .tvOS, .iOS, .watchOS:
      unreachable()
    }
  }

  private var dockerImage: String? {
    switch platform {
    case .macOS, .windows:
      return nil
    case .linux:
      let version = ContinuousIntegrationJob.currentSwiftVersion.string(droppingEmptyPatch: true)
      return "swift:\(version)\u{2D}bionic"
    case .tvOS, .iOS, .watchOS:
      unreachable()
    }
  }

  private var validateStepName: UserFacing<StrictString, InterfaceLocalization> {
    return UserFacing({ (localization) in
      switch localization {
      case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
        return "Validate"
      case .deutschDeutschland:
        return "Prüfen"
      }
    })
  }

  private var deployStepName: UserFacing<StrictString, InterfaceLocalization> {
    return UserFacing({ (localization) in
      switch localization {
      case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
        return "Deploy"
      case .deutschDeutschland:
        return "Verteilen"
      }
    })
  }

  private var deployCommitMessage: UserFacing<StrictString, InterfaceLocalization> {
    return UserFacing({ (localization) in
      switch localization {
      case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
        return "Generated documentation for ${GITHUB_SHA}."
      case .deutschDeutschland:
        return "Erstellte Dokumentation für ${GITHUB_SHA}."
      }
    })
  }

  internal func gitHubWorkflowJob(configuration: WorkspaceConfiguration) -> [String] {
    let interfaceLocalization = configuration.developmentInterfaceLocalization()

    var result: [String] = [
      "  \(name.resolved(for: interfaceLocalization)):",
      "    runs\u{2D}on: \(gitHubActionMachine)",
    ]
    if let container = dockerImage {
      result += [
        "    container: \(container)"
      ]
    }
    result += [
      "    steps:",
      "    \u{2D} uses: actions/checkout@v1",
      "    \u{2D} uses: actions/cache@v1",
      "      with:",
    ]

    func cacheEntry(os: String) -> [String] {
      return [
        "        key: \(os)‐${{ hashFiles(\u{27}Refresh*\u{27}) }}‐${{ hashFiles(\u{27}.github/workflows/**\u{27}) }}",
        "        path: \(PackageRepository.repositoryCachePath)"
      ]
    }
    switch platform {
    case .macOS:
      result.append(contentsOf: cacheEntry(os: "macOS"))
    case .windows:
      result.append(contentsOf: cacheEntry(os: "Windows"))
    case .linux:
      result.append(contentsOf: cacheEntry(os: "Linux"))
    case .tvOS, .iOS, .watchOS:
      unreachable()
    }

    func commandEntry(_ command: String, escaping: Bool = true) -> String {
      let result = escaping ? escapeCommand(command) : command
      return "        \(result)"
    }

    let xcodeVersion = ContinuousIntegrationJob.currentXcodeVersion.string(droppingEmptyPatch: true)
    result.append("    \u{2D} name: \(validateStepName.resolved(for: interfaceLocalization))")

    switch platform {
    case .macOS, .linux, .tvOS, .iOS, .watchOS:
      break
    case .windows:
      result.append("      shell: bash")
    }

    result.append("      run: |")

    switch platform {
    case .macOS:
      result.append(contentsOf: [
        commandEntry("xcversion install \(xcodeVersion)"),
        commandEntry("xcversion select \(xcodeVersion)")
      ])
    case .windows:
      let experimentalDirectory = ContinuousIntegrationJob.experimentalDirectory
      result.append(contentsOf: [
        commandEntry("repository_directory=$(pwd)"),
        commandEntry(
          "cd \u{27}/c/Program Files (x86)/Microsoft Visual Studio/2019/Enterprise/VC/Auxiliary/Build\u{27}"
        ),
        commandEntry("echo \u{27}export \u{2D}p > exported_environment.sh\u{27} > nested_bash.sh"),
        commandEntry(
          "echo \u{27}vcvarsall.bat x64 &\u{26} \u{22}C:/Program Files/Git/usr/bin/bash\u{22} \u{2D}c ./nested_bash.sh\u{27} > export_environment.bat",
          escaping: false
        ),
        commandEntry("cmd \u{22}/c export_environment.bat\u{22}", escaping: false),
        commandEntry("source ./exported_environment.sh"),
        commandEntry(
          "if [ \u{2D}z \u{22}$INCLUDE\u{22} ]; then echo \u{27}Failed to set up Visual Studio.\u{27}; exit 1; fi",
          escaping: false
        ),
        commandEntry("cd \u{22}${repository_directory}\u{22}", escaping: false),
        commandEntry("mkdir \u{2D}p '\(experimentalDirectory)'"),
        commandEntry("cd \u{27}\(experimentalDirectory)\u{27}"),
        commandEntry(
          "curl \u{2D}o swift\u{2D}build.py 'https://raw.githubusercontent.com/compnerd/swift\u{2D}build/master/utilities/swift-build.py'"
        ),
        commandEntry("python \u{2D}m pip install \u{2D}\u{2D}user azure\u{2D}devops tabulate"),
        commandEntry(
          "echo \u{27}Fetching Swift... (This is could to take up to 10 minutes.)\u{27}"
        ),
        commandEntry(
          "python swift\u{2D}build.py \u{2D}\u{2D}build\u{2D}id \u{27}VS2019 Swift 5.2\u{27} \u{2D}\u{2D}latest-artifacts \u{2D}\u{2D}filter windows-x64 \u{2D}\u{2D}download > /dev/null"
        ),
        commandEntry("7z x toolchain\u{2D}windows\u{2D}x64.zip"),
        commandEntry("7z x sdk\u{2D}windows\u{2D}x64.zip"),
        commandEntry("cd \u{22}${repository_directory}\u{22}", escaping: false),
        commandEntry(
          "\u{27}\(experimentalDirectory)/toolchain\u{2D}windows\u{2D}x64/Library/Developer/Toolchains/unknown\u{2D}Asserts\u{2D}development.xctoolchain/usr/bin/swift.exe\u{27} \u{2D}\u{2D}version"
        )
      ])
    case .linux:
      result.append(contentsOf: [
        commandEntry("apt\u{2D}get update"),
        commandEntry(
          "apt\u{2D}get install \u{2D}\u{2D}assume\u{2D}yes curl libsqlite3\u{2D}dev libncurses\u{2D}dev"
        ),
      ])
    case .tvOS, .iOS, .watchOS:
      unreachable()
    }

    switch platform {
    case .macOS, .linux, .iOS, .watchOS, .tvOS:
      result.append(contentsOf: [
        commandEntry(refreshCommand(configuration: configuration)),
        commandEntry(validateCommand(configuration: configuration))
      ])
    case .windows:
      result.append(contentsOf: [
        commandEntry("echo \u{22}Checkout succeeded.\u{22}", escaping: false)
      ])
    }

    switch platform {
    case .macOS, .windows, .tvOS, .iOS, .watchOS:
      break
    case .linux:
      result.append(commandEntry("chmod \u{2D}R a+rwx ."))
    }

    if self == .deployment {
      result.append(contentsOf: [
        "    \u{2D} name: \(deployStepName.resolved(for: interfaceLocalization))",
        "      run: |",
        "        cd docs",
        "        git init",
        "        git config user.name \u{22}${GITHUB_ACTOR}\u{22}",
        "        git config user.email \u{22}${GITHUB_ACTOR}@users.noreply.github.com\u{22}",
        "        git add .",
        "        git commit \u{2D}m \u{22}\(deployCommitMessage.resolved(for: interfaceLocalization))\u{22}",
        "        git push \u{2D}\u{2D}force https://x\u{2D}access\u{2D}token:${GITHUB_TOKEN}@github.com/${GITHUB_REPOSITORY}.git master:gh\u{2D}pages",
        "      env:",
        "        GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}"
      ])
    }

    return result
  }
}

extension Optional where Wrapped == ContinuousIntegrationJob {

  public func includes(job: ContinuousIntegrationJob) -> Bool {
    switch self {
    case .none:
      switch job {
      case .macOS, .windows, .linux, .tvOS, .iOS, .watchOS, .miscellaneous:
        return true
      case .deployment:
        return false
      }
    case .some(let currentJob):
      return currentJob == job
    }
  }
}
