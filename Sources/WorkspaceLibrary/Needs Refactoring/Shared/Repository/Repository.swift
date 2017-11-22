/*
 Repository.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2017 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import Foundation

import SDGCornerstone

struct Repository {

    // MARK: - Bridging

    static let packageRepository = PackageRepository(alreadyAt: URL(fileURLWithPath: FileManager.default.currentDirectoryPath))

    static func paths(from urls: [URL]) -> [RelativePath] {
        return urls.map() { (url) in
            return RelativePath(url.path(relativeTo: packageRepository.location))
        }
    }

    // MARK: - Configuration

    static let testZone: RelativePath = ".Test Zone"

    // MARK: - Cache

    private struct Cache {
        fileprivate var allFiles: [RelativePath]?
        fileprivate var allRealFiles: [RelativePath]?
        fileprivate var trackedFiles: [RelativePath]?
        fileprivate var sourceFiles: [RelativePath]?
        fileprivate var printableListOfAllFiles: String?
        fileprivate var packageDescription: File?
    }
    private static var cache = Cache()

    // MARK: - Constants

    private static let fileManager = FileManager.default
    static let repositoryPath: AbsolutePath = AbsolutePath(fileManager.currentDirectoryPath)
    static let folderName = URL(fileURLWithPath: repositoryPath.string).lastPathComponent
    static let root: RelativePath = RelativePath("")

    // MARK: - Repository

    static func resetCache() {
        cache = Cache()
    }

    static var allFiles: [RelativePath] {
        let urls = require() { try packageRepository.allFiles() }
        return paths(from: urls)
    }

    static var trackedFiles: [RelativePath] {
        var cacheCopy = cache
        defer { cache = cacheCopy }

        return cached(in: &cacheCopy.trackedFiles) {
            () -> [RelativePath] in

            let ignoredSummary = requireBash(["git", "status", "\u{2D}\u{2D}ignored"], silent: true)
            var ignoredPaths: [String] = [
                ".git/"
            ]
            if let header = ignoredSummary.range(of: "Ignored files:") {

                let remainder = String(ignoredSummary[header.upperBound...])
                for line in remainder.lines.lazy.dropFirst(3).map({ String($0.line) }) {
                    if line.isWhitespace {
                        break
                    } else {
                        var start = line.scalars.startIndex
                        line.scalars.advance(&start, over: RepetitionPattern(ConditionalPattern(condition: { $0 ∈ CharacterSet.whitespaces })))
                        ignoredPaths.append(String(line.scalars.suffix(from: start)))
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
        var cacheCopy = cache
        defer { cache = cacheCopy }

        return cached(in: &cacheCopy.sourceFiles) {
            () -> [RelativePath] in

            let result = trackedFiles.filter() { (path: RelativePath) -> Bool in

                let generatedPaths = [
                    "docs/",
                    String(Script.refreshMacOS.fileName),
                    String(Script.refreshLinux.fileName)
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
        return cached(in: &cache.printableListOfAllFiles) {
            () -> String in

            return join(lines: allFiles.map({ $0.string }))
        }
    }

    static var isEmpty: Bool {
        return allFiles.isEmpty
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

    static func unsupportedPathType() -> Never {
        fatalError(message: [
            "Unsupported path type.",
            "This may indicate a bug in Workspace."
            ])
    }

    static func absolute<P : Path>(_ path: P) -> AbsolutePath {
        if let absolute = path as? AbsolutePath {
            return absolute
        } else if let relative = path as? RelativePath {
            return repositoryPath.subfolderOrFile(relative.string)
        } else {
            unsupportedPathType()
        }
    }

    static func relative<P : Path>(_ path: P) -> RelativePath? {
        if let relative = path as? RelativePath {
            return relative
        } else if let absolute = path as? AbsolutePath {

            let pathString = absolute.string

            let root = Repository.absolute(Repository.root).string
            var startIndex = pathString.startIndex
            if pathString.clusters.advance(&startIndex, over: root.clusters) {
                return RelativePath(String(pathString[startIndex...]))
            } else {
                return nil
            }

        } else {
            unsupportedPathType()
        }
    }

    static var packageDescription: File {
        return cached(in: &cache.packageDescription) {
            () -> File in

            return File(possiblyAt: RelativePath("Package.swift"))
        }
    }

    // MARK: - File Actions

    static func delete<P : Path>(_ path: P) throws {

        defer {
            Repository.packageRepository.resetCache(debugReason: relative(path)?.string ?? "delete")
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

    private static func prepareForWrite<P : Path>(path: P) {

        try? delete(path)

        try? fileManager.createDirectory(atPath: absolute(path).directory, withIntermediateDirectories: true, attributes: nil)
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

            let relative = String(changeOrigin.string[changeOrigin.string.index(changeOrigin.string.clusters.startIndex, offsetBy: origin.string.clusters.count)...])

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
                // [_Workaround: Skip unavailable file copying by using shell on Linux. (Swift 3.1.0)_]
                try Shell.default.run(command: ["cp", absolute(change.changeOrigin).string, absolute(change.changeDestination).string], silently: true)
            #else
                try fileManager.copyItem(atPath: absolute(change.changeOrigin).string, toPath: absolute(change.changeDestination).string)
            #endif

            if ¬copy {
                try delete(change.changeOrigin)
            }
        }

        Repository.packageRepository.resetCache(debugReason: destination.string)
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

        let repository = Workspace.linkedRepositories.subfolderOrFile(name)

        if ¬fileManager.fileExists(atPath: absolute(repository).string) {
            prepareForWrite(path: repository)
            try? fileManager.do(in: URL(fileURLWithPath: Workspace.linkedRepositories.string)) {
                requireBash(["git", "clone", url])
            }
        }

        try? fileManager.do(in: URL(fileURLWithPath: repository.string)) {
            requireBash(["git", "pull"], silent: true)
        }

        return name
    }

    static func linkedRepository(named name: String) -> AbsolutePath {
        return Workspace.linkedRepositories.subfolderOrFile(name)
    }
}
