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

import XCTest
@testable import workspace

class WorkspaceTests: XCTestCase {
    
    func testGeneralParsing() {
        
        func testLineBreaking(text: [String]) {
            
            for newline in ["\n", String.CR_LF] {
                
                let parsed = Array<String>(text.joined(separator: newline).lines)
                XCTAssert(parsed == text, [
                    "Failure parsing lines using \(newline.addingPercentEncoding(withAllowedCharacters: CharacterSet())!):",
                    text.joined(separator: "\n"),
                    "↓",
                    parsed.joined(separator: "\n"),
                    ].joined(separator: "\n"))
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
    /*
    
    func testBlockComments() {
        
        func testComment(syntax: BlockCommentSyntax, text: [String], comment: [String]) {
            
            let output = syntax.comment(text)
            XCTAssert(output == comment, [
                "Failure generating block comment using \(syntax):",
                text,
                "↓",
                output,
                ].joined(separator: "\n"))
            
            //let simpleParse = syntax.comment(comment)
        }
        
        testComment(syntax: FileSyntax.swift.blockCommentSyntax, text: [
            "Block",
            "Comment",
            ], comment: [
                "/*",
                " Block",
                " Comment",
                " */",
                ])
        
        testComment(syntax: FileSyntax.workspaceConfiguration.blockCommentSyntax, text: [
            "Block",
            "Comment",
            ], comment: [
                "((",
                "    Block",
                "    Comment",
                "    ))",
                ])

    }*/
    
    static var allTests : [(String, (WorkspaceTests) -> () throws -> Void)] {
        return [
            ("testGeneralParsing", testGeneralParsing),
            //("testBlockComments", testBlockComments),
        ]
    }
}
