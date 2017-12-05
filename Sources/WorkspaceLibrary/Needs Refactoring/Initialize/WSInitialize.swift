/*
 WSInitialize.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2017 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import Foundation

import SDGCornerstone
import SDGCommandLine

func runInitialize(andExit shouldExit: Bool, arguments: DirectArguments, options: Options, output: inout Command.Output) throws {

    // ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••
    print("Initializing workspace...".formattedAsSectionHeader(), to: &output)
    // ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••

    if ¬Repository.isEmpty {

        let message = [
            "This folder is not empty.",
            "",
            "Existing files:",
            Repository.printableListOfAllFiles,
            "",
            "This command is only for use in empty folders.",
            "For more information, see \(DocumentationLink.setUp.url.in(Underline.underlined))"
            ]

        fatalError(message: message)
    }

    // ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••
    print("Initializing git repository...".formattedAsSectionHeader(), to: &output)
    // ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••

    requireBash(["git", "init"])

    // ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••
    print("Generating Swift package...".formattedAsSectionHeader(), to: &output)
    // ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••

    let packageType = options.projectType
    let projectName = URL(fileURLWithPath: FileManager.default.currentDirectoryPath).lastPathComponent

    let packageName = Configuration.packageName(forProjectName: projectName)
    let moduleName = Configuration.moduleName(forProjectName: projectName)
    let executableName = Configuration.executableName(forProjectName: projectName)
    let executableLibraryName = Configuration.executableLibraryName(forProjectName: projectName)
    let testsName = Configuration.testModuleName(forProjectName: projectName)

    var packageDescription = [
        "import PackageDescription",
        "",
        "let package = Package("
        ]

    switch packageType {
    case .library, .application:
        packageDescription += [
            "    name: \u{22}\(packageName)\u{22}"
        ]
    case .executable:
        packageDescription += [
            "    name: \u{22}\(packageName)\u{22},",
            "    targets: [",
            "        Target(name: \u{22}\(executableName)\u{22}, dependencies: [\u{22}\(executableLibraryName)\u{22}]),",
            "        Target(name: \u{22}\(executableLibraryName)\u{22}),",
            "        Target(name: \u{22}\(testsName)\u{22}, dependencies: [\u{22}\(executableLibraryName)\u{22}])",
            "    ]"
        ]
    }

    packageDescription += [
        ")"
    ]

    var packageDescriptionFile = File(possiblyAt: RelativePath("Package.swift"))
    packageDescriptionFile.body = packageDescription.joinAsLines()
    require() { try packageDescriptionFile.write(output: &output) }

    var source: [String]
    var sourceFile: File
    switch packageType {

    case .library:
        sourceFile = File(possiblyAt: RelativePath("Sources/\(moduleName)/\(moduleName).swift"))
        source = []

    case .application:
        sourceFile = File(possiblyAt: RelativePath("Sources/\(moduleName)/\(moduleName).swift"))
        source = [
            "\u{23}if os(macOS)",
            "    import AppKit",
            "    typealias SystemApplication = AppKit.NSApplication",
            "\u{23}else",
            "    import UIKit",
            "    typealias SystemApplication = UIKit.UIApplication",
            "#endif",
            "",
            "private let applicationDelegate = \(moduleName)()",
            "class Application : SystemApplication {",
            "    override init() {",
            "        super.init()",
            "        delegate = applicationDelegate",
            "    }",
            "    \u{23}if os(macOS)",
            "        required init?(coder: NSCoder) { // [_Exempt from Code Coverage_]",
            "            super.init(coder: coder)",
            "            delegate = applicationDelegate",
            "        }",
            "    #endif",
            "}",
            "",
            "\u{23}if os(macOS)",
            "    @NSApplicationMain class \(moduleName) : NSObject, NSApplicationDelegate {",
            "        func applicationDidFinishLaunching(_ aNotification: Notification) {",
            "            applicationDidFinishLaunching()",
            "        }",
            "    }",
            "\u{23}else",
            "    @UIApplicationMain class \(moduleName) : NSObject, UIApplicationDelegate {",
            "        func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]? = nil) -> Bool {",
            "            applicationDidFinishLaunching()",
            "            return true",
            "        }",
            "    }",
            "#endif",
            "extension \(moduleName) {",
            "",
            "    func applicationDidFinishLaunching() {",
            "        print(sayHello())",
            "    }",
            "}",
            ""
        ]

    case .executable:
        sourceFile = File(possiblyAt: RelativePath("Sources/\(executableLibraryName)/Program.swift"))
        source = [
            "/// Runs `\(executableName)`.",
            "public func run() {",
            "    print(sayHello())",
            "}",
            ""
        ]
    }

    if packageType == .library {
        source += [
            "/// Says, “Hello, world!”.",
            "public func sayHello() -> String {"
        ]
    } else {
        source += [
            "func sayHello() -> String {"
        ]
    }
    source += [
        "    return \u{22}Hello, world!\u{22}",
        "}"
    ]

    sourceFile.body = source.joinAsLines()
    require() { try sourceFile.write(output: &output) }

    if packageType == .executable {
        var mainFile = File(possiblyAt: RelativePath("Sources/\(executableName)/main.swift"))
        let main = [
            "import \(executableLibraryName)",
            "",
            "/*",
            " Nothing in this executable module (\(executableName)) will be testable.",
            " It is recommended to put the entire implementation in \(executableLibraryName).",
            " */",
            "",
            "\(executableLibraryName).run()"
        ]
        mainFile.body = main.joinAsLines()
        require() { try mainFile.write(output: &output) }
    }

    var linuxMainFile = File(possiblyAt: RelativePath("Tests/LinuxMain.swift"))
    let linuxMain = [
        "import XCTest",
        "@testable import \(testsName)",
        "",
        "XCTMain([",
        "    testCase(\(testsName).allTests)",
        "])"
    ]
    linuxMainFile.body = linuxMain.joinAsLines()
    require() { try linuxMainFile.write(output: &output) }

    var testsFile = File(possiblyAt: RelativePath("Tests/\(testsName)/\(testsName).swift"))
    var tests = [
        "import XCTest"
    ]
    switch packageType {
    case .library, .application:
        tests += ["@testable import \(moduleName)"]
    case .executable:
        tests += ["@testable import \(executableLibraryName)"]
    }
    tests += [
        "class \(testsName) : XCTestCase {",
        "",
        "    func testExample() {",
        "        XCTAssert(sayHello() == \u{22}Hello, world!\u{22})",
        "    }",
        ""
        ]
    if packageType == .executable {
        tests += [
            "    func testCommand() {",
            "        \(executableLibraryName).run()",
            "    }",
            ""
        ]
    }
    tests += [
        "    static var allTests: [(String, (\(testsName)) -> () throws -> Void)] {",
        "        return ["
        ]
    if packageType ≠ .executable {
        tests += [
            "            (\u{22}testExample\u{22}, testExample)"
        ]
    } else {
        tests += [
            "            (\u{22}testExample\u{22}, testExample),",
            "            (\u{22}testCommand\u{22}, testCommand)"
        ]
    }
    tests += [
        "        ]",
        "    }",
        "}"
    ]
    testsFile.body = tests.joinAsLines()
    require() { try testsFile.write(output: &output) }

    if packageType == .library {
        var exampleFile = File(possiblyAt: RelativePath("Tests/\(testsName)/Examples/ReadMe.swift"))
        let example = [
            "// [\u{5F}Define Example: Read‐Me_]",
            "import \(moduleName)",
            "",
            "func greet() {",
            "    print(sayHello())",
            "}",
            "// [_End_]"

        ]
        exampleFile.body = example.joinAsLines()
        require() { try exampleFile.write(output: &output) }
    }

    // ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••
    print("Configuring Workspace...".formattedAsSectionHeader(), to: &output)
    // ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••

    var configuration = File(possiblyAt: Configuration.configurationFilePath)
    let note: [String]? = [
        "This is the default setting when Workspace initializes projects.",
        "For more information about “\(Option.automaticallyTakeOnNewResponsibilites)”, see:",
        Option.automaticResponsibilityDocumentationPage.url
        ]
    let entries: [(option: Option, value: String, comment: [String]?)] = [
        (option: .automaticallyTakeOnNewResponsibilites, value: String(Configuration.trueOptionValue), comment: note),
        (option: .projectType, value: String(packageType.key), comment: nil),
        (option: .disableProofreadingRules, value: ["colon", "line_length", "leading_whitespace"].joinAsLines(), comment: nil)
    ]
    Configuration.addEntries(entries: entries, to: &configuration)
    require() { try configuration.write(output: &output) }

    // ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••
    // Refreshing
    // ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••

    try runRefresh(andExit: false, arguments: arguments, options: options, output: &output)

    // ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••
    // Summary
    // ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••

    if shouldExit {
        succeed(message: ["\(try Repository.packageRepository.projectName(output: &output)) has been initialized.", try instructionsAfterRefresh()])
    }
}
