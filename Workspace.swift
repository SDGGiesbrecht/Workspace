/*
 Workspace.swift

 This source file is part of the Workspace open source project.
 Diese Quelldatei ist Teil des quelloffenen Arbeitsbereich‐Projekt.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2018–2022 Jeremy David Giesbrecht and the Workspace project contributors.
 Urheberrecht ©2018–2022 Jeremy David Giesbrecht und die Mitwirkenden des Arbeitsbereich‐Projekts.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import WorkspaceConfiguration

public enum Metadata {

  public static let latestStableVersion = Version(0, 39, 0)
  // Set this to latestStableVersion for release commits, nil the rest of the time.
  public static let thisVersion: Version? = nil

  public static let packageURL = URL(string: "https://github.com/SDGGiesbrecht/Workspace")!
  public static let issuesURL = packageURL.appendingPathComponent("issues")
  public static let documentationURL = URL(string: "https://sdggiesbrecht.github.io/Workspace")!
}

public let configuration: WorkspaceConfiguration = {
  let configuration = WorkspaceConfiguration()
  configuration._applySDGDefaults()

  configuration.supportedPlatforms.remove(.windows)
  configuration.supportedPlatforms.remove(.web)
  configuration.supportedPlatforms.remove(.tvOS)
  configuration.supportedPlatforms.remove(.iOS)
  configuration.supportedPlatforms.remove(.android)
  configuration.supportedPlatforms.remove(.watchOS)

  configuration.documentation.currentVersion = Metadata.latestStableVersion
  configuration.documentation.projectWebsite = URL(
    string: "https://github.com/SDGGiesbrecht/Workspace#workspace"
  )!
  configuration.documentation.documentationURL = Metadata.documentationURL
  configuration.documentation.repositoryURL = Metadata.packageURL

  configuration.documentation.api.yearFirstPublished = 2017

  configuration.documentation.localizations = ["🇬🇧EN", "🇺🇸EN", "🇨🇦EN", "🇩🇪DE"]
  configuration.projectName = [
    "🇩🇪DE": "Arbeitsbereich"
  ]

  configuration.repository.ignoredPaths.insert("Tests/Mock Projects")

  configuration._applySDGOverrides()
  configuration._validateSDGStandards()

  // Optimizations
  configuration.documentation.api.ignoredDependencies = [

    // CommonMark
    "CCommonMark",

    // llbuild
    "libllbuild",
    "llbuildBasic",
    "llbuildBuildSystem",
    "llbuildCore",
    "llbuildSwift",
    "llvmDemangle",
    "llvmSupport",

    // SDGCommandLine
    "SDGCommandLine",
    "SDGExportedCommandLineInterface",
    "SDGCommandLineLocalizations",
    "SDGCommandLineTestUtilities",

    // SDGCornerstone
    "SDGCalendar",
    "SDGCollections",
    "SDGCornerstoneLocalizations",
    "SDGExternalProcess",
    "SDGLocalization",
    "SDGLocalizationTestUtilities",
    "SDGLogic",
    "SDGMathematics",
    "SDGPersistence",
    "SDGPersistenceTestUtilities",
    "SDGTesting",
    "SDGText",
    "SDGVersioning",
    "SDGXCTestUtilities",

    // SDGSwift
    "SDGCMarkShims",
    "SDGSwift",
    "SDGSwiftConfigurationLoading",
    "SDGSwiftLocalizations",
    "SDGSwiftPackageManager",
    "SDGSwiftSource",
    "SDGXcode",

    // SDGWeb
    "SDGCSS",
    "SDGHTML",
    "SDGWeb",
    "SDGWebLocalizations",

    // Swift
    "Foundation",
    "Dispatch",
    "XCTest",

    // SwiftFormat
    "SwiftFormat",
    "SwiftFormatConfiguration",
    "SwiftFormatCore",
    "SwiftFormatPrettyPrint",
    "SwiftFormatRules",
    "SwiftFormatWhitespaceLinter",

    // SwiftPM
    "Basic",
    "Build",
    "clibc",
    "POSIX",
    "PackageGraph",
    "PackageLoading",
    "PackageModel",
    "SPMLLBuild",
    "SPMLibc",
    "SPMUtility",
    "SourceControl",
    "Workspace",
    "Xcodeproj",

    // SwiftSyntax
    "_CSwiftSyntax",
    "SwiftSyntax",
  ]

  return configuration
}()
