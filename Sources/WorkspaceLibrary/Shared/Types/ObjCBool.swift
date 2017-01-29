// ObjCBool.swift
//
// This source file is part of the Workspace open source project.
//
// Copyright ©2017 Jeremy David Giesbrecht and the Workspace contributors.
//
// Soli Deo gloria
//
// Licensed under the Apache License, Version 2.0
// See http://www.apache.org/licenses/LICENSE-2.0 for licence information.

import Foundation

extension ObjCBool {
    
    #if os(Linux)
    // [_Workaround: Provide missing boolValue property on Linux. (Swift 3.0.2)_]
    var boolValue: Bool {
        return self
    }
    #endif
}
