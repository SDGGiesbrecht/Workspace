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

import SDGLogic

struct Repository {
    
    // MARK: - Configuration
    
    static let workspaceDirectory = ".Workspace/"
    
    // MARK: - Cache
    
    private struct Cache {
        fileprivate var allFilesIncludingWorkspaceItself: [String]?
        fileprivate var allFiles: [String]?
        fileprivate var printableListOfAllFiles: String?
    }
    private static var cache = Cache()
    
    // MARK: - Constants
    
    private static let fileManager = FileManager.default
    private static let repositoryPath = fileManager.currentDirectoryPath
    
    // MARK: - Interface
    
    static func resetCache() {
        cache = Cache()
    }
    
    static var allFilesIncludingWorkspaceItself: [String] {
        return cachedResult(cache: &cache.allFilesIncludingWorkspaceItself) {
            () -> [String] in
            
            guard let enumerator = fileManager.enumerator(atPath: repositoryPath) else {
                fatalError(message: ["Cannot enumerate files in project."])
            }
            
            var result: [String] = []
            while let path = enumerator.nextObject() as? String {
                result.append(path)
            }
            return result
        }
    }
    
    static var allFiles: [String] {
        return cachedResult(cache: &cache.allFiles) {
            () -> [String] in
            
            return allFilesIncludingWorkspaceItself.filter() {
                (path: String) -> Bool in
                
                return ¬(path.hasPrefix(workspaceDirectory) ∨ path == ".DS_Store")
            }
        }
    }
    
    static var printableListOfAllFiles: String {
        return cachedResult(cache: &cache.printableListOfAllFiles) {
            () -> String in
            
            return allFiles.joined(separator: "\n")
        }
    }
    
    static var isEmpty: Bool {
        return allFiles.isEmpty
    }
}
