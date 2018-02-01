/*
 SDGCommandLine.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2018 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

// [_Workaround: Everything in this file should be in moved to SDGCommandLine. (SDGCommandLine 0.1.4)_]

import Foundation

import SDGCornerstone
import SDGCommandLine

extension _Swift {

    private func parseError(packageDescription json: String) -> Command.Error { // [_Exempt from Code Coverage_] Reachable only with an incompatible version of Swift.
        return Command.Error(description: UserFacingText<InterfaceLocalization, Void>({ (localization, _) in // [_Exempt from Code Coverage_]
            switch localization {
            case .englishCanada: // [_Exempt from Code Coverage_]
                return StrictString("Error loading dependency graph:\n\(json)")
            }
        }))
    }

    func _dependencies(output: inout Command.Output) throws -> [StrictString: Version] {

        _ = try _execute(with: ["package", "resolve"], output: &output, silently: false, autoquote: true) // If resolution interrupts the dump, the output is invalid JSON.

        let json = try executeInCompatibilityMode(with: [
            "package", "show\u{2D}dependencies",
            "\u{2D}\u{2D}format", "json"
            ], output: &output, silently: true)

        guard let graph = (try JSONSerialization.jsonObject(with: json.file, options: []) as? PropertyListValue)?.as([String: Any].self) else { // [_Exempt from Code Coverage_] Reachable only with an incompatible version of Swift.
            throw parseError(packageDescription: json)
        }

        guard let dependencies = (graph["dependencies"] as? PropertyListValue)?.as([Any].self) else { // [_Exempt from Code Coverage_] Reachable only with an incompatible version of Swift.
            throw parseError(packageDescription: json)
        }

        var result: [StrictString: Version] = [:]
        for dictionary in dependencies {
            guard let dependency = (dictionary as? PropertyListValue)?.as([String: Any].self),
                let name = (dependency["name"] as? PropertyListValue)?.as(String.self),
                let versionString = (dependency["version"] as? PropertyListValue)?.as(String.self) else { // [_Exempt from Code Coverage_] Reachable only with an incompatible version of Swift.
                    throw parseError(packageDescription: json)
            }

            if let version = Version(versionString) {
                result[StrictString(name)] = version
            }
        }
        return result
    }

    @discardableResult func _build(output: inout Command.Output) throws -> Bool {
        let log = try _execute(with: ["build"], output: &output, silently: false, autoquote: true)
        if log.contains(" warning:".scalars) {
            return false
        } else {
            return true
        }
    }

    func _test(output: inout Command.Output) -> Bool {
        do {
            let _: Void = try _test(output: &output) // Shared from SDGCommandLine.
            return true
        } catch {
            return false
        }
    }
}
