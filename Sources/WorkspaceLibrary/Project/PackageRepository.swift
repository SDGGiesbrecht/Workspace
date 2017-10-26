/*
 PackageRepository.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2017 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import Foundation

import SDGCornerstone
import SDGCommandLine

internal typealias PackageRepository = _PackageRepository // Shared from SDGCornerstone.
extension PackageRepository {

    // MARK: - Initialization

    internal init(alreadyAt location: URL) {
        self.init(_alreadyAt: location) // Shared from SDGCommandLine.
    }

    // MARK: - Cache

    private class Cache {
        fileprivate var allFiles: [URL]?
        fileprivate var trackedFiles: [URL]?
    }
    private static var caches: [URL: Cache] = [:]

    func resetCache() {
        PackageRepository.caches[location] = Cache()
    }

    // MARK: - Location

    var location: URL {
        return _location // Shared from SDGCommandLine.
    }

    func url(for relativePath: String) -> URL {
        return _url(for: relativePath) // Shared from SDGCommandLine.
    }

    // MARK: - Structure

    var targets: [Target] {
        notImplementedYetAndCannotReturn()
    }

    // MARK: - Files

    func allFiles() throws -> [URL] {
        return try cached(in: &PackageRepository.caches[location, default: Cache()].allFiles) {
            () -> [URL] in

            var failureReason: Error? // Thrown after enumeration stops. (See below.)
            guard let enumerator = FileManager.default.enumerator(at: location, includingPropertiesForKeys: [.isDirectoryKey], options: [], errorHandler: { (_, error: Error) -> Bool in
                failureReason = error
                return false // Stop.
            }) else {
                throw Command.Error(description: UserFacingText<InterfaceLocalization, Void>({ (localization, _) in
                    switch localization {
                    case .englishCanada:
                        return "Cannot enumerate the project files."
                    }
                }))
            }

            var result: [URL] = []
            for object in enumerator {
                guard let url = object as? URL else {
                    throw Command.Error(description: UserFacingText<InterfaceLocalization, Void>({ (localization, _) in
                        switch localization {
                        case .englishCanada:
                            return StrictString("Unexpected \(type(of: object)) encountered while enumerating project files.")
                        }
                    }))
                }

                if ¬(try url.resourceValues(forKeys: [.isDirectoryKey])).isDirectory!, // Skip directories.
                    url.lastPathComponent ≠ ".DS_Store", // Skip irrelevant operating system files.
                    ¬url.path.hasSuffix("~") {

                    result.append(url)
                }
            }

            if let error = failureReason {
                throw error
            }

            return result
        }
    }

    func trackedFiles(output: inout Command.Output) throws -> [URL] {
        return try cached(in: &PackageRepository.caches[location, default: Cache()].trackedFiles) {
            () -> [URL] in

            var ignoredURLs: [URL] = []
            try FileManager.default.do(in: location) {
                ignoredURLs = try Git.default.ignoredFiles(output: &output)
            }
            ignoredURLs.append(url(for: ".git"))
            let ignoredPaths = ignoredURLs.map() { $0.path }

            return try allFiles().filter() { (url) in
                let path = url.path
                for ignoredPath in ignoredPaths {
                    if path == ignoredPath ∨ path.hasPrefix(ignoredPath + "/") {
                        return false
                    }
                }
                return true
            }
        }
    }

    // MARK: - Resources

    func refreshResources(output: inout Command.Output) throws {
        print(try trackedFiles(output: &output).map({ $0.path }))
        notImplementedYet()
    }
}
