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
    
    if ¬Repository.isEmpty {
        fatalError(message: [
            "This folder is not empty.",
            "",
            "Existing files:",
            Repository.printableListOfAllFiles,
            "",
            "This command is only for use in empty folders.",
            "For more information, see:",
            "https://github.com/SDGGiesbrecht/Workspace#setup",
            ])
    }
    print("Executable?: \(Flags.executable)")
    
    var script = ["swift", "package", "init"]
    if Flags.executable {
        script.append(contentsOf: ["--executable"])
    }
    //forceBash(script)
    
    if shouldExit {
        succeed(message: ["Initialized."])
    }
}
