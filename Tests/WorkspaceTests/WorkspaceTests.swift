/*
 WorkspaceTests.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2016–2017 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import Foundation

import SDGCornerstone

import XCTest
@testable import WorkspaceLibrary

class WorkspaceTests : XCTestCase {

    static var initialized = false
    override func setUp() {
        if ¬WorkspaceTests.initialized {
            defer { WorkspaceTests.initialized = true }
            SDGCornerstone.initialize(mode: .commandLineTool, applicationIdentifier: "ca.solideogloria.Workspace.Tests")
        }
    }

    func testLineNumbers() {
        let file = join(lines: [
            "Line 1: א",
            "Line 2: β",
            "Line 3: c"
            ])
        let index = file.range(of: "β")!.lowerBound
        let line = file.lineNumber(for: index)
        XCTAssert(line == 2, "Incorrect line number: \(line) ≠ 2")
        let column = file.columnNumber(for: index)
        XCTAssert(column == 9, "Incorrect column number: \(column) ≠ 9")
    }

    func testBlockComments() {

        func testComment(syntax fileType: FileType, text: [String], comment: [String]) {

            let syntax = fileType.syntax.blockCommentSyntax!

            let textString = join(lines: text)
            let commentString = join(lines: comment)

            let output = syntax.comment(contents: text)

            XCTAssert(output == commentString, join(lines: [
                "Failure generating comment using \(fileType):",
                textString,
                "↓",
                output,
                "≠",
                commentString
                ]))

            let context = "..." + commentString + "..."

            if let parse = syntax.firstComment(in: context) {
                XCTAssert(parse == commentString, join(lines: [
                    "Failure finding comment using \(fileType) syntax:",
                    context,
                    "↓",
                    parse,
                    "≠",
                    commentString
                    ]))
            } else {
                XCTFail(join(lines: [
                    "Comment not detected using \(fileType):",
                    context
                    ]))
            }

            if let parse = syntax.contentsOfFirstComment(in: context) {
                XCTAssert(parse == textString, join(lines: [
                    "Failure parsing comment using \(fileType) syntax:",
                    context,
                    "↓",
                    parse,
                    "≠",
                    textString
                    ]))
            } else {
                XCTFail(join(lines: [
                    "Comment not detected using \(fileType):",
                    context
                    ]))
            }

            let commentAtStart = join(lines: [
                syntax.start,
                syntax.end
                ])
            XCTAssert(syntax.startOfCommentExists(at: commentAtStart.startIndex, in: commentAtStart), join(lines: [
                "Comment not detected:",
                commentAtStart
                ]))

            let noCommentAtStart = join(lines: [
                "",
                syntax.start,
                syntax.end
                ])
            XCTAssert(¬syntax.startOfCommentExists(at: noCommentAtStart.startIndex, in: noCommentAtStart), join(lines: [
                "Comment detected on wrong line:",
                noCommentAtStart
                ]))

            let empty = ""
            XCTAssert(¬syntax.startOfCommentExists(at: empty.startIndex, in: empty), join(lines: [
                "Comment detected in empty string:",
                empty
                ]))
        }

        testComment(syntax: FileType.swift, text: [
            "Block",
            "Comment"
            ], comment: [
                "/*",
                " Block",
                " Comment",
                " */"
            ])

        testComment(syntax: FileType.workspaceConfiguration, text: [
            "Block",
            "Comment"
            ], comment: [
                "((",
                "    Block",
                "    Comment",
                "    ))"
            ])
    }

    func testLineComments() {

        func testComment(syntax fileType: FileType, text: String, comment: String, consecutiveText: [String], consecutiveComment: [String]) {

            let syntax = fileType.syntax.lineCommentSyntax!

            let consecutiveTextString = join(lines: consecutiveText)
            let consecutiveCommentString = join(lines: consecutiveComment)

            let output = syntax.comment(contents: text)
            XCTAssert(output == comment, join(lines: [
                "Failure generating comment using \(fileType):",
                text,
                "↓",
                output,
                "≠",
                comment
                ]))

            let consecutiveOutput = syntax.comment(contents: consecutiveTextString)
            XCTAssert(consecutiveOutput == consecutiveCommentString, join(lines: [
                "Failure generating comment using \(fileType):",
                consecutiveTextString,
                "↓",
                consecutiveOutput,
                "≠",
                consecutiveCommentString
                ]))

            let context = "..." + comment + "\n..."
            let consecutiveContext = "..." + consecutiveCommentString + "\n..."

            if let parse = syntax.firstComment(in: context) {
                XCTAssert(parse == comment, join(lines: [
                    "Failure finding comment using \(fileType) syntax:",
                    context,
                    "↓",
                    parse,
                    "≠",
                    comment
                    ]))
            } else {
                XCTFail(join(lines: [
                    "Comment not detected using \(fileType):",
                    context
                    ]))
            }

            if let parse = syntax.firstComment(in: consecutiveContext) {
                XCTAssert(parse == consecutiveCommentString, join(lines: [
                    "Failure finding comment using \(fileType) syntax:",
                    consecutiveContext,
                    "↓",
                    parse,
                    "≠",
                    consecutiveCommentString
                    ]))
            } else {
                XCTFail(join(lines: [
                    "Comment not detected using \(fileType):",
                    consecutiveContext
                    ]))
            }

            if let parse = syntax.contentsOfFirstComment(in: context) {
                XCTAssert(parse == text, join(lines: [
                    "Failure parsing comment using \(fileType) syntax:",
                    context,
                    "↓",
                    parse,
                    "≠",
                    text
                    ]))
            } else {
                XCTFail(join(lines: [
                    "Comment not detected using \(fileType):",
                    context
                    ]))
            }

            if let parse = syntax.contentsOfFirstComment(in: consecutiveContext) {
                XCTAssert(parse == consecutiveTextString, join(lines: [
                    "Failure parsing comment using \(fileType) syntax:",
                    consecutiveContext,
                    "↓",
                    parse,
                    "≠",
                    consecutiveTextString
                    ]))
            } else {
                XCTFail(join(lines: [
                    "Comment not detected using \(fileType):",
                    consecutiveContext
                    ]))
            }
        }

        testComment(syntax: FileType.swift, text: "Comment", comment: "// Comment", consecutiveText: [
            "Consecutive",
            "Comment"
            ], consecutiveComment: [
                "// Consecutive",
                "// Comment"
            ])

        testComment(syntax: FileType.workspaceConfiguration, text: "Comment", comment: "(Comment)", consecutiveText: [
            "Consecutive",
            "Comment"
            ], consecutiveComment: [
                "(Consecutive)",
                "(Comment)"
            ])
    }

    func testConfiguration() {
        let source = join(lines: [
            "Test Option: Simple Value",
            "",
            "[_Begin Test Long Option_]",
            "Multiline",
            "Value",
            "[_End_]",
            "",
            "(Comment)",
            "",
            "((",
            "    Multiline",
            "    Comment",
            "    ))"
            ])
        let expectedConfiguration: [Option: String] = [
            .testOption: "Simple Value",
            .testLongOption: join(lines: ["Multiline", "Value"])
        ]
        let parsed = Configuration.parse(configurationSource: source)

        XCTAssert(parsed == expectedConfiguration, join(lines: [
            "Failure parsing configuration source:",
            source,
            "↓",
            "\(parsed)",
            "≠",
            "\(expectedConfiguration)"
            ]))
    }

    func testHeaders() {

        func testHeader(syntax fileExtension: String, header: [String], source: [String]) {

            let path = RelativePath("Test." + fileExtension)
            guard let fileType = FileType(filePath: path) else {
                preconditionFailure("Unrecognized extension: \(fileExtension)")
            }
            let syntax = fileType.syntax
            let body = join(lines: [
                "...",
                "" // Final newline
                ])

            var headerlessFirstLine = ""
            func inContext(headerSource: String) -> File {

                var contents = ""
                if let firstLine = syntax.requiredFirstLineToken {
                    let value = join(lines: [
                        firstLine + "...",
                        "",
                        "" // First line of header.
                        ])
                    contents = value
                    headerlessFirstLine = value
                }

                contents.append(headerSource)
                contents.append(join(lines: [
                    "", // Last line of header.
                    "",
                    body
                    ]))

                return File(_path: path, _contents: contents)
            }
            var contextString = ""
            if let firstLine = syntax.requiredFirstLineToken {
                contextString.append(join(lines: [
                    firstLine + "...",
                    "",
                    "" // First line of header
                    ]))
            } else {
                contextString = "\n" + contextString
            }
            contextString.append(body)
            let context = File(_path: path, _contents: contextString)
            let file = inContext(headerSource: join(lines: source))

            let headerString = join(lines: header)

            if fileExtension == ".swift" {
                let expectedSwift = join(lines: [
                    "/*",
                    " File",
                    "",
                    " Project",
                    "",
                    " Copyright",
                    "",
                    " Licence",
                    " */",
                    "",
                    body
                    ])

                XCTAssert(file.contents == expectedSwift, join(lines: [
                    "Failure simulating file using \(fileType):",
                    headerString,
                    "↓",
                    file.contents,
                    "≠",
                    expectedSwift
                    ]))

                let startingWithDocumentation = File(_path: path, _contents: join(lines: [
                    "/*\u{2A}",
                    " Documentation",
                    " */"
                    ]))
                var withHeader = startingWithDocumentation
                withHeader.header = "Header"
                let expectedResult = join(lines: [
                    "/*",
                    " Header",
                    " */",
                    "",
                    "/*\u{2A}",
                    " Documentation",
                    " */",
                    "" // Final newline
                    ])
                XCTAssert(withHeader.contents == expectedResult, join(lines: [
                    "Failure inserting header using \(fileType):",
                    startingWithDocumentation.contents,
                    "↓",
                    withHeader.contents,
                    "≠",
                    expectedResult
                    ]))
            }

            if fileExtension == ".sh" {
                let expectedShell = join(lines: [
                    "#\u{21}...",
                    "",
                    "# File",
                    "#",
                    "# Project",
                    "#",
                    "# Copyright",
                    "#",
                    "# Licence",
                    "",
                    body
                    ])

                XCTAssert(file.contents == expectedShell, join(lines: [
                    "Failure simulating file using \(fileType):",
                    headerString,
                    "↓",
                    file.contents,
                    "≠",
                    expectedShell
                    ]))
            }

            var output = context
            output.header = headerString
            XCTAssert(output.contents == file.contents, join(lines: [
                "Failure generating header using \(fileType):",
                headerString,
                "↓",
                output.contents,
                "≠",
                file.contents
                ]))

            let input = file.header
            XCTAssert(input == headerString, join(lines: [
                "Failure parsing header using \(fileType):",
                file.contents,
                "↓",
                input,
                "≠",
                headerString
                ]))

            XCTAssert(context.body == body, join(lines: [
                "Failure parsing body using \(fileType):",
                output.contents,
                "↓",
                output.body,
                "≠",
                body
                ]))

            var newBody = file
            newBody.body = body
            XCTAssert(newBody.contents == file.contents, join(lines: [
                "Failure replacing body using \(fileType):",
                file.contents,
                "↓",
                newBody.contents,
                "≠",
                file.contents
                ]))

            let headerlessStartSection = headerlessFirstLine + "\n\n"
            let noHeader = File(_path: path, _contents: headerlessStartSection + body)
            XCTAssert(noHeader.body == body, join(lines: [
                "Failure parsing body using \(fileType):",
                noHeader.contents,
                "↓",
                noHeader.body,
                "≠",
                body
                ]))

            var newBodyNoHeader = noHeader
            newBodyNoHeader.body = body
            XCTAssert(newBodyNoHeader.contents == noHeader.contents, join(lines: [
                "Failure replacing body using \(fileType):",
                noHeader.contents,
                "↓",
                newBodyNoHeader.contents,
                "≠",
                noHeader.contents
                ]))
        }

        testHeader(syntax: ".swift", header: [
            "File",
            "",
            "Project",
            "",
            "Copyright",
            "",
            "Licence"
            ], source: [
                "/*",
                " File",
                "",
                " Project",
                "",
                " Copyright",
                "",
                " Licence",
                " */"
            ])

        testHeader(syntax: Configuration.configurationFilePath.string, header: [
            "File",
            "",
            "Project",
            "",
            "Copyright",
            "",
            "Licence"
            ], source: [
                "((",
                "    File",
                "",
                "    Project",
                "",
                "    Copyright",
                "",
                "    Licence",
                "    ))"
            ])

        testHeader(syntax: ".sh", header: [
            "File",
            "",
            "Project",
            "",
            "Copyright",
            "",
            "Licence"
            ], source: [
                "# File",
                "#",
                "# Project",
                "#",
                "# Copyright",
                "#",
                "# Licence"
            ])
    }

    func testGitIgnoreCoverage() {

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
                    XCTAssert(condition, "Script is not longer executable: \(file)")
                } catch let error {
                    XCTFail("\(error.localizedDescription)")
                }
            }
        }
    }

    func testOnProjects() {

        if ¬Environment.isInXcode ∧ ¬Configuration.nestedTest {
            if Environment.isInContinuousIntegration {
                // These tests are time consuming.
                // They are skipped on local machines so that following along in with the workflow documentation is relatively quick.
                // Comment out the if‐statement to debug locally if failures occur in continuous integration.

                do {

                    _ = try Shell.default.run(command: ["swift", "build"])

                    try Repository.delete(Repository.testZone)

                    let new: [(name: String, flags: [String])] = [
                        (name: "New Library", flags: []),
                        (name: "New Application", flags: ["•type", "application"]),
                        (name: "New Executable", flags: ["•type", "executable"])
                    ]

                    func root(of repository: String) -> RelativePath {
                        return Repository.testZone.subfolderOrFile(repository)
                    }

                    for project in new {

                        printHeader(["••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••"])
                        printHeader(["Testing Workspace with \(project.name)..."])
                        printHeader(["••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••"])

                        try FileManager.default.createDirectory(atPath: Repository.absolute(root(of: project.name)).string, withIntermediateDirectories: true, attributes: nil)

                        Repository.performInDirectory(directory: root(of: project.name)) {

                            // Test initialization.
                            do {
                                try Shell.default.run(command: ["../../.build/debug/workspace", "initialize"] + project.flags)
                            } catch {
                                XCTFail("Failed to initialize test project “\(project.name)”.")
                            }

                            // Normalize project state.
                            _ = try? Shell.default.run(command: ["../../.build/debug/workspace", "validate"], silently: true)

                            // Commit normalized project state.
                            do {
                                try Shell.default.run(command: ["git", "add", "."], silently: true)
                            } catch {
                                XCTFail("Failed to add files to Git in test project “\(project.name)”.")
                            }
                            do {
                                try Shell.default.run(command: ["git", "commit", "\u{2D}m", "Initialized state."], silently: true)
                            } catch {
                                XCTFail("Failed to commit files to Git in test project “\(project.name)”.")
                            }

                            // Test validation.
                            do {
                                try Shell.default.run(command: ["../../.build/debug/workspace", "validate"])
                            } catch {
                                XCTFail("Validation fails for initialized project “\(project.name)”.")
                            }
                        }
                    }

                    printHeader(["••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••"])
                    printHeader(["Making sure Workspace passes its own tests..."])
                    printHeader(["••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••"])

                    let testWorkspaceProject = "Workspace"
                    try Repository.copy(Repository.root, to: root(of: testWorkspaceProject + "/"))

                    // Block tests from being recursive.
                    var nestedConfiguration = try File(at: root(of: testWorkspaceProject).subfolderOrFile(Configuration.configurationFilePath.string))
                    nestedConfiguration.body.append("\n" + Configuration.configurationFileEntry(option: Option.nestedTest, value: true, comment: nil))
                    try nestedConfiguration.write()

                    Repository.performInDirectory(directory: root(of: testWorkspaceProject)) {

                        do {
                            try Shell.default.run(command: ["../../.build/debug/workspace", "refresh"])
                        } catch {
                            XCTFail("Failed to refresh Workspace.")
                        }

                        do {
                            try Shell.default.run(command: ["../../.build/debug/workspace", "validate"])
                        } catch {
                            XCTFail("Workspace fails its own validation.")
                        }
                    }

                } catch let error {

                    XCTFail(error.localizedDescription)
                }
            }
        }
    }

    static var allTests: [(String, (WorkspaceTests) -> () throws -> Void)] {
        return [
            ("testLineNumbers", testLineNumbers),
            ("testBlockComments", testBlockComments),
            ("testLineComments", testLineComments),
            ("testConfiguration", testConfiguration),
            ("testHeaders", testHeaders),
            ("testGitIgnoreCoverage", testGitIgnoreCoverage),
            ("testDocumentationCoverage", testDocumentationCoverage),
            ("testExecutables", testExecutables),
            ("testOnProjects", testOnProjects)
        ]
    }
}
