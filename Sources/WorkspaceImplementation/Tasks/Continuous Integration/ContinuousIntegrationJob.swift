/*
 ContinuousIntegrationJob.swift

 This source file is part of the Workspace open source project.
 Diese Quelldatei ist Teil des quelloffenen Arbeitsbereich‐Projekt.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2017–2021 Jeremy David Giesbrecht and the Workspace project contributors.
 Urheberrecht ©2017–2021 Jeremy David Giesbrecht und die Mitwirkenden des Arbeitsbereich‐Projekts.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

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
  case centOS
  case ubuntu
  case tvOS
  case iOS
  case android
  case amazonLinux
  case watchOS
  case miscellaneous
  case deployment

  internal static let currentSwiftVersion = Version(5, 4, 0)

  private static let currentMacOSVersion = Version(11)
  internal static let currentXcodeVersion = Version(12, 5)
  private static let currentWindowsVersion = "10"
  private static let currentVisualStudioVersion = "2019"
  private static let currentWSLImage = "2004"
  private static let currentCartonVersion = Version(0, 9, 1)
  private static let currentCentOSVersion = "8"
  private static let currentUbuntuName = "focal"  // Used by Docker image
  private static let currentUbuntuVersion = "20.04"  // Used by GitHub host
  private static let currentAnroidNDKVersion = "21"
  private static let currentAmazonLinuxVerison = "2"

  internal static let simulatorJobs: Set<ContinuousIntegrationJob> = [
    .iOS,
    .tvOS,
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
    case .centOS:
      return UserFacing({ (localization) in
        switch localization {
        case .englishUnitedKingdom, .englishUnitedStates, .englishCanada,
          .deutschDeutschland:
          return "CentOS"
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
    case .centOS:
      return UserFacing({ (localization) in
        switch localization {
        case .englishUnitedKingdom, .englishUnitedStates, .englishCanada,
          .deutschDeutschland:
          return "centos"
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
    case .centOS:  // @exempt(from: tests) Unreachable from macOS.
      return "CENTOS"
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
    switch self {
    case .macOS:
      return try .macOS ∈ project.configuration(output: output).supportedPlatforms
    case .windows:
      return try .windows ∈ project.configuration(output: output).supportedPlatforms
    case .web:
      return try .web ∈ project.configuration(output: output).supportedPlatforms
    case .centOS:
      return try .centOS ∈ project.configuration(output: output).supportedPlatforms
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
      return try project.configuration(output: output).documentation.api.generate
        ∧ project.hasTargetsToDocument()
        ∧ (try project.configuration(output: output)
          .documentation.api.serveFromGitHubPagesBranch)
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
    case .centOS:
      return .centOS
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
        "macos\u{2D}\(ContinuousIntegrationJob.currentMacOSVersion.string(droppingEmptyPatch: true))"
    case .windows:
      return "windows\u{2D}\(ContinuousIntegrationJob.currentVisualStudioVersion)"
    case .web, .centOS, .ubuntu, .android, .amazonLinux:
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
      let version = ContinuousIntegrationJob.currentCartonVersion.string(droppingEmptyPatch: true)
      return "ghcr.io/swiftwasm/carton:\(version)"
    case .centOS:
      let version = ContinuousIntegrationJob.currentSwiftVersion.string()
      return "swift:\(version)\u{2D}centos\(ContinuousIntegrationJob.currentCentOSVersion)"
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
    return uses("actions/checkout@v1")
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
    case .centOS:
      environment = "CentOS"
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
      "actions/cache@v1",
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
    commands: [StrictString]
  ) -> StrictString {
    var result: [StrictString] = [
      step(heading, localization: localization),
      "      shell: bash",
      "      run: |",
    ]
    result.append(
      contentsOf: commands.prepending("set \u{2D}x")
        .joinedAsLines().lines.map({ "        \(StrictString($0.line))" })
    )
    return result.joinedAsLines()
  }

  private func wsl(_ command: StrictString) -> StrictString {
    let command = command.replacingMatches(for: "\n", with: "\n  ")
    return "ubuntu\(ContinuousIntegrationJob.currentWSLImage) run \u{5C}\n  \(command)"
  }

  private func yumInstallation(_ packages: [StrictString]) -> StrictString {
    var installLines: [StrictString] = [
      "yum install \u{2D}\u{2D}assumeyes \u{5C}"
    ]
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

  private func aptGet(_ packages: [StrictString], wsl: Bool = false) -> StrictString {
    var update: StrictString = "apt\u{2D}get update \u{2D}\u{2D}assume\u{2D}yes"
    if wsl {
      update = self.wsl(update)
    }
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
    var install = installLines.joinedAsLines()
    if wsl {
      install = self.wsl(install)
    }
    return [update, install].joinedAsLines()
  }

  private func cURL(
    from origin: StrictString,
    to destination: StrictString,
    wsl: Bool = false
  ) -> StrictString {
    var result: StrictString = [
      "curl \u{2D}\u{2D}location \u{5C}",
      "  \u{27}\(origin)\u{27} \u{5C}",
      "  \u{2D}\u{2D}output \u{27}\(destination)\u{27}",
    ].joinedAsLines()
    if wsl {
      result = self.wsl(result)
    }
    return result
  }

  private func makeDirectory(_ directory: StrictString, sudo: Bool = false) -> StrictString {
    return "\(sudo ? "sudo " : "")mkdir \u{2D}p \(directory)"
  }
  private func copyDirectory(
    from origin: StrictString,
    to destination: StrictString,
    sudo: Bool = false,
    wsl: Bool = false
  ) -> StrictString {
    var result: [StrictString] = [
      makeDirectory(destination, sudo: sudo),
      "\(sudo ? "sudo " : "")cp \u{2D}R \(origin)/\(wsl ? "usr" : "*") \(destination)\(wsl ? "/" : "")",
    ]
    if wsl {
      result = result.map { self.wsl($0) }
    }
    return result.joinedAsLines()
  }
  private func copyFile(
    from origin: StrictString,
    to destination: StrictString
  ) -> StrictString {
    return "cp \u{22}\(origin)\u{22} \u{22}\(destination)\u{22}"
  }

  private func cURLAndExecuteWindowsInstaller(_ url: StrictString) -> StrictString {
    let installer = StrictString(url.components(separatedBy: "/").last!.contents)
    let temporaryInstaller: StrictString = "/tmp/\(installer)"
    return [
      cURL(from: url, to: temporaryInstaller),
      "\(temporaryInstaller) //passive",
    ].joinedAsLines()
  }

  private func remove(_ path: StrictString) -> StrictString {
    return "rm \u{2D}rf \(path)"
  }

  private func cURL(
    _ url: StrictString,
    andUnzipTo destination: StrictString,
    containerName: StrictString? = nil,
    removeExisting: Bool = false,
    sudoCopy: Bool = false,
    localTemporaryDirectory: Bool = false,
    use7z: Bool = false
  ) -> StrictString {
    let zipFileName = StrictString(url.components(separatedBy: "/").last!.contents)
    let fileName =
      containerName
      ?? zipFileName.components(separatedBy: ".")
      .dropLast().lazy.map({ StrictString($0.contents) })
      .joined(separator: ".")
    var temporaryZip: StrictString = "/tmp/\(zipFileName)"
    var temporary: StrictString = "/tmp/\(fileName)"
    if localTemporaryDirectory {
      let local: StrictString = ".build/SDG"
      temporaryZip.prepend(contentsOf: local)
      temporary.prepend(contentsOf: local)
    }
    var result: [StrictString] = []
    if localTemporaryDirectory {
      result.append(makeDirectory(temporaryZip.truncated(before: "/\(zipFileName)")))
    }
    result.append(cURL(from: url, to: temporaryZip))
    if use7z {
      result.append("7z x \(temporaryZip) \u{2D}o\(destination)")
    } else {
      result.append("unzip \(temporaryZip) \u{2D}d /tmp")
      if removeExisting {
        result.append(remove(destination))
      }
      result.append(copyDirectory(from: temporary, to: destination, sudo: sudoCopy))
    }
    return result.joinedAsLines()
  }

  private func cURL(
    _ url: StrictString,
    named name: StrictString? = nil,
    andUntarTo destination: StrictString,
    sudoCopy: Bool = false,
    wsl: Bool = false
  ) -> StrictString {
    let tarFileName = StrictString(url.components(separatedBy: "/").last!.contents)
    let fileName = name ?? tarFileName.truncated(before: ".tar")
    let temporaryTar: StrictString = "/tmp/\(tarFileName)"
    let temporary: StrictString = "/tmp/\(fileName)"
    var result: [StrictString] = []
    if wsl {
      result.append(self.wsl(makeDirectory("/tmp")))
    }
    result.append(cURL(from: url, to: temporaryTar, wsl: wsl))
    let forceLocal = wsl ? " \u{2D}\u{2D}force\u{2D}local" : ""
    var tar: StrictString =
      "tar \u{2D}\u{2D}extract\(forceLocal) \u{2D}\u{2D}file \(temporaryTar) \u{2D}\u{2D}directory /tmp"
    if wsl {
      tar = self.wsl(tar)
    }
    result.append(tar)
    result.append(copyDirectory(from: temporary, to: destination, sudo: sudoCopy, wsl: wsl))
    return result.joinedAsLines()
  }

  private func grantPermissions(to path: StrictString, sudo: Bool = true) -> StrictString {
    let prefix = sudo ? "sudo " : ""
    return "\(prefix)chmod \u{2D}R a+rwx \(path)"
  }

  private func set(environmentVariable: StrictString, to value: StrictString) -> StrictString {
    return "export \(environmentVariable)=\u{22}\(value)\u{22}"
  }
  private func export(_ environmentVariable: StrictString) -> StrictString {
    return "echo \u{22}\(environmentVariable)=${\(environmentVariable)}\u{22} >> $GITHUB_ENV"
  }

  private func prependPath(_ entry: StrictString) -> StrictString {
    return [
      set(environmentVariable: "PATH", to: "\(entry):${PATH}"),
      export("PATH"),
    ].joinedAsLines()
  }

  private func compressPATH() -> StrictString {
    return
      "export PATH=$(echo \u{2D}n $PATH | awk \u{2D}v RS=: \u{2D}v ORS=: \u{27}!($0 in a) {a[$0]; print $0}\u{27})"
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
      var xcodeVersion = ContinuousIntegrationJob.currentXcodeVersion
        .string(droppingEmptyPatch: true)
      if xcodeVersion.hasSuffix(".0") {  // @exempt(from: tests)
        xcodeVersion.removeLast(2)
      }
      result.append(
        script(
          heading: setXcodeUpStepName,
          localization: interfaceLocalization,
          commands: [
            "sudo xcode\u{2D}select \u{2D}switch /Applications/Xcode_\(xcodeVersion).app",
            "xcodebuild \u{2D}version",
            "swift \u{2D}\u{2D}version",
          ]
        )
      )
    case .windows:
      result.append(
        script(
          heading: setVisualStudioUpStepName,
          localization: interfaceLocalization,
          commands: [
            "cd \u{27}/c/Program Files (x86)/Microsoft Visual Studio/2019/Enterprise/VC/Auxiliary/Build\u{27}",
            "echo \u{27}export \u{2D}p > exported_environment.sh\u{27} > nested_bash.sh",
            "echo \u{27}vcvarsall.bat x64 &\u{26} \u{22}C:/Program Files/Git/usr/bin/bash\u{22} \u{2D}c ./nested_bash.sh\u{27} > export_environment.bat",
            "cmd \u{22}/c export_environment.bat\u{22}",
            "set +x",
            "source ./exported_environment.sh",
            "set \u{2D}x",
            export("PATH"),
            export("UniversalCRTSdkDir"),
            export("UCRTVersion"),
            export("VCToolsInstallDir"),
          ]
        )
      )
      let version = ContinuousIntegrationJob.currentSwiftVersion
        .string(droppingEmptyPatch: true)
      result.append(
        script(
          heading: installSwiftStepName,
          localization: interfaceLocalization,
          commands: [
            cURLAndExecuteWindowsInstaller(
              "https://swift.org/builds/swift\u{2D}\(version)\u{2D}release/windows\(ContinuousIntegrationJob.currentWindowsVersion)/swift\u{2D}\(version)\u{2D}RELEASE/swift\u{2D}\(version)\u{2D}RELEASE\u{2D}windows\(ContinuousIntegrationJob.currentWindowsVersion).exe"
            ),
            remove(
              "/c/Library/Developer/Platforms/Windows.platform/Developer/SDKs/Windows.sdk/usr/include/CFURLSessionInterface"
            ),
            remove(
              "/c/Library/Developer/Platforms/Windows.platform/Developer/SDKs/Windows.sdk/usr/include/CFXMLInterface"
            ),
            remove(
              "/c/Library/Developer/Platforms/Windows.platform/Developer/SDKs/Windows.sdk/usr/include/CoreFoundation"
            ),
            set(
              environmentVariable: "SDKROOT",
              to: "/c/Library/Developer/Platforms/Windows.platform/Developer/SDKs/Windows.sdk"
            ),
            export("SDKROOT"),
            copyFile(
              from:
                "${SDKROOT}/usr/share/ucrt.modulemap",
              to: "${UniversalCRTSdkDir}/Include/${UCRTVersion}/ucrt/module.modulemap"
            ),
            copyFile(
              from:
                "${SDKROOT}/usr/share/visualc.modulemap",
              to: "${VCToolsInstallDir}/include/module.modulemap"
            ),
            copyFile(
              from:
                "${SDKROOT}/usr/share/visualc.apinotes",
              to: "${VCToolsInstallDir}/include/visualc.apinotes"
            ),
            copyFile(
              from:
                "${SDKROOT}/usr/share/winsdk.modulemap",
              to: "${UniversalCRTSdkDir}/Include/${UCRTVersion}/um/module.modulemap"
            ),
            prependPath("/c/Library/icu\u{2D}67/usr/bin"),
            prependPath(
              "/c/Library/Developer/Toolchains/unknown\u{2D}Asserts\u{2D}development.xctoolchain/usr/bin"
            ),
            prependPath("/c/Library/Swift\u{2D}development/bin"),
            prependPath(
              "/c/Library/Developer/Platforms/Windows.platform/Developer/Library/XCTest\u{2D}development/usr/bin"
            ),
            "swift \u{2D}\u{2D}version",
          ]
        )
      )
    case .web:
      break
    case .centOS, .amazonLinux:
      result.append(contentsOf: [
        script(
          heading: installSwiftPMDependenciesStepName,
          localization: interfaceLocalization,
          commands: [
            yumInstallation(["ncurses\u{2D}devel", "sqlite\u{2D}devel"])
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
              "https://dl.google.com/android/repository/android\u{2D}ndk\u{2D}r\(ContinuousIntegrationJob.currentAnroidNDKVersion)d\u{2D}linux\u{2D}x86_64.zip",
              andUnzipTo:
                "${ANDROID_HOME}/ndk\u{2D}bundle",
              containerName:
                "android\u{2D}ndk\u{2D}r\(ContinuousIntegrationJob.currentAnroidNDKVersion)d",
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
            // #workaround(Are these still in the way?)
            "sudo rm \u{2D}rf /usr/lib/clang/10.0.0",
            "sudo rm \u{2D}rf /usr/lib/python3/dist-packages/lldb",
            cURL(
              "https://swift.org/builds/swift\u{2D}\(version)\u{2D}release/ubuntu\(ubuntuVersion.replacingMatches(for: ".", with: ""))/swift\u{2D}\(version)\u{2D}RELEASE/swift\u{2D}\(version)\u{2D}RELEASE\u{2D}ubuntu\(ubuntuVersion).tar.gz",
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
              "https://github.com/SDGGiesbrecht/Workspace/releases/download/experimental%E2%80%90swift%E2%80%90\(version)/Android.sdk.zip",
              andUnzipTo:
                "/Library/Developer/Platforms/Android.platform/Developer/SDKs/Android.sdk",
              sudoCopy: true
            ),
            grantPermissions(to: "/Library"),
          ]
        ),
      ])
    }

    switch platform {
    case .macOS, .centOS, .ubuntu, .tvOS, .iOS, .amazonLinux, .watchOS:
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
      let version = ContinuousIntegrationJob.currentSwiftVersion
        .string(droppingEmptyPatch: true)
      result.append(contentsOf: [
        script(
          heading: installLinuxStepName,
          localization: interfaceLocalization,
          commands: [
            cURL(
              "https://aka.ms/wslubuntu\(ContinuousIntegrationJob.currentWSLImage)",
              andUnzipTo: ".build/SDG/Linux/Ubuntu",
              localTemporaryDirectory: true,
              use7z: true
            ),
            prependPath("$(pwd)/.build/SDG/Linux/Ubuntu"),
            "ubuntu\(ContinuousIntegrationJob.currentWSLImage) install \u{2D}\u{2D}root",
          ]
        ),
        script(
          heading: installSwiftPMDependenciesStepName,
          localization: interfaceLocalization,
          commands: [
            aptGet(
              [
                "binutils",
                "git",
                "gnupg2",
                "libc6\u{2D}dev",
                "libcurl4",
                "libedit2",
                "libgcc\u{2D}9\u{2D}dev",
                "libpython2.7",
                "libsqlite3\u{2D}0",
                "libstdc++\u{2D}9\u{2D}dev",
                "libxml2",
                "libz3\u{2D}dev",
                "lld\u{2D}10",
                "pkg\u{2D}config",
                "tzdata",
                "zlib1g\u{2D}dev",
              ],
              wsl: true
            ),
            wsl("ln \u{2D}s //usr/bin/lld\u{2D}link\u{2D}10 //usr/bin/lld\u{2D}link"),
          ]
        ),
        script(
          heading: installSwiftPMStepName,
          localization: interfaceLocalization,
          commands: [
            cURL(
              "https://swift.org/builds/swift\u{2D}\(version)\u{2D}release/ubuntu\(ContinuousIntegrationJob.currentWSLImage)/swift\u{2D}\(version)\u{2D}RELEASE/swift\u{2D}\(version)\u{2D}RELEASE\u{2D}ubuntu\(ContinuousIntegrationJob.currentUbuntuVersion).tar.gz",
              andUntarTo: "/",
              wsl: true
            ),
            wsl("swift \u{2D}\u{2D}version"),
          ]
        ),
        script(
          heading: buildStepName,
          localization: interfaceLocalization,
          commands: [
            "export WSLENV=UniversalCRTSdkDir/p:UCRTVersion:VCToolsInstallDir/p",
            wsl(
              [
                "\(ContinuousIntegrationJob.windows.environmentVariable)=\u{27}true\u{27} \u{5C}",
                "swift build \u{2D}\u{2D}destination .github/workflows/Windows/SDK.json \u{5C}",
                "  \u{2D}Xswiftc \u{2D}use\u{2D}ld=lld \u{5C}",
                "  \u{2D}Xswiftc \u{2D}sdk \u{2D}Xswiftc //mnt/c/Library/Developer/Platforms/Windows.platform/Developer/SDKs/Windows.sdk \u{5C}",
                "  \u{2D}Xswiftc \u{2D}resource\u{2D}dir \u{2D}Xswiftc //mnt/c/Library/Developer/Platforms/Windows.platform/Developer/SDKs/Windows.sdk/usr/lib/swift \u{5C}",
                "  \u{2D}Xswiftc \u{2D}I \u{2D}Xswiftc //mnt/c/Library/Developer/Platforms/Windows.platform/Developer/SDKs/Windows.sdk/usr/lib/swift \u{5C}",
                "  \u{2D}Xswiftc \u{2D}L \u{2D}Xswiftc //mnt/c/Library/Developer/Platforms/Windows.platform/Developer/SDKs/Windows.sdk/usr/lib/swift/windows \u{5C}",
                "  \u{2D}Xswiftc \u{2D}Xcc \u{2D}Xswiftc \u{2D}isystem \u{2D}Xswiftc \u{2D}Xcc \u{2D}Xswiftc \u{27}\u{22}/${UniversalCRTSdkDir}/Include/${UCRTVersion}/ucrt\u{22}\u{27} \u{5C}",
                "  \u{2D}Xcc \u{2D}isystem \u{2D}Xcc \u{27}\u{22}/${UniversalCRTSdkDir}/Include/${UCRTVersion}/ucrt\u{22}\u{27} \u{5C}",
                "  \u{2D}Xswiftc \u{2D}L \u{2D}Xswiftc \u{27}\u{22}/${UniversalCRTSdkDir}/lib/${UCRTVersion}/ucrt/x64\u{22}\u{27} \u{5C}",
                "  \u{2D}Xswiftc \u{2D}Xcc \u{2D}Xswiftc \u{2D}isystem \u{2D}Xswiftc \u{2D}Xcc \u{2D}Xswiftc \u{27}\u{22}/${VCToolsInstallDir}/include\u{22}\u{27} \u{5C}",
                "  \u{2D}Xcc \u{2D}isystem \u{2D}Xcc \u{27}\u{22}/${VCToolsInstallDir}/include\u{22}\u{27} \u{5C}",
                "  \u{2D}Xswiftc \u{2D}L \u{2D}Xswiftc \u{27}\u{22}/${VCToolsInstallDir}/lib/x64\u{22}\u{27} \u{5C}",
                "  \u{2D}Xswiftc \u{2D}Xcc \u{2D}Xswiftc \u{2D}isystem \u{2D}Xswiftc \u{2D}Xcc \u{2D}Xswiftc \u{27}\u{22}/${UniversalCRTSdkDir}/Include/${UCRTVersion}/um\u{22}\u{27} \u{5C}",
                "  \u{2D}Xcc \u{2D}isystem \u{2D}Xcc \u{27}\u{22}/${UniversalCRTSdkDir}/Include/${UCRTVersion}/um\u{22}\u{27} \u{5C}",
                "  \u{2D}Xswiftc \u{2D}L \u{2D}Xswiftc \u{27}\u{22}/${UniversalCRTSdkDir}/lib/${UCRTVersion}/um/x64\u{22}\u{27} \u{5C}",
                "  \u{2D}Xswiftc \u{2D}Xcc \u{2D}Xswiftc \u{2D}isystem \u{2D}Xswiftc \u{2D}Xcc \u{2D}Xswiftc \u{27}\u{22}/${UniversalCRTSdkDir}/Include/${UCRTVersion}/shared\u{22}\u{27} \u{5C}",
                "  \u{2D}Xcc \u{2D}isystem \u{2D}Xcc \u{27}\u{22}/${UniversalCRTSdkDir}/Include/${UCRTVersion}/shared\u{22}\u{27} \u{5C}",
                "  \u{2D}Xswiftc \u{2D}I \u{2D}Xswiftc //mnt/c/Library/Developer/Platforms/Windows.platform/Developer/Library/XCTest\u{2D}development/usr/lib/swift/windows/x86_64 \u{5C}",
                "  \u{2D}Xswiftc \u{2D}L \u{2D}Xswiftc //mnt/c/Library/Developer/Platforms/Windows.platform/Developer/Library/XCTest\u{2D}development/usr/lib/swift/windows",
              ].joinedAsLines()
            ),
          ]
        ),
      ]
      )
      result.append(
        script(
          heading: testStepName,
          localization: interfaceLocalization,
          commands: [
            compressPATH(),
            ".build/x86_64\u{2D}unknown\u{2D}windows\u{2D}msvc/debug/WindowsTests.exe",
          ]
        )
      )
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
            "export CC=${ANDROID_HOME}/ndk\u{2D}bundle/toolchains/llvm/prebuilt/linux\u{2D}x86_64/bin/clang",
            "swift build \u{2D}\u{2D}triple x86_64\u{2D}unknown\u{2D}linux\u{2D}android \u{5C}",
            "  \u{2D}\u{2D}build\u{2D}tests \u{2D}\u{2D}enable\u{2D}test\u{2D}discovery \u{5C}",
            "  \u{2D}\u{2D}sdk /Library/Developer/Platforms/Android.platform/Developer/SDKs/Android.sdk \u{5C}",
            "  \u{2D}Xcc \u{2D}\u{2D}sysroot=${ANDROID_HOME}/ndk\u{2D}bundle/sysroot \u{5C}",
            "  \u{2D}Xswiftc \u{2D}tools\u{2D}directory \u{2D}Xswiftc ${ANDROID_HOME}/ndk\u{2D}bundle/toolchains/llvm/prebuilt/linux\u{2D}x86_64/bin \u{5C}",
            "  \u{2D}Xswiftc \u{2D}Xclang\u{2D}linker \u{2D}Xswiftc \u{2D}\u{2D}sysroot=${ANDROID_HOME}/ndk\u{2D}bundle/platforms/android\u{2D}29/arch\u{2D}x86_64",
          ]
        )
      )
      let productsDirectory: StrictString =
        ".build/x86_64\u{2D}unknown\u{2D}linux\u{2D}android/debug"
      result.append(
        script(
          heading: copyLibrariesStepName,
          localization: interfaceLocalization,
          commands: [
            copyDirectory(
              from:
                "${ANDROID_HOME}/ndk\u{2D}bundle/sources/cxx\u{2D}stl/llvm\u{2D}libc++/libs/x86_64",
              to: productsDirectory
            ),
            copyDirectory(
              from:
                "/Library/Developer/Platforms/Android.platform/Developer/SDKs/Android.sdk/usr/lib/swift/android",
              to: productsDirectory
            ),
          ]
        )
      )
      result.append(contentsOf: [
        step(uploadTestsStepName, localization: interfaceLocalization),
        uses(
          "actions/upload\u{2D}artifact@v1",
          with: [
            "name": "tests",
            "path": "\(productsDirectory)",
          ]
        ),

        "  Android_II:",
        "    name: \(androidIIJobName.resolved(for: interfaceLocalization))",
        "    runs\u{2D}on: macos\u{2D}\(ContinuousIntegrationJob.currentMacOSVersion.string(droppingEmptyPatch: true))",
        "    needs: Android",
        steps(),
        step(checkOutStepName, localization: interfaceLocalization),
        checkOut(),
        step(downloadTestsStepName, localization: interfaceLocalization),
        uses(
          "actions/download\u{2D}artifact@v1",
          with: [
            "name": "tests",
            "path": "\(productsDirectory)",
          ]
        ),
        script(
          heading: prepareScriptStepName,
          localization: interfaceLocalization,
          commands: [
            makeDirectory(".build/SDG"),
            "echo \u{27}",
            "set \u{2D}e",
            "adb \u{2D}e push . /data/local/tmp/Package",
            "adb \u{2D}e shell chmod \u{2D}R +x /data/local/tmp/Package/.build/x86_64\u{2D}unknown\u{2D}linux\u{2D}android/debug",
            "adb \u{2D}e shell \u{5C}",
            "  LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:/data/local/tmp/Package/.build/x86_64\u{2D}unknown\u{2D}linux\u{2D}android/debug \u{5C}",
            "  HOME=/data/local/tmp/Home \u{5C}",
            "  SWIFTPM_PACKAGE_ROOT=/data/local/tmp/Package \u{5C}",
            "  /data/local/tmp/Package/.build/x86_64\u{2D}unknown\u{2D}linux\u{2D}android/debug/\(try project.packageName())PackageTests.xctest",
            "\u{27} > .build/SDG/Emulator.sh",
            "chmod +x .build/SDG/Emulator.sh",
          ]
        ),
        // #workaround(Swift 5.3.3, There is no official action for this yet.)
        step(testStepName, localization: interfaceLocalization),
        uses(
          "reactivecircus/android\u{2D}emulator\u{2D}runner@v2",
          with: [
            "api\u{2D}level": "29",
            "arch": "x86_64",
            "script": ".build/SDG/Emulator.sh",
          ]
        ),
      ])
    }

    switch platform {
    case .macOS, .windows, .web, .tvOS, .iOS, .android, .watchOS:
      break
    case .centOS, .ubuntu, .amazonLinux:
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

  private var setVisualStudioUpStepName: UserFacing<StrictString, InterfaceLocalization> {
    return UserFacing({ (localization) in
      switch localization {
      case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
        return "Set Visual Studio up"
      case .deutschDeutschland:
        return "Visual Studio einrichten"
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

  private var installSwiftPMDependenciesStepName: UserFacing<StrictString, InterfaceLocalization> {
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

  private var installSwiftPMStepName: UserFacing<StrictString, InterfaceLocalization> {
    return UserFacing({ (localization) in
      switch localization {
      case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
        return "Install SwiftPM"
      case .deutschDeutschland:
        return "SwiftPM installieren"
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

  private var installLinuxStepName: UserFacing<StrictString, InterfaceLocalization> {
    return UserFacing({ (localization) in
      switch localization {
      case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
        return "Install Linux"
      case .deutschDeutschland:
        return "Linux installieren"
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

  private var prepareScriptStepName: UserFacing<StrictString, InterfaceLocalization> {
    return UserFacing({ (localization) in
      switch localization {
      case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
        return "Prepare script"
      case .deutschDeutschland:
        return "Skript vorbereiten"
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
      case .macOS, .windows, .web, .centOS, .ubuntu, .tvOS, .iOS, .android, .amazonLinux, .watchOS,
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
