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

import SDGLogic

enum Licence: String {
    
    // MARK: - Initialization
    
    init?(key: String) {
        self.init(rawValue: key)
    }
    
    // MARK: - Cases
    
    case apache2_0 = "Apache 2.0"
    
    static let all: [Licence] = [
        .apache2_0
    ]
    
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
    
    private var noticeLines: [String] {
        switch self {
        case .apache2_0:
            return [
                "Licensed under the Apache Licence, Version 2.0",
                "See http://www.apache.org/licenses/LICENSE-2.0 for licence information.",
            ]
        }
    }
    
    var notice: String {
        return join(lines: noticeLines)
    }
    
    // MARK: - Licence Management
    
    static func refreshLicence() {
        
        guard let licence = Configuration.licence else {
            
            // Fails later in validation phase.
            
            return
        }
        
        let text = licence.text
        var file = File(possiblyAt: RelativePath("LICENSE.md"))
        file.contents = text
        require() { try file.write() }
        
        // Delete alternate licence files to prevent duplicates.
        force() { try Repository.delete(RelativePath("LICENSE.txt")) }
    }
}
