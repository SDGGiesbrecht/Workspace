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

    // @localization(🇩🇪DE) @crossReference(Category)
    /// Eine Klasse von Kurrekturregeln.
    public typealias Klasse = Category
    // @localization(🇬🇧EN) @localization(🇺🇸EN) @localization(🇨🇦EN) @crossReference(Category)
    /// A category of proofreading rule.
    public enum Category {

        // MARK: - Cases

        // #workaround(Not properly localized yet.)
        // @localization(🇬🇧EN) @localization(🇺🇸EN) @localization(🇨🇦EN) @localization(🇩🇪DE)
        /// Temporary rules which help with updating Workspace by catching deprecated usage.
        case deprecation

        // #workaround(Not properly localized yet.)
        // @localization(🇬🇧EN) @localization(🇺🇸EN) @localization(🇨🇦EN) @localization(🇩🇪DE)
        /// Warnings which are requested manually.
        case intentional

        // #workaround(Not properly localized yet.)
        // @localization(🇬🇧EN) @localization(🇺🇸EN) @localization(🇨🇦EN) @localization(🇩🇪DE)
        /// Rules which ensure development tools (Workspace, Xcode, etc) work as intended.
        case functionality

        // #workaround(Not properly localized yet.)
        // @localization(🇬🇧EN) @localization(🇺🇸EN) @localization(🇨🇦EN) @localization(🇩🇪DE)
        /// Rules which improve documentation quality.
        case documentation

        // #workaround(Not properly localized yet.)
        // @localization(🇬🇧EN) @localization(🇺🇸EN) @localization(🇨🇦EN) @localization(🇩🇪DE)
        /// Rules which enforce consistent text style.
        case textStyle

        // #workaround(Not properly localized yet.)
        // @localization(🇬🇧EN) @localization(🇺🇸EN) @localization(🇨🇦EN) @localization(🇩🇪DE)
        /// Rules which enforce consistent source code style.
        case sourceCodeStyle
    }
}
