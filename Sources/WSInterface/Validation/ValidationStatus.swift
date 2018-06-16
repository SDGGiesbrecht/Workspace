/*
 ValidationStatus.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2017–2018 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import WSGeneralImports

struct ValidationStatus {

    // MARK: - Static Properties

    static let passOrFailSymbol = UserFacingDynamic<StrictString, InterfaceLocalization, Bool>({ localization, passing in
        switch localization {
        case .englishCanada:
            return passing ? "✓" : "✗"
        }
    })

    // MARK: - Initialization

    init() {

    }

    // MARK: - Properties

    var passing: Bool = true

    private var summary: [StrictString] = []
    private var currentSection = 0

    // MARK: - Usage

    mutating func newSection() -> ReportSection {
        currentSection += 1
        return ReportSection(number: currentSection)
    }

    mutating func passStep(message: UserFacing<StrictString, InterfaceLocalization>) {
        summary.append((ValidationStatus.passOrFailSymbol.resolved(using: true) + " " + message.resolved()).formattedAsSuccess())
    }

    mutating func failStep(message: UserFacing<StrictString, InterfaceLocalization>) {
        passing = false
        summary.append((ValidationStatus.passOrFailSymbol.resolved(using: false) + " " + message.resolved()).formattedAsError())
    }

    var validatedSomething: Bool {
        return ¬summary.isEmpty
    }

    func reportOutcome(projectName: StrictString, output: Command.Output) throws {
        output.print(StrictString(summary.joined(separator: "\n".scalars)).separated())
        if passing {
            output.print(UserFacing<StrictString, InterfaceLocalization>({ localization in
                switch localization {
                case .englishCanada:
                    return "“" + projectName + "” passes validation."
                }
            }).resolved().formattedAsSuccess().separated())
        } else {
            throw Command.Error(description: UserFacing<StrictString, InterfaceLocalization>({ localization in
                switch localization {
                case .englishCanada:
                    return "“" + projectName + "” fails validation."
                }
            }))
        }
    }
}
