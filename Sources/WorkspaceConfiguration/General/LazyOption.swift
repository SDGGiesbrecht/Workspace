/*
 LazyOption.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2018 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

/// An option which can be resolved lazily. It can be derived from the state of other options, which can be modified before this option’s value is resolved.
public struct Lazy<Option> : Codable where Option : Codable {

    // MARK: - Initialization

    /// Creates a lazy option with a resolution algorithm.
    public init(resolve: @escaping (WorkspaceConfiguration) -> Option) {
        self.resolve = resolve
    }

    // MARK: - Properties

    /// The algorithm for resolving the value.
    public var resolve: (WorkspaceConfiguration) -> Option

    // MARK: - Encoding

    // [_Inherit Documentation: SDGCornerstone.Encodable.encode(to:)_]
    /// Encodes this value into the given encoder.
    ///
    /// - Parameters:
    ///     - encoder: The encoder to write data to.
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(resolve(WorkspaceConfiguration.registered))
    }

    // [_Inherit Documentation: SDGCornerstone.Decodable.init(from:)_]
    /// Creates a new instance by decoding from the given decoder.
    ///
    /// - Parameters:
    ///     - decoder: The decoder to read data from.
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let resolved = try container.decode(Option.self)
        resolve = {_ in resolved }
    }
}
