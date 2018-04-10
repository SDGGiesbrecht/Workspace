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
        fileprivate var packageStructure: (name: String, libraryProductTargets: [String], executableProducts: [String], targets: [(name: String, location: URL)])?
        fileprivate var targets: [Target]?
        fileprivate var targetsByName: [String: Target]?
        fileprivate var dependencies: [StrictString: Version]?

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

    // MARK: - Location

    var location: URL {
        return _location // Shared from SDGCommandLine.
    }

    // MARK: - Configuration

    var configuration: Configuration {
        return Configuration(for: self)
    }

    // MARK: - Miscellaneous Properties

    func isWorkspaceProject(output: inout Command.Output) throws -> Bool {
        return try projectName(output: &output) == "Workspace"
    }

    // MARK: - Structure

    private func packageStructure(output: inout Command.Output) throws -> (name: String, libraryProductTargets: [String], executableProducts: [String], targets: [(name: String, location: URL)]) {
        return try cached(in: &cache.packageStructure) {
            var result: (name: String, libraryProductTargets: [String], executableProducts: [String], targets: [(name: String, location: URL)])?
            try FileManager.default.do(in: location) {
                result = try SwiftTool.default.packageStructure(output: &output)
            }
            return result!
        }
    }

    func projectName(output: inout Command.Output) throws -> StrictString {
        return StrictString(try packageName(output: &output))
    }

    func packageName(output: inout Command.Output) throws -> String {
        return try packageStructure(output: &output).name
    }

    func targets(output: inout Command.Output) throws -> [Target] {
        return try cached(in: &cache.targets) {
            let targetInformation = try packageStructure(output: &output).targets
            return targetInformation.map { Target(name: $0.name, sourceDirectory: $0.location) }
        }
    }
    func targetsByName(output: inout Command.Output) throws -> [String: Target] {
        return try cached(in: &cache.targetsByName) {
            let ordered = try targets(output: &output)
            var byName: [String: Target] = [:]
            for target in ordered {
                byName[target.name] = target
            }
            return byName
        }
    }

    func libraryProductTargets(output: inout Command.Output) throws -> [String] {
        return try packageStructure(output: &output).libraryProductTargets
    }

    func executableTargets(output: inout Command.Output) throws -> [String] {
        return try packageStructure(output: &output).executableProducts
    }

    static let resourceDirectoryName = UserFacingText<InterfaceLocalization>({ (localization) in
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

    func dependencies(output: inout Command.Output) throws -> [StrictString: Version] {
        return try cached(in: &cache.dependencies) {
            var result: [StrictString: Version]?
            try FileManager.default.do(in: location) {
                result = try SwiftTool.default.dependencies(output: &output)
            }
            return result!
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
                throw Command.Error(description: UserFacingText<InterfaceLocalization>({ (localization) in // [_Exempt from Test Coverage_]
                    switch localization {
                    case .englishCanada: // [_Exempt from Test Coverage_]
                        return "Cannot enumerate the project files."
                    }
                }))
            }

            var result: [URL] = []
            for object in enumerator {
                guard let url = object as? URL else { // [_Exempt from Test Coverage_] It is unknown why something other than a URL would be returned.
                    throw Command.Error(description: UserFacingText<InterfaceLocalization>({ (localization) in // [_Exempt from Test Coverage_]
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
                isDirectory = FileManager.default.fileExists(atPath: url.path, isDirectory: &objCBool) ∧ objCBool
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

    func trackedFiles(output: inout Command.Output) throws -> [URL] {
        return try cached(in: &cache.trackedFiles) {
            () -> [URL] in

            var ignoredURLs: [URL] = []
            try FileManager.default.do(in: location) {
                ignoredURLs = try Git.default.ignoredFiles(output: &output)
            }
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

    func sourceFiles(output: inout Command.Output) throws -> [URL] {
        return try cached(in: &cache.sourceFiles) { () -> [URL] in

            let generatedURLs = [
                "docs",
                Script.refreshMacOS.fileName,
                Script.refreshLinux.fileName,

                "Tests/Mock Projects" // To prevent treating them as Workspace source files for headers, etc.
                ].map({ location.appendingPathComponent( String($0)) })

            let result = try trackedFiles(output: &output).filter { (url) in
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

    func refreshScripts(output: inout Command.Output) throws {
        try Script.refreshRelevantScripts(for: self, output: &output)
    }

    // MARK: - Read‐Me

    func refreshReadMe(output: inout Command.Output) throws {
        try ReadMe.refreshReadMe(for: self, output: &output)
    }

    // MARK: - Continuous Integration

    func refreshContinuousIntegration(output: inout Command.Output) throws {
        try ContinuousIntegration.refreshContinuousIntegration(for: self, output: &output)
    }

    // MARK: - Resources

    func resourceFiles(output: inout Command.Output) throws -> [URL] {
        return try cached(in: &cache.resourceFiles) { () -> [URL] in
            let locations = resourceDirectories()

            let result = try sourceFiles(output: &output).filter { (file) in
                for directory in locations where file.is(in: directory) {
                    return true
                } // [_Exempt from Test Coverage_] [_Workaround: False coverage result. (Swift 4.0.2)_]
                return false
            }
            return result
        }
    }

    func target(for resource: URL, output: inout Command.Output) throws -> Target {
        let path = resource.path(relativeTo: location).dropping(through: "/")
        guard let targetName = path.prefix(upTo: "/")?.contents else {
            throw Command.Error(description: UserFacingText<InterfaceLocalization>({ (localization) in
                switch localization {
                case .englishCanada:
                    return StrictString("No target specified for resource:\n\(path)\nFiles must be in subdirectories named corresponding to the intended target.")
                }
            }))
        }
        guard let target = (try targetsByName(output: &output))[String(targetName)] else {
            throw Command.Error(description: UserFacingText<InterfaceLocalization>({ (localization) in
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
            try autoreleasepool {
                try target.refresh(resources: resources, from: self, output: &output)
            }
        }
    }

    // MARK: - Examples

    func examples(output: inout Command.Output) throws -> [String: String] {
        return try cached(in: &cache.examples) {
            return try Examples.examples(in: self, output: &output)
        }
    }

    // MARK: - Documentation

    func hasTargetsToDocument(output: inout Command.Output) throws -> Bool {
        return ¬(try libraryProductTargets(output: &output)).isEmpty
    }

    #if !os(Linux)
    func document(outputDirectory: URL, validationStatus: inout ValidationStatus, output: inout Command.Output) throws {
        for product in try libraryProductTargets(output: &output) {
            try autoreleasepool {
            try Documentation.document(target: product, for: self, outputDirectory: outputDirectory, validationStatus: &validationStatus, output: &output)
            }
        }
    }

    func validateDocumentationCoverage(outputDirectory: URL, validationStatus: inout ValidationStatus, output: inout Command.Output) throws {
        for product in try libraryProductTargets(output: &output) {
            try autoreleasepool {
            try Documentation.validateDocumentationCoverage(for: product, in: self, outputDirectory: outputDirectory, validationStatus: &validationStatus, output: &output)
            }
        }
    }
    #endif

    #if !os(Linux)

    // MARK: - Xcode

    func xcodeProjectFile() throws -> URL? { // [_Exempt from Test Coverage_] [_Workaround: Until refresh Xcode is testable._]
        var result: URL?
        try FileManager.default.do(in: location) { // [_Exempt from Test Coverage_] [_Workaround: Until refresh Xcode is testable._]
            result = try Xcode.default.projectFile()
        } // [_Exempt from Test Coverage_] [_Workaround: Until refresh Xcode is testable._]
        return result
    }

    func xcodeScheme(output: inout Command.Output) throws -> String {
        var result: String = ""
        try FileManager.default.do(in: location) {
            result = try Xcode.default.scheme(output: &output)
        }
        return result
    }

    #endif

    // MARK: - Actions

    func delete(_ location: URL, output: inout Command.Output) {
        if FileManager.default.fileExists(atPath: location.path, isDirectory: nil) {
            TextFile.reportDeleteOperation(from: location, in: self, output: &output)
            try? FileManager.default.removeItem(at: location)
            resetCache(debugReason: location.lastPathComponent)
        }
    }
}
