/*
 SDGCornerstone.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2017 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

// [_Warning: These need to be moved to SDGCornerstone._]

import Foundation

import SDGCornerstone

extension URL {

    func `is`(in other: URL) -> Bool {
        let path = self.path
        let otherPath = other.path
        return path == otherPath ∨ path.hasPrefix(otherPath + "/")
    }

    func path(relativeTo other: URL) -> String {
        guard `is`(in: other) else {
            return path
        }
        let otherLength = other.path.clusters.count
        var relative = path.clusters.dropFirst(otherLength)
        if relative.hasPrefix("/") {
            relative = relative.dropFirst()
        }
        return String(relative)
    }
}
