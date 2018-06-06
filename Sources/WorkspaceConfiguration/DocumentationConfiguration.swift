
/// Options related to documentation.
public struct DocumentationConfiguration : Codable {

    // MARK: - Properties

    /// The localizations supported by the project.
    ///
    /// This is a list of localization identifiers, either IETF language tags or language icons.
    ///
    /// The default contains no localizations, but some tasks may throw errors if they require localizations to be specified.
    public var localizations: [String] = []

    /// Whether or not to manage the project read‐me.
    ///
    /// This is off by default.
    public var manageReadMe: Bool = false
}
