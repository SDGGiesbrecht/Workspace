
extension ProcessInfo {

    public static let isInContinuousIntegration = ProcessInfo.processInfo.environment["CONTINUOUS_INTEGRATION"] ≠ nil
}
