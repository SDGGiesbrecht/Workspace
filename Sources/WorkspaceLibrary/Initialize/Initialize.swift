// Initialize.swift
//
// This source file is part of the Workspace open source project.
//
// Copyright ©2017 Jeremy David Giesbrecht and the Workspace contributors.
//
// Soli Deo gloria
//
// Licensed under the Apache License, Version 2.0
// See http://www.apache.org/licenses/LICENSE-2.0 for licence information.

import SDGLogic

func runInitialize(andExit shouldExit: Bool) {
    
    // ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••
    printHeader(["Initializing workspace..."])
    // ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••
    
    if ¬Repository.isEmpty {
        
        var message = [
            "This folder is not empty.",
            "",
            "Existing files:",
            Repository.printableListOfAllFiles,
            "",
            "This command is only for use in empty folders.",
            "For more information, see:",
            DocumentationLink.setUp.url,
            ]
        
        do {
            try Repository.delete(".Workspace")
        } catch let error {
            message.append(contentsOf: [
                "",
                "Failed to clean up “.Workspace”:",
                "",
                error.localizedDescription
                ])
        }
        
        fatalError(message: message)
    }
    
    // ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••
    printHeader(["Initializing git repository..."])
    // ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••
    
    requireBash(["git", "init"])
    
    // ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••
    printHeader(["Generating Swift package..."])
    // ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••
    
    let script = ["swift", "package", "init"]
    requireBash(script)
    
    print(["Arranging Swift package..."])
    
    let projectName = Configuration.projectName.replacingOccurrences(of: " ", with: "_")
    let testsName = projectName + "Tests"
    
    // Make module to allow folder structure.
    require() { try Repository.move("Sources", to: RelativePath("Sources/\(projectName)")) }
    
    // Escape spaces
    let withSpaces = RelativePath("Tests/\(Configuration.projectName)Tests")
    let noSpaces = RelativePath("Tests/\(testsName)")
    if withSpaces ≠ noSpaces {
        require() { try Repository.move(withSpaces, to: noSpaces) }
        require() { try Repository.delete(withSpaces) }
    }
    
    
    // Erase redundant .gitignore entries.
    var gitIngore = require() { try Repository.read(file: RelativePath(".gitignore")) }
    gitIngore.contents = ""
    require() { try Repository.write(file: gitIngore) }
    
    if Flags.executable {
        
        let executableName = projectName
        let libraryName = projectName + "Library"
        
        require() { try Repository.delete(RelativePath("Sources/\(projectName)")) }
        
        let program = File(path: RelativePath("Sources/\(libraryName)/Program.swift"), contents: join(lines: [
            "/// :nodoc:",
            "public func run() {",
            "",
            "    print(sayHello())",
            "",
            "}",
            "",
            "func sayHello() -> String {",
            "",
            "    return \u{22}Hello, world!\u{22}",
            "",
            "}",
            ]))
        
        require() { try Repository.write(file: program) }
        
        let main = File(path: RelativePath("Sources/\(executableName)/main.swift"), contents: join(lines: [
            "import \(libraryName)",
            "",
            "/*",
            " Nothing in this executable module (\(executableName)) will be testable.",
            " It is recommended to put the entire implementation in \(libraryName).",
            " */",
            "\(libraryName).run()",
            ]))
        
        require() { try Repository.write(file: main) }
        
        var package = Repository.packageDescription
        let nameRange = package.requireRange(of: ("name: \u{22}", "\u{22}"))
        let replacement = join(lines: [
            package.contents.substring(with: nameRange) + ",",
            "    targets: [",
            "        Target(name: \u{22}\(executableName)\u{22}, dependencies: [\u{22}\(libraryName)\u{22}]),",
            "        Target(name: \u{22}\(libraryName)\u{22}),",
            "        Target(name: \u{22}\(testsName)\u{22}, dependencies: [\u{22}\(libraryName)\u{22}]),",
            "    ]",
            ])
        
        package.contents.replaceSubrange(nameRange, with: replacement)
        
        require() { try Repository.write(file: package) }
        
        var tests = require { try Repository.read(file: RelativePath("Tests/\(testsName)/\(testsName).swift")) }
        let importRange = tests.requireRange(of: projectName)
        tests.contents.replaceSubrange(importRange, with: libraryName)
        let testRange = tests.requireRange(of: ("  XCTAssert", "\u{22})"))
        tests.contents.replaceSubrange(testRange, with: "  XCTAssert(sayHello() == \u{22}Hello, world!\u{22}))")
        require() { try Repository.write(file: tests) }
    }
    
    // ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••
    printHeader(["Configuring Workspace..."])
    // ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••
    
    var configuration = File(path: Configuration.configurationFilePath, contents: "")
    let note: [String]? = [
        "This is the default setting when the Workspace initializes projects.",
        "For more information about “\(Option.automaticallyTakeOnNewResponsibilites)”, see:",
        Option.automaticResponsibilityDocumentationPage.url,
        ]
    Configuration.addEntries(entries: [(option: .automaticallyTakeOnNewResponsibilites, value: Configuration.trueOptionValue, comment: note)], to: &configuration)
    require() { try Repository.write(file: configuration) }
    
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
