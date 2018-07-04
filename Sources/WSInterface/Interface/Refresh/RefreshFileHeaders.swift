
import WSGeneralImports

import WSFileHeaders

extension Workspace.Refresh {

    enum FileHeaders {

        private static let name = UserFacing<StrictString, InterfaceLocalization>({ localization in
            switch localization {
            case .englishCanada:
                return "file‐headers"
            }
        })

        private static let description = UserFacing<StrictString, InterfaceLocalization>({ localization in
            switch localization {
            case .englishCanada:
                return "re‐applies the project file header to each of the project’s files."
            }
        })

        static let command = Command(name: name, description: description, directArguments: [], options: [], execution: { (_, options: Options, output: Command.Output) throws in

            output.print(UserFacing<StrictString, InterfaceLocalization>({ localization in
                switch localization {
                case .englishCanada:
                    return "Refreshing file headers..."
                }
            }).resolved().formattedAsSectionHeader())

            try options.project.refreshFileHeaders(output: output)
        })
    }
}
