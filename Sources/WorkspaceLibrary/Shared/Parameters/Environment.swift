// Environment.swift
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

import SDGLogic

struct Environment {
    
    // MARK: - Properties
    
    private static func environmentVariable(_ name: String) -> String? {
        return ProcessInfo.processInfo.environment[name]
    }
    
    private static func requiredEnvironmentVariable(_ name: String) -> String {
        guard let result = environmentVariable(name) else {
            fatalError(message: [
                "Environment variable missing: \(name)"
                ])
        }
        return result
    }
    
    static let isInXcode: Bool = environmentVariable("__XCODE_BUILT_PRODUCTS_DIR_PATHS") ≠ nil
}
