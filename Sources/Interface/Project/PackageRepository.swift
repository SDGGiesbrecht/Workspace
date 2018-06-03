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

import PackageModel
import PackageGraph

extension PackageRepository {

    // MARK: - Configuration

    var configuration: Configuration {
        return Configuration(for: self)
    }

    // MARK: - Structure

    func targets() throws -> [Target] {
        return try cachedPackage().manifest.package.targets.map { primitiveTarget in
            return Target(packageDescriptionTarget: primitiveTarget, package: self)
        }
    }
    func targetsByName() throws -> [String: Target] {
        var byName: [String: Target] = [:]
        for target in try targets() {
            byName[target.name] = target
        }
        return byName
    }

    func publicLibraryModules() throws -> [String] {
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
        let locations = resourceDirectories()

        let result = try sourceFiles(output: output).filter { (file) in
            for directory in locations where file.is(in: directory) {
                return true
            }
            // [_Exempt from Test Coverage_] [_Workaround: False coverage result. (Swift 4.0.2)_]
            return false
        }
        return result
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

        for (target, resources) in targets.keys.sorted(by: { $0.name.scalars.lexicographicallyPrecedes($1.name.scalars) }).map({ ($0, targets[$0]!) }) { // So that output order is consistent.
            // [_Workaround: Simple “sorted()” differs between operating systems. (Swift 4.1)_]

            try autoreleasepool {
                try target.refresh(resources: resources, from: self, output: output)
            }
        }
    }

    // MARK: - Examples

    func examples(output: Command.Output) throws -> [String: String] {
        return try Examples.examples(in: self, output: output)
    }

    // MARK: - Documentation

    func hasTargetsToDocument(output: Command.Output) throws -> Bool {
        return ¬(try publicLibraryModules()).isEmpty
    }

    #if !os(Linux)
    // MARK: - #if !os(Linux)
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
}
