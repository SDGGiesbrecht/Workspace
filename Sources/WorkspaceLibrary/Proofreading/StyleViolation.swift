/*
 StyleViolation.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2018 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import GeneralImports

struct StyleViolation {

    // MARK: - Initialization

    init(in file: TextFile, at location: Range<String.ScalarView.Index>, replacementSuggestion: StrictString? = nil, noticeOnly: Bool = false, ruleIdentifier: UserFacing<StrictString, InterfaceLocalization>, message: UserFacing<StrictString, InterfaceLocalization>) {
        self.file = file
        self.noticeOnly = noticeOnly
        self.ruleIdentifier = ruleIdentifier
        self.message = message

        // Normalize to cluster boundaries
        let clusterRange = location.clusters(in: file.contents.clusters)
        self.range = clusterRange
        if let scalarReplacement = replacementSuggestion {
            let modifiedScalarRange = clusterRange.sameRange(in: file.contents.scalars)
            let clusterReplacement = StrictString(file.contents.scalars[modifiedScalarRange.lowerBound ..< location.lowerBound]) + scalarReplacement + StrictString(file.contents.scalars[location.upperBound ..< modifiedScalarRange.upperBound])
            self.replacementSuggestion = clusterReplacement
        } else {
            self.replacementSuggestion = nil
        }
    }

    // MARK: - Properties

    let file: TextFile
    let range: Range<String.ClusterView.Index>
    let replacementSuggestion: StrictString?
    let ruleIdentifier: UserFacing<StrictString, InterfaceLocalization>
    let message: UserFacing<StrictString, InterfaceLocalization>
    let noticeOnly: Bool
}
