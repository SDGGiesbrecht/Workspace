/*
 Flag.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace

 Copyright ©2017 Jeremy David Giesbrecht and the Workspace contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

enum Flag: String, Comparable, CustomStringConvertible {
    
    // MARK: - Initialization
    
    init?(name: String) {
        self.init(rawValue: name)
    }
    
    init?(flag: String) {
        if flag.hasPrefix("•") {
            var name = flag
            name.unicodeScalars.removeFirst()
            self.init(name: name)
        } else {
            return nil
        }
    }
    
    // MARK: - Cases
    
    case executable = "executable"
    
    static let all: [Flag] = [
        .executable,
        ].sorted()
    
    static let allNames: [String] = all.map() { $0.name }
    
    static let allFlags: [String] = all.map() { $0.flag }
    
    // MARK: - Usage
    
    var name: String {
        return rawValue
    }
    
    var flag: String {
        return "•\(name)"
    }
    
    // MARK: - Comparable
    
    static func <(lhs: Flag, rhs: Flag) -> Bool {
        return lhs.name < rhs.name
    }
    
    // MARK: - CustomStringConvertible
    
    var description: String {
        return name
    }
}
