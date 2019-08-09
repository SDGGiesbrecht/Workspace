/*
 Licence.swift

 This source file is part of the Workspace open source project.
 Diese Quelldatei ist Teil des qeulloffenen Workspace‐Projekt.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2018–2019 Jeremy David Giesbrecht and the Workspace project contributors.
 Urheberrecht ©2018–2019 Jeremy David Giesbrecht und die Mitwirkenden des Workspace‐Projekts.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

// @localization(🇩🇪DE) @crossReference(Licence)
/// Eine Projektlizenz.
///
/// Für Informationen über verschiedene Lizenzen, siehe [choosealicense.com](https://choosealicense.com) (nur auf Englisch).
public typealias Lizenz = Licence
// @localization(🇺🇸EN) @crossReference(Licence)
/// A project license.
///
/// For information about the various licenses, see [choosealicense.com](https://choosealicense.com).
public typealias License = Licence
// @localization(🇬🇧EN)  @localization(🇨🇦EN) @crossReference(Licence)
/// A project licence.
///
/// For information about the various licences, see [choosealicense.com](https://choosealicense.com).
public enum Licence : String, Codable {

    // MARK: - Cases

    // #workaround(Not properly localized yet.)
    // @localization(🇬🇧EN) @localization(🇺🇸EN) @localization(🇨🇦EN) @localization(🇩🇪DE)
    /// The [Apache 2.0](https://github.com/SDGGiesbrecht/Workspace/blob/master/Resources/Interface/Licences/Apache%202.0.md) licence.
    ///
    /// (Swift itself is under this licence.)
    case apache2_0

    // #workaround(Not properly localized yet.)
    // @localization(🇬🇧EN) @localization(🇺🇸EN) @localization(🇨🇦EN) @localization(🇩🇪DE)
    /// The [MIT](https://github.com/SDGGiesbrecht/Workspace/blob/master/Resources/Interface/Licences/MIT.md) licence.
    case mit

    // #workaround(Not properly localized yet.)
    // @localization(🇬🇧EN) @localization(🇺🇸EN) @localization(🇨🇦EN) @localization(🇩🇪DE)
    /// The [GNU General Public 3.0](https://github.com/SDGGiesbrecht/Workspace/blob/master/Resources/Interface/Licences/GNU%20General%20Public%203.0.md) licence.
    case gnuGeneralPublic3_0

    // #workaround(Not properly localized yet.)
    // @localization(🇬🇧EN) @localization(🇺🇸EN) @localization(🇨🇦EN) @localization(🇩🇪DE)
    /// The “[Unlicence](https://github.com/SDGGiesbrecht/Workspace/blob/master/Resources/Interface/Licences/Unlicense.md)”, which dedicates the project to the public domain.
    case unlicense

    // #workaround(Not properly localized yet.)
    // @localization(🇬🇧EN) @localization(🇺🇸EN) @localization(🇨🇦EN) @localization(🇩🇪DE)
    /// An [explicit notice of copyright](https://github.com/SDGGiesbrecht/Workspace/blob/master/Resources/Interface/Licences/Copyright.md), which gives no permissions.
    case copyright

    // MARK: - Details

    internal var notice: StrictString {
        var result: [StrictString]
        switch self {
        case .apache2_0:
            result = [
                "Licensed under the Apache Licence, Version 2.0.",
                "See http://www.apache.org/licenses/LICENSE\u{2D}2.0 for licence information."
            ]
        case .mit:
            result = [
                "Licensed under the MIT Licence.",
                "See https://opensource.org/licenses/MIT for licence information."
            ]
        case .gnuGeneralPublic3_0:
            result = [
                "Licensed under the GNU General Public Licence, Version 3.0.",
                "See http://www.gnu.org/licenses/ for licence information."
            ]
        case .unlicense:
            result = [
                "Dedicated to the public domain.",
                "See http://unlicense.org/ for more information."
            ]
        case .copyright:
            result = [
                "This software is subject to copyright law.",
                "It may not be used, copied, distributed or modified without first obtaining a private licence from the copyright holder(s)."
            ]
        }
        return result.joinedAsLines()
    }
}
