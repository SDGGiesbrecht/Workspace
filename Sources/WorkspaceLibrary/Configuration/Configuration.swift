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

    private class Cache {
        var options: [Option: String]?
    }
    private static var caches: [URL: Cache] = [:]

    func resetCache() {
        Configuration.caches[location] = Cache()
        if BuildConfiguration.current == .debug {
            print("(Debug notice: Configuration cache reset for “\(location)”)")
        }
    }

    // MARK: - Properties

    var location: URL

    func options() throws -> [Option: String] {
        return try cached(in: &Configuration.caches[location, default: Cache()].options) { () -> [Option: String] in
            let file: TextFile
            do {
                file = try TextFile(alreadyAt: location)
                if BuildConfiguration.current == .debug {
                    print("(Debug notice: Loaded configuration at “\(location)”)")
                }
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
}
