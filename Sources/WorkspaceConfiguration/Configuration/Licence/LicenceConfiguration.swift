/*
 LicenceConfiguration.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2018–2019 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

/// Options related to licencing.
///
/// ```shell
/// $ workspace refresh licence
/// ```
public struct LicenceConfiguration : Codable {

    /// Whether or not to manage the project licence.
    ///
    /// This is off by default.

    public var manage: Bool = false

    #warning("lisense")
    #warning("lizenz")
    /// The project licence.
    ///
    /// There is no default licence.
    public var licence: Licence?
}
