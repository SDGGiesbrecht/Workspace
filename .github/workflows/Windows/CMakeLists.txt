

cmake_minimum_required(VERSION 3.15)

project("Workspace" LANGUAGES Swift)

include(CTest)

set(CMAKE_Swift_MODULE_DIRECTORY ${CMAKE_BINARY_DIR}/swift)
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib)
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib)
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin)

option(BUILD_SHARED_LIBS "Use dynamic linking" YES)

add_library("SDGControlFlow"
  "../../../.build/SDG/Dependencies/SDGCornerstone/Sources/SDGControlFlow/APILocalization.swift"
  "../../../.build/SDG/Dependencies/SDGCornerstone/Sources/SDGControlFlow/Assert.swift"
  "../../../.build/SDG/Dependencies/SDGCornerstone/Sources/SDGControlFlow/AutoreleasePool.swift"
  "../../../.build/SDG/Dependencies/SDGCornerstone/Sources/SDGControlFlow/Caching.swift"
  "../../../.build/SDG/Dependencies/SDGCornerstone/Sources/SDGControlFlow/Decodable.swift"
  "../../../.build/SDG/Dependencies/SDGCornerstone/Sources/SDGControlFlow/DefaultAssignmentPropertyWrapper.swift"
  "../../../.build/SDG/Dependencies/SDGCornerstone/Sources/SDGControlFlow/Encodable.swift"
  "../../../.build/SDG/Dependencies/SDGCornerstone/Sources/SDGControlFlow/NonmutatingVariants.swift"
  "../../../.build/SDG/Dependencies/SDGCornerstone/Sources/SDGControlFlow/ProjectingPropertyWrapper.swift"
  "../../../.build/SDG/Dependencies/SDGCornerstone/Sources/SDGControlFlow/PropertyWrapper.swift"
  "../../../.build/SDG/Dependencies/SDGCornerstone/Sources/SDGControlFlow/Shared.swift"
  "../../../.build/SDG/Dependencies/SDGCornerstone/Sources/SDGControlFlow/SharedProperty.swift"
  "../../../.build/SDG/Dependencies/SDGCornerstone/Sources/SDGControlFlow/SharedValueObserver.swift"
  "../../../.build/SDG/Dependencies/SDGCornerstone/Sources/SDGControlFlow/TextualPlaygroundDisplay.swift"
  "../../../.build/SDG/Dependencies/SDGCornerstone/Sources/SDGControlFlow/TransparentWrapper.swift"
  "../../../.build/SDG/Dependencies/SDGCornerstone/Sources/SDGControlFlow/Weak.swift"
)
set_target_properties("SDGControlFlow" PROPERTIES INTERFACE_INCLUDE_DIRECTORIES ${CMAKE_Swift_MODULE_DIRECTORY})
target_compile_options("SDGControlFlow" PRIVATE -enable-testing)

add_library("SDGLogic"
  "../../../.build/SDG/Dependencies/SDGCornerstone/Sources/SDGLogic/Any.swift"
  "../../../.build/SDG/Dependencies/SDGCornerstone/Sources/SDGLogic/Bool.swift"
  "../../../.build/SDG/Dependencies/SDGCornerstone/Sources/SDGLogic/Equatable.swift"
  "../../../.build/SDG/Dependencies/SDGCornerstone/Sources/SDGLogic/NilLiteral.swift"
  "../../../.build/SDG/Dependencies/SDGCornerstone/Sources/SDGLogic/Operators.swift"
  "../../../.build/SDG/Dependencies/SDGCornerstone/Sources/SDGLogic/Tuple.swift"
)
set_target_properties("SDGLogic" PROPERTIES INTERFACE_INCLUDE_DIRECTORIES ${CMAKE_Swift_MODULE_DIRECTORY})
target_compile_options("SDGLogic" PRIVATE -enable-testing)

