/*
 ValidationStatus.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2017 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGCornerstone
import SDGCommandLine

struct ValidationStatus {

    // MARK: - Static Properties

    static let passOrFailSymbol = UserFacingText({ (localization: InterfaceLocalization, passing: Bool) in
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

    // MARK: - Usage

    mutating func passStep(message: UserFacingText<InterfaceLocalization, Void>) {
        summary.append((ValidationStatus.passOrFailSymbol.resolved(using: true) + " " + message.resolved()).formattedAsSuccess())
    }

    mutating func failStep(message: UserFacingText<InterfaceLocalization, Void>) {
        passing = false
        summary.append((ValidationStatus.passOrFailSymbol.resolved(using: false) + " " + message.resolved()).formattedAsError())
    }

    var validatedSomething: Bool {
        return ¬summary.isEmpty
    }

    func reportOutcome(projectName: StrictString, output: inout Command.Output) throws {
        print(StrictString(summary.joined(separator: "\n".scalars)).separated(), to: &output)
        if passing {
            print(UserFacingText({ (localization: InterfaceLocalization, _: Void) in
                switch localization {
                case .englishCanada:
                    return "“" + projectName + "” passes validation."
                }
            }).resolved().formattedAsSuccess().separated(), to: &output)
        } else {
            throw Command.Error(description: UserFacingText({ (localization: InterfaceLocalization, _: Void) in
                switch localization {
                case .englishCanada:
                    return "“" + projectName + "” fails validation."
                }
            }))
        }
    }
}
