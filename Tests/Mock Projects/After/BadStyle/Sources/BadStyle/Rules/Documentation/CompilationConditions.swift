// Header

#if os(macOS) // Okay.

    /// macOS only.
    public func macOSOnly() {}
#endif

#if os(Linux)
// MARK: - #if os(Linux) (Warn: This header is no longer needed.)

/// Linux only.
public func linuxOnly() {}
#endif
