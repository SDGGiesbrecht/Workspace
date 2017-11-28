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
        fileprivate class Properties {
            fileprivate var options: [Option: String]?
            fileprivate var localizations: [String]?
            fileprivate var localizedOptions: [Option: [String: String]] = [:]
        }
        fileprivate var properties = Properties()
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
        return try cached(in: &Configuration.caches[location, default: Cache()].properties.options) { () -> [Option: String] in
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

    private static func optionNotDefinedError(for option: Option) -> Command.Error { // [_Exempt from Code Coverage_] [_Workaround: Until licence is testable._]
        return Command.Error(description: UserFacingText<InterfaceLocalization, Void>({ (localization, _) in // [_Exempt from Code Coverage_] [_Workaround: Until licence is testable._]
            switch localization {
            case .englishCanada: // [_Exempt from Code Coverage_] [_Workaround: Until licence is testable._]
                return "Configuration option not defined: " + StrictString(option.key)
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
    private func strictString(for option: Option) throws -> StrictString? {
        guard let defined = try string(for: option) else {
            return nil
        }
        return StrictString(defined)
    }
    private func localizedString(for localization: String, from option: Option) throws -> String? {
        let localized = try cached(in: &Configuration.caches[location, default: Cache()].properties.localizedOptions[option]) {
            guard let defined = try string(for: option) else {
                return [:]
            }
            return try Configuration.parseLocalizations(defined, for: option)
        }
        return localized[localization]
    }
    private func localizedStrictString(for localization: String, from option: Option) throws -> StrictString? {
        guard let defined = try localizedString(for: localization, from: option) else {
            return nil
        }
        return StrictString(defined)
    }

    private func localizedTemplate(for localization: String, from option: Option) throws -> Template? {
        guard let source = try localizedStrictString(for: localization, from: option) else {
            return nil
        }
        return Template(source: source)
    }

    private func list(for option: Option) throws -> [String] {
        guard let string = try string(for: option) else {
            return []
        }
        return string.lines.map({ String($0.line) })
    }

    func optionIsDefined(_ option: Option) throws -> Bool { // [_Exempt from Code Coverage_] [_Workaround: Until licence is testable._]
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

    // MARK: - Options: Localizations

    func localizations() throws -> [String] {
        return try cached(in: &Configuration.caches[location, default: Cache()].properties.localizations) {

            let result = try list(for: .localizations)
            if result.isEmpty {
                throw Configuration.optionNotDefinedError(for: .localizations)
            }
            return result.map() { (entry) -> String in
                return InterfaceLocalization.code(for: StrictString(entry)) ?? entry
            }
        }
    }
    func developmentLocalization() throws -> String {
        guard let result = try localizations().first else {
            unreachable()
        }
        return result
    }

    // MARK: - Options: Project Metadata

    func repositoryURL() throws -> URL? {
        if let defined = try string(for: .repositoryURL) {
            return URL(string: defined)
        }
        return nil
    }
    func documentationURL() throws -> URL? {
        if let defined = try string(for: .documentationURL) {
            return URL(string: defined)
        }
        return nil
    }
    func requireDocumentationURL() throws -> URL {
        guard let defined = try documentationURL() else {
            throw Configuration.optionNotDefinedError(for: .documentationURL)
        }
        return defined
    }

    func documentationCopyright() throws -> Template {
        if let defined = try strictString(for: .documentationCopyright) {
            return Template(source: defined)
        } else {
            return try Documentation.defaultCopyrightTemplate(configuration: self)
        }
    }
    func requireAuthor() throws -> StrictString {
        if let defined = try strictString(for: .author) {
            return defined
        } else {
            throw Configuration.optionNotDefinedError(for: .author)
        }
    }

    func requireShortProjectDescription(for localization: String, project: PackageRepository) throws -> StrictString {
        guard let defined = try localizedStrictString(for: localization, from: .shortProjectDescription) else {
            throw Configuration.optionNotDefinedError(for: .shortProjectDescription)
        }
        return defined
    }
    func quotation() throws -> StrictString? {
        return try strictString(for: .quotation)
    }
    func requireQuotation() throws -> StrictString {
        guard let defined = try quotation() else {
            throw Configuration.optionNotDefinedError(for: .quotation)
        }
        return defined
    }

    func readMe(for localization: String, project: PackageRepository) throws -> Template {
        if let defined = try localizedTemplate(for: localization, from: .readMe) {
            return defined
        } else {
            return try ReadMe.defaultReadMeTemplate(for: localization, project: project)
        }
    }

    // MARK: - Options: Active Tasks

    func shouldManageReadMe() throws -> Bool {
        return try boolean(for: .manageReadMe) ?? false
    }

    func shouldManageContinuousIntegration() throws -> Bool {
        return try boolean(for: .manageContinuousIntegration) ?? false
    }

    func shouldGenerateDocumentation() throws -> Bool {
        return try boolean(for: .generateDocumentation) ?? true
    }
    func shouldEnforceDocumentationCoverage() throws -> Bool {
        return try boolean(for: .enforceDocumentationCoverage) ?? true
    }
}
