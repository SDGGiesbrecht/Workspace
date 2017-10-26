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
        fileprivate var targets: [Target]?

        fileprivate var allFiles: [URL]?
        fileprivate var trackedFiles: [URL]?
        fileprivate var sourceFiles: [URL]?
        fileprivate var resourceFiles: [URL]?
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
        return try cached(in: &PackageRepository.caches[location, default: Cache()].targets) {
             () -> [Target] in

            let swift = SwiftTool.default
            notImplementedYetAndCannotReturn()
        }
    }

    func resourceDirectories() -> [URL] {
        let resourceDirectoryName = UserFacingText<InterfaceLocalization, Void>({ (localization, _) in
            switch localization {
            case .englishCanada:
                return "Resources"
            }
        })
        return InterfaceLocalization.cases.map() { (localization) in
            return location.appendingPathComponent(String(resourceDirectoryName.resolved(for: localization)))
        }
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

            return try allFiles().filter() { (url) in
                for ignoredURL in ignoredURLs {
                    if url.is(in: ignoredURL) {
                        return false
                    }
                }
                return true
            }
        }
    }

    func sourceFiles(output: inout Command.Output) throws -> [URL] {
        return try cached(in: &PackageRepository.caches[location, default: Cache()].sourceFiles) { () -> [URL] in

            let generatedURLs = [
                "docs",
                "Refresh Workspace (macOS).command",
                "Refresh Workspace (Linux).sh"
                ].map({ URL(fileURLWithPath: $0) })

            return try trackedFiles(output: &output).filter() { (url) in
                for generatedURL in generatedURLs {
                    if url.is(in: generatedURL) {
                        return false
                    }
                }
                return true
            }
        }
    }

    // MARK: - Resources

    // [_Warning: Resources need a way of opting out of headers. (.data. ?)_]

    func resourceFiles(output: inout Command.Output) throws -> [URL] {
        return try cached(in: &PackageRepository.caches[location, default: Cache()].sourceFiles) { () -> [URL] in
            let locations = resourceDirectories()
            return try sourceFiles(output: &output).filter() { (file) in
                for directory in locations where file.is(in: directory) {
                    return true
                }
                return false
            }
        }
    }

    func target(for resource: URL) -> URL {
        let path = resource.path(relativeTo: location).dropping(through: "/")
        print(path)

        notImplementedYet()
        return location
    }

    func refreshResources(output: inout Command.Output) throws {

        for resource in try resourceFiles(output: &output) {
            let targetURL = target(for: resource)

            notImplementedYetAndCannotReturn()
        }
    }
}
