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
    static let root: RelativePath = RelativePath("")
    
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
            
            return join(lines: allFiles.map({ $0.string }))
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
        return repositoryPath.subfolderOrFile(relativePath.string)
    }
    
    static func read(file path: RelativePath) throws -> File {
        
        var encoding = String.Encoding.utf8
        return File(path: path, contents: try String(contentsOfFile: absolute(path).string, usedEncoding: &encoding))
    }
    
    static func write(file: File) throws {
        
        prepareForWrite(path: file.path)
        
        try file.contents.write(toFile: absolute(file.path).string, atomically: true, encoding: String.Encoding.utf8)
        
        resetCache()
        
        if _isDebugAssertConfiguration() {
            let written = try Repository.read(file: file.path)
            assert(written.contents == file.contents, "Write operation failed.")
        }
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
    
    private static func prepareForWrite(path: RelativePath) {
        
        force() { try delete(path) }
        
        force() { try fileManager.createDirectory(atPath: absolute(path).directory, withIntermediateDirectories: true, attributes: nil) }
    }
    
    private static func performPathChange(from origin: RelativePath, to destination: RelativePath, copy: Bool) throws {
        
        // This must generate the entire list of files to copy before starting to make changes. Otherwise the run‐away effect of copying a directory into itself is catastrophic.
        let files = allFiles(at: origin)
        let changes = files.map() {
            (changeOrigin: RelativePath) -> (changeOrigin: RelativePath, changeDestination: RelativePath) in
            
            let relative = changeOrigin.string.substring(from: changeOrigin.string.index(changeOrigin.string.characters.startIndex, offsetBy: origin.string.characters.count))
            
            return (changeOrigin, RelativePath(destination.string + relative))
        }
        if changes.isEmpty {
            fatalError(message: [
                "No files exist at “\(origin)”",
                "This may indicate a bug in Workspace.",
                ])
        }
        
        for change in changes {
            
            let verb = copy ? "Copying" : "Moving"
            print(["\(verb) “\(change.changeOrigin)” to “\(change.changeDestination)”."])
            
            prepareForWrite(path: change.changeDestination)
            
            try fileManager.copyItem(atPath: absolute(change.changeOrigin).string, toPath: absolute(change.changeDestination).string)
            
            if ¬copy {
                try delete(change.changeOrigin)
            }
        }
        
        resetCache()
    }
    
    private static func performPathChange(from origin: RelativePath, into destination: RelativePath, copy: Bool) throws {
        let destinationFile = destination.subfolderOrFile(origin.filename)
        try performPathChange(from: origin, to: destinationFile, copy: copy)
    }
    
    static func copy(_ origin: RelativePath, to destination: RelativePath) throws {
        try performPathChange(from: origin, to: destination, copy: true)
    }
    
    static func copy(_ origin: RelativePath, into destination: RelativePath) throws {
        try performPathChange(from: origin, into: destination, copy: true)
    }
    
    static func move(_ origin: RelativePath, to destination: RelativePath) throws {
        try performPathChange(from: origin, to: destination, copy: false)
    }
    
    static func move(_ origin: RelativePath, into destination: RelativePath) throws {
        try performPathChange(from: origin, into: destination, copy: false)
    }
}
