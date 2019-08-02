/*
 RefreshContinuousIntegration.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2017–2019 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import WSGeneralImports

extension Workspace.Refresh {

    enum ContinuousIntegration {

        private static let name = UserFacing<StrictString, InterfaceLocalization>({ localization in
            switch localization {
            case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                return "continuous‐integration"
            case .deutschDeutschland:
                return "fortlaufende‐einbildung"
            }
        })

        private static let description = UserFacing<StrictString, InterfaceLocalization>({ localization in
            switch localization {
            case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                return "regenerates the project’s continuous integration configuration files."
            case .deutschDeutschland:
                return "erstellt die Konfigurationsdateien des Projekts, die fortlaufende Einbildung einrichten."
            }
        })

        private static let discussion = UserFacing<StrictString, InterfaceLocalization>({ localization in
            switch localization {
            case .englishUnitedKingdom:
                return [
                    "Workspace will create a ‘.travis.yml’ file at the project root, which configures Travis CI to run all the tests from ‘Validate’ on every operating system supported by the project.",
                    "",
                    "Note: Workspace cannot turn Travis CI on. It is still necessary to log into Travis CI (https://travis\u{2D}ci.org) and activate it for the project’s repository.",
                    "",
                    "Special Thanks:",
                    "",
                    "• Travis CI (https://travis\u{2D}ci.org)",
                    "",
                    "• Kyle Fuller and Swift Version Manager (https://github.com/kylef/swiftenv), which makes continuous integration possible on Linux.",
                    ].joinedAsLines()
            case .englishUnitedStates, .englishCanada:
                return [
                    "Workspace will create a “.travis.yml” file at the project root, which configures Travis CI to run all the tests from “Validate” on every operating system supported by the project.",
                    "",
                    "Note: Workspace cannot turn Travis CI on. It is still necessary to log into Travis CI (https://travis\u{2D}ci.org) and activate it for the project’s repository.",
                    "",
                    "Special Thanks:",
                    "",
                    "• Travis CI (https://travis\u{2D}ci.org)",
                    "",
                    "• Kyle Fuller and Swift Version Manager (https://github.com/kylef/swiftenv), which makes continuous integration possible on Linux.",
                    ].joinedAsLines()
            case .deutschDeutschland:
                return [
                    "Arbeitsbereich erstellt ein ‘.travis.yml’‐Datei in der Projektwurzel, die Travis‐CI konfiguriert, alle Teste von ‘Validate’ auf jede unterstützte Betriebssystem auszuführen.",
                    "",
                    "Hinweis: Arbeitsbereich kann Travis‐CI nicht einschalten. Man muss immer noch bei Travis‐CI einloggen (https://travis\u{2D}ci.org) um es für das Projekt zu aktivieren.",
                    "",
                    "Besonderer Dank:",
                    "",
                    "• Travis CI (https://travis\u{2D}ci.org)",
                    "",
                    "• Kyle Fuller und das Swift Version Manager (https://github.com/kylef/swiftenv), fortlaufende Einbildung auf Linux ermöglicht.",
                    ].joinedAsLines()
            }
        })

        static let command = Command(
            name: name,
            description: description,
            discussion: discussion,
            directArguments: [],
            options: Workspace.standardOptions,
            execution: { (_, options: Options, output: Command.Output) throws in

            output.print(UserFacing<StrictString, InterfaceLocalization>({ localization in
                switch localization {
                case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                    return "Refreshing continuous integration configuration..."
                case .deutschDeutschland:
                    return "Konfiguration für Fortlaufende Einbildung wird aufgefrischt ..."
                }
            }).resolved().formattedAsSectionHeader())

            try options.project.refreshContinuousIntegration(output: output)
        })
    }
}
