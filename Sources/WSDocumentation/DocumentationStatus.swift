/*
 DocumentationStatus.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2018–2019 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import WSGeneralImports

import SDGSwiftSource

import WSProject

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

    private func report(problem: UserFacing<StrictString, InterfaceLocalization>) {
        passing = false
        output.print(problem.resolved().formattedAsError().separated())
    }

    private func report(problem: UserFacing<StrictString, InterfaceLocalization>, with symbol: APIElement, navigationPath: [APIElement], parameter: String? = nil, hint: UserFacing<StrictString, InterfaceLocalization>? = nil) {
        var symbolName: StrictString
        switch symbol {
        case .package, .library, .module:
            symbolName = StrictString(symbol.name.source())
        case .type, .protocol, .extension, .case, .initializer, .variable, .subscript, .function, .operator, .precedence, .conformance:
            symbolName = navigationPath.dropFirst().map({ StrictString($0.name.source()) }).joined(separator: ".")
        }
        if let specificParameter = parameter {
            symbolName += "." + StrictString(specificParameter)
        }
        report(problem: UserFacing({ localization in
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
        switch symbol {
        case .package:
            possibleSearch = "Package"
        case .library:
            possibleSearch = ".library"
        case .module:
            possibleSearch = ".target"
        case .type, .protocol, .extension, .case, .initializer, .variable, .subscript, .function, .operator, .precedence, .conformance:
            break
        }
        if var search = possibleSearch {
            search.append(contentsOf: "(name: \u{22}" + StrictString(symbol.name.source()) + "\u{22}")

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

    internal func reportMissingParameter(_ parameter: String, symbol: APIElement, navigationPath: [APIElement]) {
        report(problem: UserFacing<StrictString, InterfaceLocalization>({ localization in
            switch localization {
            case .englishCanada:
                return "A parameter has no description:"
            }
        }), with: symbol, navigationPath: navigationPath, parameter: parameter)
    }

    internal func reportNonExistentParameter(_ parameter: String, symbol: APIElement, navigationPath: [APIElement]) {
        report(problem: UserFacing<StrictString, InterfaceLocalization>({ localization in
            switch localization {
            case .englishCanada:
                return "A described parameter does not exist:"
            }
        }), with: symbol, navigationPath: navigationPath, parameter: parameter)
    }

    internal func reportUnlabelledParameter(_ closureType: String, symbol: APIElement, navigationPath: [APIElement]) {
        report(problem: UserFacing<StrictString, InterfaceLocalization>({ localization in
            switch localization {
            case .englishCanada:
                return "A closure parameter has no label:"
            }
        }), with: symbol, navigationPath: navigationPath, parameter: closureType)
    }

    internal func reportMissingVariableType(_ variable: VariableAPI, navigationPath: [APIElement]) {
        report(problem: UserFacing<StrictString, InterfaceLocalization>({ localization in
            switch localization {
            case .englishCanada:
                return "A public variable has no explicit type:"
            }
        }), with: APIElement.variable(variable), navigationPath: navigationPath)
    }

    internal func reportMissingYearFirstPublished() {
        report(problem: UserFacing<StrictString, InterfaceLocalization>({ localization in
            switch localization {
            case .englishCanada:
                return ([
                    "No original copyright date is specified.",
                    "(Configure it under “documentation.api.yearFirstPublished”.)"
                    ] as [StrictString]).joinedAsLines()
            }
        }))
    }

    internal func reportMissingCopyright(localization: LocalizationIdentifier) { // @exempt(from: tests) #workaround(Not used yet.)
        report(problem: UserFacing<StrictString, InterfaceLocalization>({ localization in
            switch localization {
            case .englishCanada:
                return ([
                    "A localization has no copyright specified: " + StrictString("\(localization)"),
                    "(Configure it under “documentation.api.copyrightNotice”.)"
                ] as [StrictString]).joinedAsLines()
            }
        }))
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
