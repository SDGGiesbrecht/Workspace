// Refresh.swift
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

let instructionsAfterRefresh = "" //"Open \(Configuration.projectName).xcodeproj to work on the project."

func runRefresh(andExit shouldExit: Bool) {
    
    // ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••
    printHeader(["Updating Workspace commands..."])
    // ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••
    
    require() { try Repository.move(Repository.workspaceDirectory.subfolderOrFile("Scripts/Refresh Workspace.command"), into: Repository.root) }
    
    if Configuration.automaticallyTakeOnNewResponsibilites {
        
        // ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••
        printHeader(["Updating Workspace configuration..."])
        // ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••
        
        print("Hello?")
        
        var newResponsibilities: [(option: Option, value: String, comment: [String]?)] = []
        
        print("Did I make it here?")
        
        for (option, details) in Option.automaticRepsonsibilities {
            
            print("Hello??")
            
            if ¬Configuration.optionIsDefined(option) {
                
                print("What about here?")
                
                newResponsibilities.append((option: option, value: details.automaticValue, comment: [
                    "Workspace took responsibility for this automatically because “\(Option.automaticallyTakeOnNewResponsibilites.key)” is “\(Configuration.trueOptionValue)”",
                    "For more information about “\(option.key)”, see:",
                    details.documentationPage.url,
                    ]))
            }
        }
        
        print("Hello???")
        
        require() { try Configuration.addEntries(entries: newResponsibilities) }
    }
    
    print("Hello????")
    
    if shouldExit {
        succeed(message: ["\(Configuration.projectName) is refreshed and ready.", instructionsAfterRefresh])
    }
}
