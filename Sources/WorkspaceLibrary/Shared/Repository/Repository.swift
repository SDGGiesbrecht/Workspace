/*
 Repository.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace

 Copyright ©2017 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import Foundation

import SDGCaching

import SDGLogic

struct Repository {

    // MARK: - Configuration

    static let workspaceDirectory: RelativePath = ".Workspace"
    static let workspaceResources: RelativePath = workspaceDirectory.subfolderOrFile("Resources")
    private static let linkedRepositories: RelativePath = ".Linked Repositories"
    static let testZone: RelativePath = ".Test Zone"

    // MARK: - Cache

    private struct Cache {
        fileprivate var moduleNames: [String]?
        fileprivate var allFiles: [RelativePath]?
        fileprivate var allFilesExcludingWorkspaceItself: [RelativePath]?
        fileprivate var trackedFiles: [RelativePath]?
        fileprivate var sourceFiles: [RelativePath]?
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

    static var moduleNames: [String] {
        return cachedResult(cache: &cache.moduleNames) {
            
            do {
                return try fileManager.contentsOfDirectory(atPath: "Sources").filter() { (module: String) -> Bool in
                    
                    for path in trackedFiles(at: "Sources") {
                        if path.string.contains("Sources/\(module)/") {
                            return true
                        }
                    }
                    return false
                }
            } catch let error {
                fatalError(message: [error.localizedDescription])
            }
        }
    }

    static var allFiles: [RelativePath] {
        return cachedResult(cache: &cache.allFiles) {
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

    static var allFilesExcludingWorkspaceInself: [RelativePath] {
        return cachedResult(cache: &cache.allFiles) {
            () -> [RelativePath] in

            let result = allFiles.filter() { (path: RelativePath) -> Bool in

                return ¬(path.string.hasPrefix(workspaceDirectory.string + "/") ∨ path == RelativePath(".DS_Store"))

            }

            return result
        }
    }

    static var trackedFiles: [RelativePath] {

        return cachedResult(cache: &cache.trackedFiles) {
            () -> [RelativePath] in

            let ignoredSummary = requireBash(["git", "status", "--ignored"], silent: true)
            var ignoredPaths: [String] = [
                ".git/"
            ]
            if let header = ignoredSummary.range(of: "Ignored files:") {

                let remainder = ignoredSummary.substring(from: header.upperBound)
                for line in remainder.lines.dropFirst(3) {
                    if line.isWhitespace {
                        break
                    } else {
                        var start = line.startIndex
                        line.advance(&start, past: CharacterSet.whitespaces)
                        ignoredPaths.append(line.substring(from: start))
                    }
                }

            }

            let result = allFiles.filter() { (path: RelativePath) -> Bool in

                for ignored in ignoredPaths {
                    if path.string.hasPrefix(ignored) {
                        return false
                    }
                }
                return true
            }

            return result
        }
    }

    static var sourceFiles: [RelativePath] {

        return cachedResult(cache: &cache.sourceFiles) {
            () -> [RelativePath] in

            let result = trackedFiles.filter() { (path: RelativePath) -> Bool in

                let generatedPaths = [
                    "docs/"
                ]

                for generated in generatedPaths {
                    if path.string.hasPrefix(generated) {
                        return false
                    }
                }
                return true
            }

            return result
        }
    }

    static var printableListOfAllFiles: String {
        return cachedResult(cache: &cache.printableListOfAllFiles) {
            () -> String in

            return join(lines: allFiles.map({ $0.string }))
        }
    }

    static var isEmpty: Bool {
        return allFilesExcludingWorkspaceInself.isEmpty
    }

    private static func path(_ possiblePath: RelativePath, isIn path: RelativePath) -> Bool {

        if path == Repository.root {
            return true
        }

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

    static func allFiles(at path: RelativePath) -> [RelativePath] {
        return allFiles.filter() { (possiblePath: RelativePath) -> Bool in

            return Repository.path(possiblePath, isIn: path)
        }
    }

    static func trackedFiles(at path: RelativePath) -> [RelativePath] {
        return trackedFiles.filter() { (possiblePath: RelativePath) -> Bool in

            return Repository.path(possiblePath, isIn: path)
        }
    }

    // MARK: - Files

    static func absolute(_ relativePath: RelativePath) -> AbsolutePath {
        return repositoryPath.subfolderOrFile(relativePath.string)
    }

    /// Use “File(at:)” instead.
    static func _read(file path: RelativePath) throws -> (contents: String, isExecutable: Bool) {

        let filePath = absolute(path).string

        #if os(Linux)
            // [_Workaround: Skip unavailable encoding detection on Linux. (Swift 3.0.2)_]
            let contents = try String(contentsOfFile: filePath, encoding: String.Encoding.utf8)
        #else
            var encoding = String.Encoding.utf8
            let contents = try String(contentsOfFile: filePath, usedEncoding: &encoding)
        #endif

        return (contents, fileManager.isExecutableFile(atPath: filePath))
    }

    /// Use File’s “write()” instead.
    static func _write(file: String, to path: RelativePath, asExecutable executable: Bool) throws {

        prepareForWrite(path: path)

        try file.write(toFile: absolute(path).string, atomically: true, encoding: String.Encoding.utf8)
        if executable {
            #if os(Linux)
                // [_Workaround: FileManager cannot change permissions on Linux. (Swift 3.0.2)_]
                requireBash(["chmod", "+x", absolute(path).string], silent: true)
            #else
                try fileManager.setAttributes([.posixPermissions: 0o777], ofItemAtPath: absolute(path).string)
            #endif
        }

        resetCache()

        if debug {
            let written = try Repository._read(file: path)
            assert(written == (file, executable), "Write operation failed.")
        }
    }

    static var packageDescription: File {
        return cachedResult(cache: &cache.packageDescription) {
            () -> File in

            return require() { try File(at: "Package.swift") }
        }
    }

    // MARK: - File Actions

    static func delete(_ path: RelativePath) throws {

        defer {
            resetCache()
        }

        #if os(Linux)
            // [_Workaround: Skip unavailable catching of NSErrors on Linux. (Swift 3.0.2)_]
            // Linux crashes if it attempts to catch the error.
            try? fileManager.removeItem(atPath: absolute(path).string)
        #else
            do {
                try fileManager.removeItem(atPath: absolute(path).string)
            } catch let error as NSError {

                if let POSIX = (error.userInfo[NSUnderlyingErrorKey] as? NSError),
                    POSIX.domain == NSPOSIXErrorDomain,
                    POSIX.code == 2 /* No such file or directory. */ {

                    return
                }
            }
        #endif
    }

    private static func prepareForWrite(path: RelativePath) {

        force() { try delete(path) }

        force() { try fileManager.createDirectory(atPath: absolute(path).directory, withIntermediateDirectories: true, attributes: nil) }
    }

    private static func performPathChange(from origin: RelativePath, to destination: RelativePath, copy: Bool, includeIgnoredFiles: Bool = false) throws {

        // This must generate the entire list of files to copy before starting to make changes. Otherwise the run‐away effect of copying a directory into itself is catastrophic.
        let files: [RelativePath]
        if includeIgnoredFiles {
            files = allFiles(at: origin)
        } else {
            files = trackedFiles(at: origin)
        }

        let changes = files.map() { (changeOrigin: RelativePath) -> (changeOrigin: RelativePath, changeDestination: RelativePath) in

            let relative = changeOrigin.string.substring(from: changeOrigin.string.index(changeOrigin.string.characters.startIndex, offsetBy: origin.string.characters.count))

            return (changeOrigin, RelativePath(destination.string + relative))
        }
        if changes.isEmpty {
            fatalError(message: [
                "No files exist at “\(origin)”",
                "This may indicate a bug in Workspace."
                ])
        }

        for change in changes {

            let verb = copy ? "Copying" : "Moving"
            print(["\(verb) “\(change.changeOrigin)” to “\(change.changeDestination)”..."])

            prepareForWrite(path: change.changeDestination)

            #if os(Linux)
                // [_Workaround: Skip unavailable file copying by using shell on Linux. (Swift 3.0.2)_]
                let result = bash(["cp", absolute(change.changeOrigin).string, absolute(change.changeDestination).string], silent: true)
                if ¬result.succeeded {
                    throw LinuxFileError(exitCode: result.exitCode)
                }
            #else
                try fileManager.copyItem(atPath: absolute(change.changeOrigin).string, toPath: absolute(change.changeDestination).string)
            #endif

            if ¬copy {
                try delete(change.changeOrigin)
            }
        }

        resetCache()
    }

    private static func performPathChange(from origin: RelativePath, into destination: RelativePath, copy: Bool, includeIgnoredFiles: Bool = false) throws {
        let destinationFile = destination.subfolderOrFile(origin.filename)
        try performPathChange(from: origin, to: destinationFile, copy: copy, includeIgnoredFiles: includeIgnoredFiles)
    }

    static func copy(_ origin: RelativePath, to destination: RelativePath, includeIgnoredFiles: Bool = false) throws {
        try performPathChange(from: origin, to: destination, copy: true, includeIgnoredFiles: includeIgnoredFiles)
    }

    static func copy(_ origin: RelativePath, into destination: RelativePath, includeIgnoredFiles: Bool = false) throws {
        try performPathChange(from: origin, into: destination, copy: true, includeIgnoredFiles: includeIgnoredFiles)
    }

    static func move(_ origin: RelativePath, to destination: RelativePath, includeIgnoredFiles: Bool = false) throws {
        try performPathChange(from: origin, to: destination, copy: false, includeIgnoredFiles: includeIgnoredFiles)
    }

    static func move(_ origin: RelativePath, into destination: RelativePath, includeIgnoredFiles: Bool = false) throws {
        try performPathChange(from: origin, into: destination, copy: false, includeIgnoredFiles: includeIgnoredFiles)
    }

    static func performInDirectory(directory: RelativePath, action: () -> Void) {

        func changeToDirectory(path: String) {
            if ¬fileManager.changeCurrentDirectoryPath(path) {
                fatalError(message: [
                    "Failed to change working directory."
                    ])
            }
        }

        changeToDirectory(path: directory.string)
        action()
        changeToDirectory(path: repositoryPath.string)
    }

    // MARK: - Linked Repositories

    static func nameOfLinkedRepository(atURL url: String) -> String {
        guard let urlObject = URL(string: url) else {
            fatalError(message: [
                "Invalid URL:",
                "",
                url
                ])
        }

        let name = urlObject.lastPathComponent

        let repository = linkedRepositories.subfolderOrFile(name)

        if ¬fileManager.fileExists(atPath: absolute(repository).string) {
            prepareForWrite(path: repository)
            performInDirectory(directory: linkedRepositories) {
                requireBash(["git", "clone", url])
            }
        }

        performInDirectory(directory: repository) {
            requireBash(["git", "pull"], silent: true)
        }

        return name
    }

    static func linkedRepository(named name: String) -> RelativePath {
        return linkedRepositories.subfolderOrFile(name)
    }
}
