/*
 WSInitialize.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2017 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGCornerstone

func runInitialize(andExit shouldExit: Bool) {

    // ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••
    printHeader(["Initializing workspace..."])
    // ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••

    if ¬Repository.isEmpty {

        let message = [
            "This folder is not empty.",
            "",
            "Existing files:",
            Repository.printableListOfAllFiles,
            "",
            "This command is only for use in empty folders.",
            "For more information, see:",
            DocumentationLink.setUp.url
            ]

        fatalError(message: message)
    }

    // ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••
    printHeader(["Initializing git repository..."])
    // ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••

    requireBash(["git", "init"])

    // ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••
    printHeader(["Generating Swift package..."])
    // ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••

    let packageType = Flags.type
    let projectName = Configuration.projectName

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
    packageDescriptionFile.body = join(lines: packageDescription)
    require() { try packageDescriptionFile.write() }

    var source: [String]
    var sourceFile: File
    switch packageType {

    case .library:
        sourceFile = File(possiblyAt: RelativePath("Sources/\(moduleName)/\(moduleName).swift"))
        source = []

    case .application:
        sourceFile = File(possiblyAt: RelativePath("Sources/\(moduleName)/\(moduleName).swift"))
        source = [
            "#if os(macOS)",
            "    import AppKit",
            "    typealias SystemApplication = AppKit.NSApplication",
            "#else",
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
            "    #if os(macOS)",
            "        required init?(coder: NSCoder) { // [_Exempt from Code Coverage_]",
            "            super.init(coder: coder)",
            "            delegate = applicationDelegate",
            "        }",
            "    #endif",
            "}",
            "",
            "#if os(macOS)",
            "    @NSApplicationMain class \(moduleName) : NSObject, NSApplicationDelegate {",
            "        func applicationDidFinishLaunching(_ aNotification: Notification) {",
            "            applicationDidFinishLaunching()",
            "        }",
            "    }",
            "#else",
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

    sourceFile.body = join(lines: source)
    require() { try sourceFile.write() }

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
        mainFile.body = join(lines: main)
        require() { try mainFile.write() }
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
    linuxMainFile.body = join(lines: linuxMain)
    require() { try linuxMainFile.write() }

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
    testsFile.body = join(lines: tests)
    require() { try testsFile.write() }

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
        exampleFile.body = join(lines: example)
        require() { try exampleFile.write() }
    }

    // ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••
    printHeader(["Configuring Workspace..."])
    // ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••

    var configuration = File(possiblyAt: Configuration.configurationFilePath)
    let note: [String]? = [
        "This is the default setting when Workspace initializes projects.",
        "For more information about “\(Option.automaticallyTakeOnNewResponsibilites)”, see:",
        Option.automaticResponsibilityDocumentationPage.url
        ]
    let entries: [(option: Option, value: String, comment: [String]?)] = [
        (option: .automaticallyTakeOnNewResponsibilites, value: Configuration.trueOptionValue, comment: note),
        (option: .projectType, value: packageType.key, comment: nil),
        (option: .disableProofreadingRules, value: join(lines: ["colon", "line_length", "leading_whitespace"]), comment: nil)
    ]
    Configuration.addEntries(entries: entries, to: &configuration)
    require() { try configuration.write() }

    // ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••
    // Refreshing
    // ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••

    WSCommand.refresh.run(andExit: false)

    // ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••
    // Summary
    // ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••

    if shouldExit {
        succeed(message: ["\(Configuration.projectName) has been initialized.", instructionsAfterRefresh])
    }
}
