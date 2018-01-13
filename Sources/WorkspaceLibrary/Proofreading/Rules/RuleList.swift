/*
 RuleList.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2018 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

let rules: [Rule.Type] = [

    // ••••••• Deprecation •••••••
    // Temporary rules which help with updating Workspace by catching deprecated usage.
    DeprecatedLinuxDocumentation.self,

    // ••••••• Intentional •••••••
    // Warnings that are requested manually.
    MissingImplementation.self,

    // ••••••• Functionality •••••••
    // Rules which ensure development tools (Workspace, Xcode, etc) work as intended.
    CompatibilityCharacters.self,
    AutoindentResilience.self,
    Mark.self,

    // ••••••• Documentation •••••••
    // Rules which improve documentation quality.
    DocumentationOfExtensionConstraints.self,
    DocumentationOfCompilationConditions.self,
    SyntaxColouring.self,

    // ••••••• Text Style •••••••
    // Rules which enforce consistent text style.
    UnicodeRule.self,

    // ••••••• Source Code Style •••••••
    // Rules which enforce consistent source code style.
    ColonSpacing.self,
    CalloutCasing.self,
    ParametersStyle.self
]
