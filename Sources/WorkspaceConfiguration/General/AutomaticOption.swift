
/// An option with a default value sensitive to information outside the configuration.
///
/// The automated value may depend on the package manifest, the contents of the repository, or other information which is not available until after the configuration is loaded.
public enum Automatic<Option> : Codable where Option : Codable {
    // [_Warning: Sink all these with context._]

    // MARK: - Cases

    /// Workspace will compute the option’s default value after the configuration is loaded.
    case automatic

    /// A custom value.
    case custom(Option)

    private enum AutomaticOptionType: String, Codable {
        case automatic
        case custom
    }

    // MARK: - Encoding

    private enum CodingKeys : CodingKey {
        case type
        case details
    }

    // [_Inherit Documentation: SDGCornerstone.Encodable.encode(to:)_]
    /// Encodes this value into the given encoder.
    ///
    /// - Parameters:
    ///     - encoder: The encoder to write data to.
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch self {
        case .automatic:
            try container.encode(AutomaticOptionType.automatic, forKey: CodingKeys.type)
        case .custom(let value):
            try container.encode(AutomaticOptionType.custom, forKey: CodingKeys.type)
            try container.encode(value, forKey: CodingKeys.details)
        }
    }

    // [_Inherit Documentation: SDGCornerstone.Decodable.init(from:)_]
    /// Creates a new instance by decoding from the given decoder.
    ///
    /// - Parameters:
    ///     - decoder: The decoder to read data from.
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let type = try container.decode(AutomaticOptionType.self, forKey: CodingKeys.type)
        switch type {
        case .automatic:
            self = .automatic
        case .custom:
            self = .custom(try container.decode(Option.self, forKey: CodingKeys.details))
        }
    }
}
