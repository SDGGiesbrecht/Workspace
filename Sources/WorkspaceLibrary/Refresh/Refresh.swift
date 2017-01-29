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

let instructionsAfterRefresh: String = {
    if Environment.operatingSystem == .macOS ∧ Configuration.manageXcode {
        return "Open “\(Configuration.projectName).xcodeproj” to work on the project."
    } else {
        return ""
    }
}()

func runRefresh(andExit shouldExit: Bool) {
    
    // ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••
    printHeader(["Refreshing \(Configuration.projectName)..."])
    // ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••
    
    // ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••
    printHeader(["Updating Workspace commands..."])
    // ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••
    
    // Refresh Workspace
    
    require() { try Repository.copy(Repository.workspaceDirectory.subfolderOrFile("Scripts/Refresh Workspace (macOS).command"), into: Repository.root, includeIgnoredFiles: true) }
    
    if Configuration.supportLinux {
        // Checked into repository, so dependent on configuration.
        
        require() { try Repository.copy(Repository.workspaceDirectory.subfolderOrFile("Scripts/Refresh Workspace (Linux).sh"), into: Repository.root, includeIgnoredFiles: true) }
    }
    
    // Validate Changes
    
    require() { try Repository.copy(Repository.workspaceDirectory.subfolderOrFile("Scripts/Validate Changes (macOS).command"), into: Repository.root, includeIgnoredFiles: true) }
    
    if Environment.operatingSystem == .linux {
        // Not checked into repository, so dependent on environment.
        
        require() { try Repository.copy(Repository.workspaceDirectory.subfolderOrFile("Scripts/Validate Changes (Linux).sh"), into: Repository.root, includeIgnoredFiles: true) }
    }
    
    // ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••
    printHeader(["Updating Workspace configuration..."])
    // ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••
    
    var newResponsibilities: [(option: Option, value: String, comment: [String]?)] = []
    
    for (option, automaticValue, documentationPage) in Option.automaticRepsonsibilities {
        
        if ¬Configuration.optionIsDefined(option) {
            
            if Configuration.automaticallyTakeOnNewResponsibilites {
                newResponsibilities.append((option: option, value: automaticValue, comment: [
                    "Workspace took responsibility for this automatically.",
                    "(Because “\(Option.automaticallyTakeOnNewResponsibilites.key)” is “\(Configuration.trueOptionValue)”)",
                    "For more information about “\(option.key)”, see:",
                    documentationPage.url,
                    ]))
            } else {
                printWarning([
                    "The configuration option “\(option.key)” is now available.",
                    "For more information, see:",
                    documentationPage.url,
                    "(To silence this notice, set “\(option.key)” to “\(option.defaultValue)”)",
                    ])
            }
        }
    }
    
    if Configuration.automaticallyTakeOnNewResponsibilites {
        Configuration.addEntries(entries: newResponsibilities)
    }
    
    // ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••
    printHeader(["Updating Git configuration..."])
    // ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••
    
    Git.refreshGitIgnore()
    
    if Configuration.manageContinuousIntegration {
        // ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••
        printHeader(["Updating continuous integration configuration..."])
        // ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••
        
        ContinuousIntegration.refreshContinuousIntegrationConfiguration()
    }
    
    if Configuration.manageXcode ∧ Environment.operatingSystem == .macOS {
        
        // ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••
        printHeader(["Refreshing Xcode project..."])
        // ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••
        
        Xcode.refreshXcodeProjects()
    }
    
    if shouldExit {
        
        succeed(message: [
            "\(Configuration.projectName) is refreshed and ready.",
            instructionsAfterRefresh
            ])
    }
}
