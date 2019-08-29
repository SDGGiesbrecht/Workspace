/*
 RefreshAll.swift

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

extension Workspace.Refresh {

    enum All {

        private static let name = UserFacing<StrictString, InterfaceLocalization>({ localization in
            switch localization {
            case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                return "all"
            case .deutschDeutschland:
                return "alles"
            }
        })

        private static let description = UserFacing<StrictString, InterfaceLocalization>({ localization in
            switch localization {
            case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                return "performs all configured refreshment tasks."
            case .deutschDeutschland:
                return "führt alle konfigurierte Auffrischungsaufgaben aus."
            }
        })

        static let command = Command(name: name, description: description, directArguments: [], options: Workspace.standardOptions, execution: { (arguments: DirectArguments, options: Options, output: Command.Output) throws in

            if options.job == .deployment {
                try TravisCI.keepAlive { // @exempt(from: tests)
                    try executeAsStep(withArguments: arguments, options: options, output: output)
                }
            } else {
                try executeAsStep(withArguments: arguments, options: options, output: output)
            }

            let projectName = try options.project.localizedIsolatedProjectName(output: output)
            var success = UserFacing<StrictString, InterfaceLocalization>({ localization in
                switch localization {
                case .englishUnitedKingdom:
                    return "‘\(projectName)’ is refreshed and ready."
                case .englishUnitedStates, .englishCanada:
                    return "“\(projectName)” is refreshed and ready."
                case .deutschDeutschland:
                    return "„\(projectName)“ ist aufgefrischt und bereit."
                }
            }).resolved()

            if let xcodeProject = (try? options.project.xcodeProject())??.lastPathComponent { // @exempt(from: tests) Unreachable on Linux.
                let xcodeInstructions = UserFacing<StrictString, InterfaceLocalization>({ localization in
                    switch localization {
                    case .englishUnitedKingdom:
                        return "Open ‘\(StrictString(xcodeProject))’ to work on the project."
                    case .englishUnitedStates, .englishCanada:
                        return "Open “\(StrictString(xcodeProject))” to work on the project."
                    case .deutschDeutschland:
                        return "Um auf das Projekt zu arbeiten, „\(StrictString(xcodeProject))“ öffnen."
                    }
                }).resolved()

                success = [
                    success,
                    xcodeInstructions
                ].joinedAsLines()
            }

            try output.succeed(message: success, project: options.project)
        })

        static func executeAsStep(withArguments arguments: DirectArguments, options: Options, output: Command.Output) throws {

            let projectName = try options.project.localizedIsolatedProjectName(output: output)
            output.print(UserFacing<StrictString, InterfaceLocalization>({ localization in
                switch localization {
                case .englishUnitedKingdom:
                    return "Refreshing ‘\(projectName)’..."
                case .englishUnitedStates, .englishCanada:
                    return "Refreshing “\(projectName)”..."
                case .deutschDeutschland:
                    return "„\(projectName)“ wird aufgefrischt ..."
                }
            }).resolved().formattedAsSectionHeader())

            // Scripts
            if try options.project.configuration(output: output).provideWorkflowScripts {
                try Workspace.Refresh.Scripts.command.execute(withArguments: arguments, options: options, output: output)
            }

            // Git
            if try options.project.configuration(output: output).git.manage {
                try Workspace.Refresh.Git.command.execute(withArguments: arguments, options: options, output: output)
            }

            // Read‐Me
            if try options.project.configuration(output: output).documentation.readMe.manage {
                try Workspace.Refresh.ReadMe.command.execute(withArguments: arguments, options: options, output: output)
            }

            // Licence
            if try options.project.configuration(output: output).licence.manage {
                try Workspace.Refresh.Licence.command.execute(withArguments: arguments, options: options, output: output)
            }

            // GitHub
            if try options.project.configuration(output: output).gitHub.manage {
                try Workspace.Refresh.GitHub.command.execute(withArguments: arguments, options: options, output: output)
            }

            // Continuous Integration
            if try options.project.configuration(output: output).continuousIntegration.manage {
                try Workspace.Refresh.ContinuousIntegration.command.execute(withArguments: arguments, options: options, output: output)
            }

            // Resources
            try Workspace.Refresh.Resources.command.execute(withArguments: arguments, options: options, output: output)

            // File Headers
            if try options.project.configuration(output: output).fileHeaders.manage {
                try Workspace.Refresh.FileHeaders.command.execute(withArguments: arguments, options: options, output: output)
            }

            // Examples
            try Workspace.Refresh.Examples.command.execute(withArguments: arguments, options: options, output: output)

            // Inherited Documentation
            try Workspace.Refresh.InheritedDocumentation.command.execute(withArguments: arguments, options: options, output: output)

            // Normalization
            try Workspace.Normalize.executeAsStep(options: options, output: output)

            // Xcode
            #if !os(Linux)
            if try options.project.configuration(output: output).xcode.manage {
                try Workspace.Refresh.Xcode.command.execute(withArguments: arguments, options: options, output: output)
            }
            #endif

            // Custom
            for task in try options.project.configuration(output: output).customRefreshmentTasks {
                output.print(UserFacing<StrictString, InterfaceLocalization>({ localization in
                    switch localization {
                    case .englishUnitedKingdom:
                        return "Executing custom task: ‘\(task.executable)’..."
                    case .englishUnitedStates, .englishCanada:
                        return "Executing custom task: “\(task.executable)”..."
                    case .deutschDeutschland:
                        return "Sonderaufgabe wird ausgeführt: „\(task.executable)“ ..."
                    }
                }).resolved().formattedAsSectionHeader())
                try task.execute(output: output)
            }
        }
    }
}
