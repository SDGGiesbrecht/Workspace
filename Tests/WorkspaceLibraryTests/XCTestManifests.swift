#if !canImport(ObjectiveC)
import XCTest

extension APITests {
    // DO NOT MODIFY: This is autogenerated, use:
    //   `swift test --generate-linuxmain`
    // to regenerate.
    static let __allTests__APITests = [
        ("testAllDisabled", testAllDisabled),
        ("testAllTasks", testAllTasks),
        ("testBadStyle", testBadStyle),
        ("testCheckedInDocumentation", testCheckedInDocumentation),
        ("testCheckForUpdates", testCheckForUpdates),
        ("testContinuousIntegrationWithoutScripts", testContinuousIntegrationWithoutScripts),
        ("testCustomProofread", testCustomProofread),
        ("testCustomReadMe", testCustomReadMe),
        ("testCustomTasks", testCustomTasks),
        ("testDefaults", testDefaults),
        ("testExecutable", testExecutable),
        ("testFailingCustomTasks", testFailingCustomTasks),
        ("testFailingCustomValidation", testFailingCustomValidation),
        ("testFailingDocumentationCoverage", testFailingDocumentationCoverage),
        ("testFailingTests", testFailingTests),
        ("testHeaders", testHeaders),
        ("testHelp", testHelp),
        ("testInvalidResourceDirectory", testInvalidResourceDirectory),
        ("testInvalidTarget", testInvalidTarget),
        ("testLocalizationIdentifier", testLocalizationIdentifier),
        ("testMissingDocumentation", testMissingDocumentation),
        ("testMissingExample", testMissingExample),
        ("testMissingReadMeLocalization", testMissingReadMeLocalization),
        ("testMultipleProducts", testMultipleProducts),
        ("testNoLibraries", testNoLibraries),
        ("testNoLocalizations", testNoLocalizations),
        ("testOneProductMultipleModules", testOneProductMultipleModules),
        ("testPartialReadMe", testPartialReadMe),
        ("testSDGLibrary", testSDGLibrary),
        ("testSDGTool", testSDGTool),
        ("testSelfSpecificScripts", testSelfSpecificScripts),
    ]
}

extension InternalTests {
    // DO NOT MODIFY: This is autogenerated, use:
    //   `swift test --generate-linuxmain`
    // to regenerate.
    static let __allTests__InternalTests = [
        ("testGitIgnoreCoverage", testGitIgnoreCoverage),
    ]
}

public func __allTests() -> [XCTestCaseEntry] {
    return [
        testCase(APITests.__allTests__APITests),
        testCase(InternalTests.__allTests__InternalTests),
    ]
}
#endif
