/*
 Configuration.swift

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

struct Configuration {

    // MARK: - Static Properties

    static let fileName = ".Workspace Configuration.txt"

    // MARK: - Initialization

    init(for repository: PackageRepository) {
        self.location = repository.location.appendingPathComponent(Configuration.fileName)
    }

    // MARK: - Cache

    private struct Cache {
        var options: [Option: String]?
    }
    private static var caches: [URL: Cache] = [:]

    func resetCache(debugReason: String) { // [_Exempt from Code Coverage_] [_Workaround: Until normalize is testable._]
        Configuration.caches[location] = Cache()
        if location == Repository.packageRepository.configuration.location { // [_Exempt from Code Coverage_]
            // [_Workaround: Temporary bridging._]
            Configuration.resetCache()
        } // [_Exempt from Code Coverage_] [_Workaround: Until normalize is testable._]
        if BuildConfiguration.current == .debug { // [_Exempt from Code Coverage_] [_Workaround: Until normalize is testable._]
            print("(Debug notice: Configuration cache reset for “\(location.lastPathComponent)” because of “\(debugReason)”")
        }
    }

    // MARK: - Properties

    var location: URL

    func options() throws -> [Option: String] {
        // [_Workaround: Should be private, but necessary for temporary bridging._]
        return try cached(in: &Configuration.caches[location, default: Cache()].options) { () -> [Option: String] in
            let file: TextFile
            do {
                file = try TextFile(alreadyAt: location)
            } catch {
                file = try TextFile(possiblyAt: location)
            }
            return Configuration.parse(configurationSource: file.contents)
        }
    }

    // MARK: - Types

    private static func optionNotDefinedError(for option: Option) -> Command.Error {
        return Command.Error(description: UserFacingText<InterfaceLocalization, Void>({ (localization, _) in
            switch localization {
            case .englishCanada:
                return "Option not defined: " + StrictString(option.key)
            }
        }))
    }

    private static func invalidEnumerationValueError(for option: Option, value: String, valid: [StrictString]) -> Command.Error {
        return Command.Error(description: UserFacingText<InterfaceLocalization, Void>({ (localization, _) in
            switch localization {
            case .englishCanada:
                return StrictString(join(lines: [
                    "Invalid value for “\(option.key)”:",
                    String(value),
                    "Available values:"
                    ] + valid.map({ String($0) }) ))
            }
        }))
    }

    static let trueOptionValue: StrictString = "True"
    static let falseOptionValue: StrictString = "False"

    private func boolean(for option: Option) throws -> Bool? {
        if let value = try options()[option] {
            switch value {
            case String(Configuration.trueOptionValue):
                return true
            case String(Configuration.falseOptionValue):
                return false
            default:
                throw Configuration.invalidEnumerationValueError(for: option, value: value, valid: [Configuration.trueOptionValue, Configuration.falseOptionValue])
            }
        } else {
            return nil
        }
    }

    private func string(for option: Option) throws -> String? {
        return try options()[option]
    }

    func optionIsDefined(_ option: Option) throws -> Bool {
        return try options()[option] ≠ nil
    }

    // MARK: - Options: Supported Environment

    func projectType() throws -> PackageRepository.Target.TargetType {
        guard let key = try string(for: .projectType) else {
            return .library
        }
        guard let result = PackageRepository.Target.TargetType(key: StrictString(key)) else {
            throw Configuration.invalidEnumerationValueError(for: .projectType, value: key, valid: PackageRepository.Target.TargetType.cases.map({ $0.key }))
        }
        return result
    }

    func supports(_ operatingSystem: OperatingSystem) throws -> Bool {
        return try (try boolean(for: operatingSystem.supportOption) ?? true)
            ∧ (try projectType().isSupported(on: operatingSystem))
    }

    // MARK: - Options: Project Metadata

    func projectName() throws -> StrictString {
        if let defined = try string(for: .projectName) {
            return StrictString(defined)
        } else {
            return StrictString(try packageName())
        }
    }

    func repositoryURL() throws -> URL? {
        if let defined = try string(for: .repositoryURL) {
            return URL(string: defined)
        }
        return nil
    }

    func documentationCopyright() throws -> Template {
        if let defined = try string(for: .documentationCopyright) {
            return Template(source: StrictString(defined))
        } else {
            return try Documentation.defaultCopyrightTemplate(configuration: self)
        }
    }
    func requireAuthor() throws -> StrictString {
        if let defined = try string(for: .author) {
            return StrictString(defined)
        } else {
            throw Configuration.optionNotDefinedError(for: .author)
        }
    }

    // MARK: - Options: Active Tasks

    func shouldManageContinuousIntegration() throws -> Bool {
        return try boolean(for: .manageContinuousIntegration) ?? false
    }

    func shouldGenerateDocumentation() throws -> Bool {
        return try boolean(for: .generateDocumentation) ?? true
    }
    func shouldEnforceDocumentationCoverage() throws -> Bool {
        return try boolean(for: .enforceDocumentationCoverage) ?? true
    }

    // MARK: - Options: Overrides

    func packageName() throws -> String {
        if let defined = try string(for: .packageName) {
            return defined
        } else {
            // [_Warning: This should parse Package.swift._]
            notImplementedYetAndCannotReturn()
        }
    }

    func xcodeScheme() throws -> String {
        if let defined = try string(for: .xcodeSchemeName) {
            return defined
        } else {
            // [_Warning: This should be moved to SwiftTool._]
            return try packageName() + "\u{2D}Package"
        }
    }
}
