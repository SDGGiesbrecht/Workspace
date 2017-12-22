
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

Writing to “Documentation/🇬🇧EN Read Me.md”...

$ swift package resolve

Writing to “README.md”...
$ workspace refresh continuous‐integration

Refreshing continuous integration configuration...

Writing to “.travis.yml”...
$ workspace refresh resources

Refreshing resources...

$ workspace validate documentation‐coverage

$ swift package resolve


Generating documentation for “CustomReadMe”...


$ jazzy --module CustomReadMe --copyright "Copyright ©2017 the CustomReadMe project contributors. All rights reserved." --github_url "https://github.com/User/Repository" --documentation=Documentation/*.md --clean --use-safe-filenames --output "[...]/Documentation/CustomReadMe" --xcodebuild-arguments "-scheme,CustomReadMe-Package,-target,CustomReadMe,-sdk,macosx,-derivedDataPath,[...]/Jazzy Build Artifacts"
0% documentation coverage with 0 undocumented symbols
skipped 1 private, fileprivate, or internal symbol (use `--min-acl` to specify a different minimum ACL)
jam out ♪♫ to your fresh new docs in `[...]/Documentation/CustomReadMe`

Writing to “[...]/Documentation/CustomReadMe/.nojekyll”...

$ swift package resolve


Checking documentation coverage for “CustomReadMe”... (§1)


✓ Generated documentation for “CustomReadMe”.
✓ Documentation coverage is complete for “CustomReadMe”.


“CustomReadMe” passes validation.
