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

    private func report(problem: UserFacing<StrictString, InterfaceLocalization>, with symbol: APIElement, navigationPath: [APIElement], hint: UserFacing<StrictString, InterfaceLocalization>? = nil) {
        let symbolName: StrictString
        switch symbol {
        case is PackageAPI, is ModuleAPI:
            symbolName = StrictString(symbol.name)
        default:
            symbolName = navigationPath.dropFirst().map({ StrictString($0.name) }).joined(separator: ".")
        }
        report(warning: UserFacing({ localization in
            var result: [StrictString] = [
                problem.resolved(for: localization),
                symbolName
            ]
            if let theHint = hint {
                result.append(theHint.resolved(for: localization))
            }
            return result.joined(separator: "\n")
        }))
    }

    internal func reportMissingDescription(symbol: APIElement, navigationPath: [APIElement]) {
        var hint: UserFacing<StrictString, InterfaceLocalization>?

        var possibleSearch: StrictString?
        if symbol is PackageAPI {
            possibleSearch = "Package"
        } else if symbol is ProductAPI {
            possibleSearch = ".library"
        } else if symbol is ModuleAPI {
            possibleSearch = ".target"
        }
        if var search = possibleSearch {
            search.append(contentsOf: "(name: \u{22}" + StrictString(symbol.name) + "\u{22}")

            hint = UserFacing<StrictString, InterfaceLocalization>({ localization in
                switch localization {
                case .englishCanada:
                    return "(Packages, products and modules (targets) can be documented in the package manifest the same way as other symbols.\nWorkspace will look for documentation on the line above “" + search + "”.)"
                }
            })
        }

        report(problem: UserFacing<StrictString, InterfaceLocalization>({ localization in
            switch localization {
            case .englishCanada:
                return "A symbol has no description:"
            }
        }), with: symbol, navigationPath: navigationPath, hint: hint)
    }

    internal func reportMissingVariableType(_ variable: VariableAPI, navigationPath: [APIElement]) {
        report(problem: UserFacing<StrictString, InterfaceLocalization>({ localization in
            switch localization {
            case .englishCanada:
                return "A public variable has no explicit type:"
            }
        }), with: variable, navigationPath: navigationPath)
    }

    internal func reportExcessiveHeading(symbol: APIElement, navigationPath: [APIElement]) {
        report(problem: UserFacing<StrictString, InterfaceLocalization>({ localization in
            switch localization {
            case .englishCanada:
                return "A symbol’s documentation contains excessively strong headings:"
            }
        }), with: symbol, navigationPath: navigationPath, hint: UserFacing<StrictString, InterfaceLocalization>({ localization in
            switch localization {
            case .englishCanada:
                return "(Use heading levels three to six. Levels one and two are reserved for the surrounding context.)"
            }
        }))
    }
}
