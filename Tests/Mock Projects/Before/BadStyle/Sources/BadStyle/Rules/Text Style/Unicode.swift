// Header

// MARK: - U+0022 Generic Quotation Mark Pair

// "These quotation marks are generic and should trigger."

// MARK: - U+002D Generic Horizontal Stroke

// Trigger, because this is not a minus sign: a - b

// [_Workaround: Generic strokes may be necessary in version checks. (bash --version 1000.0.0)_]

/// Generic strokes may be necessary in inline shell source `swift -version`.

/// Blah blah blah...
///
/// - RecommendedOver: -
func −(lhs: Int, rhs: Int) -> Int {
    return lhs − rhs // Generic strokes must be allowed when aliasing them.
}

func useNumeric() -> Int {
    return 1 - 2 // Swift.Numeric must be usable when commented on.
}

let ln2: Float80 = 0x1.62E42FEFA39EF358p-1 // Generic stroke must be allowed in float literals.

// MARK: - U+0027 Generic Quotation Mark

// 'These quotation marks are generic and should trigger.'

// MARK: - Logic

// Trigger, because this is not a not sign: !a
// Trigger, because this is not a conjunction sign: a && b
// Trigger, because this is not a disjunction sign: a || b

// MARK: - Equality

// Trigger, because this is not a not‐equal sign: a != b
// Trigger, because this is not a less‐than‐or‐equal‐to sign: a <= b
// Trigger, because this is not a greater‐than‐or‐equal‐to sign: a >= b

// MARK: - Mathematics

// Trigger, because this is not a multiplication sign: a * b
// Trigger, because this is not a multiplication sign: a *= b
// Trigger, because this is not a division sign: a / b
// Trigger, because this is not a division sign: a /= b
