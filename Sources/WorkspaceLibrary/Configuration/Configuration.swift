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

    init(location: URL) {
        self.location = location
    }

    // MARK: - Cache

    private struct Cache {
        var options: [Option: String]?
    }
    private static var caches: [URL: Cache] = [:]

    func resetCache(debugReason: String) {
        Configuration.caches[location] = Cache()
        if location == Repository.packageRepository.configuration.location {
            // [_Workaround: Temporary bridging._]
            Configuration.resetCache()
        }
        if BuildConfiguration.current == .debug {
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
                print(UserFacingText<InterfaceLocalization, Void>({ (localization, _) in
                    switch localization {
                    case .englishCanada:
                        return StrictString(join(lines: [
                            "Found no configuration file.",
                            "Following the default configuration."
                        ]))
                    }
                }))
                file = try TextFile(possiblyAt: location)
            }
            return Configuration.parse(configurationSource: file.contents)
        }
    }

    // MARK: - Types

    private static func invalidEnumerationValue(option: Option, value: String, valid: [StrictString]) -> Command.Error {
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

    private func boolean(for option: Option) throws -> Bool {
        if let value = try options()[option] {
            switch value {
            case String(Configuration.trueOptionValue):
                return true
            case String(Configuration.falseOptionValue):
                return false
            default:
                throw Configuration.invalidEnumerationValue(option: option, value: value, valid: [Configuration.trueOptionValue, Configuration.falseOptionValue])
            }
        } else {
            return option.defaultValue == String(Configuration.trueOptionValue)
        }
    }

    // MARK: - Options

    func shouldManageContinuousIntegration() throws -> Bool {
        return try boolean(for: .manageContinuousIntegration)
    }
}
