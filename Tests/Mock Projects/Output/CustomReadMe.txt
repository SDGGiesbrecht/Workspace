
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
$ workspace refresh resources

Refreshing resources...

$ workspace validate documentation‐coverage

$ swift package resolve


Generating documentation for “CustomReadMe”...


$ jazzy --module CustomReadMe --copyright "Customized copyright string." --github_url "https://github.com/User/Repository" --documentation=Documentation/*.md --clean --use-safe-filenames --output "[...]/Tests/Mock Projects/Before/CustomReadMe/docs/CustomReadMe" --xcodebuild-arguments "-scheme,CustomReadMe-Package,-target,CustomReadMe,-sdk,macosx,-derivedDataPath,[...]/Jazzy Build Artifacts"
0% documentation coverage with 0 undocumented symbols
skipped 1 private, fileprivate, or internal symbol (use `--min-acl` to specify a different minimum ACL)
jam out ♪♫ to your fresh new docs in `docs/CustomReadMe`

Writing to “docs/CustomReadMe/.nojekyll”...
Writing to “docs/CustomReadMe/docsets/CustomReadMe.docset/Contents/Resources/Documents/en-read-me.html”...
Writing to “docs/CustomReadMe/docsets/CustomReadMe.docset/Contents/Resources/Documents/index.html”...
Writing to “docs/CustomReadMe/en-read-me.html”...
Writing to “docs/CustomReadMe/index.html”...

$ swift package resolve


Checking documentation coverage for “CustomReadMe”... (§1)


✓ Generated documentation for “CustomReadMe”.
✓ Documentation coverage is complete for “CustomReadMe”.


“CustomReadMe” passes validation.