add_library("SDGMathematics"
  "../../../.build/SDG/Dependencies/SDGCornerstone/Sources/SDGMathematics/Angle.swift"
  "../../../.build/SDG/Dependencies/SDGCornerstone/Sources/SDGMathematics/BitField.swift"
  "../../../.build/SDG/Dependencies/SDGCornerstone/Sources/SDGMathematics/ClosedRange.swift"
  "../../../.build/SDG/Dependencies/SDGCornerstone/Sources/SDGMathematics/Comparable.swift"
  "../../../.build/SDG/Dependencies/SDGCornerstone/Sources/SDGMathematics/Data.swift"
  "../../../.build/SDG/Dependencies/SDGCornerstone/Sources/SDGMathematics/Float.swift"
  "../../../.build/SDG/Dependencies/SDGCornerstone/Sources/SDGMathematics/FunctionAnalysis.swift"
  "../../../.build/SDG/Dependencies/SDGCornerstone/Sources/SDGMathematics/Int.swift"
  "../../../.build/SDG/Dependencies/SDGCornerstone/Sources/SDGMathematics/Measurement.swift"
  "../../../.build/SDG/Dependencies/SDGCornerstone/Sources/SDGMathematics/Numeric Protocols/Addable.swift"
  "../../../.build/SDG/Dependencies/SDGCornerstone/Sources/SDGMathematics/Numeric Protocols/FixedScaleOneDimensionalPoint.swift"
  "../../../.build/SDG/Dependencies/SDGCornerstone/Sources/SDGMathematics/Numeric Protocols/GenericAdditiveArithmetic.swift"
  "../../../.build/SDG/Dependencies/SDGCornerstone/Sources/SDGMathematics/Numeric Protocols/IntegerProtocol.swift"
  "../../../.build/SDG/Dependencies/SDGCornerstone/Sources/SDGMathematics/Numeric Protocols/IntegralArithmetic.swift"
  "../../../.build/SDG/Dependencies/SDGCornerstone/Sources/SDGMathematics/Numeric Protocols/Negatable.swift"
  "../../../.build/SDG/Dependencies/SDGCornerstone/Sources/SDGMathematics/Numeric Protocols/NumericAdditiveArithmetic.swift"
  "../../../.build/SDG/Dependencies/SDGCornerstone/Sources/SDGMathematics/Numeric Protocols/OneDimensionalPoint.swift"
  "../../../.build/SDG/Dependencies/SDGCornerstone/Sources/SDGMathematics/Numeric Protocols/OneDimensionalVector.swift"
  "../../../.build/SDG/Dependencies/SDGCornerstone/Sources/SDGMathematics/Numeric Protocols/PointProtocol.swift"
  "../../../.build/SDG/Dependencies/SDGCornerstone/Sources/SDGMathematics/Numeric Protocols/RationalArithmetic.swift"
  "../../../.build/SDG/Dependencies/SDGCornerstone/Sources/SDGMathematics/Numeric Protocols/RationalNumberProtocol.swift"
  "../../../.build/SDG/Dependencies/SDGCornerstone/Sources/SDGMathematics/Numeric Protocols/RationalVector.swift"
  "../../../.build/SDG/Dependencies/SDGCornerstone/Sources/SDGMathematics/Numeric Protocols/RealArithmetic.swift"
  "../../../.build/SDG/Dependencies/SDGCornerstone/Sources/SDGMathematics/Numeric Protocols/RealNumberProtocol.swift"
  "../../../.build/SDG/Dependencies/SDGCornerstone/Sources/SDGMathematics/Numeric Protocols/Subtractable.swift"
  "../../../.build/SDG/Dependencies/SDGCornerstone/Sources/SDGMathematics/Numeric Protocols/VectorProtocol.swift"
  "../../../.build/SDG/Dependencies/SDGCornerstone/Sources/SDGMathematics/Numeric Protocols/WholeArithmetic.swift"
  "../../../.build/SDG/Dependencies/SDGCornerstone/Sources/SDGMathematics/Numeric Protocols/WholeNumberProtocol.swift"
  "../../../.build/SDG/Dependencies/SDGCornerstone/Sources/SDGMathematics/Operators.swift"
  "../../../.build/SDG/Dependencies/SDGCornerstone/Sources/SDGMathematics/OrderedEnumeration.swift"
  "../../../.build/SDG/Dependencies/SDGCornerstone/Sources/SDGMathematics/Sequence.swift"
  "../../../.build/SDG/Dependencies/SDGCornerstone/Sources/SDGMathematics/Tuple.swift"
  "../../../.build/SDG/Dependencies/SDGCornerstone/Sources/SDGMathematics/UInt.swift"
)
set_target_properties("SDGMathematics" PROPERTIES INTERFACE_INCLUDE_DIRECTORIES ${CMAKE_Swift_MODULE_DIRECTORY})
target_compile_options("SDGMathematics" PRIVATE -enable-testing)
target_link_libraries("SDGMathematics" PRIVATE
  "SDGControlFlow"
  "SDGLogic"
)

