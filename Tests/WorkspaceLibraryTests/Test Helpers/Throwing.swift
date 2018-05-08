/*
 Throwing.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2017–2018 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import GeneralTestImports

func XCTAssertErrorFree(file: StaticString = #file, line: UInt = #line, _ expression: () throws -> Void) {
    do {
        try expression()
    } catch let error {
        XCTFail("\(error)", file: file, line: line)
    }
}

func XCTAssertThrows<E : Error>(_ error: E, file: StaticString = #file, line: UInt = #line, _ expression: () throws -> Void) {
    do {
        try expression()
        XCTFail("The expected error was never thrown:\n" + "\(error)", file: file, line: line)
    } catch let thrown {
        XCTAssertEqual("\(thrown)", "\(error)", file: file, line: line)
    }
}

func XCTAssertThrowsError(containing searchTerm: StrictString, file: StaticString = #file, line: UInt = #line, _ expression: () throws -> Void) {
    do {
        try expression()
        XCTFail("The expected error was never thrown:\n...\(searchTerm)...", file: file, line: line)
    } catch let thrown {
        XCTAssert("\(thrown)".contains(String(searchTerm)), "Error message does not contain “\(searchTerm)”:\n\(thrown)", file: file, line: line)
    }
}
