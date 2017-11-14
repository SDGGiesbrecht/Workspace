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

typealias PackageRepository = _PackageRepository // Shared from SDGCommandLine.
extension PackageRepository {

    // MARK: - Initialization

    init(alreadyAt location: URL) {
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
        configuration.resetCache()
        if BuildConfiguration.current == .debug {
            print("(Debug notice: Repository cache reset for “\(location)”)")
        }
    }

    // MARK: - Location

    var location: URL {
        return _location // Shared from SDGCommandLine.
    }

    func url(for relativePath: String) -> URL {
        return _url(for: relativePath) // Shared from SDGCommandLine.
    }

    // MARK: - Configuration

    var configuration: Configuration {
        return Configuration(for: self)
    }

    // MARK: - Miscellaneous Properties

    var isWorkspaceProject: Bool {
        return location.lastPathComponent == "Workspace"
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

            if BuildConfiguration.current == .debug {
                print("(Debug notice: Loaded targets for “\(location)”)")
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
            guard let enumerator = FileManager.default.enumerator(at: location, includingPropertiesForKeys: [.isDirectoryKey, .isExecutableKey], options: [], errorHandler: { (_, error: Error) -> Bool in // [_Exempt from Code Coverage_] It is unknown what circumstances would actually cause an error.
                failureReason = error
                return false // Stop.
            }) else { // [_Exempt from Code Coverage_] It is unknown what circumstances would actually result in a `nil` enumerator being returned.
                throw Command.Error(description: UserFacingText<InterfaceLocalization, Void>({ (localization, _) in // [_Exempt from Code Coverage_]
                    switch localization {
                    case .englishCanada: // [_Exempt from Code Coverage_]
                        return "Cannot enumerate the project files."
                    }
                }))
            }

            var result: [URL] = []
            for object in enumerator {
                guard let url = object as? URL else { // [_Exempt from Code Coverage_] It is unknown why something other than a URL would be returned.
                    throw Command.Error(description: UserFacingText<InterfaceLocalization, Void>({ (localization, _) in // [_Exempt from Code Coverage_]
                        switch localization {
                        case .englishCanada: // [_Exempt from Code Coverage_]
                            return StrictString("Unexpected \(type(of: object)) encountered while enumerating project files.")
                        }
                    }))
                }

                let isDirectory: Bool
                #if os(Linux)
                    // [_Workaround: Linux has no implementation for resourcesValues(forKeys:) (Swift 4.0.2)_]
                    var objCBool: ObjCBool = false
                    isDirectory = FileManager.default.fileExists(atPath: url.path, isDirectory: &objCBool) ∧ objCBool
                #else
                    isDirectory = (try url.resourceValues(forKeys: [.isDirectoryKey])).isDirectory!
                #endif

                if ¬isDirectory, // Skip directories.
                    url.lastPathComponent ≠ ".DS_Store", // Skip irrelevant operating system files.
                    ¬url.path.hasSuffix("~") {

                    result.append(url)
                }
            }

            if let error = failureReason { // [_Exempt from Code Coverage_] It is unknown what circumstances would actually cause an error.
                throw error
            }

            if BuildConfiguration.current == .debug {
                print("(Debug notice: Loaded file list for “\(location)”)")
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

            let result = try allFiles().filter() { (url) in
                for ignoredURL in ignoredURLs {
                    if url.is(in: ignoredURL) {
                        return false
                    }
                }
                return true
            }

            if BuildConfiguration.current == .debug {
                print("(Debug notice: Loaded tracked file list for “\(location)”)")
            }

            return result
        }
    }

    func sourceFiles(output: inout Command.Output) throws -> [URL] {
        return try cached(in: &PackageRepository.caches[location, default: Cache()].sourceFiles) { () -> [URL] in

            let generatedURLs = [
                "docs",
                Script.refreshMacOS.fileName,
                Script.refreshLinux.fileName
                ].map({ url(for: String($0)) })

            let result = try trackedFiles(output: &output).filter() { (url) in
                for generatedURL in generatedURLs {
                    if url.is(in: generatedURL) { // [_Exempt from Code Coverage_] [_Workaround: Until “workspace‐scripts” is testable._]
                        return false
                    }
                }
                return true
            }

            if BuildConfiguration.current == .debug {
                print("(Debug notice: Loaded source list for “\(location)”)")
            }

            return result
        }
    }

    // MARK: - Scripts

    func refreshScripts(output: inout Command.Output) throws {
        try Script.refreshRelevantScripts(for: self, output: &output)
    }

    // MARK: - Resources

    func resourceFiles(output: inout Command.Output) throws -> [URL] {
        return try cached(in: &PackageRepository.caches[location, default: Cache()].resourceFiles) { () -> [URL] in
            let locations = resourceDirectories()

            let result = try sourceFiles(output: &output).filter() { (file) in
                for directory in locations where file.is(in: directory) {
                    return true
                } // [_Exempt from Code Coverage_] [_Workaround: False coverage result. (Swift 4.0.2)_]
                return false
            }

            if BuildConfiguration.current == .debug {
                print("(Debug notice: Loaded resource list for “\(location)”)")
            }

            return result
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
            try target.refresh(resources: resources, from: self, output: &output)
        }
    }
}
