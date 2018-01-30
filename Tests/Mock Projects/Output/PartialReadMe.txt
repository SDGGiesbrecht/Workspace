
$ workspace refresh scripts

Refreshing scripts...


$ swift package resolve

Writing to “Refresh (macOS).command”...
Writing to “Refresh (Linux).sh”...

$ swift package resolve

Writing to “Validate (macOS).command”...
$ workspace refresh read‐me

Refreshing read‐me...


$ swift package resolve

Writing to “Documentation/🇨🇦EN Read Me.md”...

$ swift package resolve

Writing to “README.md”...

$ swift package resolve

Writing to “Documentation/🇬🇧EN Read Me.md”...

$ swift package resolve

Writing to “Documentation/🇺🇸EN Read Me.md”...

$ swift package resolve

Writing to “Documentation/🇩🇪DE Lies mich.md”...

$ swift package resolve

Writing to “Documentation/🇫🇷FR Lisez moi.md”...

$ swift package resolve

Writing to “Documentation/🇬🇷ΕΛ Με διαβάστε.md”...

$ swift package resolve

Writing to “Documentation/🇮🇱עב קרא אותי.md”...

$ swift package resolve

Writing to “Documentation/[zxx] Read Me.md”...
$ workspace refresh resources

Refreshing resources...

$ workspace proofread

Normalizing files...

Writing to “.Workspace Configuration.txt”...

Proofreading source code... (§1)

.Workspace Configuration.txt
.gitignore
Documentation/[zxx] Read Me.md
Documentation/🇨🇦EN Read Me.md
Documentation/🇩🇪DE Lies mich.md
Documentation/🇫🇷FR Lisez moi.md
Documentation/🇬🇧EN Read Me.md
Documentation/🇬🇷ΕΛ Με διαβάστε.md
Documentation/🇮🇱עב קרא אותי.md
Documentation/🇺🇸EN Read Me.md
Package.swift
README.md
Sources/PartialReadMe/PartialReadMe.swift
Tests/LinuxMain.swift
Tests/PartialReadMeTests/PartialReadMeTests.swift

$ swiftlint lint --strict --config [...]/SwiftLint/Configuration.yml --reporter emoji


$ swift package resolve


✓ Source code passes proofreading.


“PartialReadMe” passes validation.

$ workspace validate documentation‐coverage

Generating documentation for “PartialReadMe”...


$ jazzy --module PartialReadMe --copyright "Copyright ©2018 the PartialReadMe project contributors. All rights reserved." --github_url "https://somewhere.com" --documentation=Documentation/*.md --clean --use-safe-filenames --output "[...]/Documentation/PartialReadMe" --xcodebuild-arguments "-scheme,PartialReadMe-Package,-target,PartialReadMe,-sdk,macosx,-derivedDataPath,[...]/Jazzy Build Artifacts"
0% documentation coverage with 0 undocumented symbols
skipped 1 private, fileprivate, or internal symbol (use `--min-acl` to specify a different minimum ACL)
jam out ♪♫ to your fresh new docs in `[...]/Documentation/PartialReadMe`

Writing to “[...]/Documentation/PartialReadMe/.nojekyll”...

$ swift package resolve


Checking documentation coverage for “PartialReadMe”... (§1)


✓ Generated documentation for “PartialReadMe”.
✓ Documentation coverage is complete for “PartialReadMe”.


“PartialReadMe” passes validation.
