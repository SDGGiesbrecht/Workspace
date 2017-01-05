// Repository.swift
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

import SDGCaching

struct Repository {
    
    private struct Cache {
        fileprivate var contentsList: [String]?
    }
    private static var cache = Cache()
    
    static func resetCache() {
        cache = Cache()
    }
    
    private static let fileManager = FileManager.default
    private static let repositoryPath = fileManager.currentDirectoryPath
    
    static var contentsList: [String] {
        return cachedResult(cache: &cache.contentsList) {
            () -> [String] in
            
            guard let enumerator = fileManager.enumerator(atPath: repositoryPath) else {
                fail(message: "Cannot enumerate files in project.")
            }
            
            var result: [String] = []
            while let path = enumerator.nextObject() as? String {
                result.append(path)
            }
            return result
        }
    }
}
