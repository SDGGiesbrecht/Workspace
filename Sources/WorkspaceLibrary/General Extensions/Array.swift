/*
 Array.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2017 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGCornerstone

extension Array where Element : StringFamily {
    // MARK: - where Element : StringFamily

    func joinAsLines() -> Element {
        return joined(separator: "\n")
    }
}
