/*
 Version.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2017 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

enum Localization {
    
    // MARK: - Initialization
    
    init(code: String) {
        if let result = SupportedLocalization(code: code) {
            self = .supported(result)
        } else {
            self = .unsupported(code)
        }
    }
    
    // MARK: - Cases
    
    case supported(SupportedLocalization)
    case unsupported(String)
    
    // MARK: - Properties
    
    var code: String {
        switch self {
        case .supported(let localization):
            return localization.code
        case .unsupported(let code):
            return code
        }
    }
    
    // MARK: - Supported
    
    enum SupportedLocalization: String {
        
        // MARK: - Initialization
        
        init?(code: String) {
            
            if let result = SupportedLocalization(rawValue: code) {
                self = result
            } else if let result = SupportedLocalization.aliases[code] {
                self = result
            } else {
                return nil
            }
        }
        
        // MARK: - Cases
        
        case englishUnitedKindom = "en-GB"
        case englishUnitedStates = "en-US"
        case englishCanada = "en-CA"
        
        case germanGermany = "de-DE"
        
        private static let aliases: [String: SupportedLocalization] = [
            "en": .englishUnitedKindom,
            "de": .germanGermany
        ]
        
        // MARK: - Properties
        
        var code: String {
            return rawValue
        }
    }
}
