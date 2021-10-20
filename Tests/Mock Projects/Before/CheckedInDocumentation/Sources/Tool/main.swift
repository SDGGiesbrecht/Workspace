import EnableBuild

if CommandLine.arguments.contains("de\u{2D}DE") {
    print(Resources.deutsch)
} else {
    print(Resources.english)
}
