/*
 Workspace.swift

 This source file is part of the Workspace open source project.
 Diese Quelldatei ist Teil des qeulloffenen Arbeitsbereich‐Projekt.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2018–2019 Jeremy David Giesbrecht and the Workspace project contributors.
 Urheberrecht ©2018–2019 Jeremy David Giesbrecht und die Mitwirkenden des Arbeitsbereich‐Projekts.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import WorkspaceConfiguration

public enum Metadata {

    public static let latestStableVersion = Version(0, 23, 0)
    public static let thisVersion: Version? = nil // Set this to latestStableWorkspaceVersion for release commits, nil the rest of the time.

    public static let packageURL = URL(string: "https://github.com/SDGGiesbrecht/Workspace")!
    public static let issuesURL = packageURL.appendingPathComponent("issues")
    public static let documentationURL = URL(string: "https://sdggiesbrecht.github.io/Workspace")!
}

public let configuration: WorkspaceConfiguration = {
    let configuration = WorkspaceConfiguration()
    configuration._applySDGDefaults()

    configuration.supportedPlatforms.remove(.iOS)
    configuration.supportedPlatforms.remove(.watchOS)
    configuration.supportedPlatforms.remove(.tvOS)

    configuration.documentation.currentVersion = Metadata.latestStableVersion
    configuration.documentation.projectWebsite = URL(string: "https://github.com/SDGGiesbrecht/Workspace#workspace")!
    configuration.documentation.documentationURL = Metadata.documentationURL
    configuration.documentation.repositoryURL = Metadata.packageURL

    configuration.documentation.api.yearFirstPublished = 2017

    configuration.documentation.localizations = ["🇬🇧EN", "🇺🇸EN", "🇨🇦EN", "🇩🇪DE"]
    configuration.projectName = [
        "🇩🇪DE": "Arbeitsbereich"
    ]

    configuration.repository.ignoredPaths.insert("Tests/Mock Projects")

    configuration.documentation.api.encryptedTravisCIDeploymentKey = "WfBLnstfcBi0Z8yioAfvEnoK/R59u+fLag3vBulzdePBF60jRQbT4qCr1wCuBsp1JHWJlJSM/GmVsqFEJgt1hJOL4lfx2proY6XUBNdn3BElPkDBgG2eIbPFHkdCtDLGSVqzNhUca6MKWJ4qZCujLKMSfvb+OBylzdhhVd+j5l/Icza0shRpAWDaSWiio3RkvxD08lFm9Fvlg4d09uRKzGPhlg1PjUP7bbl9xcoEqh/4ZzL2GTXGbHfJJOkQQXoPTbF0R8LiYVJVA5euFfHQw1rFepHhfSdhililvC0ld/ksSpQRLwCY93Sb9wOMRrc6HASApRALi9M3TGOQQrEI/Kjh4lJ+Okjg7wZnKixAuGPMUH0DWy57t+gSy51PyFi0bHfJzGm3Y5t8gtimsIiiWbWlNyZF3EndFmtQRfzLjfdJwHx34Zj44kX+rr7p29hkTlfv9YUuOP6CizVQnDfAoWPyv6lsD/PSYTdw97yWBoNXNVbKp8Ge4MmgtpYuWdOaZj0Lim0WZ/04A0clXW7wj/G+MJCbeRiFxKyVi6OUdhRy+BkVVqdNul892/vKyeLwJp9d6DtDkwy11TaxLeGpu0eBWUEhfQJIUG/EaE5FD1v6GsZpmy8FF+XVKeOPDI+kHuHQ6hUjXnOM8HGr0HGpbiQ9Nw0mv4ozUi+EFv7429Q="

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
        "SDGWebLocalizations",

        // Swift
        "Foundation",
        "Dispatch",
        "XCTest",

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
        "SwiftSyntax"
    ]

    return configuration
}()
