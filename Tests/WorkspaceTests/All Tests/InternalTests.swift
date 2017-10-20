/*
 InternalTests.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2016–2017 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import Foundation
import XCTest

import SDGCornerstone

@testable import WorkspaceLibrary

class InternalTests : TestCase {

    func testHelp() {
        for localization in InterfaceLocalization.cases {
            LocalizationSetting(orderOfPrecedence: [localization.code]).do {
                XCTAssertErrorFree() {
                    try Workspace.command.execute(with: ["help"])
                }
            }
        }
    }

    func testGitIgnoreCoverage() {
        // [_Workaround: Can this be moved to API Tests?_]

        let expectedPrefixes = [

            // Swift Package Manager
            "Package.swift",
            "Sources",
            "Tests",
            "Package.pins",
            "Package.resolved",

            // Workspace
            ".Workspace Configuration.txt",
            "Refresh Workspace (macOS).command",
            "Refresh Workspace (Linux).sh",

            // Git
            ".gitignore",
            ".gitattributes",

            // GitHub
            "README.md",
            "LICENSE.md",
            ".github",

            // Travis CI
            ".travis.yml",

            // Workspace Project
            "Related Projects.md",
            "Documentation",
            "Resources"
        ]

        if ¬Environment.isInXcode ∧ ¬Configuration.nestedTest {

            let unexpected = Repository.trackedFiles.map({ $0.string }).filter() { (file: String) -> Bool in

                for prefix in expectedPrefixes {
                    if file.hasPrefix(prefix) {
                        return false
                    }
                }

                return true
            }

            XCTAssert(unexpected.isEmpty, join(lines: [
                "Unexpected files are being tracked by Git:",
                join(lines: unexpected)
                ]))
        }
    }

    func testDocumentationCoverage() {
        // [_Workaround: Can this be moved to API Tests?_]

        if ¬Environment.isInXcode ∧ ¬Configuration.nestedTest {
            for link in DocumentationLink.all {
                var url = link.url
                if let anchor = url.range(of: "#") {
                    url = String(url[..<anchor.lowerBound])
                }

                var exists = false
                for file in Repository.trackedFiles {

                    if url.hasSuffix(file.string) {
                        exists = true
                        break
                    }
                }
                XCTAssert(exists, "Broken link: \(link.url)")
            }
        }
    }

    func testExecutables() {
        // [_Workaround: Can this be moved to API Tests?_]

        if ¬Environment.isInXcode ∧ ¬Configuration.nestedTest {

            let executables: [String] = [
                "Refresh Workspace (macOS).command",
                "Refresh Workspace (Linux).sh",
                "Validate Changes (macOS).command",
                "Validate Changes (Linux).sh"
            ]

            for file in executables {
                do {
                    let condition = try File(at: RelativePath("Resources/Scripts/\(file)")).isExecutable
                    XCTAssert(condition, "Script is no longer executable: \(file)")
                } catch let error {
                    XCTFail("\(error.localizedDescription)")
                }
            }
        }
    }

    static var allTests: [(String, (InternalTests) -> () throws -> Void)] {
        return [
            ("testHelp", testHelp),
            ("testGitIgnoreCoverage", testGitIgnoreCoverage),
            ("testDocumentationCoverage", testDocumentationCoverage),
            ("testExecutables", testExecutables)
        ]
    }
}
