/*
 Xcode.swift

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

typealias Xcode = _Xcode // Shared from SDGCommandLine.
extension Xcode {

    // MARK: - Static Properties

    static let defaultVersion = Version(9, 1)
    static let `default` = Xcode(version: defaultVersion)

    // MARK: - Initialization

    convenience init(version: Version) {
        self.init(_version: version)
    }

    // MARK: - Usage

    private func parseError(projectInformation: String) -> Command.Error {
        return Command.Error(description: UserFacingText<InterfaceLocalization, Void>({ (localization, _) in // [_Exempt from Code Coverage_] Reachable only with an incompatible version of Xcode.
            switch localization {
            case .englishCanada: // [_Exempt from Code Coverage_]
                return StrictString("Error loading Xcode project:\n\(projectInformation)")
            }
        }))
    }

    func projectFile() throws -> URL? {
        let files = try FileManager.default.contentsOfDirectory(at: URL(fileURLWithPath: FileManager.default.currentDirectoryPath), includingPropertiesForKeys: [], options: [])

        for file in files where file.pathExtension == "xcodeproj" {
            return file
        }

        return nil
    }

    func scheme(output: inout Command.Output) throws -> String {
        let information = try executeInCompatibilityMode(with: ["\u{2D}list"], output: &output, silently: true)

        guard let schemesHeader = information.scalars.firstMatch(for: "Schemes:".scalars)?.range else {
            throw parseError(projectInformation: information)
        }
        let schemesHeaderLine = schemesHeader.lines(in: information.lines)
        let nextLine = schemesHeaderLine.upperBound
        guard nextLine ≠ information.lines.endIndex else {
            throw parseError(projectInformation: information)
        }
        let line = information.lines[nextLine].line

        return String(line.filter({ $0 ∉ CharacterSet.whitespaces }))
    }
}
