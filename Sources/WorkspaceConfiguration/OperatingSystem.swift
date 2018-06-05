/*
 OperatingSystem.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2018 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

/// An operating system.
public enum OperatingSystem : String, Codable {

    // MARK: - Cases

    /// macOS.
    case macOS

    /// Linux.
    case linux

    /// iOS
    case iOS

    /// watchOS
    case watchOS

    /// tvOS
    case tvOS

    /// An iterable list of all operating systems.
    public static let cases: [OperatingSystem] = [
        .macOS,
        .linux,
        .iOS,
        .watchOS,
        .tvOS
    ]
}
