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

enum OperatingSystem: String {
    
    // MARK: - Initialization
    
    init?(code: String) {
        self.init(rawValue: code)
    }
    
    // MARK: - Cases
    
    // Raw values are Travis CI environment keys.
    case macOS = "osx"
    case linux = "linux"
    
    // MARK: - Usage
    
    var code: String {
        return rawValue
    }
}
