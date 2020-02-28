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
  // #workaround(Swift 5.1.3, Debug builds are broken.)
  private static let workaroundAndroidSwiftVersion = Version(5, 1, 1)
  private static let experimentalDownloads =
    "https://github.com/SDGGiesbrecht/Workspace/releases/download/experimental%E2%80%90swift%E2%80%90pre%E2%80%905.2%E2%80%902020%E2%80%9002%E2%80%9005"

  private static let currentMacOSVersion = Version(10, 15)
  public static let currentXcodeVersion = Version(11, 3, 1)
  private static let currentWindowsVersion = "2019"
  private static let currentLinuxVersion = "18.04"

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
  private var androidIIJobName: UserFacing<StrictString, InterfaceLocalization> {
    return UserFacing({ (localization) in
      switch localization {
      case .englishUnitedKingdom, .englishUnitedStates, .englishCanada,
        .deutschDeutschland:
        return "Android II"
      }
    })
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

  private func appendLanguage(
    to command: StrictString,
    configuration: WorkspaceConfiguration
  ) -> StrictString {
    var command = command
    let languages = configuration.documentation.localisations
    if ¬languages.isEmpty {
      let argument = StrictString(
        languages.lazy.map({ $0._iconOrCode })
          .joined(separator: ";" as StrictString)
      )
      command.append(contentsOf: " •language \u{27}\(argument)\u{27}")
    }
    return command
  }
  private func refreshCommand(configuration: WorkspaceConfiguration) -> StrictString {
    return appendLanguage(to: "\u{27}./Refresh (macOS).command\u{27}", configuration: configuration)
  }
  private func validateCommand(configuration: WorkspaceConfiguration) -> StrictString {
    return appendLanguage(
      to:
        "\u{27}./Validate (macOS).command\u{27} •job \(argumentName.resolved(for: .englishCanada))",
      configuration: configuration
    )
  }

  // MARK: - GitHub Actions

  private var gitHubActionMachine: StrictString {
    switch platform {
    case .macOS:
      return
        "macos\u{2D}\(ContinuousIntegrationJob.currentMacOSVersion.string(droppingEmptyPatch: true))"
    case .windows:
      return "windows\u{2D}\(ContinuousIntegrationJob.currentWindowsVersion)"
    case .linux, .android:
      return "ubuntu\u{2D}\(ContinuousIntegrationJob.currentLinuxVersion)"
    case .tvOS, .iOS, .watchOS:
      unreachable()
    }
  }

  private var dockerImage: StrictString? {
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
    let os: StrictString
    switch platform {
    case .macOS:
      os = "macOS"
    case .windows:
      os = "Windows"
    case .linux:
      os = "Linux"
    case .tvOS, .iOS, .watchOS:
      unreachable()
    case .android:
      os = "Android"
    }
    return uses(
      "actions/cache@v1",
      with: [
        "key":
          "\(os)‐${{ hashFiles(\u{27}Refresh*\u{27}) }}‐${{ hashFiles(\u{27}.github/workflows/**\u{27}) }}",
        "path": PackageRepository.repositoryWorkspaceCacheDirectory
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
      "      run: |"
    ]
    result.append(
      contentsOf: commands.prepending("set \u{2D}x")
        .joinedAsLines().lines.map({ "        \(StrictString($0.line))" })
    )
    return result.joinedAsLines()
  }

  private func aptGet(_ packages: [StrictString], sudo: Bool = false) -> StrictString {
    let prefix = sudo ? "sudo " : ""
    let packages = StrictString(packages.joined(separator: " " as StrictString))
    return [
      "\(prefix)apt\u{2D}get update \u{2D}\u{2D}assume\u{2D}yes",
      "\(prefix)apt\u{2D}get install \u{2D}\u{2D}assume\u{2D}yes \(packages)"
    ].joinedAsLines()
  }

  private func cURL(
    from origin: StrictString,
    to destination: StrictString,
    allowVariableSubstitution: Bool = false
  ) -> StrictString {
    let quotedDestination: StrictString
    if allowVariableSubstitution {
      quotedDestination = "\u{22}\(destination)\u{22}"
    } else {
      quotedDestination = "\u{27}\(destination)\u{27}"
    }
    return [
      "curl \u{2D}\u{2D}location \u{5C}",
      "  \u{27}\(origin)\u{27} \u{5C}",
      "  \u{2D}\u{2D}output \(quotedDestination)"
    ].joinedAsLines()
  }

  private func makeDirectory(_ directory: StrictString) -> StrictString {
    return "mkdir \u{2D}p \(directory)"
  }
  private func copy(
    from origin: StrictString,
    to destination: StrictString,
    sudo: Bool = false
  ) -> StrictString {
    return [
      makeDirectory(destination),
      "\(sudo ? "sudo " : "")cp \u{2D}R \(origin)/* \(destination)"
    ].joinedAsLines()
  }

  private func cURL(
    _ url: StrictString,
    andUnzipTo destination: StrictString,
    windows: Bool = false,
    doubleWrapped: Bool = false,
    sudoCopy: Bool = false
  ) -> StrictString {
    let zipFileName = StrictString(url.components(separatedBy: "/").last!.contents)
    let fileName = zipFileName.truncated(before: ".")
    let temporaryZip: StrictString = "/tmp/\(zipFileName)"
    let temporary: StrictString = "/tmp/\(fileName)"
    var result: [StrictString] = [cURL(from: url, to: temporaryZip)]
    if windows {
      let output = doubleWrapped ? "." : fileName
      result.append(contentsOf: [
        "cd /tmp",
        "7z x \(zipFileName) \u{2D}o\(output)"
      ])
    } else {
      result.append(contentsOf: [
        "unzip \(temporaryZip) \u{2D}d /tmp"
      ])
    }
    result.append(copy(from: temporary, to: destination, sudo: sudoCopy))
    return result.joinedAsLines()
  }

  private func cURL(
    _ url: StrictString,
    andUntarTo destination: StrictString,
    sudoCopy: Bool = false
  ) -> StrictString {
    let tarFileName = StrictString(url.components(separatedBy: "/").last!.contents)
    let fileName = tarFileName.truncated(before: ".tar")
    let temporaryTar: StrictString = "/tmp/\(tarFileName)"
    let temporary: StrictString = "/tmp/\(fileName)"
    return [
      cURL(from: url, to: temporaryTar),
      "tar \u{2D}\u{2D}extract \u{2D}\u{2D}file \(temporaryTar) \u{2D}\u{2D}directory /tmp",
      copy(from: temporary, to: destination, sudo: sudoCopy)
    ].joinedAsLines()
  }

  private func grantPermissions(to path: StrictString, sudo: Bool = true) -> StrictString {
    let prefix = sudo ? "sudo " : ""
    return "\(prefix)chmod \u{2D}R a+rwx \(path)"
  }

  private func export(_ environmentVariable: StrictString) -> StrictString {
    return "echo \u{22}::set\u{2D}env name=\(environmentVariable)::${\(environmentVariable)}\u{22}"
  }

  private func prependPath(_ entry: StrictString) -> StrictString {
    return [
      "export PATH=\u{22}\(entry):${PATH}\u{22}",
      export("PATH")
    ].joinedAsLines()
  }

  private func commandEntry(_ command: StrictString) -> StrictString {
    #warning("Remove.")
    return "        \(command)"
  }

  internal func gitHubWorkflowJob(
    for project: PackageRepository,
    output: Command.Output
  ) throws -> [StrictString] {
    let configuration = try project.configuration(output: output)
    let interfaceLocalization = configuration.developmentInterfaceLocalization()

    var result: [StrictString] = [
      "  \(name.resolved(for: interfaceLocalization)):",
      runsOn(gitHubActionMachine)
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
      cache()
    ]

    switch platform {
    case .macOS:
      let xcodeVersion = ContinuousIntegrationJob.currentXcodeVersion
        .string(droppingEmptyPatch: true)
      result.append(
        script(
          heading: setXcodeUpStepName,
          localization: interfaceLocalization,
          commands: [
            "export DEVELOPER_DIR=/Applications/Xcode_\(xcodeVersion).app/Contents/Developer",
            export("DEVELOPER_DIR"),
            "xcodebuild \u{2D}version"
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
      let version = ContinuousIntegrationJob.currentExperimentalSwiftVersion
        .string(droppingEmptyPatch: true)
      let platform: StrictString =
        "https://raw.githubusercontent.com/apple/swift/swift\u{2D}\(version)\u{2D}branch/stdlib/public/Platform"
      result.append(
        script(
          heading: fetchWinSDKModuleMapsStepName,
          localization: interfaceLocalization,
          commands: [
            cURL(
              from: "\(platform)/ucrt.modulemap",
              to: "${UniversalCRTSdkDir}/Include/${UCRTVersion}/ucrt/module.modulemap",
              allowVariableSubstitution: true
            ),
            cURL(
              from: "\(platform)/visualc.modulemap",
              to: "${VCToolsInstallDir}/include/module.modulemap",
              allowVariableSubstitution: true
            ),
            cURL(
              from: "\(platform)/visualc.apinotes",
              to: "${VCToolsInstallDir}/include/visualc.apinotes",
              allowVariableSubstitution: true
            ),
            cURL(
              from: "\(platform)/winsdk.modulemap",
              to: "${UniversalCRTSdkDir}/Include/${UCRTVersion}/um/module.modulemap",
              allowVariableSubstitution: true
            ),
          ]
        )
      )
      result.append(
        script(
          heading: fetchICUStepName,
          localization: interfaceLocalization,
          commands: [
            cURL(
              "http://download.icu\u{2D}project.org/files/icu4c/64.2/icu4c\u{2D}64_2\u{2D}Win64\u{2D}MSVC2017.zip",
              andUnzipTo: "/c/Library/ICU\u{2D}64.2",
              windows: true
            ),
            "mv /c/Library/ICU\u{2D}64.2/bin64 /c/Library/ICU\u{2D}64.2/bin",
            prependPath("/c/Library/ICU\u{2D}64.2/bin")
          ]
        )
      )
      let downloads = ContinuousIntegrationJob.experimentalDownloads
      result.append(
        script(
          heading: installSwiftStepName,
          localization: interfaceLocalization,
          commands: [
            cURL(
              "\(downloads)/toolchain\u{2D}windows\u{2D}x64.zip",
              andUnzipTo: "/c",
              windows: true,
              doubleWrapped: true
            ),
            cURL(
              "\(downloads)/sdk\u{2D}windows\u{2D}x64.zip",
              andUnzipTo: "/c",
              windows: true,
              doubleWrapped: true
            ),
            prependPath(
              "/c/Library/Developer/Toolchains/unknown\u{2D}Asserts\u{2D}development.xctoolchain/usr/bin"
            ),
            copy(
              from:
                "/c/Library/Developer/Platforms/Windows.platform/Developer/SDKs/Windows.sdk/usr/bin",
              to: "/c/Library/Swift/Current/bin"
            ),
            prependPath("/c/Library/Swift/Current/bin"),
            prependPath(
              "/c/Library/Developer/Platforms/Windows.platform/Developer/Library/XCTest-development/usr/bin"
            ),
            "swift \u{2D}\u{2D}version"
          ]
        )
      )
    case .linux:
      result.append(contentsOf: [
        script(
          heading: installSwiftPMDependenciesStepName,
          localization: interfaceLocalization,
          commands: [
            aptGet(["libsqlite3\u{2D}dev", "libncurses\u{2D}dev"])
          ]
        ),
        script(
          heading: installCURLStepName,
          localization: interfaceLocalization,
          commands: [
            aptGet(["curl"])
          ]
        )
      ])
    case .tvOS, .iOS, .watchOS:
      unreachable()
    case .android:
      let version = ContinuousIntegrationJob.workaroundAndroidSwiftVersion
        .string(droppingEmptyPatch: true)
      result.append(contentsOf: [
        script(
          heading: installSwiftStepName,
          localization: interfaceLocalization,
          commands: [
            cURL(
              "https://swift.org/builds/swift\u{2D}\(version)\u{2D}release/ubuntu1804/swift\u{2D}\(version)\u{2D}RELEASE/swift\u{2D}\(version)\u{2D}RELEASE\u{2D}ubuntu18.04.tar.gz",
              andUntarTo: "/",
              sudoCopy: true
            ),
            "swift \u{2D}\u{2D}version",
          ]
        ),
        script(
          heading: fetchCrossCompilationToolchainStepName,
          localization: interfaceLocalization,
          commands: [
            cURL(
              "\(ContinuousIntegrationJob.experimentalDownloads)/toolchain\u{2D}linux\u{2D}x64.zip",
              andUnzipTo: "/",
              sudoCopy: true
            ),
            grantPermissions(to: "/Library"),
            "/Library/Developer/Toolchains/unknown\u{2D}Asserts\u{2D}development.xctoolchain/usr/bin/swift \u{2D}\u{2D}version"
          ]
        ),
        script(
          heading: fetchAndroidSDKStepName,
          localization: interfaceLocalization,
          commands: [
            cURL(
              "\(ContinuousIntegrationJob.experimentalDownloads)/sdk\u{2D}android\u{2D}x64.zip",
              andUnzipTo: "/"
            ),
            "sed \u{2D}i \u{2D}e s~C:/Microsoft/AndroidNDK64/android\u{2D}ndk\u{2D}r16b~${ANDROID_HOME}/ndk\u{2D}bundle~g /Library/Developer/Platforms/Android.platform/Developer/SDKs/Android.sdk/usr/lib/swift/android/x86_64/glibc.modulemap",
            aptGet(["patchelf"], sudo: true),
            "patchelf \u{2D}\u{2D}replace\u{2D}needed lib/swift/android/x86_64/libswiftCore.so libswiftCore.so /Library/Developer/Platforms/Android.platform/Developer/SDKs/Android.sdk/usr/lib/swift/android/libswiftSwiftOnoneSupport.so",
            "patchelf \u{2D}\u{2D}replace\u{2D}needed lib/swift/android/x86_64/libswiftCore.so libswiftCore.so /Library/Developer/Platforms/Android.platform/Developer/SDKs/Android.sdk/usr/lib/swift/android/libswiftGlibc.so",
            copy(
              from: "${ANDROID_HOME}/ndk\u{2D}bundle/platforms/android\u{2D}29/arch\u{2D}x86_64",
              to: "/Library/Developer/Platforms/Android.platform/Developer/SDKs/Android.sdk"
            )
          ]
        ),
        script(
          heading: fetchICUStepName,
          localization: interfaceLocalization,
          commands: [
            cURL(
              "\(ContinuousIntegrationJob.experimentalDownloads)/icu\u{2D}android\u{2D}x64.zip",
              andUnzipTo: "/"
            ),
            cURL(
              from: "\(ContinuousIntegrationJob.experimentalDownloads)/libicudt64.so",
              to: "/Library/icu\u{2D}64/usr/lib/libicudt64.so"
            )
          ]
        )
      ])
    }

    switch platform {
    case .macOS, .linux, .iOS, .watchOS, .tvOS:
      result.append(
        script(
          heading: refreshStepName,
          localization: interfaceLocalization,
          commands: [
            refreshCommand(configuration: configuration)
          ]
        )
      )
      let mainStepName = self == .deployment ? documentStepName : validateStepName
      result.append(
        script(
          heading: mainStepName,
          localization: interfaceLocalization,
          commands: [
            validateCommand(configuration: configuration)
          ]
        )
      )
    case .windows:
      result.append(
        script(
          heading: compressPATHStepName,
          localization: interfaceLocalization,
          commands: [
            "export PATH=$(echo -n $PATH | awk -v RS=: -v ORS=: '!($0 in a) {a[$0]; print $0}')",
            export("PATH")
          ]
        )
      )
      var clones: [StrictString] = []
      #if !(os(Windows) || os(Android))  // #workaround(SwiftSyntax 0.50100.0, Cannot build.)
        let graph = try project.cachedWindowsPackageGraph()
        for package in graph.packages.sorted(by: { $0.name < $1.name }) {
          if let version = package.underlyingPackage.manifest.version {
            let url = package.underlyingPackage.manifest.url
            clones.append(
              "git clone \(url) .build/SDG/Dependencies/\(package.name) \u{2D}\u{2D}branch \(version.description) \u{2D}\u{2D}depth 1 \u{2D}\u{2D}config advice.detachedHead=false"
            )
          }
        }
      #endif
      result.append(
        script(
          heading: fetchDependenciesStepName,
          localization: interfaceLocalization,
          commands: clones
        )
      )
      result.append(
        script(
          heading: buildStepName,
          localization: interfaceLocalization,
          commands: [
            "cmake \u{2D}G Ninja \u{2D}S .github/workflows/Windows \u{2D}B .build/SDG/CMake \u{2D}DCMAKE_Swift_FLAGS=\u{27}\u{2D}resource\u{2D}dir C:\u{5C}Library\u{5C}Developer\u{5C}Platforms\u{5C}Windows.platform\u{5C}Developer\u{5C}SDKs\u{5C}Windows.sdk\u{5C}usr\u{5C}lib\u{5C}swift \u{2D}I C:\u{5C}Library\u{5C}Developer\u{5C}Platforms\u{5C}Windows.platform\u{5C}Developer\u{5C}Library\u{5C}XCTest\u{2D}development\u{5C}usr\u{5C}lib\u{5C}swift\u{5C}windows\u{5C}x86_64 \u{2D}L C:\u{5C}Library\u{5C}Developer\u{5C}Platforms\u{5C}Windows.platform\u{5C}Developer\u{5C}SDKs\u{5C}Windows.sdk\u{5C}usr\u{5C}lib\u{5C}swift\u{5C}windows \u{2D}L C:\u{5C}Library\u{5C}Developer\u{5C}Platforms\u{5C}Windows.platform\u{5C}Developer\u{5C}Library\u{5C}XCTest\u{2D}development\u{5C}usr\u{5C}lib\u{5C}swift\u{5C}windows\u{27}",
            "cmake \u{2D}\u{2D}build \u{27}.build/SDG/CMake\u{27}",
          ]
        )
      )
      result.append(
        script(
          heading: testStepName,
          localization: interfaceLocalization,
          commands: [
            "cd .build/SDG/CMake",
            "ctest \u{2D}\u{2D}verbose"
          ]
        )
      )
    case .android:
      result.append(
        script(
          heading: buildStepName,
          localization: interfaceLocalization,
          commands: [
            "export TARGETING_ANDROID=true",
            "swift build \u{2D}\u{2D}destination .github/workflows/Android/SDK.json \u{5C}",
            "  \u{2D}\u{2D}build\u{2D}tests \u{2D}\u{2D}enable\u{2D}test\u{2D}discovery \u{5C}",
            "  \u{2D}Xswiftc \u{2D}resource\u{2D}dir \u{2D}Xswiftc /Library/Developer/Platforms/Android.platform/Developer/SDKs/Android.sdk/usr/lib/swift \u{5C}",
            "  \u{2D}Xswiftc \u{2D}tools\u{2D}directory \u{2D}Xswiftc ${ANDROID_HOME}/ndk\u{2D}bundle/toolchains/llvm/prebuilt/linux\u{2D}x86_64/bin \u{5C}",
            "  \u{2D}Xswiftc \u{2D}Xclang\u{2D}linker \u{2D}Xswiftc \u{2D}\u{2D}gcc\u{2D}toolchain=${ANDROID_HOME}/ndk\u{2D}bundle/toolchains/x86_64\u{2D}4.9/prebuilt/linux\u{2D}x86_64 \u{5C}",
            "  \u{2D}Xcc \u{2D}I${ANDROID_HOME}/ndk\u{2D}bundle/sysroot/usr/include \u{5C}",
            "  \u{2D}Xcc \u{2D}I${ANDROID_HOME}/ndk\u{2D}bundle/sysroot/usr/include/x86_64\u{2D}linux\u{2D}android \u{5C}",
            "  \u{2D}Xswiftc \u{2D}I \u{2D}Xswiftc /Library/Developer/Platforms/Android.platform/Developer/Library/XCTest\u{2D}development/usr/lib/swift/android/x86_64 \u{5C}",
            "  \u{2D}Xswiftc \u{2D}L \u{2D}Xswiftc /Library/Developer/Platforms/Android.platform/Developer/Library/XCTest\u{2D}development/usr/lib/swift/android",
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
            copy(
              from:
                "${ANDROID_HOME}/ndk\u{2D}bundle/sources/cxx\u{2D}stl/llvm\u{2D}libc++/libs/x86_64",
              to: productsDirectory
            ),
            copy(from: "/Library/icu\u{2D}64/usr/lib", to: productsDirectory),
            copy(
              from:
                "/Library/Developer/Platforms/Android.platform/Developer/SDKs/Android.sdk/usr/lib/swift/android",
              to: productsDirectory
            ),
            copy(
              from:
                "/Library/Developer/Platforms/Android.platform/Developer/Library/XCTest\u{2D}development/usr/lib/swift/android",
              to: productsDirectory
            )
          ]
        )
      )
      result.append(contentsOf: [
        step(uploadTestsStepName, localization: interfaceLocalization),
        uses(
          "actions/upload\u{2D}artifact@v1",
          with: [
            "name": "tests",
            "path": "\(productsDirectory)"
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
            "path": "\(productsDirectory)"
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
            "chmod +x .build/SDG/Emulator.sh"
          ]
        ),
        // #workaround(There is no official action for this yet.)
        step(installEmulatorStepName, localization: interfaceLocalization),
        uses("malinskiy/action\u{2D}android/install\u{2D}sdk@release/0.0.5"),
        step(testStepName, localization: interfaceLocalization),
        uses(
          "malinskiy/action\u{2D}android/emulator\u{2D}run\u{2D}cmd@release/0.0.5",
          with: [
            "abi": "x86_64",
            "cmd": ".build/SDG/Emulator.sh"
          ]
        )
      ])
    }

    switch platform {
    case .macOS, .windows, .tvOS, .iOS, .android, .watchOS:
      break
    case .linux:
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
        "        GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}"
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

  private var fetchWinSDKModuleMapsStepName: UserFacing<StrictString, InterfaceLocalization> {
    return UserFacing({ (localization) in
      switch localization {
      case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
        return "Fetch WinSDK module maps"
      case .deutschDeutschland:
        return "WinSDK‐Modulabbildungen holen"
      }
    })
  }

  private var fetchICUStepName: UserFacing<StrictString, InterfaceLocalization> {
    return UserFacing({ (localization) in
      switch localization {
      case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
        return "Fetch ICU"
      case .deutschDeutschland:
        return "ICU holen"
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

  private var fetchCrossCompilationToolchainStepName:
    UserFacing<StrictString, InterfaceLocalization>
  {
    return UserFacing({ (localization) in
      switch localization {
      case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
        return "Fetch cross‐compilation toolchain"
      case .deutschDeutschland:
        return "Fremdübersetzungs Werkzeugkette holen"
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

  private var installCURLStepName: UserFacing<StrictString, InterfaceLocalization> {
    return UserFacing({ (localization) in
      switch localization {
      case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
        return "Install cURL"
      case .deutschDeutschland:
        return "cURL installieren"
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

  private var compressPATHStepName: UserFacing<StrictString, InterfaceLocalization> {
    return UserFacing({ (localization) in
      switch localization {
      case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
        return "Compress PATH"
      case .deutschDeutschland:
        return "PATH komprimieren"
      }
    })
  }

  private var fetchDependenciesStepName: UserFacing<StrictString, InterfaceLocalization> {
    return UserFacing({ (localization) in
      switch localization {
      case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
        return "Fetch dependencies"
      case .deutschDeutschland:
        return "Abhängigkeiten holen"
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

  private var installEmulatorStepName: UserFacing<StrictString, InterfaceLocalization> {
    return UserFacing({ (localization) in
      switch localization {
      case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
        return "Install emulator"
      case .deutschDeutschland:
        return "Emulator installieren"
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
