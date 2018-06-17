/*
 Dictionary.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2018 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

extension Dictionary where Key == LocalizationIdentifier {
    // MARK: - where Key == LocalizationIdentifier

    /// Accesses the respective localized value.
    public subscript<L>(_ key: L) -> Value? where L : Localization {
        get {
            return self[LocalizationIdentifier(key)]
        }
        set {
            self[LocalizationIdentifier(key)] = newValue
        }
    }
}
