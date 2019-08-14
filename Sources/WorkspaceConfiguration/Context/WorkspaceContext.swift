/*
 WorkspaceContext.swift

 This source file is part of the Workspace open source project.
 Diese Quelldatei ist Teil des qeulloffenen Workspace‐Projekt.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2018–2019 Jeremy David Giesbrecht and the Workspace project contributors.
 Urheberrecht ©2018–2019 Jeremy David Giesbrecht und die Mitwirkenden des Workspace‐Projekts.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGSwiftConfiguration

// @localization(🇩🇪DE) @crossReference(WorkspaceContext)
/// Externe Informationen über das Projekt.
public typealias Arbeitsbereichszusammenhang = WorkspaceContext
// @localization(🇬🇧EN) @localization(🇺🇸EN) @localization(🇨🇦EN) @crossReference(WorkspaceContext)
/// External information about the project.
public struct WorkspaceContext : Context {

    // MARK: - Static Properties

    // @localization(🇩🇪DE) @crossReference(WorkspaceContext.current)
    /// Der Zusammenhang des aktuellen Projekts.
    public static var aktueller: Arbeitsbereichszusammenhang {
        get { return current }
        set { current = newValue }
    }
    private static var _current: WorkspaceContext?
    // @localization(🇬🇧EN) @localization(🇺🇸EN) @localization(🇨🇦EN) @crossReference(WorkspaceContext.current)
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

    // @localization(🇬🇧EN) @localization(🇺🇸EN) @localization(🇨🇦EN) @crossReference(WorkspaceContext.location)
    /// The location of the configured repository.
    public let location: URL
    // @localization(🇩🇪DE) @crossReference(WorkspaceContext.location)
    /// Der Standort des konfigurierten Lagers.
    public var standort: EinheitlicherRessourcenzeiger {
        return location
    }

    // @localization(🇬🇧EN) @localization(🇺🇸EN) @localization(🇨🇦EN) @crossReference(WorkspaceContext.manifest)
    /// Information from the package manifest.
    public let manifest: PackageManifest
    // @localization(🇩🇪DE) @crossReference(WorkspaceContext.manifest)
    /// Informationen aus der Paketenladeliste.
    public var ladeliste: Paketenladeliste {
        return manifest
    }
}
