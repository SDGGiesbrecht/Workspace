/*
 DeprecatedInheritanceDirectives.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2018 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import WSGeneralImports

import WSProject

internal struct DeprecatedInheritanceDirectives : Rule {
    // Deprecated in 0.10.0 (2018‐07‐11)

    internal static let name = UserFacing<StrictString, InterfaceLocalization>({ (localization) in
        switch localization {
        case .englishCanada:
            return "deprecatedInheritanceDirectives"
        }
    })

    private static func message(replacement: StrictString) -> UserFacing<StrictString, InterfaceLocalization> {
        return UserFacing<StrictString, InterfaceLocalization>({ (localization) in
            switch localization {
            case .englishCanada:
                return "This syntax is no longer recognized. Use “" + replacement + "” instead."
            }
        })
    }

    internal static func check(file: TextFile, in project: PackageRepository, status: ProofreadingStatus, output: Command.Output) {

        var searchIndex = file.contents.scalars.startIndex
        while let definition = file.contents.scalars[searchIndex...].firstNestingLevel(startingWith: "[\u{5F}Define Documentation: ".scalars, endingWith: "_]".scalars) {
            searchIndex = definition.container.range.upperBound

            let identifier = StrictString(definition.contents.contents)

            let definitionReplacement = UserFacing<StrictString, InterfaceLocalization>({ (localization) in
                switch localization {
                case .englishCanada:
                    return "\u{40}documentation(" + identifier + ")"
                }
            }).resolved()
            reportViolation(in: file, at: definition.container.range, replacementSuggestion: definitionReplacement, message: message(replacement: definitionReplacement), status: status, output: output)
        }

        searchIndex = file.contents.scalars.startIndex
        while let directive = file.contents.scalars[searchIndex...].firstNestingLevel(startingWith: "[\u{5F}Inherit Documentation: ".scalars, endingWith: "_]".scalars) {
            searchIndex = directive.container.range.upperBound

            let identifier = StrictString(directive.contents.contents)

            let directiveReplacement = UserFacing<StrictString, InterfaceLocalization>({ (localization) in
                switch localization {
                case .englishCanada:
                    return "\u{23}documentation(" + identifier + ")"
                }
            }).resolved()
            reportViolation(in: file, at: directive.container.range, replacementSuggestion: directiveReplacement, message: message(replacement: directiveReplacement), status: status, output: output)
        }
    }
}
