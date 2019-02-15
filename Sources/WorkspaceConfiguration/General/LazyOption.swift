/*
 LazyOption.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2018–2019 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

/// An option which can be resolved lazily. It can be derived from the state of other options, which can be modified before this option’s value is resolved.
public struct Lazy<Option> : Decodable, Encodable where Option : Codable {

    // MARK: - Initialization

    /// Creates a lazy option with a resolution algorithm.
    ///
    /// - Parameters:
    ///     - resolve: An closure which resolves the option.
    ///     - configuration: The configuration from which to derive the result.
    public init(resolve: @escaping (_ configuration: WorkspaceConfiguration) -> Option) {
        self.resolve = resolve
    }

    // MARK: - Properties

    /// The algorithm for resolving the value.
    ///
    /// - Parameters:
    ///     - configuration: The configuration based on which to resolve the option.
    public var resolve: (_ configuration: WorkspaceConfiguration) -> Option

    // MARK: - Encoding

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(resolve(WorkspaceConfiguration.registered))
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let resolved = try container.decode(Option.self)
        resolve = { _ in resolved }
    }
}
