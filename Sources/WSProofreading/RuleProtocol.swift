/*
 RuleProtocol.swift

 This source file is part of the Workspace open source project.
 Diese Quelldatei ist Teil des qeulloffenen Arbeitsbereich‐Projekt.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2018–2019 Jeremy David Giesbrecht and the Workspace project contributors.
 Urheberrecht ©2018–2019 Jeremy David Giesbrecht und die Mitwirkenden des Arbeitsbereich‐Projekts.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGLogic
import SDGCollections
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
        let line = fileLines[lineIndex].line
        for exemptionMarker in exemptionMarkers {
            if line.contains(exemptionMarker) {
                for localization in InterfaceLocalization.allCases {
                    if line.contains(StrictString("\(exemptionMarker)\(name.resolved(for: localization)))")) {
                        return
                    }
                }
            }
        }

        status.report(violation: StyleViolation(in: file, at: location, replacementSuggestion: replacementSuggestion, noticeOnly: noticeOnly, ruleIdentifier: Self.name, message: message), to: output)
    }
}

private let exemptionMarkers: [StrictString] = {
    var result: Set<StrictString> = Set(InterfaceLocalization.allCases.map({ localization in
        switch localization {
        case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
            return "@exempt(from: _)"
        case .deutschDeutschland:
            return "@ausnahme(zu: _)"
        }
    }))
    return result.map { $0.truncated(before: "_") }
}()
