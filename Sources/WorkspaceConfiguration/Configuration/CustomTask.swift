/*
 CustomTask.swift

 This source file is part of the Workspace open source project.
 Diese Quelldatei ist Teil des qeulloffenen Workspace‐Projekt.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2019 Jeremy David Giesbrecht and the Workspace project contributors.
 Urheberrecht ©2019 Jeremy David Giesbrecht und die Mitwirkenden des Workspace‐Projekts.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

/// A custom task.
///
/// A custom task can be any executable vended as a Swift package. Exit code 0 must indicate that the project passes validation or that refreshment was successful. Any other exit code must indicate that the project fails validation or that the task itself failed. Output will be included in the log.
public struct CustomTask : Decodable, Encodable {

    // MARK: - Initialization

    /// Creates a custom task.
    ///
    /// - Parameters:
    ///     - url: The URL of the Swift package defining the task.
    ///     - release: The version of the Swift package defining the task.
    ///     - executable: The name of the executable for the task.
    ///     - arguments: Any arguments for the executable.
    public init(url: URL, version release: Version, executable: StrictString, arguments: [String] = []) {
        self.url = url
        self.version = release
        self.executable = executable
        self.arguments = arguments
    }

    // MARK: - Properties

    /// The URL of the Swift package defining the task.
    public var url: URL

    /// The version of the Swift package defining the task.
    public var version: Version

    /// The name of the executable for the task.
    public var executable: StrictString

    /// Any arguments for the executable.
    public var arguments: [String]
}
