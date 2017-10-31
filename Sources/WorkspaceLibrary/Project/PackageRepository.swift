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
        fileprivate var targets: [String: Target]?

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

    func targets(output: inout Command.Output) throws -> [String: Target] {
        return try cached(in: &PackageRepository.caches[location, default: Cache()].targets) {
            () -> [String: Target] in

            var list: [String: Target] = [:]
            try FileManager.default.do(in: location) {
                let targetInformation = try SwiftTool.default.targets(output: &output)
                for (name, sourceDirectory) in targetInformation {
                    list[name] = Target(name: name, sourceDirectory: sourceDirectory)
                }
            }
            return list
        }
    }

    static let resourceDirectoryName = UserFacingText<InterfaceLocalization, Void>({ (localization, _) in
        switch localization {
        case .englishCanada:
            return "Resources"
        }
    })

    func resourceDirectories() -> [URL] {

        return InterfaceLocalization.cases.map() { (localization) in
            return location.appendingPathComponent(String(PackageRepository.resourceDirectoryName.resolved(for: localization)))
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
    // [_Workaround: Then licences can be restored to markdown files._]

    func resourceFiles(output: inout Command.Output) throws -> [URL] {
        return try cached(in: &PackageRepository.caches[location, default: Cache()].resourceFiles) { () -> [URL] in
            let locations = resourceDirectories()
            return try sourceFiles(output: &output).filter() { (file) in
                for directory in locations where file.is(in: directory) {
                    return true
                }
                return false
            }
        }
    }

    func target(for resource: URL, output: inout Command.Output) throws -> Target {
        let path = resource.path(relativeTo: location).dropping(through: "/")
        guard let targetName = path.prefix(upTo: "/")?.contents else {
            throw Command.Error(description: UserFacingText<InterfaceLocalization, Void>({ (localization, _) in
                switch localization {
                case .englishCanada:
                    return StrictString("No target specified for resource:\n\(path)\nFiles must be in subdirectories named corresponding to the intended target.")
                }
            }))
        }
        guard let target = (try targets(output: &output))[String(targetName)] else {
            throw Command.Error(description: UserFacingText<InterfaceLocalization, Void>({ (localization, _) in
                switch localization {
                case .englishCanada:
                    return StrictString("No target named “\(targetName)”.\nResources must be in subdirectories named corresponding to the intended target.")
                }
            }))
        }
        return target
    }

    func refreshResources(output: inout Command.Output) throws {

        var targets: [Target: [URL]] = [:]
        for resource in try resourceFiles(output: &output) {
            let intendedTarget = try target(for: resource, output: &output)
            targets[intendedTarget, default: []].append(resource)
        }

        for (target, resources) in targets {
            target.refresh(resources: resources, from: self)
        }
    }
}
