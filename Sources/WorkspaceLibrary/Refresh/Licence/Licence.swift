// Licence.swift
//
// This source file is part of the Workspace open source project.
//
// Copyright ©2017 Jeremy David Giesbrecht and the Workspace contributors.
//
// Soli Deo gloria
//
// Licensed under the Apache License, Version 2.0
// See http://www.apache.org/licenses/LICENSE-2.0 for licence information.

enum Licence: String {
    
    // MARK: - Cases
    
    case Apache2_0 = "Apache 2.0"
    
    // MARK: - Properties
    
    var key: String {
        return rawValue
    }
    
    private var filenameWithoutExtension: String {
        return rawValue
    }
    
    static let licenceFolder = "Resources/Licences"
    
    private func licenceData(fileExtension: String) -> String {

        let licenceDirectory = Repository.workspaceDirectory.subfolderOrFile(Licence.licenceFolder)
        let path = licenceDirectory.subfolderOrFile("\(filenameWithoutExtension).\(fileExtension)")
        let file = require() { try File(at: path) }
        
        return file.contents
    }
    
    var filename: String {
        return filenameWithoutExtension + ".md"
    }
    
    var text: String {
        return licenceData(fileExtension: "md")
    }
    
    var notice: String {
        return licenceData(fileExtension: ".txt")
    }
}
