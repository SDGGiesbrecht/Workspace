// Process.swift
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

#if os(Linux)
    // [_Workaround: Rename Process on Linux. (Swift 3.0.2)_]
    typealias Process = Task
#endif
