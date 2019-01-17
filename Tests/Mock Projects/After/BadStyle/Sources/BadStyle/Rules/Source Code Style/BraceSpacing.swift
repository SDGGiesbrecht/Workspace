// Header

let x = [].map {$0} // These braces should trigger; they should be spaced.
func y() {} // These braces are fine; they are empty.
func z() {/* These braces should trigger; they should be spaced. */}

func þ() { // This brace should not trigger; it’s not empty.
    // ...
} // This brace should not trigger; it’s not empty.

/// ...
///
/// ```swift
/// func þ() { // This brace should not trigger; it’s not empty.
///     // ...
/// } // This brace should not trigger; it’s not empty.
/// ```
func a() {}
