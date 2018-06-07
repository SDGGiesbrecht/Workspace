
import GeneralImports

extension DocumentationConfiguration {

    internal static func normalize(localizationIdentifier: String) -> String {
        return InterfaceLocalization.code(for: StrictString(localizationIdentifier)) ?? localizationIdentifier
    }

    public var normalizedLocalizations: [String] {
        return localizations.map { DocumentationConfiguration.normalize(localizationIdentifier: $0) }
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
