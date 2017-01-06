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
        fileprivate var packageDescription: File?
    }
    private static var cache = Cache()
    
    // MARK: - Constants
    
    private static let fileManager = FileManager.default
    private static let repositoryPath = fileManager.currentDirectoryPath
    
    // MARK: - Repository
    
    static func resetCache() {
        cache = Cache()
        Configuration.resetCache()
    }
    
    static var allFilesIncludingWorkspaceItself: [String] {
        return cachedResult(cache: &cache.allFilesIncludingWorkspaceItself) {
            () -> [String] in
            
            guard let enumerator = fileManager.enumerator(atPath: repositoryPath) else {
                fatalError(message: ["Cannot enumerate files in project."])
            }
            
            var result: [String] = []
            while let path = enumerator.nextObject() as? String {
                
                var isDirectory: ObjCBool = false
                if fileManager.fileExists(atPath: path, isDirectory: &isDirectory) {
                    
                    if ¬isDirectory.boolValue {
                        result.append(path)
                    }
                }
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
    
    // MARK: - Files
    
    static func read(file path: String) throws -> File {
        
        var encoding = String.Encoding.utf8
        return File(path: path, contents: try String(contentsOfFile: path, usedEncoding: &encoding))
    }
    
    static var packageDescription: File {
        return cachedResult(cache: &cache.packageDescription) {
            () -> File in
            
            return require() { try read(file: "Package.swift") }
        }
    }
    
    // MARK: - Actions
    
    static func delete(_ path: String) throws {
        
        try fileManager.removeItem(atPath: path)
        
        resetCache()
    }
    
    static func copy(_ origin: String, to destination: String) throws {
        
        force() { try delete(destination) }
        
        //try fileManager.copyItem(atPath: origin, toPath: destination)
        
        resetCache()
    }
    
    static func move(_ origin: String, to destination: String) throws {
        try copy(origin, to: destination)
        try delete(origin)
        
        resetCache()
    }
}
