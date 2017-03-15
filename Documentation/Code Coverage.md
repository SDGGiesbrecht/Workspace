<!--
 Code Coverage.md

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace

 Copyright ©2017 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 -->

# Code Coverage

Workspace can enforce code coverage.

This is controlled by the [configuration](Configuring%20Workspace.md) option `Enforce Code Coverage`. The default value is `True`.

## Exemptions

Some code paths should never occur or cannot be tested. These code paths can be exempted from code coverage requirements. There are two categories: [same‐line exemptions](#sameline-exemptions) and [previous‐line exemptions](#previousline-exemptions).

### Same‐Line Exemptions

Same‐line exemption tokens cause the exemption of any untested ranges that begin on the same line.

```swift
assert(x == y, "There is a problem: \(problem)")
// ↑↑↑
// The string interpolation cannot be covered by tests...
// ...but the “assert” token causes it to be exempt.

func untestableFunction() { // [_Exempt from Code Coverage_]
    // This is also exempt.
}
```

The built‐in same‐line tokens are:

- `assert`
- `precondition`
- `[_Exempt from Code Coverage_]`

The [configuration](Configuring%20Workspace.md) option `Code Coverage Exemption Tokens for the Same Line` can be used to add custom tokens. It is a list separated by line breaks.

### Previous‐Line Exemptions

Previous‐line exemption tokens cause the exemption of any untested ranges that begin on the previous line.

```swift
guard let x = y else { // ← The untested range starts at this brace...
    preconditionFailure("This should never happen.")
    // ↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑
    // ...but the “preconditionFailure” token causes it to be exempt.
}
```

The built‐in previous‐line tokens are:

- `assertionFailure`
- `preconditionFailure`
- `fatalError`

The [configuration](Configuring%20Workspace.md) option `Code Coverage Exemption Tokens for the Previous Line` can be used to add custom tokens. It is a list separated by line breaks.
