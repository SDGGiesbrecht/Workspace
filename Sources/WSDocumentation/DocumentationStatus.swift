/*
 DocumentationStatus.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2018 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import WSGeneralImports

import SDGSwiftSource

internal class DocumentationStatus {

    // MARK: - Initialization

    internal init(output: Command.Output) {
        passing = true
        self.output = output
    }

    // MARK: - Properties

    internal var passing: Bool
    internal let output: Command.Output

    // MARK: - Reporting

    private func report(warning: UserFacing<StrictString, InterfaceLocalization>) {
        passing = false
        output.print(warning.resolved().formattedAsError())
    }

    internal func reportMissingDescription(symbol: APIElement, navigationPath: [APIElement]) {
        let description = UserFacing<StrictString, InterfaceLocalization>({ localization in
            switch localization {
            case .englishCanada:
                return "A symbol has no description:"
            }
        })
        let symbolName: StrictString
        switch symbol {
        case is PackageAPI, is ModuleAPI:
            symbolName = StrictString(symbol.name)
        default:
            symbolName = navigationPath.dropFirst().map({ StrictString($0.name) }).joined(separator: ".")
        }
        var hint: UserFacing<StrictString, InterfaceLocalization>?
        if symbol is PackageAPI {
            hint = UserFacing<StrictString, InterfaceLocalization>({ localization in
                switch localization {
                case .englishCanada:
                    return "(The package can be documented in the package manifest the same way as other symbols. Workspace will look for documentation on the line above “Package(name: \u{22}" + StrictString(symbol.name) + "\u{22}”.)"
                }
            })
        }
        report(warning: UserFacing({ localization in
            var result: [StrictString] = [
                description.resolved(for: localization),
                symbolName
            ]
            if let theHint = hint {
                result.append(theHint.resolved(for: localization))
            }
            return result.joined(separator: "\n")
        }))
    }
}
