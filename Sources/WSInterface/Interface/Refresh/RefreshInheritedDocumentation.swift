
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

        static let command = Command(name: name, description: description, directArguments: [], options: [], execution: { (_, options: Options, output: Command.Output) throws in

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
