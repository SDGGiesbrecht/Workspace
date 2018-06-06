/*
 ContinousIntegrationConfiguration.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2018 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

/// Options related to continuous integration.
public struct ContinuousIntegrationConfiguration : Codable {

    /// Whether or not to skip simulator tasks when running them locally.
    ///
    /// This is off by default.
    ///
    /// Because booting and switching the simulator often takes longer than all the other tasks combined, this option is available to skip actions requiring the simulator. It can save a lot of time for projects where there are very few differences between the macOS tests and those of the other Apple platforms.
    ///
    /// **This option only takes effect when running locally. Workspace still performs all tasks during continuous integration.**
    public var skipSimulatorOutsideContinuousIntegration: Bool = false
}
