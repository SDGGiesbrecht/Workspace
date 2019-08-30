/*
 ContinuousIntegrationJob.swift

 This source file is part of the Workspace open source project.
 Diese Quelldatei ist Teil des qeulloffenen Arbeitsbereich‐Projekt.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2017–2019 Jeremy David Giesbrecht and the Workspace project contributors.
 Urheberrecht ©2017–2019 Jeremy David Giesbrecht und die Mitwirkenden des Arbeitsbereich‐Projekts.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import WSGeneralImports
import WSContinuousIntegration

extension ContinuousIntegrationJob {

    private static let optionName = UserFacing<StrictString, InterfaceLocalization>({ localization in
        switch localization {
        case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
            return "job"
        case .deutschDeutschland:
            return "aufgabe"
        }
    })

    private static let optionDescription = UserFacing<StrictString, InterfaceLocalization>({ localization in
        switch localization {
        case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
            return "A particular continuous integration job."
        case .deutschDeutschland:
            return "Eine bestimmte aufgabe der fortlaufenden Einbindung."
        }
    })

    internal static let option = SDGCommandLine.Option(name: optionName, description: optionDescription, type: argument)

    private static let argumentTypeName = UserFacing<StrictString, InterfaceLocalization>({ localization in
        switch localization {
        case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
            return "job"
        case .deutschDeutschland:
            return "Aufgabe"
        }
    })

    private static let argument = ArgumentType.enumeration(name: argumentTypeName, cases: ContinuousIntegrationJob.allCases.map { (job: ContinuousIntegrationJob) -> (value: ContinuousIntegrationJob, label: UserFacing<StrictString, InterfaceLocalization>) in
        return (value: job, label: job.argumentName)
    })
}
