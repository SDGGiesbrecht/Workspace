// WorkspaceTests.swift
//
// This source file is part of the Workspace open source project.
//
// Copyright ©2016–2017 Jeremy David Giesbrecht and the Workspace contributors.
//
// Soli Deo gloria
//
// Licensed under the Apache License, Version 2.0
// See http://www.apache.org/licenses/LICENSE-2.0 for licence information.

import Foundation

import XCTest
@testable import WorkspaceLibrary

class WorkspaceTests: XCTestCase {
    
    func testGeneralParsing() {
        
        func testLineBreaking(text: [String]) {
            
            fail(message: ["Hello, world!"])
            
            for newline in ["\n", String.CR_LF] {
                
                let parsed = text.joined(separator: newline).linesArray
                XCTAssert(parsed == text, join(lines: [
                    "Failure parsing lines using \(newline.addingPercentEncoding(withAllowedCharacters: CharacterSet())!):",
                    join(lines: text),
                    "↓",
                    join(lines: parsed),
                    ]))
            }
        }
        
        testLineBreaking(text: [
            "Line 1",
            "Line 2",
            "Line 3",
            ])
        
        testLineBreaking(text: [
            "",
            ])
        
        testLineBreaking(text: [
            "Line 1",
            "",
            "Line 3",
            ])
        
        testLineBreaking(text: [
            "",
            "Line 2",
            ])
        
        testLineBreaking(text: [
            "Line 1",
            "",
            ])
        
        testLineBreaking(text: [
            "Line 1",
            "",
            "",
            "Line 4",
            ])
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
                commentString,
                ]))
            
            let context = "..." + commentString + "..."
            
            if let parse = syntax.firstComment(in: context) {
                XCTAssert(parse == commentString, join(lines: [
                    "Failure finding comment using \(fileType) syntax:",
                    context,
                    "↓",
                    parse,
                    "≠",
                    commentString,
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
                    textString,
                    ]))
            } else {
                XCTFail(join(lines: [
                    "Comment not detected using \(fileType):",
                    context
                    ]))
            }
        }
        
        testComment(syntax: FileType.swift, text: [
            "Block",
            "Comment",
            ], comment: [
                "/*",
                " Block",
                " Comment",
                " */",
                ])
        
        testComment(syntax: FileType.workspaceConfiguration, text: [
            "Block",
            "Comment",
            ], comment: [
                "((",
                "    Block",
                "    Comment",
                "    ))",
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
                comment,
                ]))
            
            let consecutiveOutput = syntax.comment(contents: consecutiveTextString)
            XCTAssert(consecutiveOutput == consecutiveCommentString, join(lines: [
                "Failure generating comment using \(fileType):",
                consecutiveTextString,
                "↓",
                consecutiveOutput,
                "≠",
                consecutiveCommentString,
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
                    comment,
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
                    consecutiveCommentString,
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
                    text,
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
                    consecutiveTextString,
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
            "Comment",
            ], consecutiveComment: [
                "// Consecutive",
                "// Comment",
                ])
        
        testComment(syntax: FileType.workspaceConfiguration, text: "Comment", comment: "(Comment)", consecutiveText: [
            "Consecutive",
            "Comment",
            ], consecutiveComment: [
                "(Consecutive)",
                "(Comment)",
                ])
    }
    
    func testHeaders() {
        
        func testHeader(syntax fileExtension: String, header: [String], source: [String]) {
            
            let path = RelativePath("Test." + fileExtension)
            guard let fileType = FileType(filePath: path) else {
                preconditionFailure("Unrecognized extension: \(fileExtension)")
            }
            let syntax = fileType.syntax
            
            func inContext(headerSource: String) -> File {
                
                var contents = ""
                if let firstLine = syntax.requiredFirstLineTokens {
                    contents = join(lines: [
                        firstLine.start + "..." + firstLine.end,
                        "",
                        "", // First line of header.
                        ])
                }
                
                contents.append(headerSource)
                contents.append(join(lines: [
                    "", // Last line of header.
                    "",
                    "...",
                    ]))
                
                return File(path: path, contents: contents)
            }
            var contextString = ""
            if let firstLine = syntax.requiredFirstLineTokens {
                contextString.append(join(lines: [
                    firstLine.start + "..." + firstLine.end,
                    "",
                    ]))
            }
            contextString.append("...")
            let context = File(path: path, contents: contextString)
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
                    "...",
                    ])
                
                XCTAssert(file.contents == expectedSwift, join(lines: [
                    "Failure simulating file using \(fileType):",
                    headerString,
                    "↓",
                    file.contents,
                    "≠",
                    expectedSwift,
                    ]))
            }
            
            if fileExtension == ".sh" {
                let expectedShell = join(lines: [
                    "#!...sh",
                    "",
                    "# File",
                    "# ",
                    "# Project",
                    "# ",
                    "# Copyright",
                    "# ",
                    "# Licence",
                    "",
                    "...",
                    ])
                
                XCTAssert(file.contents == expectedShell, join(lines: [
                    "Failure simulating file using \(fileType):",
                    headerString,
                    "↓",
                    file.contents,
                    "≠",
                    expectedShell,
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
                file.contents,
                ]))
            
            let input = file.header
            XCTAssert(input == headerString, join(lines: [
                "Failure parsing header using \(fileType):",
                file.contents,
                "↓",
                input,
                "≠",
                headerString,
                ]))
        }
        
        testHeader(syntax: ".swift", header: [
            "File",
            "",
            "Project",
            "",
            "Copyright",
            "",
            "Licence",
            ], source: [
                "/*",
                " File",
                "",
                " Project",
                "",
                " Copyright",
                "",
                " Licence",
                " */",
                ])
        
        testHeader(syntax: Configuration.configurationFilePath.string, header: [
            "File",
            "",
            "Project",
            "",
            "Copyright",
            "",
            "Licence",
            ], source: [
                "((",
                "    File",
                "",
                "    Project",
                "",
                "    Copyright",
                "",
                "    Licence",
                "    ))",
                ])
        
        testHeader(syntax: ".sh", header: [
            "File",
            "",
            "Project",
            "",
            "Copyright",
            "",
            "Licence",
            ], source: [
                "# File",
                "# ",
                "# Project",
                "# ",
                "# Copyright",
                "# ",
                "# Licence",
                ])
    }
    
    static var allTests : [(String, (WorkspaceTests) -> () throws -> Void)] {
        return [
            ("testGeneralParsing", testGeneralParsing),
            ("testBlockComments", testBlockComments),
            ("testLineComments", testLineComments),
            ("testHeaders", testHeaders),
        ]
    }
}
