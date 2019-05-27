/*
 RefreshScripts.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2017–2019 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import WSGeneralImports
import WSProject
import WSScripts

extension Workspace.Refresh {

    enum Scripts {

        private static let name = UserFacing<StrictString, InterfaceLocalization>({ localization in
            switch localization {
            case .englishCanada:
                return "scripts"
            }
        })

        private static let description = UserFacing<StrictString, InterfaceLocalization>({ localization in
            switch localization {
            case .englishCanada:
                return "regenerates the project’s refresh and validation scripts."
            }
        })

        private static let discussion = UserFacing<StrictString, InterfaceLocalization>({ localization in
            switch localization {
            case .englishCanada:
                return [
                    "Linux may require some additional set‐up before the generated scripts work with a double‐click. This applies to both “Refresh (Linux).sh” and “Validate (Linux).sh”.",
                    "",
                    "Solutions to common errors are found below.",
                    "",
                    "If the necessary fix is undesirable, it is possible to run these scripts from a terminal instead. (See the bottom of this page.)",
                    "",
                    "• Error: The Script Opens in a Text Editor",
                    "",
                    "Linux needs to be set to run executable scripts when they are double‐clicked instead of opening them to edit.",
                    "",
                    "On Ubuntu, the setting is found at:",
                    "",
                    "“Files” → “Edit” → “Preferences” → “Behavior” → “Run execuatable text files when they are opened”",
                    "",
                    "• Error: Swift Is Unavailable",
                    "",
                    "Because the script opens a new terminal to display its output, brand‐new terminal sessions need to be able to find the `swift` command without additional set‐up.",
                    "",
                    "To register the location of `swift` even for new terminal sessions, run the following command, substituting the real location of the Swift install.",
                    "",
                    "$ echo 'export PATH=/path/to/swift-0.0.0-RELEASE-ubuntu00.00/usr/bin:\u{22}${PATH}\u{22}' >>~/.profile",
                    "",
                    "(If Swift is not even istalled yet, see the Swift website—https://swift.org/download/—for instructions.)",
                    "",
                    "• Running from a Terminal",
                    "",
                    "While double‐clicking is usually the most convenient, it can be bypassed by manually running the macOS equivalent from a terminal:",
                    "",
                    "$ \u{22}./Refresh (macOS).command\u{22}",
                    "",
                    "This is exactly what the Linux script does internally. It just opens a new terminal window first to display the output.",
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
                    return "Refreshing scripts..."
                }
            }).resolved().formattedAsSectionHeader())

            try options.project.refreshScripts(output: output)
        })
    }
}
