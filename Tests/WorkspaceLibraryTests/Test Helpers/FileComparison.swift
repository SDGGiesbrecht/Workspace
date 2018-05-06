/*
 FileComparison.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2017–2018 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import Foundation
import XCTest

import SDGExternalProcess

import SDGCommandLine

func checkForDifferences(in contentLabel: String, at location: URL, for mockProject: URL, file: StaticString = #file, line: UInt = #line) {
    do {
        try Shell.default.run(command: [
            "git", "add", Shell.quote(location.path),
            "\u{2D}\u{2D}intent\u{2D}to\u{2D}add"
            ])
        try Shell.default.run(command: [
            "git", "diff",
            "\u{2D}\u{2D}exit\u{2D}code",
            Shell.quote(location.path)
            ])
    } catch let error as ExternalProcess.Error {
        XCTFail("\n\nThe \(contentLabel) for mock project “\(mockProject.lastPathComponent)” changed.\n\nIf the following changes are intended, commit them to update the test expectations:\n$ git add \u{22}\(location.path(relativeTo: repositoryRoot))\u{22}\n$ git commit \u{2D}m ...\n\n" + error.output, file: file, line: line)
    } catch let error {
        XCTFail(error.localizedDescription, file: file, line: line)
    }
}