add_library("SDGCollections"
  "../../../.build/SDG/Dependencies/SDGCornerstone/Sources/SDGCollections/Addable.swift"
  "../../../.build/SDG/Dependencies/SDGCornerstone/Sources/SDGCollections/Associative/BijectiveMapping.swift"
  "../../../.build/SDG/Dependencies/SDGCornerstone/Sources/SDGCollections/Associative/ContextualMapping.swift"
  "../../../.build/SDG/Dependencies/SDGCornerstone/Sources/SDGCollections/Associative/Dictionary.swift"
  "../../../.build/SDG/Dependencies/SDGCornerstone/Sources/SDGCollections/Conformances/CharacterSet.swift"
  "../../../.build/SDG/Dependencies/SDGCornerstone/Sources/SDGCollections/Conformances/Data.swift"
  "../../../.build/SDG/Dependencies/SDGCornerstone/Sources/SDGCollections/Conformances/String.swift"
  "../../../.build/SDG/Dependencies/SDGCornerstone/Sources/SDGCollections/LegacyMode.swift"
  "../../../.build/SDG/Dependencies/SDGCornerstone/Sources/SDGCollections/Operators.swift"
  "../../../.build/SDG/Dependencies/SDGCornerstone/Sources/SDGCollections/Ordered/AnyCollection.swift"
  "../../../.build/SDG/Dependencies/SDGCornerstone/Sources/SDGCollections/Ordered/Array.swift"
  "../../../.build/SDG/Dependencies/SDGCornerstone/Sources/SDGCollections/Ordered/BidirectionalCollection.swift"
  "../../../.build/SDG/Dependencies/SDGCornerstone/Sources/SDGCollections/Ordered/Collection.swift"
  "../../../.build/SDG/Dependencies/SDGCornerstone/Sources/SDGCollections/Ordered/CollectionDifference.swift"
  "../../../.build/SDG/Dependencies/SDGCornerstone/Sources/SDGCollections/Ordered/CollectionDifferenceChange.swift"
  "../../../.build/SDG/Dependencies/SDGCornerstone/Sources/SDGCollections/Ordered/FillDirection.swift"
  "../../../.build/SDG/Dependencies/SDGCornerstone/Sources/SDGCollections/Ordered/Patterns/AlternativePatterns.swift"
  "../../../.build/SDG/Dependencies/SDGCornerstone/Sources/SDGCollections/Ordered/Patterns/AnyPattern.swift"
  "../../../.build/SDG/Dependencies/SDGCornerstone/Sources/SDGCollections/Ordered/Patterns/ConcatenatedPatterns.swift"
  "../../../.build/SDG/Dependencies/SDGCornerstone/Sources/SDGCollections/Ordered/Patterns/ConditionalPattern.swift"
  "../../../.build/SDG/Dependencies/SDGCornerstone/Sources/SDGCollections/Ordered/Patterns/NaryAlternativePatterns.swift"
  "../../../.build/SDG/Dependencies/SDGCornerstone/Sources/SDGCollections/Ordered/Patterns/NaryConcatenatedPatterns.swift"
  "../../../.build/SDG/Dependencies/SDGCornerstone/Sources/SDGCollections/Ordered/Patterns/NegatedPattern.swift"
  "../../../.build/SDG/Dependencies/SDGCornerstone/Sources/SDGCollections/Ordered/Patterns/NestingLevel.swift"
  "../../../.build/SDG/Dependencies/SDGCornerstone/Sources/SDGCollections/Ordered/Patterns/Pattern.swift"
  "../../../.build/SDG/Dependencies/SDGCornerstone/Sources/SDGCollections/Ordered/Patterns/PatternConsumption.swift"
  "../../../.build/SDG/Dependencies/SDGCornerstone/Sources/SDGCollections/Ordered/Patterns/PatternMatch.swift"
  "../../../.build/SDG/Dependencies/SDGCornerstone/Sources/SDGCollections/Ordered/Patterns/RepetitionPattern.swift"
  "../../../.build/SDG/Dependencies/SDGCornerstone/Sources/SDGCollections/Ordered/Range.swift"
  "../../../.build/SDG/Dependencies/SDGCornerstone/Sources/SDGCollections/Ordered/RangeExpression.swift"
  "../../../.build/SDG/Dependencies/SDGCornerstone/Sources/SDGCollections/Ordered/RangeReplaceableCollection.swift"
  "../../../.build/SDG/Dependencies/SDGCornerstone/Sources/SDGCollections/Ordered/ReversedCollection.swift"
  "../../../.build/SDG/Dependencies/SDGCornerstone/Sources/SDGCollections/Ordered/SearchableBidirectionalCollection.swift"
  "../../../.build/SDG/Dependencies/SDGCornerstone/Sources/SDGCollections/Ordered/SearchableCollection.swift"
  "../../../.build/SDG/Dependencies/SDGCornerstone/Sources/SDGCollections/Ordered/Slice.swift"
  "../../../.build/SDG/Dependencies/SDGCornerstone/Sources/SDGCollections/Unordered/AbsoluteComplement.swift"
  "../../../.build/SDG/Dependencies/SDGCornerstone/Sources/SDGCollections/Unordered/ComparableSet.swift"
  "../../../.build/SDG/Dependencies/SDGCornerstone/Sources/SDGCollections/Unordered/FiniteSet.swift"
  "../../../.build/SDG/Dependencies/SDGCornerstone/Sources/SDGCollections/Unordered/IntensionalSet.swift"
  "../../../.build/SDG/Dependencies/SDGCornerstone/Sources/SDGCollections/Unordered/Intersection.swift"
  "../../../.build/SDG/Dependencies/SDGCornerstone/Sources/SDGCollections/Unordered/MutableSet.swift"
  "../../../.build/SDG/Dependencies/SDGCornerstone/Sources/SDGCollections/Unordered/Set.swift"
  "../../../.build/SDG/Dependencies/SDGCornerstone/Sources/SDGCollections/Unordered/SetDefinition.swift"
  "../../../.build/SDG/Dependencies/SDGCornerstone/Sources/SDGCollections/Unordered/SetInRepresentableUniverse.swift"
  "../../../.build/SDG/Dependencies/SDGCornerstone/Sources/SDGCollections/Unordered/Union.swift"
)
set_target_properties("SDGCollections" PROPERTIES INTERFACE_INCLUDE_DIRECTORIES ${CMAKE_Swift_MODULE_DIRECTORY})
target_compile_options("SDGCollections" PRIVATE -enable-testing)
target_link_libraries("SDGCollections" PRIVATE
  "SDGControlFlow"
  "SDGLogic"
  "SDGMathematics"
)

