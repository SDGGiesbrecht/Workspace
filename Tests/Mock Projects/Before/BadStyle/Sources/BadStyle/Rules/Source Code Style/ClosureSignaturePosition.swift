private let good: (String) -> Void = { parameter in // Positioned correctly; should not trigger.
    print("Hello, world.")
}

private let bad: (String) -> Void = {
    parameter in // Wrong position; should trigger.

    print("Hello, world!")
}
