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
    
    printWarning(["Warning A"])
    printWarning(["Warning B"])
    
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
    printHeader(["Generating Swift package..."])
    // ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••
    
    var script = ["swift", "package", "init"]
    if Flags.executable {
        script.append(contentsOf: ["--type", "executable"])
    }
    requireBash(script)
    
    print(["Arranging Swift package..."])
    
    force() { try Repository.move("Sources", to: RelativePath("Sources/\(Configuration.projectName)")) }
    
    // ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••
    printHeader(["Initializing git repository..."])
    // ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••
    
    requireBash(["git", "init"])
    
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
