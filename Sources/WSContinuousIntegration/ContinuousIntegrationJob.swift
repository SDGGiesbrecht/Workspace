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

  private func appendLanguage(to command: StrictString, configuration: WorkspaceConfiguration)
    -> StrictString
  {
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
    for command in commands.prepending("set \u{2D}x") {
      result.append("        \(command)")
    }
    return result.joinedAsLines()
  }

  private func export(_ environmentVariable: StrictString) -> StrictString {
    return "echo ::set\u{2D}env name=\(environmentVariable)::\u{22}${\(environmentVariable)}\u{22}"
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
            "xcodebuild \u{2D}version",
            export("DEVELOPER_DIR")
          ]
        )
      )
    case .windows:
      result.append(script(heading: setVisualStudioUpStepName, localization: interfaceLocalization, commands: [
        "cd \u{27}/c/Program Files (x86)/Microsoft Visual Studio/2019/Enterprise/VC/Auxiliary/Build\u{27}",
        "echo \u{27}export \u{2D}p > exported_environment.sh\u{27} > nested_bash.sh",
        "echo \u{27}vcvarsall.bat x64 &\u{26} \u{22}C:/Program Files/Git/usr/bin/bash\u{22} \u{2D}c ./nested_bash.sh\u{27} > export_environment.bat",
        "cmd \u{22}/c export_environment.bat\u{22}",
        "source ./exported_environment.sh",
        export("CommandPromptType"),
        export("DevEnvDir"),
        export("__DOTNET_ADD_64BIT"),
        export("__DOTNET_PREFERRED_BITNESS"),
        export("ExtensionSdkDir"),
        export("Framework40Version"),
        export("FrameworkDir"),
        export("FrameworkDIR64"),
        export("FrameworkVersion"),
        export("FrameworkVersion64"),
        export("FSHARPINSTALLDIR"),
        export("HTMLHelpDir"),
        export("INCLUDE"),
        export("LIB"),
        export("LIBPATH"),
        export("NETFXSDKDir"),
        export("PATH"),
        export("Platform"),
        export("PROMPT"),
        export("UniversalCRTSdkDir"),
        export("UCRTVersion"),
        export("VCIDEInstallDir"),
        export("VCINSTALLDIR"),
        export("VCToolsInstallDir"),
        export("VCToolsRedistDir"),
        export("VCToolsVersion"),
        export("VisualStudioVersion"),
        export("VS160COMNTOOLS"),
        export("VSCMD_ARG_app_plat"),
        export("VSCMD_ARG_HOST_ARCH"),
        export("VSCMD_ARG_TGT_ARCH"),
        export("__VSCMD_PREINIT_PATH"),
        export("VSCMD_VER"),
        export("VSINSTALLDIR"),
        export("VSSDKINSTALL"),
        export("VSSDK150INSTALL"),
        export("WindowsLibPath"),
        export("WindowsSdkBinPath"),
        export("WindowsSdkDir"),
        export("WindowsSDK_ExecutablePath_x64"),
        export("WindowsSDK_ExecutablePath_x86"),
        export("WindowsSDKLibVersion"),
        export("WindowsSdkVerBinPath"),
        export("WindowsSDKVersion")
      ]))
    case .linux, .tvOS, .iOS, .android, .watchOS:
      break
    }

    result.append(step(validateStepName, localization: interfaceLocalization))

    switch platform {
    case .macOS, .linux, .tvOS, .iOS, .android, .watchOS:
      break
    case .windows:
      result.append("      shell: bash")
    }

    #warning("Continue here.")
    result.append("      run: |")

    switch platform {
    case .macOS:
      break
    case .windows:
      let version = ContinuousIntegrationJob.currentExperimentalSwiftVersion
        .string(droppingEmptyPatch: true)
      result.append(contentsOf: [
        commandEntry("repository_directory=$(pwd)"),
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
          "curl \u{2D}L \u{2D}o toolchain\u{2D}windows\u{2D}x64.zip \u{27}https://github.com/SDGGiesbrecht/Workspace/releases/download/experimental%E2%80%90swift%E2%80%90pre%E2%80%905.2%E2%80%902020%E2%80%9002%E2%80%9005/toolchain\u{2D}windows\u{2D}x64.zip\u{27}"
        ),
        commandEntry(
          "curl \u{2D}L \u{2D}o sdk\u{2D}windows\u{2D}x64.zip \u{27}https://github.com/SDGGiesbrecht/Workspace/releases/download/experimental%E2%80%90swift%E2%80%90pre%E2%80%905.2%E2%80%902020%E2%80%9002%E2%80%9005/sdk\u{2D}windows\u{2D}x64.zip\u{27}"
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
      let version = ContinuousIntegrationJob.workaroundAndroidSwiftVersion
        .string(droppingEmptyPatch: true)
      result.append(contentsOf: [
        commandEntry("echo \u{27}Fetching Swift...\u{27}"),
        commandEntry("repository_directory=$(pwd)"),
        commandEntry("mkdir \u{2D}p .build/SDG/Swift"),
        commandEntry("cd .build/SDG/Swift"),
        commandEntry(
          "curl \u{2D}o Swift.tar.gz \u{27}https://swift.org/builds/swift\u{2D}\(version)\u{2D}release/ubuntu1804/swift\u{2D}\(version)\u{2D}RELEASE/swift\u{2D}\(version)\u{2D}RELEASE\u{2D}ubuntu18.04.tar.gz\u{27}"
        ),
        commandEntry("tar \u{2D}\u{2D}extract \u{2D}\u{2D}file Swift.tar.gz"),
        commandEntry(
          "sudo cp \u{2D}R swift\u{2D}\(version)\u{2D}RELEASE\u{2D}ubuntu18.04/usr/* /usr/"
        ),
        commandEntry("cd \u{22}${repository_directory}\u{22}"),
        commandEntry("swift \u{2D}\u{2D}version"),
        "",
        commandEntry("echo \u{27}Fetching Swift cross‐compilation toolchain...\u{27}"),
        commandEntry("mkdir \u{2D}p .build/SDG/Experimental_Swift"),
        commandEntry("cd .build/SDG/Experimental_Swift"),
        commandEntry(
          "curl \u{2D}L \u{2D}o toolchain\u{2D}linux\u{2D}x64.zip \u{27}https://github.com/SDGGiesbrecht/Workspace/releases/download/experimental%E2%80%90swift%E2%80%90pre%E2%80%905.2%E2%80%902020%E2%80%9002%E2%80%9005/toolchain\u{2D}linux\u{2D}x64.zip\u{27}"
        ),
        commandEntry("unzip toolchain\u{2D}linux\u{2D}x64.zip"),
        commandEntry("sudo mv toolchain\u{2D}linux\u{2D}x64/Library /Library"),
        commandEntry("chmod \u{2D}R a+rwx /Library"),
        commandEntry("cd \u{22}${repository_directory}\u{22}"),
        commandEntry(
          "/Library/Developer/Toolchains/unknown\u{2D}Asserts\u{2D}development.xctoolchain/usr/bin/swift \u{2D}\u{2D}version"
        ),
        "",
        commandEntry("echo \u{27}Fetching Swift Android SDK...\u{27}"),
        commandEntry("cd .build/SDG/Experimental_Swift"),
        commandEntry(
          "curl \u{2D}L \u{2D}o sdk\u{2D}android\u{2D}x64.zip \u{27}https://github.com/SDGGiesbrecht/Workspace/releases/download/experimental%E2%80%90swift%E2%80%90pre%E2%80%905.2%E2%80%902020%E2%80%9002%E2%80%9005/sdk\u{2D}android\u{2D}x64.zip\u{27}"
        ),
        commandEntry("unzip sdk\u{2D}android\u{2D}x64.zip"),
        commandEntry(
          "mv sdk\u{2D}android\u{2D}x64/Library/Developer/Platforms /Library/Developer/Platforms"
        ),
        commandEntry(
          "sed \u{2D}i \u{2D}e s~C:/Microsoft/AndroidNDK64/android\u{2D}ndk\u{2D}r16b~${ANDROID_HOME}/ndk\u{2D}bundle~g /Library/Developer/Platforms/Android.platform/Developer/SDKs/Android.sdk/usr/lib/swift/android/x86_64/glibc.modulemap"
        ),
        commandEntry("sudo apt\u{2D}get update \u{2D}\u{2D}yes"),
        commandEntry("sudo apt\u{2D}get install \u{2D}\u{2D}yes patchelf"),
        commandEntry(
          "patchelf \u{2D}\u{2D}replace\u{2D}needed lib/swift/android/x86_64/libswiftCore.so libswiftCore.so /Library/Developer/Platforms/Android.platform/Developer/SDKs/Android.sdk/usr/lib/swift/android/libswiftSwiftOnoneSupport.so"
        ),
        commandEntry(
          "patchelf \u{2D}\u{2D}replace\u{2D}needed lib/swift/android/x86_64/libswiftCore.so libswiftCore.so /Library/Developer/Platforms/Android.platform/Developer/SDKs/Android.sdk/usr/lib/swift/android/libswiftGlibc.so"
        ),
        commandEntry(
          "cp \u{2D}R \u{22}${ANDROID_HOME}/ndk\u{2D}bundle/platforms/android\u{2D}29/arch\u{2D}x86_64/\u{22}* /Library/Developer/Platforms/Android.platform/Developer/SDKs/Android.sdk"
        ),
        commandEntry("cd \u{22}${repository_directory}\u{22}"),
        "",
        commandEntry("echo \u{27}Fetching ICU...\u{27}"),
        commandEntry("cd .build/SDG/Experimental_Swift"),
        commandEntry(
          "curl \u{2D}L \u{2D}o icu\u{2D}android\u{2D}x64.zip \u{27}https://github.com/SDGGiesbrecht/Workspace/releases/download/experimental%E2%80%90swift%E2%80%90pre%E2%80%905.2%E2%80%902020%E2%80%9002%E2%80%9005/icu\u{2D}android\u{2D}x64.zip\u{27}"
        ),
        commandEntry("unzip icu\u{2D}android\u{2D}x64.zip"),
        commandEntry("mv icu\u{2D}android\u{2D}x64/Library/icu\u{2D}64 /Library/icu\u{2D}64"),
        commandEntry(
          "curl \u{2D}L \u{2D}o libicudt64.so \u{27}https://github.com/SDGGiesbrecht/Workspace/releases/download/experimental%E2%80%90swift%E2%80%90pre%E2%80%905.2%E2%80%902020%E2%80%9002%E2%80%9005/libicudt64.so\u{27}"
        ),
        commandEntry("mv libicudt64.so /Library/icu\u{2D}64/usr/lib/libicudt64.so"),
        commandEntry("cd \u{22}${repository_directory}\u{22}"),
        ""
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
      #if !(os(Windows) || os(Android))  // #workaround(SwiftSyntax 0.50100.0, Cannot build.)
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
      #endif
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
        commandEntry("echo \u{27}Building \(try project.packageName())...\u{27}"),
        commandEntry("export TARGETING_ANDROID=true"),
        commandEntry(
          "swift build \u{2D}\u{2D}destination .github/workflows/Android/SDK.json \u{5C}"
        ),
        commandEntry(
          "  \u{2D}\u{2D}build\u{2D}tests \u{2D}\u{2D}enable\u{2D}test\u{2D}discovery \u{5C}"
        ),
        commandEntry(
          "  \u{2D}Xswiftc \u{2D}resource\u{2D}dir \u{2D}Xswiftc /Library/Developer/Platforms/Android.platform/Developer/SDKs/Android.sdk/usr/lib/swift \u{5C}"
        ),
        commandEntry(
          "  \u{2D}Xswiftc \u{2D}tools\u{2D}directory \u{2D}Xswiftc ${ANDROID_HOME}/ndk\u{2D}bundle/toolchains/llvm/prebuilt/linux\u{2D}x86_64/bin \u{5C}"
        ),
        commandEntry(
          "  \u{2D}Xswiftc \u{2D}Xclang\u{2D}linker \u{2D}Xswiftc \u{2D}\u{2D}gcc\u{2D}toolchain=${ANDROID_HOME}/ndk\u{2D}bundle/toolchains/x86_64\u{2D}4.9/prebuilt/linux\u{2D}x86_64 \u{5C}"
        ),
        commandEntry(
          "  \u{2D}Xcc \u{2D}I${ANDROID_HOME}/ndk\u{2D}bundle/sysroot/usr/include \u{5C}"
        ),
        commandEntry(
          "  \u{2D}Xcc \u{2D}I${ANDROID_HOME}/ndk\u{2D}bundle/sysroot/usr/include/x86_64\u{2D}linux\u{2D}android \u{5C}"
        ),
        commandEntry(
          "  \u{2D}Xswiftc \u{2D}I \u{2D}Xswiftc /Library/Developer/Platforms/Android.platform/Developer/Library/XCTest\u{2D}development/usr/lib/swift/android/x86_64 \u{5C}"
        ),

        commandEntry(
          "  \u{2D}Xswiftc \u{2D}L \u{2D}Xswiftc /Library/Developer/Platforms/Android.platform/Developer/Library/XCTest\u{2D}development/usr/lib/swift/android"
        ),
        "",
        commandEntry("echo \u{27}Copying libraries...\u{27}"),
        commandEntry(
          "cp \u{2D}R \u{22}${ANDROID_HOME}/ndk\u{2D}bundle/sources/cxx\u{2D}stl/llvm\u{2D}libc++/libs/x86_64/\u{22}* .build/x86_64\u{2D}unknown\u{2D}linux\u{2D}android/debug"
        ),
        commandEntry(
          "cp \u{2D}R /Library/icu\u{2D}64/usr/lib/* .build/x86_64\u{2D}unknown\u{2D}linux\u{2D}android/debug"
        ),
        commandEntry(
          "cp \u{2D}R /Library/Developer/Platforms/Android.platform/Developer/SDKs/Android.sdk/usr/lib/swift/android/* .build/x86_64\u{2D}unknown\u{2D}linux\u{2D}android/debug"
        ),
        commandEntry(
          "cp \u{2D}R /Library/Developer/Platforms/Android.platform/Developer/Library/XCTest\u{2D}development/usr/lib/swift/android/* .build/x86_64\u{2D}unknown\u{2D}linux\u{2D}android/debug"
        ),
        step(uploadTestsStepName, localization: interfaceLocalization),
        uses("actions/upload\u{2D}artifact@v1"),
        "      with:",
        "        name: tests",
        "        path: .build/x86_64\u{2D}unknown\u{2D}linux\u{2D}android/debug",
        "  Android_II:",
        "    name: \(androidIIJobName.resolved(for: interfaceLocalization))",
        "    runs\u{2D}on: macos\u{2D}\(ContinuousIntegrationJob.currentMacOSVersion.string(droppingEmptyPatch: true))",
        "    needs: Android",
        steps(),
        step(checkOutStepName, localization: interfaceLocalization),
        checkOut(),
        step(downloadTestsStepName, localization: interfaceLocalization),
        uses("actions/download\u{2D}artifact@v1"),
        "      with:",
        "        name: tests",
        "        path: .build/x86_64\u{2D}unknown\u{2D}linux\u{2D}android/debug",
        step(prepareScriptStepName, localization: interfaceLocalization),
        "      run: |",
        commandEntry("mkdir \u{2D}p .build/SDG"),
        commandEntry("echo \u{27}"),
        commandEntry("set \u{2D}e"),
        commandEntry("adb \u{2D}e push . /data/local/tmp/Package"),
        commandEntry(
          "adb \u{2D}e shell chmod \u{2D}R +x /data/local/tmp/Package/.build/x86_64\u{2D}unknown\u{2D}linux\u{2D}android/debug"
        ),
        commandEntry("adb \u{2D}e shell \u{5C}"),
        commandEntry(
          "  LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:/data/local/tmp/Package/.build/x86_64\u{2D}unknown\u{2D}linux\u{2D}android/debug \u{5C}"
        ),
        commandEntry("  HOME=/data/local/tmp/Home \u{5C}"),
        commandEntry("  SWIFTPM_PACKAGE_ROOT=/data/local/tmp/Package \u{5C}"),
        commandEntry(
          "  /data/local/tmp/Package/.build/x86_64\u{2D}unknown\u{2D}linux\u{2D}android/debug/\(try project.packageName())PackageTests.xctest"
        ),
        commandEntry("\u{27} > .build/SDG/Emulator.sh"),
        commandEntry("chmod +x .build/SDG/Emulator.sh"),
        // #workaround(There is no official action for this yet.)
        step(installEmulatorStepName, localization: interfaceLocalization),
        uses("malinskiy/action\u{2D}android/install\u{2D}sdk@release/0.0.5"),
        step(testStepName, localization: interfaceLocalization),
        uses("malinskiy/action\u{2D}android/emulator\u{2D}run\u{2D}cmd@release/0.0.5"),
        "      with:",
        "        abi: x86_64",
        "        cmd: .build/SDG/Emulator.sh"
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
        step(deployStepName, localization: interfaceLocalization),
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
