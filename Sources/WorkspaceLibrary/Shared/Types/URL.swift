/*
 URL.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2017 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import Foundation

extension URL {

    var linuxSafeLastPathComponent: String {
        // [_Workaround: Linux uses mismatched encodings for this method. (Swift 3.0.2)_]
        #if os(Linux)
            let wrong = lastPathComponent
            guard let data = wrong.data(using: String.Encoding.macOSRoman) else {
                fatalError(message: ["Failed to re‐encode path component."])
            }
            guard let result = String(data: data, encoding: String.Encoding.utf8) else {
                fatalError(message: ["Failed to re‐encode path component."])
            }
            return result
        #else
            return lastPathComponent
        #endif
    }
}
