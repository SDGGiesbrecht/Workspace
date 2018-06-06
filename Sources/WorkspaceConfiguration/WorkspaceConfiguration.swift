/*
 WorkspaceConfiguration.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2018 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGSwiftConfiguration

/// A Workspace configuration.
public final class WorkspaceConfiguration : Configuration {

    // MARK: - Properties

    /// The operating systems the project supports.
    ///
    /// The default assumes support for all operating systems.
    var supportedOperatingSystems: Set<OperatingSystem> = Set(OperatingSystem.cases)

    /// Options related to continuous integration.
    var continuousIntegration: ContinuousIntegrationConfiguration = ContinuousIntegrationConfiguration()

    // MARK: - Encoding

    private enum CodingKeys : CodingKey {
        case supportedOperatingSystems
        case continuousIntegration
    }

    // [_Inherit Documentation: SDGCornerstone.Encodable.encode(to:)_]
    /// Encodes this value into the given encoder.
    ///
    /// - Parameters:
    ///     - encoder: The encoder to write data to.
    public override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(supportedOperatingSystems, forKey: .supportedOperatingSystems)
        try container.encode(continuousIntegration, forKey: .continuousIntegration)
        try super.encode(to: container.superEncoder())
    }

    // [_Inherit Documentation: SDGCornerstone.Decodable.init(from:)_]
    /// Creates a new instance by decoding from the given decoder.
    ///
    /// - Parameters:
    ///     - decoder: The decoder to read data from.
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        supportedOperatingSystems = try container.decode(Set<OperatingSystem>.self, forKey: .supportedOperatingSystems)
        continuousIntegration = try container.decode(ContinuousIntegrationConfiguration.self, forKey: .continuousIntegration)
        try super.init(from: container.superDecoder())
    }

    // MARK: - Configuration

    /// Creates a Workspace configuration according to the defaults.
    public required init() {
        super.init()
    }
}
