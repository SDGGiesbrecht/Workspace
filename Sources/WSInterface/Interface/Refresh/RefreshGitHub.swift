
import WSGeneralImports

extension Workspace.Refresh {

    enum GitHub {

        private static let name = UserFacing<StrictString, InterfaceLocalization>({ localization in
            switch localization {
            case .englishCanada:
                return "github"
            }
        })

        private static let description = UserFacing<StrictString, InterfaceLocalization>({ localization in
            switch localization {
            case .englishCanada:
                return "regenerates the project’s GitHub configuration files."
            }
        })

        static let command = Command(name: name, description: description, directArguments: [], options: [], execution: { (_, options: Options, output: Command.Output) throws in

            output.print(UserFacing<StrictString, InterfaceLocalization>({ localization in
                switch localization {
                case .englishCanada:
                    return "Refreshing GitHub configuration..."
                }
            }).resolved().formattedAsSectionHeader())

            try options.project.refreshGitHubConfiguration(output: output)
        })
    }
}
