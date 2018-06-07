import GeneralImports

extension ReadMeConfiguration {

    public var normalizedShortProjectDescription: [LocalizationIdentifier: StrictString] {
        return shortProjectDescription.mapKeyValuePairs { localization, text in
            return (DocumentationConfiguration.normalize(localizationIdentifier: localization), StrictString(text))
        }
    }
}
