
extension Version : Codable {

    // MARK: - Encodable

    private enum CodingKeys : CodingKey {
        case major
        case minor
        case patch
    }

    // [_Inherit Documentation: SDGCornerstone.Encodable.encode(to:)_]
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(major, forKey: .major)
        try container.encode(minor, forKey: .minor)
        try container.encode(patch, forKey: .patch)
    }

    // [_Inherit Documentation: SDGCornerstone.Decodable.init(from:)_]
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let major = try container.decode(Int.self, forKey: .major)
        let minor = try container.decode(Int.self, forKey: .minor)
        let patch = try container.decode(Int.self, forKey: .patch)
        self.init(major, minor, patch)
    }
}
