/*
 WorkspaceContext.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2018–2019 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGSwiftConfiguration

/// External information about the project.
public struct WorkspaceContext : Context {

    // MARK: - Static Properties

    private static var _current: WorkspaceContext?
    /// The context of the current project.
    public static var current: WorkspaceContext {
        get {
            return _current ?? accept()! // @exempt(from: tests)
        }
        set {
            _current = newValue
        }
    }

    // MARK: - Initialization

    public init(_location: URL, manifest: PackageManifest) {
        self.location = _location
        self.manifest = manifest
    }

    // MARK: - Properties

    /// The location of the configured repository.
    public let location: URL

    /// Information from the package manifest.
    public let manifest: PackageManifest
}
