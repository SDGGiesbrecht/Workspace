/*
 Resources.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2017 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import Foundation

internal enum Resources {}

extension Resources {
    enum Licences {
        static let Apache_2_0 = Data(base64Encoded: "")
        static let Copyright = Data(base64Encoded: "")
        static let GNU_General_Public_3_0 = Data(base64Encoded: "")
        static let MIT = Data(base64Encoded: "")
        static let Unlicense = Data(base64Encoded: "")
    }
    enum Scripts {
        static let Refresh_Workspace__Linux_ = Data(base64Encoded: "")
        static let Refresh_Workspace__macOS_ = Data(base64Encoded: "")
        static let Validate_Changes__Linux_ = Data(base64Encoded: "")
        static let Validate_Changes__macOS_ = Data(base64Encoded: "")
    }

}
