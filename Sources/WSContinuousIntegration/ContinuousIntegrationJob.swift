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
  case android
  case watchOS
  case miscellaneous
  case deployment

  public static let currentSwiftVersion = Version(5, 1, 3)
  private static let currentExperimentalSwiftVersion = Version(5, 2, 0)
  public static let currentXcodeVersion = Version(11, 3, 0)

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
    case .android:
      return UserFacing({ (localization) in
        switch localization {
        case .englishUnitedKingdom, .englishUnitedStates, .englishCanada,
             .deutschDeutschland:
          return "Android"
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
    case .android:
      return UserFacing({ (localization) in
        switch localization {
        case .englishUnitedKingdom, .englishUnitedStates, .englishCanada,
             .deutschDeutschland:
          return "android"
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
    case .android:
      return try .android ∈ project.configuration(output: output).supportedPlatforms
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
    case .android:
      return .android
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
    case .android:
      return "ubuntu\u{2D}18.04"
    }
  }

  private var dockerImage: String? {
    switch platform {
    case .macOS, .windows, .android:
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

  internal func gitHubWorkflowJob(for project: PackageRepository, output: Command.Output) throws
    -> [String]
  {
    let configuration = try project.configuration(output: output)
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
        "        path: \(PackageRepository.repositoryWorkspaceCacheDirectory)"
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
    case .android:
      result.append(contentsOf: cacheEntry(os: "Android"))
    }

    func commandEntry(_ command: String) -> String {
      return "        \(command)"
    }

    let xcodeVersion = ContinuousIntegrationJob.currentXcodeVersion.string(droppingEmptyPatch: true)
    result.append("    \u{2D} name: \(validateStepName.resolved(for: interfaceLocalization))")

    switch platform {
    case .macOS, .linux, .tvOS, .iOS, .android, .watchOS:
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
      let version = ContinuousIntegrationJob.currentExperimentalSwiftVersion.string(
        droppingEmptyPatch: true
      )
      result.append(contentsOf: [
        commandEntry(
          "echo \u{27}Setting up Visual Studio... (in order to proceed as though in the Native Tools Command Prompt)\u{27}"
        ),
        commandEntry("repository_directory=$(pwd)"),
        commandEntry(
          "cd \u{27}/c/Program Files (x86)/Microsoft Visual Studio/2019/Enterprise/VC/Auxiliary/Build\u{27}"
        ),
        commandEntry("echo \u{27}export \u{2D}p > exported_environment.sh\u{27} > nested_bash.sh"),
        commandEntry(
          "echo \u{27}vcvarsall.bat x64 &\u{26} \u{22}C:/Program Files/Git/usr/bin/bash\u{22} \u{2D}c ./nested_bash.sh\u{27} > export_environment.bat"
        ),
        commandEntry("cmd \u{22}/c export_environment.bat\u{22}"),
        commandEntry("source ./exported_environment.sh"),
        commandEntry(
          "if [ \u{2D}z \u{22}$INCLUDE\u{22} ]; then echo \u{27}Failed to set up Visual Studio.\u{27}; exit 1; fi"
        ),
        commandEntry("cd \u{22}${repository_directory}\u{22}"),
        "",
        commandEntry("echo \u{27}Fetching Windows platform module maps...\u{27}"),
        commandEntry(
          "curl \u{2D}L \u{27}https://raw.githubusercontent.com/apple/swift/swift\u{2D}\(version)\u{2D}branch/stdlib/public/Platform/ucrt.modulemap\u{27} \u{2D}o \u{22}${UniversalCRTSdkDir}/Include/${UCRTVersion}/ucrt/module.modulemap\u{22}"
        ),
        commandEntry(
          "curl \u{2D}L \u{27}https://raw.githubusercontent.com/apple/swift/swift\u{2D}\(version)\u{2D}branch/stdlib/public/Platform/visualc.modulemap\u{27} \u{2D}o \u{22}${VCToolsInstallDir}/include/module.modulemap\u{22}"
        ),
        commandEntry(
          "curl \u{2D}L \u{27}https://raw.githubusercontent.com/apple/swift/swift\u{2D}\(version)\u{2D}branch/stdlib/public/Platform/visualc.apinotes\u{27} \u{2D}o \u{22}${VCToolsInstallDir}/include/visualc.apinotes\u{22}"
        ),
        commandEntry(
          "curl \u{2D}L \u{27}https://raw.githubusercontent.com/apple/swift/swift\u{2D}\(version)\u{2D}branch/stdlib/public/Platform/winsdk.modulemap\u{27} \u{2D}o \u{22}${UniversalCRTSdkDir}/Include/${UCRTVersion}/um/module.modulemap\u{22}"
        ),
        "",
        commandEntry("echo \u{27}Fetching Swift...\u{27}"),
        commandEntry("mkdir \u{2D}p .build/SDG/Experimental_Swift"),
        commandEntry("cd .build/SDG/Experimental_Swift"),
        commandEntry(
          "curl \u{2D}o swift\u{2D}build.py \u{27}https://raw.githubusercontent.com/compnerd/swift\u{2D}build/master/utilities/swift\u{2D}build.py\u{27}"
        ),
        commandEntry("python \u{2D}m pip install \u{2D}\u{2D}user azure\u{2D}devops tabulate"),
        commandEntry(
          "echo \u{27}Downloading... (This could take up to 10 minutes.)\u{27}"
        ),
        commandEntry(
          "python swift\u{2D}build.py \u{2D}\u{2D}build\u{2D}id \u{27}VS2019 Swift \(version)\u{27} \u{2D}\u{2D}latest\u{2D}artifacts \u{2D}\u{2D}filter windows\u{2D}x64 \u{2D}\u{2D}download > /dev/null"
        ),
        commandEntry("7z x toolchain\u{2D}windows\u{2D}x64.zip"),
        commandEntry("mv toolchain\u{2D}windows\u{2D}x64/Library /c/Library"),
        commandEntry("7z x sdk\u{2D}windows\u{2D}x64.zip"),
        commandEntry(
          "mv sdk\u{2D}windows\u{2D}x64/Library/Developer/Platforms /c/Library/Developer/Platforms"
        ),
        commandEntry("cd \u{22}${repository_directory}\u{22}"),
        commandEntry(
          "export PATH=\u{22}/c/Library/Developer/Toolchains/unknown\u{2D}Asserts\u{2D}development.xctoolchain/usr/bin:${PATH}\u{22}"
        ),
        commandEntry("mkdir \u{2D}p /c/Library/Swift/Current"),
        commandEntry(
          "cp \u{2D}R /c/Library/Developer/Platforms/Windows.platform/Developer/SDKs/Windows.sdk/usr/bin /c/Library/Swift/Current/bin"
        ),
        commandEntry("export PATH=\u{22}/c/Library/Swift/Current/bin:${PATH}\u{22}"),
        commandEntry(
          "export PATH=\u{22}/c/Library/Developer/Platforms/Windows.platform/Developer/Library/XCTest\u{2D}development/usr/bin:${PATH}\u{22}"
        ),
        commandEntry("swift \u{2D}\u{2D}version"),
        "",
        commandEntry("echo \u{27}Fetching ICU...\u{27}"),
        commandEntry("mkdir \u{2D}p .build/SDG/ICU"),
        commandEntry("cd .build/SDG/ICU"),
        commandEntry(
          "curl \u{2D}L http://download.icu\u{2D}project.org/files/icu4c/64.2/icu4c\u{2D}64_2\u{2D}Win64\u{2D}MSVC2017.zip \u{2D}\u{2D}output ICU.zip"
        ),
        commandEntry("7z x ICU.zip \u{2D}oICU\u{2D}64.2"),
        commandEntry("mv ICU\u{2D}64.2 /c/Library/ICU\u{2D}64.2"),
        commandEntry("mv /c/Library/ICU\u{2D}64.2/bin64 /c/Library/ICU\u{2D}64.2/bin"),
        commandEntry("export PATH=\u{22}/c/Library/ICU\u{2D}64.2/bin:${PATH}\u{22}"),
        commandEntry("cd \u{22}${repository_directory}\u{22}"),
        "",
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
    case .android:
      result.append(contentsOf: [
        commandEntry("Set‐Up")
      ])
    }

    switch platform {
    case .macOS, .linux, .iOS, .watchOS, .tvOS:
      result.append(contentsOf: [
        commandEntry(refreshCommand(configuration: configuration)),
        commandEntry(validateCommand(configuration: configuration))
      ])
    case .windows:
      result.append(contentsOf: [
        commandEntry("echo \u{27}Fetching package graph...\u{27}"),
      ])
      let graph = try project.cachedWindowsPackageGraph()
      for package in graph.packages.sorted(by: { $0.name < $1.name }) {
        if let version = package.underlyingPackage.manifest.version {
          let url = package.underlyingPackage.manifest.url
          result.append(
            commandEntry(
              "git clone \(url) .build/SDG/Dependencies/\(package.name) \u{2D}\u{2D}branch \(version.description) \u{2D}\u{2D}depth 1 \u{2D}\u{2D}config advice.detachedHead=false"
            )
          )
        }
      }
      result.append(contentsOf: [
        "",
        commandEntry("echo \u{27}Building \(try project.packageName())...\u{27}"),
        commandEntry(
          "cmake \u{2D}G Ninja \u{2D}S .github/workflows/Windows \u{2D}B .build/SDG/CMake \u{2D}DCMAKE_Swift_FLAGS=\u{27}\u{2D}resource\u{2D}dir C:\u{5C}Library\u{5C}Developer\u{5C}Platforms\u{5C}Windows.platform\u{5C}Developer\u{5C}SDKs\u{5C}Windows.sdk\u{5C}usr\u{5C}lib\u{5C}swift \u{2D}I C:\u{5C}Library\u{5C}Developer\u{5C}Platforms\u{5C}Windows.platform\u{5C}Developer\u{5C}Library\u{5C}XCTest\u{2D}development\u{5C}usr\u{5C}lib\u{5C}swift\u{5C}windows\u{5C}x86_64 \u{2D}L C:\u{5C}Library\u{5C}Developer\u{5C}Platforms\u{5C}Windows.platform\u{5C}Developer\u{5C}SDKs\u{5C}Windows.sdk\u{5C}usr\u{5C}lib\u{5C}swift\u{5C}windows \u{2D}L C:\u{5C}Library\u{5C}Developer\u{5C}Platforms\u{5C}Windows.platform\u{5C}Developer\u{5C}Library\u{5C}XCTest\u{2D}development\u{5C}usr\u{5C}lib\u{5C}swift\u{5C}windows\u{27}"
        ),
        commandEntry("cmake \u{2D}\u{2D}build \u{27}.build/SDG/CMake\u{27}"),
        commandEntry("echo \u{27}Testing \(try project.packageName())...\u{27}"),
        commandEntry("cd .build/SDG/CMake"),
        commandEntry("ctest \u{2D}\u{2D}verbose")
      ])
    case .android:
      result.append(contentsOf: [
        commandEntry("Build")
      ])
    }

    switch platform {
    case .macOS, .windows, .tvOS, .iOS, .android, .watchOS:
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
      case .macOS, .windows, .linux, .tvOS, .iOS, .android, .watchOS, .miscellaneous:
        return true
      case .deployment:
        return false
      }
    case .some(let currentJob):
      return currentJob == job
    }
  }
}
