
import SDGLogic
import WSGeneralImports
import WSProject

extension PackageRepository {

    public func refreshScripts(output: Command.Output) throws {

        for deprecated in Script.deprecatedFileNames {
            delete(location.appendingPathComponent(String(deprecated)), output: output)
        }

        for script in Script.cases where script.isRelevantOnCurrentDevice ∨ script.isCheckedIn {
            try autoreleasepool {

                var file = try TextFile(possiblyAt: location.appendingPathComponent(String(script.fileName)), executable: true)
                file.contents.replaceSubrange(file.contents.startIndex ..< file.headerStart, with: String(script.shebang()))
                file.body = String(try script.source(for: self, output: output))
                try file.writeChanges(for: self, output: output)
            }
        }
    }
}
