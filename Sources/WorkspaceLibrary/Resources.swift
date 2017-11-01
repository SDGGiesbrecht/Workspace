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
        static let apache2_0 = Data(base64Encoded: "")
        static let copyright = Data(base64Encoded: "")
        static let gnuGeneralPublic3_0 = Data(base64Encoded: "")
        static let mit = Data(base64Encoded: "")
        static let unlicense = Data(base64Encoded: "")
    }
    enum Scripts {
        static let refreshWorkspaceLinux = Data(base64Encoded: "")
        static let refreshWorkspaceMacOS = Data(base64Encoded: "")
        static let validateChangesLinux = Data(base64Encoded: "")
        static let validateChangesMacOS = Data(base64Encoded: "")
    }

}
