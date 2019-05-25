/*
 MockCommand.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2019 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import WSGeneralTestImports

import SDGCommandLine

let mockCommand = Command(
    name: UserFacing<StrictString, InterfaceLocalization>({ localization in
        switch localization {
        case .englishCanada:
            return "do‐something"
        }
    }),
    description: UserFacing<StrictString, InterfaceLocalization>({ localization in
        switch localization {
        case .englishCanada:
            return "does something."
        }
    }),
    discussion: UserFacing<StrictString, InterfaceLocalization>({ localization in
        switch localization {
        case .englishCanada:
            return "Paragraph one.\nLine two.\n\nParagraph two."
        }
    }),
    directArguments: [ArgumentType.string],
    options: [mockOption],
    execution: { _, _, _ in })

let mockOption = Option(
    name: UserFacing<StrictString, InterfaceLocalization>({ localization in
        switch localization {
        case .englishCanada:
            return "alternative"
        }
    }),
    description: UserFacing<StrictString, InterfaceLocalization>({ localization in
        switch localization {
        case .englishCanada:
            return "An alternative."
        }
    }),
    type: ArgumentType.string)
