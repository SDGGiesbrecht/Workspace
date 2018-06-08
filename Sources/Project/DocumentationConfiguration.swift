
import GeneralImports

extension DocumentationConfiguration {

    internal static func normalize(localizationIdentifier: LocalizationIdentifier) -> LocalizationIdentifier {
        return InterfaceLocalization.code(for: StrictString(localizationIdentifier)) ?? localizationIdentifier
    }

    internal var normalizedLocalizations: [LocalizationIdentifier] {
        return localizations.map { DocumentationConfiguration.normalize(localizationIdentifier: $0) }
    }
}
