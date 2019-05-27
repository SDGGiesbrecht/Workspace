/*
 ProofreadingConfiguration.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2018–2019 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

/// Options related to proofreading.
///
/// ```shell
/// $ workspace proofread
/// ```
public struct ProofreadingConfiguration : Codable {

    /// The set of active proofreading rules.
    ///
    /// All rules are active by default.
    ///
    /// Individual proofreading violations can be suppressed by placing `@exempt(from: ruleIdentifier)` on the same line.
    public var rules: Set<ProofreadingRule> = Set(ProofreadingRule.allCases)

    /// The scope in which to apply the `unicode` rule.
    public var unicodeRuleScope: Set<UnicodeRuleScope> = Set(UnicodeRuleScope.allCases)
}
