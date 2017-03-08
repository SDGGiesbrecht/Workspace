/*
 Initialize.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace

 Copyright ©2017 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGLogic

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
    let testsName = Configuration.testsName(forProjectName: projectName)

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
            "import Cocoa",
            "",
            "private let applicationDelegate = \(moduleName)()",
            "private class Application : Cocoa.NSApplication {",
            "    override init() {",
            "        super.init()",
            "        delegate = applicationDelegate",
            "    }",
            "    required init?(coder: NSCoder) {",
            "        super.init(coder: coder)",
            "        delegate = applicationDelegate",
            "    }",
            "}",
            "",
            "@NSApplicationMain class \(moduleName) : NSObject, NSApplicationDelegate {",
            "",
            "    func applicationDidFinishLaunching(_ aNotification: Notification) {",
            "        print(sayHello())",
            "    }",
            "}",
            ""
        ]

    case .executable:
        sourceFile = File(possiblyAt: RelativePath("Sources/\(executableLibraryName)/Program.swift"))
        source = [
            "/// Runs \(executableName).",
            "public func run() {",
            "    print(sayHello())",
            "}",
            ""
        ]
    }

    source += [
        "func sayHello() -> String {",
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
        "]"
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
        "",
        "    static var allTests: [(String, (\(testsName)) -> () throws -> Void)] {",
        "        return [",
        "            (\u{22}testExample\u{22}, testExample)",
        "        ]",
        "    }",
        "}"
    ]
    testsFile.body = join(lines: tests)
    require() { try testsFile.write() }

    // ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••
    printHeader(["Configuring Workspace..."])
    // ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••

    var configuration = File(possiblyAt: Configuration.configurationFilePath)
    let note: [String]? = [
        "This is the default setting when Workspace initializes projects.",
        "For more information about “\(Option.automaticallyTakeOnNewResponsibilites)”, see:",
        Option.automaticResponsibilityDocumentationPage.url
        ]
    var entries: [(option: Option, value: String, comment: [String]?)] = [(option: .automaticallyTakeOnNewResponsibilites, value: Configuration.trueOptionValue, comment: note)]
    if Flags.type == .executable {
        entries.append(contentsOf: [
            (option: .projectType, value: ProjectType.executable.key, comment: nil)
            ])
    }
    Configuration.addEntries(entries: entries, to: &configuration)
    require() { try configuration.write() }

    // ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••
    // Refreshing
    // ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••

    Command.refresh.run(andExit: false)

    // ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••
    // Summary
    // ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••

    if shouldExit {
        succeed(message: ["\(Configuration.projectName) has been initialized.", instructionsAfterRefresh])
    }
}
