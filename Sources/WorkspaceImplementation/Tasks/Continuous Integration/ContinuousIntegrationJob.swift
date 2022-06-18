/*
 ContinuousIntegrationJob.swift

 This source file is part of the Workspace open source project.
 Diese Quelldatei ist Teil des quelloffenen Arbeitsbereich‐Projekt.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2017–2022 Jeremy David Giesbrecht and the Workspace project contributors.
 Urheberrecht ©2017–2022 Jeremy David Giesbrecht und die Mitwirkenden des Arbeitsbereich‐Projekts.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

#if !PLATFORM_NOT_SUPPORTED_BY_WORKSPACE_WORKSPACE
  import SDGLogic
  import SDGCollections

  import SDGCommandLine

  import SDGSwift

  import WorkspaceLocalizations
  import WorkspaceConfiguration

  internal enum ContinuousIntegrationJob: Int, CaseIterable {

    // MARK: - Cases

    case macOS
    case windows
    case web
    case ubuntu
    case tvOS
    case iOS
    case android
    case amazonLinux
    case watchOS
    case miscellaneous
    case deployment

    internal static let currentSwiftVersion = Version(5, 6, 0)

    private static let currentMacOSVersion = Version(12)
    internal static let currentXcodeVersion = Version(13, 4)
    private static let currentVisualStudioVersion = "2019"
    private static let currentCartonVersion = Version(0, 16, 0)
    private static let currentUbuntuName = "focal"  // Used by Docker image
    private static let currentUbuntuVersion = "20.04"  // Used by GitHub host
    private static let currentAnroidNDKVersion = "23b"
    private static let currentAmazonLinuxVerison = "2"

    internal static let simulatorJobs: Set<ContinuousIntegrationJob> = [
      .iOS,
      .tvOS,
      .watchOS,
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
      case .web:
        return UserFacing({ (localization) in
          switch localization {
          case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
            return "Web"
          case .deutschDeutschland:
            return "Netz"
          }
        })
      case .ubuntu:
        return UserFacing({ (localization) in
          switch localization {
          case .englishUnitedKingdom, .englishUnitedStates, .englishCanada,
            .deutschDeutschland:
            return "Ubuntu"
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
      case .android:
        return UserFacing({ (localization) in
          switch localization {
          case .englishUnitedKingdom, .englishUnitedStates, .englishCanada,
            .deutschDeutschland:
            return "Android"
          }
        })
      case .amazonLinux:
        return UserFacing({ (localization) in
          switch localization {
          case .englishUnitedKingdom, .englishUnitedStates, .englishCanada,
            .deutschDeutschland:
            return "Amazon Linux"
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
    private var androidIIJobName: UserFacing<StrictString, InterfaceLocalization> {
      return UserFacing({ (localization) in
        switch localization {
        case .englishUnitedKingdom, .englishUnitedStates, .englishCanada,
          .deutschDeutschland:
          return "Android II"
        }
      })
    }

    internal var argumentName: UserFacing<StrictString, InterfaceLocalization> {
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
      case .web:
        return UserFacing({ (localization) in
          switch localization {
          case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
            return "web"
          case .deutschDeutschland:
            return "netz"
          }
        })
      case .ubuntu:
        return UserFacing({ (localization) in
          switch localization {
          case .englishUnitedKingdom, .englishUnitedStates, .englishCanada,
            .deutschDeutschland:
            return "ubuntu"
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
      case .android:
        return UserFacing({ (localization) in
          switch localization {
          case .englishUnitedKingdom, .englishUnitedStates, .englishCanada,
            .deutschDeutschland:
            return "android"
          }
        })
      case .amazonLinux:
        return UserFacing({ (localization) in
          switch localization {
          case .englishUnitedKingdom, .englishUnitedStates, .englishCanada,
            .deutschDeutschland:
            return "amazon‐linux"
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

    private var environmentVariableName: StrictString {
      switch self {
      case .macOS:  // @exempt(from: tests) Unreachable from Linux.
        return "MACOS"
      case .windows:
        return "WINDOWS"
      case .web:
        return "WEB"
      case .ubuntu:  // @exempt(from: tests) Unreachable from macOS.
        return "UBUNTU"
      case .tvOS:  // @exempt(from: tests) Unreachable from Linux.
        return "TVOS"
      case .iOS:  // @exempt(from: tests) Unreachable from Linux.
        return "IOS"
      case .android:
        return "ANDROID"
      case .amazonLinux:  // @exempt(from: tests) Unreachable from macOS.
        return "AMAZON_LINUX"
      case .watchOS:  // @exempt(from: tests) Unreachable from Linux.
        return "WATCHOS"
      case .miscellaneous, .deployment:
        unreachable()
      }
    }
    internal var environmentVariable: StrictString {
      return "TARGETING_\(environmentVariableName)"
    }

    internal func isRequired(by project: PackageRepository, output: Command.Output) throws -> Bool {
      if try project.isWorkspaceProject() {
        return true  // So that handling of cross‐compilation platforms is properly tested.
      }

      switch self {
      case .macOS:
        return try .macOS ∈ project.configuration(output: output).supportedPlatforms
      case .windows:
        return try .windows ∈ project.configuration(output: output).supportedPlatforms
      case .web:
        return try .web ∈ project.configuration(output: output).supportedPlatforms
      case .ubuntu:
        return try .ubuntu ∈ project.configuration(output: output).supportedPlatforms
      case .tvOS:
        return try .tvOS ∈ project.configuration(output: output).supportedPlatforms
      case .iOS:
        return try .iOS ∈ project.configuration(output: output).supportedPlatforms
      case .android:
        return try .android ∈ project.configuration(output: output).supportedPlatforms
      case .watchOS:
        return try .watchOS ∈ project.configuration(output: output).supportedPlatforms
      case .amazonLinux:
        return try .amazonLinux ∈ project.configuration(output: output).supportedPlatforms
      case .miscellaneous:
        return true
      case .deployment:
        let shouldGenerate = try project.configuration(output: output).documentation.api.generate
        let hasTargets = try project.hasTargetsToDocument()
        let served = try project.configuration(output: output)
          .documentation.api.serveFromGitHubPagesBranch
        return shouldGenerate ∧ hasTargets ∧ served
      }
    }

    internal var platform: Platform {
      switch self {
      case .macOS, .tvOS, .iOS, .watchOS:
        return .macOS
      case .windows:
        return .windows
      case .web:
        return .web
      case .ubuntu, .miscellaneous, .deployment:
        return .ubuntu
      case .android:
        return .android
      case .amazonLinux:
        return .amazonLinux
      }
    }

    // MARK: - Shared

    private func appendLanguage(
      to command: StrictString,
      configuration: WorkspaceConfiguration
    ) -> StrictString {
      var command = command
      let languages = configuration.documentation.localisations
      if ¬languages.isEmpty {
        let argument = languages.lazy.map({ $0._iconOrCode }).joined(separator: ";")
        command.append(contentsOf: " •language \u{27}\(argument)\u{27}")
      }
      return command
    }

    private func workspaceStep(
      named name: UserFacing<StrictString, InterfaceLocalization>,
      command: StrictString,
      localization: InterfaceLocalization,
      configuration: WorkspaceConfiguration,
      project: PackageRepository,
      output: Command.Output
    ) throws -> StrictString {
      return script(
        heading: name,
        localization: localization,
        commands: try Script.getWorkspace(
          andExecute: appendLanguage(to: command, configuration: configuration),
          for: project,
          useSystemCache: false,
          forwardingArguments: false,
          output: output
        )
      )
    }

    // MARK: - GitHub Actions

    private var gitHubActionMachine: StrictString {
      switch platform {
      case .macOS:
        return
          "macos\u{2D}\(ContinuousIntegrationJob.currentMacOSVersion.stringDroppingEmptyMinor())"
      case .windows:
        return "windows\u{2D}\(ContinuousIntegrationJob.currentVisualStudioVersion)"
      case .web, .ubuntu, .android, .amazonLinux:
        return "ubuntu\u{2D}\(ContinuousIntegrationJob.currentUbuntuVersion)"
      case .tvOS, .iOS, .watchOS:
        unreachable()
      }
    }

    private var dockerImage: StrictString? {
      switch platform {
      case .macOS, .windows, .android:
        return nil
      case .web:
        let version = ContinuousIntegrationJob.currentCartonVersion.string()
        return "ghcr.io/swiftwasm/carton:\(version)"
      case .ubuntu:
        let version = ContinuousIntegrationJob.currentSwiftVersion.string()
        return "swift:\(version)\u{2D}\(ContinuousIntegrationJob.currentUbuntuName)"
      case .tvOS, .iOS, .watchOS:
        unreachable()
      case .amazonLinux:
        let version = ContinuousIntegrationJob.currentSwiftVersion.string()
        return
          "swift:\(version)\u{2D}amazonlinux\(ContinuousIntegrationJob.currentAmazonLinuxVerison)"
      }
    }

    private func runsOn(_ machine: StrictString) -> StrictString {
      return "    runs\u{2D}on: \(machine)"
    }

    private func steps() -> StrictString {
      return "    steps:"
    }

    private func step(
      _ name: UserFacing<StrictString, InterfaceLocalization>,
      localization: InterfaceLocalization
    ) -> StrictString {
      return "    \u{2D} name: \(name.resolved(for: localization))"
    }

    private func uses(
      _ action: StrictString,
      with: [StrictString: StrictString] = [:]
    ) -> StrictString {
      var result: [StrictString] = ["      uses: \(action)"]
      if ¬with.isEmpty {
        result.append("      with:")
        for (key, value) in with.sorted(by: { $0.0 < $1.0 }) {
          result.append("        \(key): \(value)")
        }
      }
      return result.joinedAsLines()
    }

    private func checkOut() -> StrictString {
      return uses("actions/checkout@v2")
    }

    private func cache() -> StrictString {
      let environment: StrictString
      switch platform {
      case .macOS:
        environment = "macOS"
      case .windows:
        environment = "Windows"
      case .web:
        environment = "Web"
      case .ubuntu:
        environment = "Ubuntu"
      case .tvOS, .iOS, .watchOS:
        unreachable()
      case .android:
        environment = "Android"
      case .amazonLinux:
        environment = "Amazon‐Linux"
      }
      return uses(
        "actions/cache@v2",
        with: [
          "key":
            "\(environment)‐${{ hashFiles(\u{27}.github/workflows/**\u{27}) }}",
          "path": PackageRepository.repositoryWorkspaceCacheDirectory,
        ]
      )
    }

    private func script(
      heading: UserFacing<StrictString, InterfaceLocalization>,
      localization: InterfaceLocalization,
      shell: StrictString = "bash",
      commands: [StrictString]
    ) -> StrictString {
      var result: [StrictString] = [
        step(heading, localization: localization),
        "      shell: \(shell)",
        "      run: |",
      ]
      var commands = commands
      switch shell {
      case "bash":
        commands.prepend("set \u{2D}x")
      case "cmd":
        commands.prepend("echo on")
      default:
        unreachable()
      }
      result.append(
        contentsOf: commands.joinedAsLines()
          .lines.map({ "        \(StrictString($0.line))" })
      )
      return result.joinedAsLines()
    }

    private func yumInstallation(
      _ packages: [StrictString]
    ) -> StrictString {
      var installLines: [StrictString] = []
      installLines.append(contentsOf: [
        "yum install \u{2D}\u{2D}assumeyes \u{5C}"
      ])
      let sorted = packages.sorted()
      installLines.append(
        contentsOf: sorted.indices.map { index in
          let package = sorted[index]
          var entry: StrictString = "  \(package)"
          if index ≠ sorted.indices.last {
            entry.append(contentsOf: " \u{5C}")
          }
          return entry
        }
      )
      return installLines.joinedAsLines()
    }

    private func aptGet(_ packages: [StrictString]) -> StrictString {
      let update: StrictString = "apt\u{2D}get update \u{2D}\u{2D}assume\u{2D}yes"
      var installLines: [StrictString] = [
        "UCF_FORCE_CONFOLD=1 DEBIAN_FRONTEND=noninteractive \u{5C}",
        "apt\u{2D}get \u{2D}o Dpkg::Options::=\u{22}\u{2D}\u{2D}force\u{2D}confdef\u{22} \u{2D}o Dpkg::Options::=\u{22}\u{2D}\u{2D}force\u{2D}confold\u{22} \u{5C}",
        "  install \u{2D}\u{2D}assume\u{2D}yes \u{5C}",
      ]
      let sorted = packages.sorted()
      installLines.append(
        contentsOf: sorted.indices.map { index in
          let package = sorted[index]
          var entry: StrictString = "    \(package)"
          if index ≠ sorted.indices.last {
            entry.append(contentsOf: " \u{5C}")
          }
          return entry
        }
      )
      let install = installLines.joinedAsLines()
      return [update, install].joinedAsLines()
    }

    private func cURL(
      from origin: StrictString,
      to destination: StrictString
    ) -> StrictString {
      let continuation = "\u{5C}"
      let quotation = "\u{27}"
      return [
        "curl \(continuation)",
        "  \(quotation)\(origin)\(quotation) \(continuation)",
        "  \u{2D}\u{2D}output \(quotation)\(destination)\(quotation) \(continuation)",
        "  \u{2D}\u{2D}location",
      ].joinedAsLines()
    }

    private func makeDirectory(_ directory: StrictString, sudo: Bool = false) -> StrictString {
      return "\(sudo ? "sudo " : "")mkdir \u{2D}p \(directory)"
    }
    private func copyFiles(
      from origin: StrictString,
      to destination: StrictString,
      sudo: Bool = false
    ) -> StrictString {
      let result: [StrictString] = [
        makeDirectory(destination, sudo: sudo),
        "\(sudo ? "sudo " : "")cp \u{2D}R \(origin) \(destination)",
      ]
      return result.joinedAsLines()
    }
    private func copyDirectory(
      from origin: StrictString,
      to destination: StrictString,
      sudo: Bool = false
    ) -> StrictString {
      return copyFiles(from: "\(origin)/*", to: destination, sudo: sudo)
    }

    private func remove(_ path: StrictString) -> StrictString {
      return "rm \u{2D}rf \(path)"
    }

    private func cURL(
      _ url: StrictString,
      andUnzipTo destination: StrictString,
      containerName: StrictString,
      removeExisting: Bool = false,
      sudoCopy: Bool = false
    ) -> StrictString {
      let zipFileName = StrictString(url.components(separatedBy: "/").last!.contents)
      let fileName = containerName
      let temporaryZip: StrictString = "/tmp/\(zipFileName)"
      let temporary: StrictString = "/tmp/\(fileName)"
      var result: [StrictString] = []
      result.append(cURL(from: url, to: temporaryZip))
      result.append("unzip \(temporaryZip) \u{2D}d /tmp")
      if removeExisting {
        result.append(remove(destination))
      }
      result.append(copyDirectory(from: temporary, to: destination, sudo: sudoCopy))
      return result.joinedAsLines()
    }

    private func cURL(
      _ url: StrictString,
      named name: StrictString? = nil,
      andUntarTo destination: StrictString,
      sudoCopy: Bool = false
    ) -> StrictString {
      let tarFileName = StrictString(url.components(separatedBy: "/").last!.contents)
      let fileName = name ?? tarFileName.truncated(before: ".tar")
      let temporaryTar: StrictString = "/tmp/\(tarFileName)"
      let temporary: StrictString = "/tmp/\(fileName)"
      var result: [StrictString] = []
      result.append(cURL(from: url, to: temporaryTar))
      result.append(contentsOf: [
        "tar \u{2D}\u{2D}extract \u{5C}",
        "  \u{2D}\u{2D}file \(temporaryTar) \u{5C}",
        "  \u{2D}\u{2D}directory /tmp \u{5C}",
        "  \u{2D}\u{2D}verbose",
      ]
      )
      result.append(copyDirectory(from: temporary, to: destination, sudo: sudoCopy))
      return result.joinedAsLines()
    }

    private func grantPermissions(to path: StrictString, sudo: Bool = true) -> StrictString {
      let prefix = sudo ? "sudo " : ""
      return "\(prefix)chmod \u{2D}R a+rwx \(path)"
    }

    private func createSymlink(
      pointingAt destination: String,
      from origin: String
    ) -> StrictString {
      return [
        "ln \u{5C}",
        "  \(destination) \u{5C}",
        "  \(origin) \u{5C}",
        "  \u{2D}\u{2D}symbolic \u{5C}",
        "  \u{2D}\u{2D}force",
      ].joinedAsLines()
    }

    private func set(
      environmentVariable: StrictString,
      to value: StrictString,
      windows: Bool = false
    ) -> StrictString {
      if windows {
        return "set \(environmentVariable)=\(value)"
      } else {
        return "export \(environmentVariable)=\u{22}\(value)\u{22}"
      }
    }
    private func export(
      _ environmentVariable: StrictString
    ) -> StrictString {
      return "echo \u{22}\(environmentVariable)=${\(environmentVariable)}\u{22} >> $GITHUB_ENV"
    }

    private func prependPath(_ entry: StrictString) -> StrictString {
      return [
        set(environmentVariable: "PATH", to: "\(entry):${PATH}"),
        export("PATH"),
      ].joinedAsLines()
    }

    internal func gitHubWorkflowJob(
      for project: PackageRepository,
      output: Command.Output
    ) throws -> [StrictString] {
      let configuration = try project.configuration(output: output)
      let interfaceLocalization = configuration.developmentInterfaceLocalization()

      let jobName = name.resolved(for: interfaceLocalization)
      var result: [StrictString] = [
        "  \(jobName.replacingMatches(for: " ", with: "_")):",
        "    name: \(jobName)",
        runsOn(gitHubActionMachine),
      ]
      if let container = dockerImage {
        result += [
          "    container: \(container)"
        ]
      }
      result += [
        steps(),
        step(checkOutStepName, localization: interfaceLocalization),
        checkOut(),
        step(cacheWorkspaceStepName, localization: interfaceLocalization),
        cache(),
      ]

      switch platform {
      case .macOS:
        let xcodeVersion = ContinuousIntegrationJob.currentXcodeVersion
          .string(droppingEmptyPatch: true)
        result.append(contentsOf: [
          script(
            heading: setXcodeUpStepName,
            localization: interfaceLocalization,
            commands: [
              "sudo xcode\u{2D}select \u{2D}switch /Applications/Xcode_\(xcodeVersion).app",
              "xcodebuild \u{2D}version",
              "swift \u{2D}\u{2D}version",
            ]
          )
        ])
      case .windows:
        let version = ContinuousIntegrationJob.currentSwiftVersion
          .string(droppingEmptyPatch: true)
        result.append(contentsOf: [
          step(installSwiftStepName, localization: interfaceLocalization),
          uses(
            "compnerd/gha\u{2D}setup\u{2D}swift@cf2a61060c146203ea6fe10cce367979ae4ec0b1",
            with: [
              "branch": "swift\u{2D}\(version)\u{2D}release",
              "tag": "\(version)\u{2D}RELEASE",
            ]
          ),
          script(
            heading: testStepName,
            localization: interfaceLocalization,
            shell: "cmd",
            commands: [
              set(
                environmentVariable: ContinuousIntegrationJob.windows.environmentVariable,
                to: "true",
                windows: true
              ),
              "swift test",
            ]
          ),
        ])
      case .web:
        break
      case .ubuntu:
        result.append(contentsOf: [
          script(
            heading: installSwiftPMDependenciesStepName,
            localization: interfaceLocalization,
            commands: [
              aptGet(["libncurses\u{2D}dev", "libsqlite3\u{2D}dev"])
            ]
          ),
          script(
            heading: installWorkspaceDependencies,
            localization: interfaceLocalization,
            commands: [
              aptGet(["curl"])
            ]
          ),
        ])
      case .tvOS, .iOS, .watchOS:
        unreachable()
      case .android:
        result.append(
          script(
            heading: fetchAndroidNDKStepName,
            localization: interfaceLocalization,
            commands: [
              cURL(
                "https://dl.google.com/android/repository/android\u{2D}ndk\u{2D}r\(ContinuousIntegrationJob.currentAnroidNDKVersion)\u{2D}linux.zip",
                andUnzipTo:
                  "${ANDROID_HOME}/ndk\u{2D}bundle",
                containerName:
                  "android\u{2D}ndk\u{2D}r\(ContinuousIntegrationJob.currentAnroidNDKVersion)",
                removeExisting: true,
                sudoCopy: true
              )
            ]
          )
        )
        let version = ContinuousIntegrationJob.currentSwiftVersion
          .string(droppingEmptyPatch: true)
        let ubuntuVersion = ContinuousIntegrationJob.currentUbuntuVersion
        result.append(contentsOf: [
          script(
            heading: installSwiftStepName,
            localization: interfaceLocalization,
            commands: [
              "sudo rm \u{2D}rf /usr/lib/clang/10.0.0",
              "sudo rm \u{2D}rf /usr/lib/python3/dist\u{2D}packages/lldb",
              cURL(
                "https://download.swift.org/swift\u{2D}\(version)\u{2D}release/ubuntu\(ubuntuVersion.replacingMatches(for: ".", with: ""))/swift\u{2D}\(version)\u{2D}RELEASE/swift\u{2D}\(version)\u{2D}RELEASE\u{2D}ubuntu\(ubuntuVersion).tar.gz",
                andUntarTo: "/",
                sudoCopy: true
              ),
              prependPath("/usr/bin"),
              "swift \u{2D}\u{2D}version",
            ]
          ),
          script(
            heading: fetchAndroidSDKStepName,
            localization: interfaceLocalization,
            commands: [
              cURL(
                "https://github.com/buttaface/swift\u{2D}android\u{2D}sdk/releases/download/\(version)/swift\u{2D}\(version)\u{2D}android\u{2D}x86_64\u{2D}24\u{2D}sdk.tar.xz",
                andUntarTo:
                  "/Library/Developer/Platforms/Android.platform/Developer/SDKs/Android.sdk",
                sudoCopy: true
              ),
              grantPermissions(to: "/Library"),
              createSymlink(
                pointingAt: "/usr/lib/clang/13.0.0",
                from:
                  "/Library/Developer/Platforms/Android.platform/Developer/SDKs/Android.sdk/usr/lib/swift/clang"
              ),
            ]
          ),
        ])
      case .amazonLinux:
        result.append(contentsOf: [
          script(
            heading: installSwiftPMDependenciesStepName,
            localization: interfaceLocalization,
            commands: [
              yumInstallation(
                ["ncurses\u{2D}devel", "sqlite\u{2D}devel"]
              )
            ]
          ),
          script(
            heading: installWorkspaceDependencies,
            localization: interfaceLocalization,
            commands: [
              yumInstallation(["curl"])
            ]
          ),
        ])
      }

      switch platform {
      case .macOS, .ubuntu, .tvOS, .iOS, .amazonLinux, .watchOS:
        if ¬(try project.isWorkspaceProject()) {
          result.append(
            try workspaceStep(
              named: installWorkspaceStepName,
              command: "version",
              localization: interfaceLocalization,
              configuration: configuration,
              project: project,
              output: output
            )
          )
        }
        result.append(
          try workspaceStep(
            named: refreshStepName,
            command: "refresh",
            localization: interfaceLocalization,
            configuration: configuration,
            project: project,
            output: output
          )
        )
        let mainStepName = self == .deployment ? documentStepName : validateStepName
        result.append(
          try workspaceStep(
            named: mainStepName,
            command: "validate •job \(argumentName.resolved(for: .englishCanada))",
            localization: interfaceLocalization,
            configuration: configuration,
            project: project,
            output: output
          )
        )
      case .windows:
        break
      case .web:
        result.append(
          script(
            heading: testStepName,
            localization: interfaceLocalization,
            commands: [
              "export \(ContinuousIntegrationJob.web.environmentVariable)=true",
              "carton test",
            ]
          )
        )
      case .android:
        result.append(
          script(
            heading: buildStepName,
            localization: interfaceLocalization,
            commands: [
              "export \(ContinuousIntegrationJob.android.environmentVariable)=true",
              "swift build \u{2D}\u{2D}triple x86_64\u{2D}unknown\u{2D}linux\u{2D}android24 \u{5C}",
              "  \u{2D}\u{2D}build\u{2D}tests \u{5C}",
              "  \u{2D}\u{2D}sdk ${ANDROID_HOME}/ndk\u{2D}bundle/toolchains/llvm/prebuilt/linux\u{2D}x86_64/sysroot \u{5C}",
              "  \u{2D}Xswiftc \u{2D}resource\u{2D}dir \u{2D}Xswiftc /Library/Developer/Platforms/Android.platform/Developer/SDKs/Android.sdk/usr/lib/swift \u{5C}",
              "  \u{2D}Xswiftc \u{2D}tools\u{2D}directory \u{2D}Xswiftc ${ANDROID_HOME}/ndk\u{2D}bundle/toolchains/llvm/prebuilt/linux\u{2D}x86_64/bin \u{5C}",
              "  \u{2D}Xswiftc \u{2D}Xclang\u{2D}linker \u{2D}Xswiftc \u{2D}\u{2D}target=x86_64\u{2D}linux\u{2D}android24 \u{5C}",
              "  \u{2D}Xswiftc \u{2D}use\u{2D}ld=lld \u{5C}",
              "  \u{2D}Xcc \u{2D}fPIC \u{5C}",
              "  \u{2D}Xcc \u{2D}lstdc++",
            ]
          )
        )
        let productsDirectory: StrictString =
          ".build/x86_64\u{2D}unknown\u{2D}linux\u{2D}android24/debug"
        result.append(
          script(
            heading: copyLibrariesStepName,
            localization: interfaceLocalization,
            commands: [
              copyFiles(
                from:
                  "/Library/Developer/Platforms/Android.platform/Developer/SDKs/Android.sdk/usr/lib/*.so",
                to: productsDirectory
              ),
              copyFiles(
                from:
                  "/Library/Developer/Platforms/Android.platform/Developer/SDKs/Android.sdk/usr/lib/swift/android/*.so",
                to: productsDirectory
              ),
            ]
          )
        )
        result.append(contentsOf: [
          step(uploadTestsStepName, localization: interfaceLocalization),
          uses(
            "actions/upload\u{2D}artifact@v2",
            with: [
              "name": "tests",
              "path": "\(productsDirectory)",
            ]
          ),

          "  Android_II:",
          "    name: \(androidIIJobName.resolved(for: interfaceLocalization))",
          "    runs\u{2D}on: macos\u{2D}\(ContinuousIntegrationJob.currentMacOSVersion.stringDroppingEmptyMinor())",
          "    needs: Android",
          steps(),
          step(checkOutStepName, localization: interfaceLocalization),
          checkOut(),
          step(downloadTestsStepName, localization: interfaceLocalization),
          uses(
            "actions/download\u{2D}artifact@v2",
            with: [
              "name": "tests",
              "path": "\(productsDirectory)",
            ]
          ),
          step(testStepName, localization: interfaceLocalization),
          uses(
            "reactivecircus/android\u{2D}emulator\u{2D}runner@v2",
            with: [
              "api\u{2D}level": "24",
              "arch": "x86_64",
              "script": [
                "|",
                "adb \u{2D}e push . /data/local/tmp/Package",
                "adb \u{2D}e shell \u{27}chmod \u{2D}R +x /data/local/tmp/Package/.build/x86_64\u{2D}unknown\u{2D}linux\u{2D}android24/debug\u{27}",
                "adb \u{2D}e shell \u{27}LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:/data/local/tmp/Package/.build/x86_64\u{2D}unknown\u{2D}linux\u{2D}android24/debug HOME=/data/local/tmp/Home SWIFTPM_PACKAGE_ROOT=/data/local/tmp/Package /data/local/tmp/Package/.build/x86_64\u{2D}unknown\u{2D}linux\u{2D}android24/debug/\(try project.packageName())PackageTests.xctest\u{27}",
              ].joined(separator: "\n          "),
            ]
          ),
        ])
      }

      switch platform {
      case .macOS, .windows, .web, .tvOS, .iOS, .android, .watchOS:
        break
      case .ubuntu, .amazonLinux:
        result.append(
          script(
            heading: grantCachPermissionsStepName,
            localization: interfaceLocalization,
            commands: [
              grantPermissions(to: ".", sudo: false)
            ]
          )
        )
      }

      if self == .deployment {
        result.append(contentsOf: [
          script(
            heading: deployStepName,
            localization: interfaceLocalization,
            commands: [
              "cd docs",
              "git init",
              "git config user.name \u{22}${GITHUB_ACTOR}\u{22}",
              "git config user.email \u{22}${GITHUB_ACTOR}@users.noreply.github.com\u{22}",
              "git add .",
              "git commit \u{2D}m \u{22}\(deployCommitMessage.resolved(for: interfaceLocalization))\u{22}",
              "git push \u{2D}\u{2D}force https://x\u{2D}access\u{2D}token:${GITHUB_TOKEN}@github.com/${GITHUB_REPOSITORY}.git master:gh\u{2D}pages",
            ]
          ),
          "      env:",
          "        GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}",
        ])
      }

      return result
    }

    // MARK: - Localized Text

    private var checkOutStepName: UserFacing<StrictString, InterfaceLocalization> {
      return UserFacing({ (localization) in
        switch localization {
        case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
          return "Check out"
        case .deutschDeutschland:
          return "Holen"
        }
      })
    }

    private var cacheWorkspaceStepName: UserFacing<StrictString, InterfaceLocalization> {
      return UserFacing({ (localization) in
        switch localization {
        case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
          return "Cache Workspace"
        case .deutschDeutschland:
          return "Arbeitsbereich zwischenspeichern"
        }
      })
    }

    private var setXcodeUpStepName: UserFacing<StrictString, InterfaceLocalization> {
      return UserFacing({ (localization) in
        switch localization {
        case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
          return "Set Xcode up"
        case .deutschDeutschland:
          return "Xcode einrichten"
        }
      })
    }

    private var fetchAndroidNDKStepName: UserFacing<StrictString, InterfaceLocalization> {
      return UserFacing({ (localization) in
        switch localization {
        case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
          return "Fetch Android NDK"
        case .deutschDeutschland:
          return "Android‐NDK holen"
        }
      })
    }

    private var installSwiftPMDependenciesStepName: UserFacing<StrictString, InterfaceLocalization>
    {
      return UserFacing({ (localization) in
        switch localization {
        case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
          return "Install SwiftPM dependencies"
        case .deutschDeutschland:
          return "SwiftPM‐Abhängigkeiten installieren"
        }
      })
    }

    private var installSwiftStepName: UserFacing<StrictString, InterfaceLocalization> {
      return UserFacing({ (localization) in
        switch localization {
        case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
          return "Install Swift"
        case .deutschDeutschland:
          return "Swift installieren"
        }
      })
    }

    private var fetchAndroidSDKStepName: UserFacing<StrictString, InterfaceLocalization> {
      return UserFacing({ (localization) in
        switch localization {
        case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
          return "Fetch Android SDK"
        case .deutschDeutschland:
          return "Android‐Entwicklungsausrüstung holen"
        }
      })
    }

    private var installWorkspaceDependencies: UserFacing<StrictString, InterfaceLocalization> {
      return UserFacing({ (localization) in
        switch localization {
        case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
          return "Install Workspace dependencies"
        case .deutschDeutschland:
          return "Abhängigkeiten von Arbeitsbereich installieren"
        }
      })
    }

    private var installWorkspaceStepName: UserFacing<StrictString, InterfaceLocalization> {
      return UserFacing({ (localization) in
        switch localization {
        case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
          return "Install Workspace"
        case .deutschDeutschland:
          return "Arbeitsbereich installieren"
        }
      })
    }

    private var refreshStepName: UserFacing<StrictString, InterfaceLocalization> {
      return UserFacing({ (localization) in
        switch localization {
        case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
          return "Refresh"
        case .deutschDeutschland:
          return "Auffrischen"
        }
      })
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

    private var buildStepName: UserFacing<StrictString, InterfaceLocalization> {
      return UserFacing({ (localization) in
        switch localization {
        case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
          return "Build"
        case .deutschDeutschland:
          return "Erstellen"
        }
      })
    }

    private var copyLibrariesStepName: UserFacing<StrictString, InterfaceLocalization> {
      return UserFacing({ (localization) in
        switch localization {
        case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
          return "Copy libraries"
        case .deutschDeutschland:
          return "Bibliotheken kopieren"
        }
      })
    }

    private var uploadTestsStepName: UserFacing<StrictString, InterfaceLocalization> {
      return UserFacing({ (localization) in
        switch localization {
        case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
          return "Upload tests"
        case .deutschDeutschland:
          return "Teste hochladen"
        }
      })
    }

    private var downloadTestsStepName: UserFacing<StrictString, InterfaceLocalization> {
      return UserFacing({ (localization) in
        switch localization {
        case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
          return "Download tests"
        case .deutschDeutschland:
          return "Teste herunterladen"
        }
      })
    }

    private var testStepName: UserFacing<StrictString, InterfaceLocalization> {
      return UserFacing({ (localization) in
        switch localization {
        case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
          return "Test"
        case .deutschDeutschland:
          return "Testen"
        }
      })
    }

    private var documentStepName: UserFacing<StrictString, InterfaceLocalization> {
      return UserFacing({ (localization) in
        switch localization {
        case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
          return "Document"
        case .deutschDeutschland:
          return "Dokumentieren"
        }
      })
    }

    private var grantCachPermissionsStepName: UserFacing<StrictString, InterfaceLocalization> {
      return UserFacing({ (localization) in
        switch localization {
        case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
          return "Grant permission to cache"
        case .deutschDeutschland:
          return "Zugriffsrechte zum Zwischenspeichern erteilen"
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
  }

  extension Optional where Wrapped == ContinuousIntegrationJob {

    internal func includes(job: ContinuousIntegrationJob) -> Bool {
      switch self {
      case .none:
        switch job {
        case .macOS, .windows, .web, .ubuntu, .tvOS, .iOS, .android, .amazonLinux,
          .watchOS,
          .miscellaneous:
          return true
        case .deployment:
          return false
        }
      case .some(let currentJob):
        return currentJob == job
      }
    }
  }
#endif
