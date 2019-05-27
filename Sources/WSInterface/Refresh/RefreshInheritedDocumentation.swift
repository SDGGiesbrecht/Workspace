/*
 RefreshInheritedDocumentation.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2018–2019 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import WSGeneralImports

import WSDocumentation

extension Workspace.Refresh {

    enum InheritedDocumentation {

        private static let name = UserFacing<StrictString, InterfaceLocalization>({ localization in
            switch localization {
            case .englishCanada:
                return "inherited‐documentation"
            }
        })

        private static let description = UserFacing<StrictString, InterfaceLocalization>({ localization in
            switch localization {
            case .englishCanada:
                return "synchronizes the project’s inherited documentation."
            }
        })

        private static let discussion = UserFacing<StrictString, InterfaceLocalization>({ localization in
            switch localization {
            case .englishCanada:
                return [
                    "It can be tedious re‐writing the same documentation over again. Workspace can make documentation comments re‐usable.",
                    "",
                    "Note: Both Xcode and Workspace now do this automatically in many situations when the child symbol is left undocumented, such as protocol conformances, default implementations and subclass overrides. The explicit directives described here should only be used as a fall‐back in situations where the tools cannot deduce the parent symbol automatically.",
                    "",
                    "To designate a documentation comment as a definition, place “@documentation(identifier)” on the line above. Anything on the same line will be ignored (such as “//”).",
                    "",
                    "protocol Rambler {",
                    "    // @documentation(MyLibrary.Rambler.ramble)",
                    "    /// Rambles on and on and on and on...",
                    "    func ramble() \u{2D}> Never",
                    "}",
                    "",
                    "Workspace can find definitions in any Swift file in the project.",
                    "",
                    "To inherit the documentation elsewhere, place “#documentation(identifier)” where the documentation would go (or above it if it already exists). Anything on the same line will be ignored (such as “//”).",
                    "",
                    "struct Teacher : Rambler {",
                    "    // #documentation(MyLibrary.Rambler.ramble)",
                    "    /// (Workspace will automatically fill this in whenever the project is refreshed.)",
                    "    func ramble() \u{2D}> Never {",
                    "        print(\u{22}Blah\u{22})",
                    "        while true {",
                    "            print(\u{22}, blah\u{22})",
                    "        }",
                    "    }",
                    "}",
                    ].joinedAsLines()
            }
        })

        static let command = Command(
            name: name,
            description: description,
            discussion: discussion,
            directArguments: [],
            options: Workspace.standardOptions,
            execution: { (_, options: Options, output: Command.Output) throws in

            output.print(UserFacing<StrictString, InterfaceLocalization>({ localization in
                switch localization {
                case .englishCanada:
                    return "Refreshing inherited documentation..."
                }
            }).resolved().formattedAsSectionHeader())

            try options.project.refreshInheritedDocumentation(output: output)
        })
    }
}
