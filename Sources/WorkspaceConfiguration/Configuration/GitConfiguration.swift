/*
 GitConfiguration.swift

 This source file is part of the Workspace open source project.
 Diese Quelldatei ist Teil des qeulloffenen Workspace‐Projekt.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2018–2019 Jeremy David Giesbrecht and the Workspace project contributors.
 Urheberrecht ©2018–2019 Jeremy David Giesbrecht und die Mitwirkenden des Workspace‐Projekts.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

/// Options related to Git.
public struct GitConfiguration : Codable {

    /// Whether or not to manage the project’s Git configuration files.
    ///
    /// This is off by default.
    public var manage: Bool = false

    /// Additional entries to append to the standard gitignore file.
    public var additionalGitIgnoreEntries: [String] = []
}