add_library("SDGText"
  "../../../.build/SDG/Dependencies/SDGCornerstone/Sources/SDGText/Array.swift"
  "../../../.build/SDG/Dependencies/SDGCornerstone/Sources/SDGText/CharacterSet.swift"
  "../../../.build/SDG/Dependencies/SDGCornerstone/Sources/SDGText/Collection.swift"
  "../../../.build/SDG/Dependencies/SDGCornerstone/Sources/SDGText/Compatibility/StaticString.swift"
  "../../../.build/SDG/Dependencies/SDGCornerstone/Sources/SDGText/Compatibility/String.swift"
  "../../../.build/SDG/Dependencies/SDGCornerstone/Sources/SDGText/Compatibility/StringClusterView.swift"
  "../../../.build/SDG/Dependencies/SDGCornerstone/Sources/SDGText/Compatibility/StringScalarView.swift"
  "../../../.build/SDG/Dependencies/SDGCornerstone/Sources/SDGText/ExtendedGraphemeCluster.swift"
  "../../../.build/SDG/Dependencies/SDGCornerstone/Sources/SDGText/Font.swift"
  "../../../.build/SDG/Dependencies/SDGCornerstone/Sources/SDGText/MarkupPlaygroundDisplay.swift"
  "../../../.build/SDG/Dependencies/SDGCornerstone/Sources/SDGText/Range.swift"
  "../../../.build/SDG/Dependencies/SDGCornerstone/Sources/SDGText/SemanticMarkup.swift"
  "../../../.build/SDG/Dependencies/SDGCornerstone/Sources/SDGText/SemanticMarkupStringInterpolation.swift"
  "../../../.build/SDG/Dependencies/SDGCornerstone/Sources/SDGText/Strict/StrictString.swift"
  "../../../.build/SDG/Dependencies/SDGCornerstone/Sources/SDGText/Strict/StrictStringClusterView.swift"
  "../../../.build/SDG/Dependencies/SDGCornerstone/Sources/SDGText/Strict/StrictStringInterpolationProtocol.swift"
  "../../../.build/SDG/Dependencies/SDGCornerstone/Sources/SDGText/Strict/StrictStringStringInterpolation.swift"
  "../../../.build/SDG/Dependencies/SDGCornerstone/Sources/SDGText/String Family/ExtendedGraphemeClusterView.swift"
  "../../../.build/SDG/Dependencies/SDGCornerstone/Sources/SDGText/String Family/Line.swift"
  "../../../.build/SDG/Dependencies/SDGCornerstone/Sources/SDGText/String Family/LineView.swift"
  "../../../.build/SDG/Dependencies/SDGCornerstone/Sources/SDGText/String Family/LineViewIndex.swift"
  "../../../.build/SDG/Dependencies/SDGCornerstone/Sources/SDGText/String Family/NewlinePattern.swift"
  "../../../.build/SDG/Dependencies/SDGCornerstone/Sources/SDGText/String Family/StringFamily.swift"
  "../../../.build/SDG/Dependencies/SDGCornerstone/Sources/SDGText/String Family/StringIndex.swift"
  "../../../.build/SDG/Dependencies/SDGCornerstone/Sources/SDGText/String Family/UnicodeScalarView.swift"
  "../../../.build/SDG/Dependencies/SDGCornerstone/Sources/SDGText/UnicodeScalar.swift"
)
set_target_properties("SDGText" PROPERTIES INTERFACE_INCLUDE_DIRECTORIES ${CMAKE_Swift_MODULE_DIRECTORY})
target_compile_options("SDGText" PRIVATE -enable-testing)
target_link_libraries("SDGText" PRIVATE
  "SDGControlFlow"
  "SDGLogic"
  "SDGMathematics"
  "SDGCollections"
)

