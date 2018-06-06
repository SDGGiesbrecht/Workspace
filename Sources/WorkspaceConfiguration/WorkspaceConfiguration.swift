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

    /// Whether or not to provide workflow scripts.
    ///
    /// This is on by default.
    ///
    /// These scripts are provided to reduce refreshment and validation to a simple double‐click. They will also ensure that the same version of Workspace gets used for the project on every machine it is cloned to.
    var provideWorkflowScripts: Bool = true

    /// The operating systems the project supports.
    ///
    /// The default assumes support for all operating systems.
    var supportedOperatingSystems: Set<OperatingSystem> = Set(OperatingSystem.cases)

    /// Options related to documentation.
    var documentation: DocumentationConfiguration = DocumentationConfiguration()

    /// Options related to continuous integration.
    var continuousIntegration: ContinuousIntegrationConfiguration = ContinuousIntegrationConfiguration()

    // MARK: - Methods

    /// Opts into all tasks which are off by default.
    ///
    /// - Warning: Many opt‐in tasks involve writing into project files.
    public func optIntoAllTasks() {
        documentation.manageReadMe = true
    }

    // MARK: - Encoding

    private enum CodingKeys : CodingKey {
        case provideWorkflowScripts
        case supportedOperatingSystems
        case documentation
        case continuousIntegration
    }

    // [_Inherit Documentation: SDGCornerstone.Encodable.encode(to:)_]
    /// Encodes this value into the given encoder.
    ///
    /// - Parameters:
    ///     - encoder: The encoder to write data to.
    public override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(provideWorkflowScripts, forKey: .provideWorkflowScripts)
        try container.encode(supportedOperatingSystems, forKey: .supportedOperatingSystems)
        try container.encode(documentation, forKey: .documentation)
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
        provideWorkflowScripts = try container.decode(Bool.self, forKey: .provideWorkflowScripts)
        supportedOperatingSystems = try container.decode(Set<OperatingSystem>.self, forKey: .supportedOperatingSystems)
        documentation = try container.decode(DocumentationConfiguration.self, forKey: .documentation)
        continuousIntegration = try container.decode(ContinuousIntegrationConfiguration.self, forKey: .continuousIntegration)
        try super.init(from: container.superDecoder())
    }

    // MARK: - Configuration

    /// Creates a Workspace configuration according to the defaults.
    ///
    /// Defaults are generally non‐invasive. Tasks which would write into project files are generally off by default.
    ///
    /// To opt in to all tasks, including the more invasive ones, use `optIntoAllTasks()`.
    public required init() {
        super.init()
    }
}
