/*
 RuleProtocol.swift

 This source file is part of the Workspace open source project.
 Diese Quelldatei ist Teil des qeulloffenen Workspace‐Projekt.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2018–2019 Jeremy David Giesbrecht and the Workspace project contributors.
 Urheberrecht ©2018–2019 Jeremy David Giesbrecht und die Mitwirkenden des Workspace‐Projekts.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGLogic
import WSGeneralImports

import SDGSwiftSource

import WSProject

internal protocol RuleProtocol {
    static var name: UserFacing<StrictString, InterfaceLocalization> { get }
    static var noticeOnly: Bool { get }
}

extension RuleProtocol {

    // MARK: - Default Implementations

    internal static var noticeOnly: Bool {
        return false
    }

    // MARK: - Reporting

    internal static func reportViolation(in file: TextFile, at location: Range<String.ScalarView.Index>, replacementSuggestion: StrictString? = nil, message: UserFacing<StrictString, InterfaceLocalization>, status: ProofreadingStatus, output: Command.Output) {

        let fileLines = file.contents.lines
        let lineIndex = location.lowerBound.line(in: fileLines)
        let line = String(fileLines[lineIndex].line)
        if line.contains("@exempt") {
            for localization in InterfaceLocalization.allCases {
                if line.contains("@exempt(from: \(name.resolved(for: localization)))") {
                    return
                }
            }
        }

        status.report(violation: StyleViolation(in: file, at: location, replacementSuggestion: replacementSuggestion, noticeOnly: noticeOnly, ruleIdentifier: Self.name, message: message), to: output)
    }
}