add_library("SDGPersistence"
  "../../../.build/SDG/Dependencies/SDGCornerstone/Sources/SDGPersistence/Data.swift"
  "../../../.build/SDG/Dependencies/SDGCornerstone/Sources/SDGPersistence/FileConvertible.swift"
  "../../../.build/SDG/Dependencies/SDGCornerstone/Sources/SDGPersistence/FileManager.swift"
  "../../../.build/SDG/Dependencies/SDGCornerstone/Sources/SDGPersistence/Preference.swift"
  "../../../.build/SDG/Dependencies/SDGCornerstone/Sources/SDGPersistence/PreferenceSet.swift"
  "../../../.build/SDG/Dependencies/SDGCornerstone/Sources/SDGPersistence/ProcessInfo.swift"
  "../../../.build/SDG/Dependencies/SDGCornerstone/Sources/SDGPersistence/StrictString.swift"
  "../../../.build/SDG/Dependencies/SDGCornerstone/Sources/SDGPersistence/String.swift"
  "../../../.build/SDG/Dependencies/SDGCornerstone/Sources/SDGPersistence/URL.swift"
)
set_target_properties("SDGPersistence" PROPERTIES INTERFACE_INCLUDE_DIRECTORIES ${CMAKE_Swift_MODULE_DIRECTORY})
target_compile_options("SDGPersistence" PRIVATE -enable-testing)
target_link_libraries("SDGPersistence" PRIVATE
  "SDGControlFlow"
  "SDGLogic"
  "SDGMathematics"
  "SDGCollections"
  "SDGText"
)

