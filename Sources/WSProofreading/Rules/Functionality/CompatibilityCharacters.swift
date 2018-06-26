/*
 CompatibilityCharacters.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2017–2018 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGLogic
import WSGeneralImports

import WSProject

internal struct CompatibilityCharacters : Rule {

    internal static let name = UserFacing<StrictString, InterfaceLocalization>({ (localization) in
        switch localization {
        case .englishCanada:
            return "compatibilityCharacters"
        }
    })

    internal static func check(file: TextFile, in project: PackageRepository, status: ProofreadingStatus, output: Command.Output) {
        for index in file.contents.scalars.indices {
            let scalar = file.contents.scalars[index]
            let character = String(scalar)
            let normalized = character.decomposedStringWithCompatibilityMapping
            if character ≠ normalized {
                reportViolation(in: file, at: index ..< file.contents.scalars.index(after: index), replacementSuggestion: StrictString(normalized), message: UserFacing<StrictString, InterfaceLocalization>({ (localization) in
                    switch localization {
                    case .englishCanada:
                        return StrictString("U+\(scalar.hexadecimalCode) may be lost in normalization; use “\(normalized)” instead.")
                    }
                }), status: status, output: output)
            }
        }
    }
}
