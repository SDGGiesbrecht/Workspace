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
    
    static let workspaceDirectory: RelativePath = ".Workspace"
    
    // MARK: - Cache
    
    private struct Cache {
        fileprivate var allFilesIncludingWorkspaceItself: [RelativePath]?
        fileprivate var allFiles: [RelativePath]?
        fileprivate var printableListOfAllFiles: String?
        fileprivate var packageDescription: File?
    }
    private static var cache = Cache()
    
    // MARK: - Constants
    
    private static let fileManager = FileManager.default
    private static let repositoryPath: AbsolutePath = AbsolutePath(fileManager.currentDirectoryPath)
    
    // MARK: - Repository
    
    static func resetCache() {
        cache = Cache()
        Configuration.resetCache()
    }
    
    static var allFilesIncludingWorkspaceItself: [RelativePath] {
        return cachedResult(cache: &cache.allFilesIncludingWorkspaceItself) {
            () -> [RelativePath] in
            
            guard let enumerator = fileManager.enumerator(atPath: repositoryPath.string) else {
                fatalError(message: ["Cannot enumerate files in project."])
            }
            
            var result: [RelativePath] = []
            while let path = enumerator.nextObject() as? String {
                
                var isDirectory: ObjCBool = false
                if fileManager.fileExists(atPath: path, isDirectory: &isDirectory) {
                    
                    if ¬isDirectory.boolValue {
                        result.append(RelativePath(path))
                    }
                }
            }
            return result
        }
    }
    
    static var allFiles: [RelativePath] {
        return cachedResult(cache: &cache.allFiles) {
            () -> [RelativePath] in
            
            return allFilesIncludingWorkspaceItself.filter() {
                (path: RelativePath) -> Bool in
                
                return ¬(path.string.hasPrefix(workspaceDirectory.string + "/") ∨ path == RelativePath(".DS_Store"))
            }
        }
    }
    
    static var printableListOfAllFiles: String {
        return cachedResult(cache: &cache.printableListOfAllFiles) {
            () -> String in
            
            return allFiles.map({ $0.string }).joined(separator: "\n")
        }
    }
    
    static var isEmpty: Bool {
        return allFiles.isEmpty
    }
    
    static func allFiles(at path: RelativePath) -> [RelativePath] {
        return allFilesIncludingWorkspaceItself.filter() {
            (possiblePath: RelativePath) -> Bool in
            
            if possiblePath == path {
                // The file itself
                return true
            }
            
            if possiblePath.string.hasPrefix(path.string + "/") {
                // In that folder.
                return true
            }
            
            return false
        }
    }
    
    // MARK: - Files
    
    private static func absolute(_ relativePath: RelativePath) -> AbsolutePath {
        return AbsolutePath(repositoryPath.string + "/" + relativePath.string)
    }
    
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
    
    static func delete(_ path: RelativePath) throws {
        
        try fileManager.removeItem(atPath: absolute(path).string)
        
        resetCache()
    }
    
    private static func performPathChange(from origin: RelativePath, to destination: RelativePath, copy: Bool) throws {
        
        // This must generate the entire list of files to copy before starting to make changes. Otherwise the run‐away effect of copying a directory into itself is catastrophic.
        let files = allFiles(at: origin)
        let changes = files.map() {
            (changeOrigin: RelativePath) -> (changeOrigin: RelativePath, changeDestination: RelativePath) in
            
            let relative = changeOrigin.string.substring(from: changeOrigin.string.index(changeOrigin.string.characters.startIndex, offsetBy: origin.string.characters.count))
            
            return (changeOrigin, RelativePath(destination.string + relative))
        }
        
        for change in changes {
            
            let verb = copy ? "Copying" : "Moving"
            print(["\(verb) “\(change.changeOrigin)” to “\(change.changeDestination)”."])
            
            force() { try delete(change.changeDestination) }
            
            try fileManager.copyItem(atPath: absolute(change.changeOrigin).string, toPath: absolute(change.changeDestination).string)
            
            print("Copied successfully.")
            
            if ¬copy {
                try delete(change.changeOrigin)
            }
        }
        
        resetCache()
    }
    
    static func copy(_ origin: RelativePath, to destination: RelativePath) throws {
        
        try performPathChange(from: origin, to: destination, copy: true)
    }
    
    static func move(_ origin: RelativePath, to destination: RelativePath) throws {
        
        try performPathChange(from: origin, to: destination, copy: false)
    }
}
