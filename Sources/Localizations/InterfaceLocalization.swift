/*
 InterfaceLocalization.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2017–2018 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGLocalization

public enum InterfaceLocalization : String, InputLocalization, Localization {

    // MARK: - Cases

    case englishCanada = "en\u{2D}CA"
    // Do not forget to register new localizations in “.Workspace Configuration.txt” as well.

    public static let cases: [InterfaceLocalization] = [
        .englishCanada
    ]

    // MARK: - Localization

    public static let fallbackLocalization = InterfaceLocalization.englishCanada
}
