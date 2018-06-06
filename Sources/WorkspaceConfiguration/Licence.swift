/*
 Licence.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2018 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

public enum Licence: String, Codable {

    // MARK: - Cases

    /// The [Apache 2.0](https://github.com/SDGGiesbrecht/Workspace/blob/master/Resources/Interface/Licences/Apache%202.0.md)) licence.
    ///
    /// (Swift itself is under this licence.)
    case apache2_0

    /// The [MIT](https://github.com/SDGGiesbrecht/Workspace/blob/master/Resources/Interface/Licences/MIT.md) licence.
    case mit

    /// The [GNU General Public 3.0](https://github.com/SDGGiesbrecht/Workspace/blob/master/Resources/Interface/Licences/GNU%20General%20Public%203.0.md) licence.
    case gnuGeneralPublic3_0

    /// The “[Unlicence](https://github.com/SDGGiesbrecht/Workspace/blob/master/Resources/Interface/Licences/Unlicense.md)”, which dedicates the project to the public domain.
    case unlicense

    /// An [explicit notice of copyright](https://github.com/SDGGiesbrecht/Workspace/blob/master/Resources/Interface/Licences/Copyright.md), which gives no permissions.
    case copyright
}
