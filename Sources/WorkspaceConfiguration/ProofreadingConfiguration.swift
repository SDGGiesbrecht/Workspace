/*
 LicenceConfiguration.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2018 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

/// Options related to proofreading.
public struct ProofreadingConfiguration: Codable {

    /// The set of active proofreading rules.
    ///
    /// All rules are active by default.
    public var rules: Set<ProofreadingRule> = Set(ProofreadingRule.cases)
}
