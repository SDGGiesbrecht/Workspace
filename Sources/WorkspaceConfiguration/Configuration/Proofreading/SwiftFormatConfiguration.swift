/*
 SwiftFormatConfiguration.swift

 This source file is part of the Workspace open source project.
 Diese Quelldatei ist Teil des quelloffenen Arbeitsbereich‐Projekt.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2019–2020 Jeremy David Giesbrecht and the Workspace project contributors.
 Urheberrecht ©2019–2020 Jeremy David Giesbrecht und die Mitwirkenden des Arbeitsbereich‐Projekts.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

// @localization(🇩🇪DE) @notLocalized(🇬🇧EN) @notLocalized(🇺🇸EN) @notLocalized(🇨🇦EN)
/// Eine SwiftFormat‐Konfiguration.
public typealias SwiftFormatKonfiguration = SwiftFormatConfiguration.Configuration

extension SwiftFormatConfiguration.Configuration {

  internal static var `default`: SwiftFormatConfiguration.Configuration {
    let configuration = SwiftFormatConfiguration.Configuration()

    // Illogical style choices.
    configuration.rules["IdentifiersMustBeASCII"] = false
    configuration.rules["MultiLineTrailingCommas"] = false
    configuration.rules["NoBlockComments"] = false

    // Generally good advice, but rules are noisy due to many valid exceptions.
    configuration.rules["DontRepeatTypeInStaticProperties"] = false
    configuration.rules["NeverUseForceTry"] = false
    configuration.rules["NeverForceUnwrap"] = false
    configuration.rules["NeverUseImplicitlyUnwrappedOptionals"] = false
    configuration.rules["NoLeadingUnderscores"] = false
    configuration.rules["OrderedImports"] = false
    configuration.rules["UseSynthesizedInitializer"] = false

    // Handled better during documentation coverage check.
    configuration.rules["AllPublicDeclarationsHaveDocumentation"] = false

    // Bugs currently result in false positives.
    // #workaround(Swift 5.1.3, Can these be restored?)
    configuration.rules["AlwaysUseLowerCamelCase"] = false
    configuration.rules["BlankLineBetweenMembers"] = false
    configuration.rules["CaseIndentLevelEqualsSwitch"] = false
    configuration.rules["UseLetInEveryBoundCaseVariable"] = false
    configuration.rules["ValidateDocumentationComments"] = false

    configuration.lineBreakBeforeEachArgument = true
    return configuration
  }
}
