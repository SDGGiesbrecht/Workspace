
import GeneralImports

import WorkspaceConfiguration

extension DocumentationConfiguration {

    public var normalizedLocalizations: [String] {
        return localizations.map { (entry) -> String in
            return InterfaceLocalization.code(for: StrictString(entry)) ?? entry
        }
    }

    public func developmentLocalization() throws -> String {
        guard let result = normalizedLocalizations.first else {
            throw Command.Error(description: UserFacing<StrictString, InterfaceLocalization>({ localization in
                switch localization {
                case .englishCanada:
                    return "The project does not specify any localizations."
                }
            }))
        }
        return result
    }
}
