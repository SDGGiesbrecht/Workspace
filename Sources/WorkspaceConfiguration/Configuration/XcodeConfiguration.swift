/*
 XcodeConfiguration.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2018 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

/// Options related to Xcode.
public struct XcodeConfiguration : Codable {

    /// Whether or not to manage the Xcode project.
    ///
    /// This is off by default, but some tasks may throw errors if they require a compatible Xcode project and none is present.
    ///
    /// ```shell
    /// $ workspace refresh xcode
    /// ```
    ///
    /// An Xcode project can be managed manually instead, but it must correspond with the Package manifest. Where a customized Xcode project is needed, it is recommended to start with an automatically generated one and adjust it from there.
    public var manage: Bool = false
}
