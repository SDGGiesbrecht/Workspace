/*
 Script.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2017 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGCornerstone

enum Script : Int, IterableEnumeration {

    // MARK: - Cases

    case refreshMacOS
    case refreshLinux
    case validateMacOS
    case validateLinux
    
    // MARK: - Properties
    
    private var templateFile: String {
        switch self {
        case .refreshMacOS:
            return Resources.Scripts.refreshWorkspaceMacOS
        case .refreshLinux:
            return Resources.Scripts.refreshWorkspaceLinux
        case .validateMacOS:
            return Resources.Scripts.validateChangesMacOS
        case .validateLinux:
            return Resources.Scripts.validateChangesLinux
        }
    }
    
    var template: StrictString {
        return StrictString(templateFile)
    }
}
