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
///
/// ### In Xcode
///
/// Proofreading also works within Xcode, provided Workspace has been [fully installed](https://github.com/SDGGiesbrecht/Workspace#installation) on the local device. (If not, a link to installation instructions will be displayed instead.)
///
/// Workspace will automatically set up a proofreading scheme if it is in charge of Xcode.
///
/// If Workspace is not in charge of Xcode, proofreading can still be activated for a project by copying the scheme over from a generated project.
///
/// ### SwiftLint
///
/// Workspace’s proofreading includes [SwiftLint](https://github.com/realm/SwiftLint).
///
/// By default, Workspace provides SwiftLint with a standard configuration that interoperates well with Workspace and the Swift Package Manager.
///
/// However, SwiftLint can instead be configured manually by placing a `.swiftlint.yml` file in the project root. If such a file is present, Workspace will not apply its own configuration to SwiftLint. For more information about `.swiftlint.yml`, see [SwiftLint’s own documentation](https://github.com/realm/SwiftLint).
///
/// ### Special Thanks
///
/// - Realm and [SwiftLint](https://github.com/realm/SwiftLint)
public struct ProofreadingConfiguration : Codable {

    /// The set of active proofreading rules.
    ///
    /// All rules are active by default.
    ///
    /// Individual proofreading violations can be suppressed by placing `@exempt(from: ruleIdentifier)` on the same line.
    public var rules: Set<ProofreadingRule> = Set(ProofreadingRule.allCases)
}
