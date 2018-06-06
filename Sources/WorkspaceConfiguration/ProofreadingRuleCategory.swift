
extension ProofreadingRule {

    /// A category of proofreading rule.
    public enum Category {

        // MARK: - Cases

        /// Temporary rules which help with updating Workspace by catching deprecated usage.
        case deprecation

        /// Warnings which are requested manually.
        case intentional

        /// Rules which ensure development tools (Workspace, Xcode, etc) work as intended.
        case functionality

        /// Rules which improve documentation quality.
        case documentation

        /// Rules which enforce consistent text style.
        case textStyle

        /// Rules which enforce consistent source code style.
        case sourceCodeStyle
    }
}
