/*
 ProofreadingRuleCategory.swift

 This source file is part of the Workspace open source project.
 Diese Quelldatei ist Teil des qeulloffenen Workspace‐Projekt.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2018–2019 Jeremy David Giesbrecht and the Workspace project contributors.
 Urheberrecht ©2018–2019 Jeremy David Giesbrecht und die Mitwirkenden des Workspace‐Projekts.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

extension ProofreadingRule {

    /// A category of proofreading rule.
    public enum Category {

        // MARK: - Cases

        /// Temporary rules which help with updating Workspace by catching deprecated usage.
        case deprecation

        /// Warnings which are requested manually.
        case intentional

        /// Rules which ensure development tools (Workspace, Xcode, etc) work as intended.
        case functionality

        /// Rules which improve documentation quality.
        case documentation

        /// Rules which enforce consistent text style.
        case textStyle

        /// Rules which enforce consistent source code style.
        case sourceCodeStyle
    }
}
