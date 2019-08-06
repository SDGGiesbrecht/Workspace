/*
 RepositoryConfiguration.swift

 This source file is part of the Workspace open source project.
 Diese Quelldatei ist Teil des qeulloffenen Workspace‐Projekt.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2018–2019 Jeremy David Giesbrecht and the Workspace project contributors.
 Urheberrecht ©2018–2019 Jeremy David Giesbrecht und die Mitwirkenden des Workspace‐Projekts.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

/// Options related to the project repository.
public struct RepositoryConfiguration : Codable {

    /// A set of file extensions which source operations should ignore.
    ///
    /// These will not receive headers or be proofread.
    ///
    /// Workspace automatically skips files it does not understand, but it prints a warning first. These warnings can be silenced by adding the file type to this list. For standard file types related to Swift projects, please [request that support be added](https://github.com/SDGGiesbrecht/Workspace/issues).
    public var ignoredFileTypes: Set<String> = [
        "04",
        "cfg",
        "cmake",
        "dsidx",
        "DS_Store",
        "dtrace",
        "entitlements",
        "gyb",
        "gz",
        "icns",
        "in",
        "inc",
        "LinuxMain.swift",
        "llbuild",
        "LLVM",
        "modulemap",
        "ninja",
        "nojekyll",
        "pep8",
        "pc",
        "plist",
        "pins",
        "png",
        "resolved",
        "svg",
        "swift\u{2D}build",
        "testspec",
        "tgz",
        "txt",
        "TXT",
        "xcconfig",
        "xcsettings",
        "XCTestManifests.swift",
        "xcworkspacedata"
    ]

    public static let _refreshScriptMacOSFileName: StrictString = "Refresh (macOS).command"
    public static let _refreshScriptLinuxFileName: StrictString = "Refresh (Linux).sh"

    /// Paths which source operations should ignore.
    ///
    /// Files in these paths will not receive headers or be proofread.
    ///
    /// The paths must be specified relative to the package root.
    public var ignoredPaths: Set<String> = [
        "docs",
        String(RepositoryConfiguration._refreshScriptMacOSFileName),
        String(RepositoryConfiguration._refreshScriptLinuxFileName)
    ]
}
