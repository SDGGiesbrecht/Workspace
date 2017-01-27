// OperatingSystem.swift
//
// This source file is part of the Workspace open source project.
//
// Copyright ©2017 Jeremy David Giesbrecht and the Workspace contributors.
//
// Soli Deo gloria
//
// Licensed under the Apache License, Version 2.0
// See http://www.apache.org/licenses/LICENSE-2.0 for licence information.

enum OperatingSystem: String, CustomStringConvertible {
    
    // MARK: - Cases
    
    case macOS = "macOS"
    case linux = "Linux"
    case iOS = "iOS"
    case watchOS = "watchOS"
    case tvOS = "tvOS"
    
    // MARK: - CustomStringConvertible
    
    var description: String {
        return rawValue
    }
}
