/*
 PackageRepository.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2017–2018 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGLogic
import GeneralImports

import SDGSwiftPackageManager
import SDGSwiftConfigurationLoading

extension PackageRepository {

    // MARK: - Cache

    private class Cache {
        fileprivate var manifest: PackageModel.Manifest?
        fileprivate var package: PackageModel.Package?
        fileprivate var packageGraph: PackageGraph?

        fileprivate var configuration: WorkspaceConfiguration?

        fileprivate var allFiles: [URL]?
        fileprivate var trackedFiles: [URL]?
        fileprivate var sourceFiles: [URL]?

        fileprivate var dependenciesByName: [String: ResolvedPackage]?
    }
    private static var caches: [URL: Cache] = [:]
    private var cache: Cache {
        return cached(in: &PackageRepository.caches[location]) {
            return Cache()
        }
    }

    public func resetCache(debugReason: String) {
        PackageRepository.caches[location] = Cache()
        if BuildConfiguration.current == .debug {
            print("(Debug notice: Repository cache reset for “\(location.lastPathComponent)” because of “\(debugReason)”)")
        }
    }

    // MARK: - Miscellaneous Properties

    public func isWorkspaceProject() throws -> Bool {
        return try projectName() == "Workspace"
    }

    // MARK: - Structure

    public func cachedManifest() throws -> PackageModel.Manifest {
        return try cached(in: &cache.manifest) {
            return try manifest()
        }
    }

    public func cachedPackage() throws -> PackageModel.Package {
        return try cached(in: &cache.package) {
            return try package()
        }
    }

    public func cachedPackageGraph() throws -> PackageGraph {
        return try cached(in: &cache.packageGraph) {
            return try packageGraph()
        }
    }

    public func cachedConfiguration() throws -> WorkspaceConfiguration {
        return try cached(in: &cache.configuration) {
            let other = try packageGraph()
            return WorkspaceConfiguration()
        }
    }

    public func projectName() throws -> StrictString {
        return StrictString(try cachedManifest().name)
    }

    public func dependenciesByName() throws -> [String: ResolvedPackage] {
        return try cached(in: &cache.dependenciesByName) {
            let graph = try cachedPackageGraph()

            var result: [String: ResolvedPackage] = [:]
            for dependency in graph.packages {
                result[dependency.name] = dependency
            }
            return result
        }
    }

    // MARK: - Files

    public func allFiles() throws -> [URL] {
        return try cached(in: &cache.allFiles) {
            () -> [URL] in
            let files = try FileManager.default.deepFileEnumeration(in: location).filter { url in
                // Skip irrelevant operating system files.
                return url.lastPathComponent ≠ ".DS_Store"
                    ∧ ¬url.lastPathComponent.hasSuffix("~")
            }
            return files.sorted { $0.absoluteString.scalars.lexicographicallyPrecedes($1.absoluteString.scalars) } // So that output order is consistent.
            // [_Workaround: Simple “sorted()” differs between operating systems. (Swift 4.1)_]
        }
    }

    public func trackedFiles(output: Command.Output) throws -> [URL] {
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

    public func sourceFiles(output: Command.Output) throws -> [URL] {
        return try cached(in: &cache.sourceFiles) { () -> [URL] in

            let generatedURLs = [
                "docs",
                refreshScriptMacOSFileName,
                refreshScriptLinuxFileName,

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

    // MARK: - Actions

    public func delete(_ location: URL, output: Command.Output) {
        if FileManager.default.fileExists(atPath: location.path, isDirectory: nil) {

            output.print(UserFacingDynamic<StrictString, InterfaceLocalization, String>({ localization, path in
                switch localization {
                case .englishCanada:
                    return StrictString("Deleting “\(path)”...")
                }
            }).resolved(using: location.path(relativeTo: self.location)))

            try? FileManager.default.removeItem(at: location)
            resetCache(debugReason: location.lastPathComponent)
        }
    }
}
