
import SDGLogic
import SDGCollections
import WSGeneralImports

extension URL {

    public func isIgnored(by project: PackageRepository, output: Command.Output) throws -> Bool {
        let ignoredTypes = try project.configuration(output: output).repository.ignoredFileTypes
        return pathExtension ∈ ignoredTypes ∨ lastPathComponent ∈ ignoredTypes
    }
}
