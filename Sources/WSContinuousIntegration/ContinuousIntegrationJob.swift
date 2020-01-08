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
import WSDocumentation

public enum ContinuousIntegrationJob: Int, CaseIterable {

  // MARK: - Cases

  case macOS
  case linux
  case iOS
  case watchOS
  case tvOS
  case miscellaneous
  case deployment

  public static let currentSwiftVersion = Version(5, 1, 2)
  public static let currentXcodeVersion = Version(11, 2, 0)

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
    case .linux:
      return UserFacing({ (localization) in
        switch localization {
        case .englishUnitedKingdom, .englishUnitedStates, .englishCanada,
          .deutschDeutschland:
          return "Linux"
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
    case .tvOS:
      return UserFacing({ (localization) in
        switch localization {
        case .englishUnitedKingdom, .englishUnitedStates, .englishCanada,
          .deutschDeutschland:
          return "tvOS"
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
    case .linux:
      return UserFacing({ (localization) in
        switch localization {
        case .englishUnitedKingdom, .englishUnitedStates, .englishCanada,
          .deutschDeutschland:
          return "linux"
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
    case .tvOS:
      return UserFacing({ (localization) in
        switch localization {
        case .englishUnitedKingdom, .englishUnitedStates, .englishCanada,
          .deutschDeutschland:
          return "tvos"
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
    case .linux:
      return try .linux ∈ project.configuration(output: output).supportedPlatforms
    case .iOS:
      return try .iOS ∈ project.configuration(output: output).supportedPlatforms
    case .watchOS:
      return try .watchOS ∈ project.configuration(output: output).supportedPlatforms
    case .tvOS:
      return try .tvOS ∈ project.configuration(output: output).supportedPlatforms
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
    case .macOS, .iOS, .watchOS, .tvOS:
      return .macOS
    case .linux, .miscellaneous, .deployment:
      return .linux
    }
  }

  // MARK: - Shared

  private var refreshCommand: String {
    return "\u{27}./Refresh (macOS).command\u{27}"
  }
  private var validateCommand: String {
    return "\u{27}./Validate (macOS).command\u{27} •job "
      + String(argumentName.resolved(for: .englishCanada))
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
    case .linux:
      return "ubuntu\u{2D}18.04"
    case .iOS, .watchOS, .tvOS:
      unreachable()
    }
  }

  private var dockerImage: String? {
    switch platform {
    case .macOS, .iOS, .watchOS, .tvOS:
      return nil
    case .linux:
      let version = ContinuousIntegrationJob.currentSwiftVersion.string(droppingEmptyPatch: true)
      return "swift:\(version)\u{2D}bionic"
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

    func cacheEntry(os: String, path: String) -> [String] {
      return [
        "        key: \(os)‐${{ hashFiles(\u{27}Refresh*\u{27}) }}‐${{ hashFiles(\u{27}.github/workflows/**\u{27}) }}",
        "        path: ~/\(path)"
      ]
    }
    switch platform {
    case .macOS:
      result.append(contentsOf: cacheEntry(os: "macOS", path: PackageRepository.macOSCachePath))
    case .linux:
      result.append(contentsOf: cacheEntry(os: "Linux", path: PackageRepository.linuxCachePath))
    case .iOS, .watchOS, .tvOS:
      unreachable()
    }

    func commandEntry(_ command: String) -> String {
      return "        \(escapeCommand(command))"
    }

    let xcodeVersion = ContinuousIntegrationJob.currentXcodeVersion.string(droppingEmptyPatch: true)
    result.append(contentsOf: [
      "    \u{2D} name: \(validateStepName.resolved(for: interfaceLocalization))",
      "      run: |",
    ])

    switch platform {
    case .macOS:
      result.append(contentsOf: [
        commandEntry("xcversion install \(xcodeVersion)"),
        commandEntry("xcversion select \(xcodeVersion)")
      ])
    case .linux:
      result.append(contentsOf: [
        commandEntry("apt\u{2D}get update"),
        commandEntry(
          "apt\u{2D}get install \u{2D}\u{2D}assume\u{2D}yes libsqlite3\u{2D}dev libncurses\u{2D}dev"
        ),
      ])
    case .iOS, .watchOS, .tvOS:
      unreachable()
    }

    result.append(contentsOf: [
      commandEntry(refreshCommand),
      commandEntry(validateCommand)
    ])

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
      case .macOS, .linux, .iOS, .watchOS, .tvOS, .miscellaneous:
        return true
      case .deployment:
        return false
      }
    case .some(let currentJob):
      return currentJob == job
    }
  }
}
