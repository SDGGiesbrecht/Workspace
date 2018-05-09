import XCTest

extension APITests {
    static let __allTests = [
        ("testCheckForUpdates", testCheckForUpdates),
        ("testDefaults", testDefaults),
        ("testHelp", testHelp),
        ("testLinuxMainGenerationCompatibility", testLinuxMainGenerationCompatibility),
        ("testSelfSpecificScripts", testSelfSpecificScripts),
    ]
}

extension InternalTests {
    static let __allTests = [
        ("testDocumentationCoverage", testDocumentationCoverage),
        ("testGitIgnoreCoverage", testGitIgnoreCoverage),
        ("testLinuxMainGenerationCompatibility", testLinuxMainGenerationCompatibility),
    ]
}

#if !os(macOS)
public func __allTests() -> [XCTestCaseEntry] {
    return [
        testCase(APITests.__allTests),
        testCase(InternalTests.__allTests),
    ]
}
#endif
