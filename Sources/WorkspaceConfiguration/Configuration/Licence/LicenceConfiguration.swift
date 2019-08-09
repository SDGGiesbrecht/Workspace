/*
 LicenceConfiguration.swift

 This source file is part of the Workspace open source project.
 Diese Quelldatei ist Teil des qeulloffenen Workspace‐Projekt.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2018–2019 Jeremy David Giesbrecht and the Workspace project contributors.
 Urheberrecht ©2018–2019 Jeremy David Giesbrecht und die Mitwirkenden des Workspace‐Projekts.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

// #workaround(Not properly localized yet.)
// @localization(🇩🇪DE) @crossReference(LicenceConfiguration)
/// ...
public typealias Lizenzeinstellungen = LicenceConfiguration
// @localization(🇺🇸EN) @crossReference(LicenceConfiguration)
/// ...
public typealias LicenseConfiguration = LicenceConfiguration
// @localization(🇬🇧EN) @localization(🇨🇦EN) @crossReference(LicenceConfiguration)
/// Options related to licencing.
///
/// ```shell
/// $ workspace refresh licence
/// ```
public struct LicenceConfiguration : Codable {

    // #workaround(Not properly localized yet.)
    // @localization(🇬🇧EN) @localization(🇺🇸EN) @localization(🇨🇦EN) @localization(🇩🇪DE)
    /// Whether or not to manage the project licence.
    ///
    /// This is off by default.
    public var manage: Bool = false

    // #workaround(Not properly localized yet.)
    // @localization(🇬🇧EN)  @localization(🇨🇦EN) @crossReference(LicenceConfiguration.licence)
    /// The project licence.
    public var licence: Licence?
    // @localization(🇺🇸EN) @crossReference(LicenceConfiguration.licence)
    /// The project license.
    public var license: License? {
        get { return licence }
        set { licence = newValue }
    }
    // @localization(🇩🇪DE) @crossReference(LicenceConfiguration.licence)
    /// Die Projektlizenz.
    public var lizenz: Lizenz? {
        get { return licence }
        set { licence = newValue }
    }
}
