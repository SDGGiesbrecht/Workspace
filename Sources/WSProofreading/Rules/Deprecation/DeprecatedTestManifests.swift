import WSGeneralImports

import WSProject

internal struct DeprecatedTestManifests : TextRule {
    // Deprecated in 0.25.0 (????‐??‐??)

    internal static let name = UserFacing<StrictString, InterfaceLocalization>({ (localization) in
        switch localization {
        case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
            return "deprecatedTestManifests"
        case .deutschDeutschland:
            return "überholteTestlisten"
        }
    })

    private static let message = UserFacing<StrictString, InterfaceLocalization>({ (localization) in
        switch localization {
        case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
            return "Test manifests are no longer necessary."
        case .deutschDeutschland:
            return "Testlisten werden nicht mehr benötigt."
        }
    })

    internal static func check(file: TextFile, in project: PackageRepository, status: ProofreadingStatus, output: Command.Output) {
        reportViolation(in: file, at: file.contents.bounds, message: message, status: status, output: output)
    }
}
