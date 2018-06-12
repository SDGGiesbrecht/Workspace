import GeneralImports

struct DeprecatedConfiguration : Rule {
    // Deprecated in 0.8.0 (???)

    static let name = UserFacing<StrictString, InterfaceLocalization>({ (localization) in
        switch localization {
        case .englishCanada:
            return "deprecatedConfiguration"
        }
    })

    static let message = UserFacing<StrictString, InterfaceLocalization>({ (localization) in
        switch localization {
        case .englishCanada:
            return "“.Workspace Configuration.txt” is no longer used. It has been replaced by “Workspace.swift”."
        }
    })

    static func check(file: TextFile, in project: PackageRepository, status: ProofreadingStatus, output: Command.Output) {
        if file.location.lastPathComponent == ".Workspace Configuration.txt" {
            reportViolation(in: file, at: file.contents.bounds, message: message, status: status, output: output)
        }
    }
}
