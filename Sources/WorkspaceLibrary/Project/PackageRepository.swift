/*
 PackageRepository.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2017–2018 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import Foundation

import SDGControlFlow
import SDGLogic

import SDGCommandLine

import SDGSwift
import SDGSwiftPackageManager
// [_Warning: Probably not necessary._]
import SDGXcode

// [_Warning: Probably not necessary._]
import PackageModel

extension PackageRepository {

    // MARK: - Cache

    private class Cache {
        fileprivate var manifest: PackageModel.Manifest?
        fileprivate var package: PackageModel.Package?
        fileprivate var publicLibraryModules: [String]?
        fileprivate var targets: [Target]?
        fileprivate var targetsByName: [String: Target]?
        fileprivate var dependencies: [StrictString: SDGSwift.Version]?

        fileprivate var allFiles: [URL]?
        fileprivate var trackedFiles: [URL]?
        fileprivate var sourceFiles: [URL]?
        fileprivate var resourceFiles: [URL]?

        fileprivate var examples: [String: String]?
    }
    private static var caches: [URL: Cache] = [:]
    private var cache: Cache {
        return cached(in: &PackageRepository.caches[location]) {
            return Cache()
        }
    }

    func resetCache(debugReason: String) {
        PackageRepository.caches[location] = Cache()
        if BuildConfiguration.current == .debug {
            print("(Debug notice: Repository cache reset for “\(location.lastPathComponent)” because of “\(debugReason)”)")
        }
    }

    // MARK: - Configuration

    var configuration: Configuration {
        return Configuration(for: self)
    }

    // MARK: - Miscellaneous Properties

    func isWorkspaceProject(output: Command.Output) throws -> Bool {
        return try projectName() == "Workspace"
    }

    // MARK: - Structure

    func cachedManifest() throws -> PackageModel.Manifest {
        return try cached(in: &cache.manifest) {
            return try manifest()
        }
    }

    func cachedPackage() throws -> PackageModel.Package {
        return try cached(in: &cache.package) {
            return try package()
        }
    }

    func projectName() throws -> StrictString {
        return StrictString(try cachedManifest().name)
    }

    func targets() throws -> [Target] {
        // [_Warning: Redesign this._]
        return try cached(in: &cache.targets) {
            var targetInformation: [(name: String, location: URL)] = []
            for target in try cachedPackage().manifest.package.targets {
                if let path = target.path {
                    targetInformation.append((name: target.name, location: URL(fileURLWithPath: path)))
                } else {
                    let base: URL
                    if target.isTest {
                        base = location.appendingPathComponent("Tests")
                    } else {
                        base = location.appendingPathComponent("Sources")
                    }
                    targetInformation.append((name: target.name, location: base.appendingPathComponent(target.name)))
                }
            }
            return targetInformation.map { Target(name: $0.name, sourceDirectory: $0.location) }
        }
    }
    func targetsByName() throws -> [String: Target] {
        return try cached(in: &cache.targetsByName) {
            let ordered = try targets()
            var byName: [String: Target] = [:]
            for target in ordered {
                byName[target.name] = target
            }
            return byName
        }
    }

    func publicLibraryModules() throws -> [String] {
        return try cached(in: &cache.publicLibraryModules) {
            var result: [String] = []
            for product in try cachedPackage().products {
                switch product.type {
                case .library:
                    for target in product.targets {
                        if ¬result.contains(target.name) {
                            result.append(target.name)
                        }
                    }
                case .executable, .test:
                    break
                }
            }
            return result
        }
    }

    static let resourceDirectoryName = UserFacing<StrictString, InterfaceLocalization>({ localization in
        switch localization {
        case .englishCanada:
            return "Resources"
        }
    })

    func resourceDirectories() -> [URL] {

        return InterfaceLocalization.cases.map { (localization) in
            return location.appendingPathComponent(String(PackageRepository.resourceDirectoryName.resolved(for: localization)))
        }
    }

    func dependencies(output: Command.Output) throws -> [StrictString: SDGSwift.Version] {
        return try cached(in: &cache.dependencies) {
            // [_Warning: Redesign this._]
            var result: [StrictString: SDGSwift.Version] = [:]
            let graph = try packageGraph()
            for dependency in graph.packages {
                if let version = dependency.manifest.version {
                    result[StrictString(dependency.name)] = SDGSwift.Version(version.major, version.minor, version.patch)
                }
            }
            return result
        }
    }

    // MARK: - Files

    func allFiles() throws -> [URL] {
        return try cached(in: &cache.allFiles) {
            () -> [URL] in

            var failureReason: Error? // Thrown after enumeration stops. (See below.)
            guard let enumerator = FileManager.default.enumerator(at: location, includingPropertiesForKeys: [.isDirectoryKey, .isExecutableKey], options: [], errorHandler: { (_, error: Error) -> Bool in // [_Exempt from Test Coverage_] It is unknown what circumstances would actually cause an error.
                failureReason = error
                return false // Stop.
            }) else { // [_Exempt from Test Coverage_] It is unknown what circumstances would actually result in a `nil` enumerator being returned.
                throw Command.Error(description: UserFacing<StrictString, InterfaceLocalization>({ (localization) in // [_Exempt from Test Coverage_]
                    switch localization {
                    case .englishCanada: // [_Exempt from Test Coverage_]
                        return "Cannot enumerate the project files."
                    }
                }))
            }

            var result: [URL] = []
            for object in enumerator {
                guard let url = object as? URL else { // [_Exempt from Test Coverage_] It is unknown why something other than a URL would be returned.
                    throw Command.Error(description: UserFacing<StrictString, InterfaceLocalization>({ (localization) in // [_Exempt from Test Coverage_]
                        switch localization {
                        case .englishCanada: // [_Exempt from Test Coverage_]
                            return StrictString("Unexpected \(type(of: object)) encountered while enumerating project files.")
                        }
                    }))
                }

                let isDirectory: Bool
                #if os(Linux)
                // [_Workaround: Linux has no implementation for resourcesValues(forKeys:) (Swift 4.0.2)_]
                var objCBool: ObjCBool = false
                isDirectory = FileManager.default.fileExists(atPath: url.path, isDirectory: &objCBool) ∧ objCBool.boolValue
                #else
                isDirectory = (try url.resourceValues(forKeys: [.isDirectoryKey])).isDirectory!
                #endif

                if ¬isDirectory, // Skip directories.
                    url.lastPathComponent ≠ ".DS_Store", // Skip irrelevant operating system files.
                    ¬url.lastPathComponent.hasSuffix("~") {

                    result.append(url)
                }
            }

            if let error = failureReason { // [_Exempt from Test Coverage_] It is unknown what circumstances would actually cause an error.
                throw error
            }
            return result.sorted() // So that output order is consistent.
        }
    }

    func trackedFiles(output: Command.Output) throws -> [URL] {
        return try cached(in: &cache.trackedFiles) {
            () -> [URL] in

            var ignoredURLs: [URL] = try ignoredFiles()
            ignoredURLs.append(location.appendingPathComponent(".git"))

            let result = try allFiles().filter { (url) in
                for ignoredURL in ignoredURLs {
                    if url.is(in: ignoredURL) {
                        return false
                    }
                }
                return true
            }
            return result
        }
    }

    func sourceFiles(output: Command.Output) throws -> [URL] {
        return try cached(in: &cache.sourceFiles) { () -> [URL] in

            let generatedURLs = [
                "docs",
                Script.refreshMacOS.fileName,
                Script.refreshLinux.fileName,

                "Tests/Mock Projects" // To prevent treating them as Workspace source files for headers, etc.
                ].map({ location.appendingPathComponent( String($0)) })

            let result = try trackedFiles(output: output).filter { (url) in
                for generatedURL in generatedURLs {
                    if url.is(in: generatedURL) {
                        return false
                    }
                }
                return true
            }
            return result
        }
    }

    // MARK: - Scripts

    func refreshScripts(output: Command.Output) throws {
        try Script.refreshRelevantScripts(for: self, output: output)
    }

    // MARK: - Read‐Me

    func refreshReadMe(output: Command.Output) throws {
        try ReadMe.refreshReadMe(for: self, output: output)
    }

    // MARK: - Continuous Integration

    func refreshContinuousIntegration(output: Command.Output) throws {
        try ContinuousIntegration.refreshContinuousIntegration(for: self, output: output)
    }

    // MARK: - Resources

    func resourceFiles(output: Command.Output) throws -> [URL] {
        return try cached(in: &cache.resourceFiles) { () -> [URL] in
            let locations = resourceDirectories()

            let result = try sourceFiles(output: output).filter { (file) in
                for directory in locations where file.is(in: directory) {
                    return true
                } // [_Exempt from Test Coverage_] [_Workaround: False coverage result. (Swift 4.0.2)_]
                return false
            }
            return result
        }
    }

    func target(for resource: URL, output: Command.Output) throws -> Target {
        let path = resource.path(relativeTo: location).dropping(through: "/")
        guard let targetName = path.prefix(upTo: "/")?.contents else {
            throw Command.Error(description: UserFacing<StrictString, InterfaceLocalization>({ (localization) in
                switch localization {
                case .englishCanada:
                    return StrictString("No target specified for resource:\n\(path)\nFiles must be in subdirectories named corresponding to the intended target.")
                }
            }))
        }
        guard let target = (try targetsByName())[String(targetName)] else {
            throw Command.Error(description: UserFacing<StrictString, InterfaceLocalization>({ (localization) in
                switch localization {
                case .englishCanada:
                    return StrictString("No target named “\(targetName)”.\nResources must be in subdirectories named corresponding to the intended target.")
                }
            }))
        }
        return target
    }

    func refreshResources(output: Command.Output) throws {

        var targets: [Target: [URL]] = [:]
        for resource in try resourceFiles(output: output) {
            let intendedTarget = try target(for: resource, output: output)
            targets[intendedTarget, default: []].append(resource)
        }

        for (target, resources) in targets {
            try autoreleasepool {
                try target.refresh(resources: resources, from: self, output: output)
            }
        }
    }

    // MARK: - Examples

    func examples(output: Command.Output) throws -> [String: String] {
        return try cached(in: &cache.examples) {
            return try Examples.examples(in: self, output: output)
        }
    }

    // MARK: - Documentation

    func hasTargetsToDocument(output: Command.Output) throws -> Bool {
        return ¬(try publicLibraryModules()).isEmpty
    }

    #if !os(Linux)
    func document(outputDirectory: URL, validationStatus: inout ValidationStatus, output: Command.Output) throws {
        for product in try publicLibraryModules() {
            try autoreleasepool {
                try Documentation.document(target: product, for: self, outputDirectory: outputDirectory, validationStatus: &validationStatus, output: output)
            }
        }
    }

    func validateDocumentationCoverage(outputDirectory: URL, validationStatus: inout ValidationStatus, output: Command.Output) throws {
        for product in try publicLibraryModules() {
            try autoreleasepool {
                try Documentation.validateDocumentationCoverage(for: product, in: self, outputDirectory: outputDirectory, validationStatus: &validationStatus, output: output)
            }
        }
    }
    #endif

    #if !os(Linux)

    // MARK: - Xcode

    func xcodeProjectFile() throws -> URL? { // [_Exempt from Test Coverage_] [_Workaround: Until refresh Xcode is testable._]
        // [_Warning: Redesign this._]
        return try xcodeProject()
    }

    func xcodeScheme(output: Command.Output) throws -> String {
        // [_Warning: Redesign this._]
        return try scheme()
    }

    #endif

    // MARK: - Actions

    func delete(_ location: URL, output: Command.Output) {
        if FileManager.default.fileExists(atPath: location.path, isDirectory: nil) {
            TextFile.reportDeleteOperation(from: location, in: self, output: output)
            try? FileManager.default.removeItem(at: location)
            resetCache(debugReason: location.lastPathComponent)
        }
    }
}
