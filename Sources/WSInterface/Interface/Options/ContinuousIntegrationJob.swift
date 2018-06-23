/*
 ContinuousIntegrationJob.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2017–2018 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import WSGeneralImports
import WSContinuousIntegration

extension ContinuousIntegrationJob {

    private static let optionName = UserFacing<StrictString, InterfaceLocalization>({ localization in
        switch localization {
        case .englishCanada:
            return "job"
        }
    })

    private static let optionDescription = UserFacing<StrictString, InterfaceLocalization>({ localization in
        switch localization {
        case .englishCanada:
            return "A particular continuous integration job."
        }
    })

    internal static let option = SDGCommandLine.Option(name: optionName, description: optionDescription, type: argument)

    private static let argumentTypeName = UserFacing<StrictString, InterfaceLocalization>({ localization in
        switch localization {
        case .englishCanada:
            return "job"
        }
    })

    private static let argument = ArgumentType.enumeration(name: argumentTypeName, cases: ContinuousIntegrationJob.cases.map { (job: ContinuousIntegrationJob) -> (value: ContinuousIntegrationJob, label: UserFacing<StrictString, InterfaceLocalization>) in
        return (value: job, label: job.argumentName)
    })
}
