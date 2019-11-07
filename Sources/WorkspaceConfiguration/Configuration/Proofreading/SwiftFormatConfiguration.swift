/*
 SwiftFormatConfiguration.swift

 This source file is part of the Workspace open source project.
 Diese Quelldatei ist Teil des qeulloffenen Arbeitsbereich‐Projekt.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2019 Jeremy David Giesbrecht and the Workspace project contributors.
 Urheberrecht ©2019 Jeremy David Giesbrecht und die Mitwirkenden des Arbeitsbereich‐Projekts.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

// @notLocalized(🇬🇧EN) @notLocalized(🇺🇸EN) @notLocalized(🇨🇦EN)
/// Eine SwiftFormat‐Konfiguration.
public typealias SwiftFormatKonfiguration = SwiftFormatConfiguration.Configuration

extension SwiftFormatConfiguration.Configuration {

    internal static let `default`: SwiftFormatConfiguration.Configuration = {
        let configuration = SwiftFormatConfiguration.Configuration()
        #warning("Restore some of these.")
        configuration.rules = [:]
        #warning("Change this to new default?")
        configuration.indentation = .spaces(4) // Xcode’s default.
        #warning("Is this necessary?")
        configuration.respectsExistingLineBreaks = true
        return configuration
    }()
}
