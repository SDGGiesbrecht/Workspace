/*
 FastTestLocalization.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2019 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import WSGeneralTestImports

public enum FastTestLocalization : String, InputLocalization, Localization {

    // MARK: - Cases

    case englishCanada = "en\u{2D}CA"

    // MARK: - Localization

    public static let fallbackLocalization = FastTestLocalization.englishCanada
}
