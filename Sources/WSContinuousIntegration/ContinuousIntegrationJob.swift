/*
 ContinuousIntegrationJob.swift

 This source file is part of the Workspace open source project.
 Diese Quelldatei ist Teil des qeulloffenen Arbeitsbereich‐Projekt.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2017–2019 Jeremy David Giesbrecht and the Workspace project contributors.
 Urheberrecht ©2017–2019 Jeremy David Giesbrecht und die Mitwirkenden des Arbeitsbereich‐Projekts.

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
          try project.configuration(output: output).documentation.api
            .encryptedTravisCIDeploymentKey
        ) ≠ nil
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

  private var swiftVersionSelection: String {
    return "export SWIFT_VERSION=5.1.2"
  }
  private var swiftVersionFetch: String {
    return
      "eval \u{22}$(curl \u{2D}sL https://swiftenv.fuller.li/install.sh)\u{22}"
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
      // #workaround(workspace version 0.27.0, GitHub doesn’t provide version specificity.)
      return "macos\u{2D}latest"
    case .linux:
      return "ubuntu\u{2D}18.04"
    case .iOS, .watchOS, .tvOS:
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

  internal func gitHubWorkflowJob(configuration: WorkspaceConfiguration) -> [String] {
    let interfaceLocalization = configuration.developmentInterfaceLocalization()

    #warning("Fill in other nuances from Travis CI.")
    var result: [String] = [
      "  \(name.resolved(for: interfaceLocalization)):",
      "    runs\u{2D}on: \(gitHubActionMachine)",
      "    steps:",
      "    \u{2D} uses: actions/checkout@v1"
    ]

    func commandEntry(_ command: String, escaping: Bool = true) -> String {
      let processed = escaping ? escapeCommand(command) : command
      return "        \(processed)"
    }

    result.append(contentsOf: [
      "    \u{2D} name: \(validateStepName.resolved(for: interfaceLocalization))",
      "      run: |",
      commandEntry(swiftVersionSelection),
      commandEntry(swiftVersionFetch, escaping: false),
      commandEntry("\u{27}./Refresh (macOS).command\u{27}"),
      commandEntry(
        "\u{27}./Validate (macOS).command\u{27} •job "
          + String(argumentName.resolved(for: .englishCanada))
      )
    ])

    return result
  }

  // MARK: - Travis CI

  private var travisOperatingSystemKey: String {
    switch platform {
    case .macOS:
      return "osx"
    case .linux:
      return "linux"
    case .iOS, .watchOS, .tvOS:
      unreachable()
    }
  }

  private var travisSDKKey: String? {
    switch self {
    case .macOS, .linux, .watchOS, .miscellaneous, .deployment:
      return nil
    case .iOS:
      return "iphonesimulator"
    case .tvOS:
      return "appletvsimulator"
    }
  }

  internal func travisScript(configuration: WorkspaceConfiguration) throws -> [String] {
    let localization = configuration.developmentInterfaceLocalization()
    var result: [String] = [
      "    \u{2D} name: \u{22}" + String(name.resolved(for: localization)) + "\u{22}",
      "      os: " + travisOperatingSystemKey
    ]
    if self == .deployment {
      guard let key = configuration.documentation.api.encryptedTravisCIDeploymentKey else {
        unreachable()
      }

      result.append(contentsOf: [
        "      env:",
        "        \u{2D} secure: \u{22}" + key + "\u{22}",
        "      if: branch = master and (not type = pull_request)",
        "",
        "      deploy:",
        "        provider: pages",
        "        local_dir: " + PackageRepository.documentationDirectoryName,
        "        github_token: $GITHUB_TOKEN",
        "        skip_cleanup: true"
      ])
    }

    switch platform {
    case .macOS:
      result.append("      osx_image: xcode11.2")
    case .linux:
      result.append("      dist: bionic")
    case .iOS, .watchOS, .tvOS:
      unreachable()
    }

    if let sdk = travisSDKKey {
      result.append(contentsOf: [
        "      language: objective\u{2D}c",
        "      xcode_sdk: " + sdk
      ])
    }

    result.append("      script:")

    func commandEntry(_ command: String) -> String {
      return "        \u{2D} \u{22}\(escapeCommand(command))\u{22}"
    }

    if platform == .macOS {
      result.append(contentsOf: [
        commandEntry("git config \u{2D}\u{2D}global protocol.version 1")
      ])
    }

    if platform == .linux {
      result.append(contentsOf: [
        commandEntry(swiftVersionSelection),
        commandEntry(swiftVersionFetch)
      ])
    }

    #warning("Is bash necessary? Can these be merged with GitHub actions?")
    result.append(contentsOf: [
      commandEntry("bash \u{22}./Refresh (macOS).command\u{22}"),
      commandEntry(
        "bash \u{22}./Validate (macOS).command\u{22} •job "
          + String(argumentName.resolved(for: .englishCanada))
      )
    ])

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
