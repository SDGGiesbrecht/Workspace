/*
 InternalTests.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2016–2018 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import Foundation
import XCTest

import SDGCornerstone
import SDGCommandLine

@testable import WorkspaceLibrary

class InternalTests : TestCase {

    func testDocumentationCoverage() {
        // [_Workaround: Can this be moved to API Tests?_]

        XCTAssertErrorFree {
            try FileManager.default.do(in: repositoryRoot) {
                for link in DocumentationLink.all {
                    var url = link.url
                    if let anchor = url.range(of: "#") {
                        url = String(url[..<anchor.lowerBound])
                    }

                    if ¬url.hasSuffix("master") { // Read‐me
                        break
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
            String(Script.refreshMacOS.fileName),
            String(Script.refreshLinux.fileName),

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

        XCTAssertErrorFree {
            _ = try Command(name: UserFacingText<InterfaceLocalization, Void>({ (_, _) in "" }), description: UserFacingText({ (_, _) in "" }), directArguments: [], options: [], execution: { (_, _, output: inout Command.Output) in

                let tracked = try PackageRepository(alreadyAt: repositoryRoot).trackedFiles(output: &output)
                let relative = tracked.map { $0.path(relativeTo: repositoryRoot) }
                let unexpected = relative.filter { path in

                    for prefix in expectedPrefixes {
                        if path.hasPrefix(prefix) {
                            return false
                        }
                    }

                    return true
                }

                XCTAssert(unexpected.isEmpty, [
                    "Unexpected files are being tracked by Git:",
                    unexpected.joinAsLines()
                    ].joinAsLines())

            }).execute(with: [])
        }
    }

    func testHelp() {
        for localization in InterfaceLocalization.cases {
            LocalizationSetting(orderOfPrecedence: [localization.code]).do {
                XCTAssertErrorFree {
                    try Workspace.command.execute(with: ["help"])
                }
            }
        }
    }

    func testSystemToolVersions() {
        let shouldTest = ProcessInfo.processInfo.environment["CONTINUOUS_INTEGRATION"] ≠ nil
            ∨ ProcessInfo.processInfo.environment["CI"] ≠ nil
            ∨ ProcessInfo.processInfo.environment["TRAVIS"] ≠ nil

        if shouldTest {
            XCTAssertErrorFree({
                #if !os(Linux)
                    var versionString = Xcode.defaultVersion.string
                    if versionString.hasSuffix(".0") {
                        versionString.scalars.removeLast(2)
                    }

                    XCTAssert(try Shell.default.run(command: ["xcodebuild", "\u{2D}version"]).scalars.contains(versionString.scalars), "Xcode is out of date.")
                #endif
            })
        }
    }

    static var allTests: [(String, (InternalTests) -> () throws -> Void)] {
        return [
            ("testDocumentationCoverage", testDocumentationCoverage),
            ("testGitIgnoreCoverage", testGitIgnoreCoverage),
            ("testHelp", testHelp),
            ("testSystemToolVersions", testSystemToolVersions)
        ]
    }
}
