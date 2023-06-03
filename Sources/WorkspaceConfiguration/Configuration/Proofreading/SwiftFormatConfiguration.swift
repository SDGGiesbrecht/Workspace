/*
 SwiftFormatConfiguration.swift

 This source file is part of the Workspace open source project.
 Diese Quelldatei ist Teil des quelloffenen Arbeitsbereich‐Projekt.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2019–2023 Jeremy David Giesbrecht and the Workspace project contributors.
 Urheberrecht ©2019–2023 Jeremy David Giesbrecht und die Mitwirkenden des Arbeitsbereich‐Projekts.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

#if !PLATFORM_NOT_SUPPORTED_BY_SWIFT_FORMAT_SWIFT_FORMAT_CONFIGURATION
  // @localization(🇩🇪DE) @notLocalized(🇬🇧EN) @notLocalized(🇺🇸EN) @notLocalized(🇨🇦EN)
  /// Eine SwiftFormat‐Konfiguration.
  public typealias SwiftFormatKonfiguration = SwiftFormatConfiguration.Configuration

  extension SwiftFormatConfiguration.Configuration {

    internal static var `default`: SwiftFormatConfiguration.Configuration {
      var configuration = SwiftFormatConfiguration.Configuration()

      // Illogical style choices.
      configuration.rules["IdentifiersMustBeASCII"] = false
      configuration.rules["MultiLineTrailingCommas"] = false
      configuration.rules["NoBlockComments"] = false

      // Generally good advice, but rules are noisy due to many valid exceptions.
      configuration.rules["AmbiguousTrailingClosureOverload"] = false
      configuration.rules["DontRepeatTypeInStaticProperties"] = false
      configuration.rules["NeverUseForceTry"] = false
      configuration.rules["NeverForceUnwrap"] = false
      configuration.rules["NeverUseImplicitlyUnwrappedOptionals"] = false
      configuration.rules["NoLeadingUnderscores"] = false
      configuration.rules["OrderedImports"] = false
      configuration.rules["UseSynthesizedInitializer"] = false
      configuration.rules["ValidateDocumentationComments"] = false

      // Handled better during documentation coverage check.
      configuration.rules["AllPublicDeclarationsHaveDocumentation"] = false

      // Unable to enforce correctly; many false positives.
      configuration.rules["AlwaysUseLowerCamelCase"] = false

      configuration.lineBreakBeforeEachArgument = true
      configuration.lineBreakBeforeEachGenericRequirement = true
      // #workaround(swift-format 0.508000.0, Leads to crash.) @exempt(from: unicode)
      // configuration.prioritizeKeepingFunctionOutputTogether = true

      // For consistency across all operators, both standard and custom.
      configuration.spacesAroundRangeFormationOperators = true

      return configuration
    }
  }
#endif