add_library("WSAndroidTests"
  "../../../Tests/WSAndroidTests/WSAndroidTests.swift"
)
set_target_properties("WSAndroidTests" PROPERTIES INTERFACE_INCLUDE_DIRECTORIES ${CMAKE_Swift_MODULE_DIRECTORY})
target_compile_options("WSAndroidTests" PRIVATE -enable-testing)
target_link_libraries("WSAndroidTests" PRIVATE
  "SDGPersistence"
)

add_library("SwiftFormatConfiguration"
  "../../../.build/SDG/Dependencies/swift-format/Sources/SwiftFormatConfiguration/Configuration.swift"
  "../../../.build/SDG/Dependencies/swift-format/Sources/SwiftFormatConfiguration/Indent.swift"
  "../../../.build/SDG/Dependencies/swift-format/Sources/SwiftFormatConfiguration/RuleRegistry+Generated.swift"
)
set_target_properties("SwiftFormatConfiguration" PROPERTIES INTERFACE_INCLUDE_DIRECTORIES ${CMAKE_Swift_MODULE_DIRECTORY})
target_compile_options("SwiftFormatConfiguration" PRIVATE -enable-testing)

add_library("WSWindowsLibrary"
  "../../../Tests/WSWindowsLibrary/WSWindowsLibrary.swift"
)
set_target_properties("WSWindowsLibrary" PROPERTIES INTERFACE_INCLUDE_DIRECTORIES ${CMAKE_Swift_MODULE_DIRECTORY})
target_compile_options("WSWindowsLibrary" PRIVATE -enable-testing)
target_link_libraries("WSWindowsLibrary" PRIVATE
  "SwiftFormatConfiguration"
)

add_library("WSWindowsTests"
  "../../../Tests/WSWindowsTests/WSWindowsTests.swift"
)
set_target_properties("WSWindowsTests" PROPERTIES INTERFACE_INCLUDE_DIRECTORIES ${CMAKE_Swift_MODULE_DIRECTORY})
target_compile_options("WSWindowsTests" PRIVATE -enable-testing)
target_link_libraries("WSWindowsTests" PRIVATE
  "WSWindowsLibrary"
)

add_executable("WSWindowsTool"
  "../../../Tests/WSWindowsTool/main.swift"
)
target_link_libraries("WSWindowsTool" PRIVATE
  "WSWindowsLibrary"
)

add_executable("WSWindows_Unicode"
  "../../../Tests/WSWindowsUnicode/main.swift"
)
target_link_libraries("WSWindows_Unicode" PRIVATE
  "WSWindowsLibrary"
)

add_executable(WindowsMain
  WindowsMain.swift
)
target_link_libraries(WindowsMain PRIVATE
  "WSAndroidTests"
  "WSWindowsTests"
)
add_test(NAME WindowsMain COMMAND WindowsMain)
set_property(TEST WindowsMain PROPERTY ENVIRONMENT "LD_LIBRARY_PATH=${CMAKE_LIBRARY_OUTPUT_DIRECTORY}")
