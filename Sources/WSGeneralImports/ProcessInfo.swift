
extension ProcessInfo {

    public static let isInContinuousIntegration = ProcessInfo.processInfo.environment["CONTINUOUS_INTEGRATION"] ≠ nil
    public static let isPullRequest = ProcessInfo.processInfo.environment["TRAVIS_PULL_REQUEST"].flatMap({ Int($0) }) ≠ nil
}
