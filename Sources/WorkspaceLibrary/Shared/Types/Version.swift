/*
 Version.swift

 This source file is part of the Workspace open source project.

 Copyright ©2017 Jeremy David Giesbrecht and the Workspace contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGMathematics

struct Version: Comparable, CustomStringConvertible, Equatable, LosslessStringConvertible {
    
    // MARK: - Initialization
    
    init(_ major: Int, _ minor: Int, _ patch: Int) {
        self.major = major
        self.minor = minor
        self.patch = patch
    }
    
    // MARK: - Properties
    
    var major: Int
    var minor: Int
    var patch: Int
    
    // MARK: - Comparable
    
    static func <(lhs: Version, rhs: Version) -> Bool {
        return (lhs.major, lhs.minor, lhs.patch) < (rhs.major, rhs.minor, rhs.patch)
    }
    
    // MARK: - CustomStringConvertible
    
    var description: String {
        return "\(major).\(minor).\(patch)"
    }
    
    // MARK: - Equatable
    
    static func ==(lhs: Version, rhs: Version) -> Bool {
        return (lhs.major, lhs.minor, lhs.patch) == (rhs.major, rhs.minor, rhs.patch)
    }
    
    // MARK: - LosslessStringConvertible
    
    init?(_ string: String) {
        let sections = string.components(separatedBy: ".")
        
        if sections.count ≥ 1 {
            if let major = Int(sections[0]) {
                self.major = major
            } else {
                return nil
            }
        } else {
            return nil
        }
        
        if sections.count ≥ 2 {
            minor = Int(sections[1]) ?? 0
        } else {
            minor = 0
        }
        
        if sections.count ≥ 3 {
            patch = Int(sections[2]) ?? 0
        } else {
            patch = 0
        }
    }
}
