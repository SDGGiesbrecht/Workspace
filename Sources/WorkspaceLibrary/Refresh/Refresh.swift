/*
 Refresh.swift

 This source file is part of the Workspace open source project.

 Copyright ©2017 Jeremy David Giesbrecht and the Workspace contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

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
    
    func copy(script: String) {
        let origin = require() { try File(at: Repository.workspaceResources.subfolderOrFile("Scripts/\(script)")) }
        
        var destination = File(possiblyAt: RelativePath(script))
        destination.contents = origin.contents
        require() { try destination.write() }
    }
    
    // Refresh Workspace
    
    copy(script: "Refresh Workspace (macOS).command")
    
    if Configuration.supportLinux {
        // Checked into repository, so dependent on configuration.
        
        copy(script: "Refresh Workspace (Linux).sh")
    }
    
    // Validate Changes
    
    copy(script: "Validate Changes (macOS).command")
    
    if Environment.operatingSystem == .linux {
        // Not checked into repository, so dependent on environment.
        
        copy(script: "Validate Changes (Linux).command")
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
    
    if Configuration.manageLicence {
        
        // ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••
        printHeader(["Updating licence..."])
        // ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••
        
        Licence.refreshLicence()
    }
    
    if Configuration.manageContinuousIntegration {
        // ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••
        printHeader(["Updating continuous integration configuration..."])
        // ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••
        
        ContinuousIntegration.refreshContinuousIntegrationConfiguration()
    } else {
        ContinuousIntegration.relinquishControl()
    }
    
    if Configuration.manageFileHeaders {
        // ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••
        printHeader(["Updating file headers..."])
        // ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••
        
        FileHeaders.refreshFileHeaders()
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
