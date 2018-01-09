
import SDGCornerstone
import SDGCommandLine

protocol Rule {
    static var name: UserFacingText<InterfaceLocalization, Void> { get }
    static var noticeOnly: Bool { get }
    static func check(file: TextFile, status: ProofreadingStatus, output: inout Command.Output)
}

extension Rule {
    
    static var noticeOnly: Bool {
        return false
    }
    
    static func reportViolation(in file: TextFile, at location: Range<String.ScalarView.Index>, replacementSuggestion: StrictString? = nil, message: UserFacingText<InterfaceLocalization, Void>, status: ProofreadingStatus, output: inout Command.Output) {
        status.report(violation: StyleViolation(in: file, at: location, replacementSuggestion: replacementSuggestion, noticeOnly: noticeOnly, ruleIdentifier: Self.name, message: message), to: &output)
    }
}
