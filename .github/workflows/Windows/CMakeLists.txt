

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
  "../../../.build/SDG/Dependencies/SDGCornerstone/Sources/SDGText/CharacterSet.swift"
  "../../../.build/SDG/Dependencies/SDGCornerstone/Sources/SDGText/CollectionStringFamily.swift"
  "../../../.build/SDG/Dependencies/SDGCornerstone/Sources/SDGText/CollectionUnicodeScalar.swift"
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

add_library("SDGLocalization"
  "../../../.build/SDG/Dependencies/SDGCornerstone/Sources/SDGLocalization/CachedLocalization.swift"
  "../../../.build/SDG/Dependencies/SDGCornerstone/Sources/SDGLocalization/Extensions/Bool.swift"
  "../../../.build/SDG/Dependencies/SDGCornerstone/Sources/SDGLocalization/Extensions/Decodable.swift"
  "../../../.build/SDG/Dependencies/SDGCornerstone/Sources/SDGLocalization/Extensions/LosslessStringConvertible.swift"
  "../../../.build/SDG/Dependencies/SDGCornerstone/Sources/SDGLocalization/Extensions/Numbers/Angle.swift"
  "../../../.build/SDG/Dependencies/SDGCornerstone/Sources/SDGLocalization/Extensions/Numbers/Float.swift"
  "../../../.build/SDG/Dependencies/SDGCornerstone/Sources/SDGLocalization/Extensions/Numbers/Int.swift"
  "../../../.build/SDG/Dependencies/SDGCornerstone/Sources/SDGLocalization/Extensions/Numbers/IntegerProtcool.swift"
  "../../../.build/SDG/Dependencies/SDGCornerstone/Sources/SDGLocalization/Extensions/Numbers/IntegralArithmetic.swift"
  "../../../.build/SDG/Dependencies/SDGCornerstone/Sources/SDGLocalization/Extensions/Numbers/RationalArithmetic.swift"
  "../../../.build/SDG/Dependencies/SDGCornerstone/Sources/SDGLocalization/Extensions/Numbers/RationalNumberProtocol.swift"
  "../../../.build/SDG/Dependencies/SDGCornerstone/Sources/SDGLocalization/Extensions/Numbers/UInt.swift"
  "../../../.build/SDG/Dependencies/SDGCornerstone/Sources/SDGLocalization/Extensions/Numbers/WholeArithmetic.swift"
  "../../../.build/SDG/Dependencies/SDGCornerstone/Sources/SDGLocalization/Extensions/Numbers/WholeNumberProtocol.swift"
  "../../../.build/SDG/Dependencies/SDGCornerstone/Sources/SDGLocalization/Extensions/Precondition.swift"
  "../../../.build/SDG/Dependencies/SDGCornerstone/Sources/SDGLocalization/Extensions/PresentableError.swift"
  "../../../.build/SDG/Dependencies/SDGCornerstone/Sources/SDGLocalization/Extensions/Range.swift"
  "../../../.build/SDG/Dependencies/SDGCornerstone/Sources/SDGLocalization/Extensions/TextConvertibleNumber.swift"
  "../../../.build/SDG/Dependencies/SDGCornerstone/Sources/SDGLocalization/Extensions/TextConvertibleNumberParseError.swift"
  "../../../.build/SDG/Dependencies/SDGCornerstone/Sources/SDGLocalization/InputLocalization.swift"
  "../../../.build/SDG/Dependencies/SDGCornerstone/Sources/SDGLocalization/Interpolation/Casing.swift"
  "../../../.build/SDG/Dependencies/SDGCornerstone/Sources/SDGLocalization/Interpolation/EnglishCasing.swift"
  "../../../.build/SDG/Dependencies/SDGCornerstone/Sources/SDGLocalization/Interpolation/GenreGrammatical.swift"
  "../../../.build/SDG/Dependencies/SDGCornerstone/Sources/SDGLocalization/Interpolation/GrammaticalGender.swift"
  "../../../.build/SDG/Dependencies/SDGCornerstone/Sources/SDGLocalization/Interpolation/GrammaticalNumber.swift"
  "../../../.build/SDG/Dependencies/SDGCornerstone/Sources/SDGLocalization/Interpolation/GrammatikiPtosi.swift"
  "../../../.build/SDG/Dependencies/SDGCornerstone/Sources/SDGLocalization/Localization.swift"
  "../../../.build/SDG/Dependencies/SDGCornerstone/Sources/SDGLocalization/LocalizationSetting.swift"
  "../../../.build/SDG/Dependencies/SDGCornerstone/Sources/SDGLocalization/LocalizationSettingStabilizationMode.swift"
  "../../../.build/SDG/Dependencies/SDGCornerstone/Sources/SDGLocalization/Localizations/APILocalization.swift"
  "../../../.build/SDG/Dependencies/SDGCornerstone/Sources/SDGLocalization/Localizations/AnyLocalization.swift"
  "../../../.build/SDG/Dependencies/SDGCornerstone/Sources/SDGLocalization/Localizations/ContentLocalization.swift"
  "../../../.build/SDG/Dependencies/SDGCornerstone/Sources/SDGLocalization/Localizations/FormatLocalization.swift"
  "../../../.build/SDG/Dependencies/SDGCornerstone/Sources/SDGLocalization/Localizations/InterfaceLocalization.swift"
  "../../../.build/SDG/Dependencies/SDGCornerstone/Sources/SDGLocalization/Metadata/Language.swift"
  "../../../.build/SDG/Dependencies/SDGCornerstone/Sources/SDGLocalization/Metadata/LocalizationData.swift"
  "../../../.build/SDG/Dependencies/SDGCornerstone/Sources/SDGLocalization/Metadata/Script.swift"
  "../../../.build/SDG/Dependencies/SDGCornerstone/Sources/SDGLocalization/Metadata/State.swift"
  "../../../.build/SDG/Dependencies/SDGCornerstone/Sources/SDGLocalization/Metadata/StateData.swift"
  "../../../.build/SDG/Dependencies/SDGCornerstone/Sources/SDGLocalization/Metadata/TextDirection.swift"
  "../../../.build/SDG/Dependencies/SDGCornerstone/Sources/SDGLocalization/UserFacing.swift"
  "../../../.build/SDG/Dependencies/SDGCornerstone/Sources/SDGLocalization/UserFacingDynamic.swift"
)
set_target_properties("SDGLocalization" PROPERTIES INTERFACE_INCLUDE_DIRECTORIES ${CMAKE_Swift_MODULE_DIRECTORY})
target_compile_options("SDGLocalization" PRIVATE -enable-testing)
target_link_libraries("SDGLocalization" PRIVATE
  "SDGControlFlow"
  "SDGLogic"
  "SDGMathematics"
  "SDGCollections"
  "SDGText"
  "SDGPersistence"
)

add_library("SDGCommandLineLocalizations"
  "../../../.build/SDG/Dependencies/SDGCommandLine/Sources/SDGCommandLineLocalizations/APILocalization.swift"
  "../../../.build/SDG/Dependencies/SDGCommandLine/Sources/SDGCommandLineLocalizations/Exports.swift"
  "../../../.build/SDG/Dependencies/SDGCommandLine/Sources/SDGCommandLineLocalizations/InterfaceLocalization.swift"
  "../../../.build/SDG/Dependencies/SDGCommandLine/Sources/SDGCommandLineLocalizations/SystemLocalization.swift"
)
set_target_properties("SDGCommandLineLocalizations" PROPERTIES INTERFACE_INCLUDE_DIRECTORIES ${CMAKE_Swift_MODULE_DIRECTORY})
target_compile_options("SDGCommandLineLocalizations" PRIVATE -enable-testing)
target_link_libraries("SDGCommandLineLocalizations" PRIVATE
  "SDGLocalization"
)

add_library("SDGCornerstoneLocalizations"
  "../../../.build/SDG/Dependencies/SDGCornerstone/Sources/SDGCornerstoneLocalizations/APILocalization.swift"
  "../../../.build/SDG/Dependencies/SDGCornerstone/Sources/SDGCornerstoneLocalizations/FormatLocalization.swift"
  "../../../.build/SDG/Dependencies/SDGCornerstone/Sources/SDGCornerstoneLocalizations/InterfaceLocalization.swift"
)
set_target_properties("SDGCornerstoneLocalizations" PROPERTIES INTERFACE_INCLUDE_DIRECTORIES ${CMAKE_Swift_MODULE_DIRECTORY})
target_compile_options("SDGCornerstoneLocalizations" PRIVATE -enable-testing)
target_link_libraries("SDGCornerstoneLocalizations" PRIVATE
  "SDGControlFlow"
  "SDGLocalization"
)

add_library("SDGCalendar"
  "../../../.build/SDG/Dependencies/SDGCornerstone/Sources/SDGCalendar/Abstract Components/CalendarComponent.swift"
  "../../../.build/SDG/Dependencies/SDGCornerstone/Sources/SDGCalendar/Abstract Components/CardinalCalendarComponent.swift"
  "../../../.build/SDG/Dependencies/SDGCornerstone/Sources/SDGCalendar/Abstract Components/ConsistentDurationCalendarComponent.swift"
  "../../../.build/SDG/Dependencies/SDGCornerstone/Sources/SDGCalendar/Abstract Components/ConsistentlyOrderedCalendarComponent.swift"
  "../../../.build/SDG/Dependencies/SDGCornerstone/Sources/SDGCalendar/Abstract Components/Day.swift"
  "../../../.build/SDG/Dependencies/SDGCornerstone/Sources/SDGCalendar/Abstract Components/EnumerationCalendarComponent.swift"
  "../../../.build/SDG/Dependencies/SDGCornerstone/Sources/SDGCalendar/Abstract Components/ICalendarComponent.swift"
  "../../../.build/SDG/Dependencies/SDGCornerstone/Sources/SDGCalendar/Abstract Components/ISOCalendarComponent.swift"
  "../../../.build/SDG/Dependencies/SDGCornerstone/Sources/SDGCalendar/Abstract Components/Month.swift"
  "../../../.build/SDG/Dependencies/SDGCornerstone/Sources/SDGCalendar/Abstract Components/NumericCalendarComponent.swift"
  "../../../.build/SDG/Dependencies/SDGCornerstone/Sources/SDGCalendar/Abstract Components/OrdinalCalendarComponent.swift"
  "../../../.build/SDG/Dependencies/SDGCornerstone/Sources/SDGCalendar/Abstract Components/RawRepresentableCalendarComponent.swift"
  "../../../.build/SDG/Dependencies/SDGCornerstone/Sources/SDGCalendar/Abstract Components/SmallestCalendarComponent.swift"
  "../../../.build/SDG/Dependencies/SDGCornerstone/Sources/SDGCalendar/Abstract Components/Weekday.swift"
  "../../../.build/SDG/Dependencies/SDGCornerstone/Sources/SDGCalendar/Abstract Components/Year.swift"
  "../../../.build/SDG/Dependencies/SDGCornerstone/Sources/SDGCalendar/AnyDescribableDate.swift"
  "../../../.build/SDG/Dependencies/SDGCornerstone/Sources/SDGCalendar/CalendarDate.swift"
  "../../../.build/SDG/Dependencies/SDGCornerstone/Sources/SDGCalendar/CalendarInterval.swift"
  "../../../.build/SDG/Dependencies/SDGCornerstone/Sources/SDGCalendar/Date.swift"
  "../../../.build/SDG/Dependencies/SDGCornerstone/Sources/SDGCalendar/DateDefinition.swift"
  "../../../.build/SDG/Dependencies/SDGCornerstone/Sources/SDGCalendar/DescribableDate.swift"
  "../../../.build/SDG/Dependencies/SDGCornerstone/Sources/SDGCalendar/FoundationDate.swift"
  "../../../.build/SDG/Dependencies/SDGCornerstone/Sources/SDGCalendar/Gregorian/GregorianDate.swift"
  "../../../.build/SDG/Dependencies/SDGCornerstone/Sources/SDGCalendar/Gregorian/GregorianDay.swift"
  "../../../.build/SDG/Dependencies/SDGCornerstone/Sources/SDGCalendar/Gregorian/GregorianHour.swift"
  "../../../.build/SDG/Dependencies/SDGCornerstone/Sources/SDGCalendar/Gregorian/GregorianMinute.swift"
  "../../../.build/SDG/Dependencies/SDGCornerstone/Sources/SDGCalendar/Gregorian/GregorianMonth.swift"
  "../../../.build/SDG/Dependencies/SDGCornerstone/Sources/SDGCalendar/Gregorian/GregorianSecond.swift"
  "../../../.build/SDG/Dependencies/SDGCornerstone/Sources/SDGCalendar/Gregorian/GregorianWeekday.swift"
  "../../../.build/SDG/Dependencies/SDGCornerstone/Sources/SDGCalendar/Gregorian/GregorianWeekdayDate.swift"
  "../../../.build/SDG/Dependencies/SDGCornerstone/Sources/SDGCalendar/Gregorian/GregorianYear.swift"
  "../../../.build/SDG/Dependencies/SDGCornerstone/Sources/SDGCalendar/Hebrew/HebrewDate.swift"
  "../../../.build/SDG/Dependencies/SDGCornerstone/Sources/SDGCalendar/Hebrew/HebrewDay.swift"
  "../../../.build/SDG/Dependencies/SDGCornerstone/Sources/SDGCalendar/Hebrew/HebrewHour.swift"
  "../../../.build/SDG/Dependencies/SDGCornerstone/Sources/SDGCalendar/Hebrew/HebrewMonth.swift"
  "../../../.build/SDG/Dependencies/SDGCornerstone/Sources/SDGCalendar/Hebrew/HebrewMonthAndYear.swift"
  "../../../.build/SDG/Dependencies/SDGCornerstone/Sources/SDGCalendar/Hebrew/HebrewPart.swift"
  "../../../.build/SDG/Dependencies/SDGCornerstone/Sources/SDGCalendar/Hebrew/HebrewWeekday.swift"
  "../../../.build/SDG/Dependencies/SDGCornerstone/Sources/SDGCalendar/Hebrew/HebrewWeekdayDate.swift"
  "../../../.build/SDG/Dependencies/SDGCornerstone/Sources/SDGCalendar/Hebrew/HebrewYear.swift"
  "../../../.build/SDG/Dependencies/SDGCornerstone/Sources/SDGCalendar/Hebrew/HebrewYearLength.swift"
  "../../../.build/SDG/Dependencies/SDGCornerstone/Sources/SDGCalendar/RationalArithmetic.swift"
  "../../../.build/SDG/Dependencies/SDGCornerstone/Sources/SDGCalendar/RelativeDate.swift"
  "../../../.build/SDG/Dependencies/SDGCornerstone/Sources/SDGCalendar/UnknownDate.swift"
)
set_target_properties("SDGCalendar" PROPERTIES INTERFACE_INCLUDE_DIRECTORIES ${CMAKE_Swift_MODULE_DIRECTORY})
target_compile_options("SDGCalendar" PRIVATE -enable-testing)
target_link_libraries("SDGCalendar" PRIVATE
  "SDGControlFlow"
  "SDGLogic"
  "SDGMathematics"
  "SDGCollections"
  "SDGText"
  "SDGLocalization"
  "SDGCornerstoneLocalizations"
)

add_library("SDGExternalProcess"
  "../../../.build/SDG/Dependencies/SDGCornerstone/Sources/SDGExternalProcess/ExternalProcess.swift"
  "../../../.build/SDG/Dependencies/SDGCornerstone/Sources/SDGExternalProcess/ExternalProcessError.swift"
  "../../../.build/SDG/Dependencies/SDGCornerstone/Sources/SDGExternalProcess/LegacyMode.swift"
  "../../../.build/SDG/Dependencies/SDGCornerstone/Sources/SDGExternalProcess/Shell.swift"
)
set_target_properties("SDGExternalProcess" PROPERTIES INTERFACE_INCLUDE_DIRECTORIES ${CMAKE_Swift_MODULE_DIRECTORY})
target_compile_options("SDGExternalProcess" PRIVATE -enable-testing)
target_link_libraries("SDGExternalProcess" PRIVATE
  "SDGControlFlow"
  "SDGLogic"
  "SDGText"
  "SDGPersistence"
  "SDGLocalization"
)

add_library("SDGTesting"
  "../../../.build/SDG/Dependencies/SDGCornerstone/Sources/SDGTesting/PerformanceTest.swift"
  "../../../.build/SDG/Dependencies/SDGCornerstone/Sources/SDGTesting/Test.swift"
)
set_target_properties("SDGTesting" PROPERTIES INTERFACE_INCLUDE_DIRECTORIES ${CMAKE_Swift_MODULE_DIRECTORY})
target_compile_options("SDGTesting" PRIVATE -enable-testing)
target_link_libraries("SDGTesting" PRIVATE
  "SDGControlFlow"
  "SDGMathematics"
  "SDGText"
  "SDGLocalization"
  "SDGCornerstoneLocalizations"
)

add_library("SDGPersistenceTestUtilities"
  "../../../.build/SDG/Dependencies/SDGCornerstone/Sources/SDGPersistenceTestUtilities/Codable.swift"
  "../../../.build/SDG/Dependencies/SDGCornerstone/Sources/SDGPersistenceTestUtilities/FileConvertible.swift"
  "../../../.build/SDG/Dependencies/SDGCornerstone/Sources/SDGPersistenceTestUtilities/Specification.swift"
)
set_target_properties("SDGPersistenceTestUtilities" PROPERTIES INTERFACE_INCLUDE_DIRECTORIES ${CMAKE_Swift_MODULE_DIRECTORY})
target_compile_options("SDGPersistenceTestUtilities" PRIVATE -enable-testing)
target_link_libraries("SDGPersistenceTestUtilities" PRIVATE
  "SDGPersistence"
  "SDGTesting"
  "SDGControlFlow"
  "SDGLogic"
  "SDGMathematics"
  "SDGCollections"
  "SDGText"
  "SDGLocalization"
  "SDGCalendar"
  "SDGCornerstoneLocalizations"
)

add_library("SDGLocalizationTestUtilities"
  "../../../.build/SDG/Dependencies/SDGCornerstone/Sources/SDGLocalizationTestUtilities/CustomStringConvertible.swift"
)
set_target_properties("SDGLocalizationTestUtilities" PROPERTIES INTERFACE_INCLUDE_DIRECTORIES ${CMAKE_Swift_MODULE_DIRECTORY})
target_compile_options("SDGLocalizationTestUtilities" PRIVATE -enable-testing)
target_link_libraries("SDGLocalizationTestUtilities" PRIVATE
  "SDGLocalization"
  "SDGTesting"
  "SDGText"
  "SDGPersistence"
  "SDGPersistenceTestUtilities"
)

add_library("SDGVersioning"
  "../../../.build/SDG/Dependencies/SDGCornerstone/Sources/SDGVersioning/Version.swift"
)
set_target_properties("SDGVersioning" PROPERTIES INTERFACE_INCLUDE_DIRECTORIES ${CMAKE_Swift_MODULE_DIRECTORY})
target_compile_options("SDGVersioning" PRIVATE -enable-testing)
target_link_libraries("SDGVersioning" PRIVATE
  "SDGControlFlow"
  "SDGLogic"
  "SDGMathematics"
  "SDGCollections"
  "SDGText"
  "SDGLocalization"
  "SDGCornerstoneLocalizations"
)

add_library("SDGXCTestUtilities"
  "../../../.build/SDG/Dependencies/SDGCornerstone/Sources/SDGXCTestUtilities/TestCase.swift"
  "../../../.build/SDG/Dependencies/SDGCornerstone/Sources/SDGXCTestUtilities/XCTAssert.swift"
)
set_target_properties("SDGXCTestUtilities" PROPERTIES INTERFACE_INCLUDE_DIRECTORIES ${CMAKE_Swift_MODULE_DIRECTORY})
target_compile_options("SDGXCTestUtilities" PRIVATE -enable-testing)
target_link_libraries("SDGXCTestUtilities" PRIVATE
  "SDGTesting"
  "SDGLogic"
  "SDGMathematics"
  "SDGText"
  "SDGPersistence"
)

add_library("SDGSwiftConfiguration"
  "../../../.build/SDG/Dependencies/SDGSwift/Sources/SDGSwiftConfiguration/Configuration.swift"
  "../../../.build/SDG/Dependencies/SDGSwift/Sources/SDGSwiftConfiguration/Context.swift"
  "../../../.build/SDG/Dependencies/SDGSwift/Sources/SDGSwiftConfiguration/Export.swift"
)
set_target_properties("SDGSwiftConfiguration" PROPERTIES INTERFACE_INCLUDE_DIRECTORIES ${CMAKE_Swift_MODULE_DIRECTORY})
target_compile_options("SDGSwiftConfiguration" PRIVATE -enable-testing)

add_library("SDGSwiftLocalizations"
  "../../../.build/SDG/Dependencies/SDGSwift/Sources/SDGSwiftLocalizations/APILocalization.swift"
  "../../../.build/SDG/Dependencies/SDGSwift/Sources/SDGSwiftLocalizations/InterfaceLocalization.swift"
)
set_target_properties("SDGSwiftLocalizations" PROPERTIES INTERFACE_INCLUDE_DIRECTORIES ${CMAKE_Swift_MODULE_DIRECTORY})
target_compile_options("SDGSwiftLocalizations" PRIVATE -enable-testing)
target_link_libraries("SDGSwiftLocalizations" PRIVATE
  "SDGLocalization"
)

add_library("SDGSwift"
  "../../../.build/SDG/Dependencies/SDGSwift/Sources/SDGSwift/Build.swift"
  "../../../.build/SDG/Dependencies/SDGSwift/Sources/SDGSwift/Git.swift"
  "../../../.build/SDG/Dependencies/SDGSwift/Sources/SDGSwift/PackageRepository.swift"
  "../../../.build/SDG/Dependencies/SDGSwift/Sources/SDGSwift/PackageStructure.swift"
  "../../../.build/SDG/Dependencies/SDGSwift/Sources/SDGSwift/PackageStructureBuildError.swift"
  "../../../.build/SDG/Dependencies/SDGSwift/Sources/SDGSwift/PackageStructureExecutionError.swift"
  "../../../.build/SDG/Dependencies/SDGSwift/Sources/SDGSwift/SwiftCompiler.swift"
  "../../../.build/SDG/Dependencies/SDGSwift/Sources/SDGSwift/VersionedExternalProcess.swift"
  "../../../.build/SDG/Dependencies/SDGSwift/Sources/SDGSwift/VersionedExternalProcessExecutionError.swift"
  "../../../.build/SDG/Dependencies/SDGSwift/Sources/SDGSwift/VersionedExternalProcessLocationError.swift"
)
set_target_properties("SDGSwift" PROPERTIES INTERFACE_INCLUDE_DIRECTORIES ${CMAKE_Swift_MODULE_DIRECTORY})
target_compile_options("SDGSwift" PRIVATE -enable-testing)
target_link_libraries("SDGSwift" PRIVATE
  "SDGSwiftLocalizations"
  "SDGControlFlow"
  "SDGLogic"
  "SDGMathematics"
  "SDGCollections"
  "SDGText"
  "SDGLocalization"
  "SDGExternalProcess"
  "SDGVersioning"
)

add_library("SDGCommandLine"
  "../../../.build/SDG/Dependencies/SDGCommandLine/Sources/SDGCommandLine/Argument/AnyArgumentTypeDefinition.swift"
  "../../../.build/SDG/Dependencies/SDGCommandLine/Sources/SDGCommandLine/Argument/ArgumentInterface.swift"
  "../../../.build/SDG/Dependencies/SDGCommandLine/Sources/SDGCommandLine/Argument/ArgumentType.swift"
  "../../../.build/SDG/Dependencies/SDGCommandLine/Sources/SDGCommandLine/Argument/ArgumentTypeDefinition.swift"
  "../../../.build/SDG/Dependencies/SDGCommandLine/Sources/SDGCommandLine/Argument/DirectArguments.swift"
  "../../../.build/SDG/Dependencies/SDGCommandLine/Sources/SDGCommandLine/Command/Command.Error.swift"
  "../../../.build/SDG/Dependencies/SDGCommandLine/Sources/SDGCommandLine/Command/Command.Output.swift"
  "../../../.build/SDG/Dependencies/SDGCommandLine/Sources/SDGCommandLine/Command/Command.swift"
  "../../../.build/SDG/Dependencies/SDGCommandLine/Sources/SDGCommandLine/Command/EmptyCache.swift"
  "../../../.build/SDG/Dependencies/SDGCommandLine/Sources/SDGCommandLine/Command/ExportInterface.swift"
  "../../../.build/SDG/Dependencies/SDGCommandLine/Sources/SDGCommandLine/Command/Help.swift"
  "../../../.build/SDG/Dependencies/SDGCommandLine/Sources/SDGCommandLine/Command/SetLanguage.swift"
  "../../../.build/SDG/Dependencies/SDGCommandLine/Sources/SDGCommandLine/Command/VersionSubcommand.swift"
  "../../../.build/SDG/Dependencies/SDGCommandLine/Sources/SDGCommandLine/Error.swift"
  "../../../.build/SDG/Dependencies/SDGCommandLine/Sources/SDGCommandLine/Option/AnyOption.swift"
  "../../../.build/SDG/Dependencies/SDGCommandLine/Sources/SDGCommandLine/Option/Option.swift"
  "../../../.build/SDG/Dependencies/SDGCommandLine/Sources/SDGCommandLine/Option/OptionInterface.swift"
  "../../../.build/SDG/Dependencies/SDGCommandLine/Sources/SDGCommandLine/Option/Options.swift"
  "../../../.build/SDG/Dependencies/SDGCommandLine/Sources/SDGCommandLine/Output/Colour.swift"
  "../../../.build/SDG/Dependencies/SDGCommandLine/Sources/SDGCommandLine/Output/FontWeight.swift"
  "../../../.build/SDG/Dependencies/SDGCommandLine/Sources/SDGCommandLine/Output/StringFamily.swift"
  "../../../.build/SDG/Dependencies/SDGCommandLine/Sources/SDGCommandLine/Output/TextFormat.swift"
  "../../../.build/SDG/Dependencies/SDGCommandLine/Sources/SDGCommandLine/Output/Underline.swift"
  "../../../.build/SDG/Dependencies/SDGCommandLine/Sources/SDGCommandLine/Package/Build.swift"
  "../../../.build/SDG/Dependencies/SDGCommandLine/Sources/SDGCommandLine/Package/Package.swift"
  "../../../.build/SDG/Dependencies/SDGCommandLine/Sources/SDGCommandLine/ProcessInfo.swift"
)
set_target_properties("SDGCommandLine" PROPERTIES INTERFACE_INCLUDE_DIRECTORIES ${CMAKE_Swift_MODULE_DIRECTORY})
target_compile_options("SDGCommandLine" PRIVATE -enable-testing)
target_link_libraries("SDGCommandLine" PRIVATE
  "SDGCommandLineLocalizations"
  "SDGControlFlow"
  "SDGLogic"
  "SDGMathematics"
  "SDGCollections"
  "SDGText"
  "SDGLocalization"
  "SDGExternalProcess"
  "SDGVersioning"
  "SDGSwift"
)

add_library("SDGCommandLineTestUtilities"
  "../../../.build/SDG/Dependencies/SDGCommandLine/Sources/SDGCommandLineTestUtilities/Command.swift"
)
set_target_properties("SDGCommandLineTestUtilities" PROPERTIES INTERFACE_INCLUDE_DIRECTORIES ${CMAKE_Swift_MODULE_DIRECTORY})
target_compile_options("SDGCommandLineTestUtilities" PRIVATE -enable-testing)
target_link_libraries("SDGCommandLineTestUtilities" PRIVATE
  "SDGCommandLine"
  "SDGCommandLineLocalizations"
  "SDGControlFlow"
  "SDGLogic"
  "SDGText"
  "SDGLocalization"
  "SDGTesting"
  "SDGPersistenceTestUtilities"
)

add_library("SDGExportedCommandLineInterface"
  "../../../.build/SDG/Dependencies/SDGCommandLine/Sources/SDGExportedCommandLineInterface/ArgumentInterface.swift"
  "../../../.build/SDG/Dependencies/SDGCommandLine/Sources/SDGExportedCommandLineInterface/CommandInterface.swift"
  "../../../.build/SDG/Dependencies/SDGCommandLine/Sources/SDGExportedCommandLineInterface/OptionInterface.swift"
)
set_target_properties("SDGExportedCommandLineInterface" PROPERTIES INTERFACE_INCLUDE_DIRECTORIES ${CMAKE_Swift_MODULE_DIRECTORY})
target_compile_options("SDGExportedCommandLineInterface" PRIVATE -enable-testing)
target_link_libraries("SDGExportedCommandLineInterface" PRIVATE
  "SDGCommandLine"
  "SDGText"
  "SDGPersistence"
  "SDGExternalProcess"
)

add_library("SDGSwiftConfigurationLoading"
  "../../../.build/SDG/Dependencies/SDGSwift/Sources/SDGSwiftConfigurationLoading/Configuration.swift"
  "../../../.build/SDG/Dependencies/SDGSwift/Sources/SDGSwiftConfigurationLoading/ConfigurationError.swift"
  "../../../.build/SDG/Dependencies/SDGSwift/Sources/SDGSwiftConfigurationLoading/Resources.swift"
)
set_target_properties("SDGSwiftConfigurationLoading" PROPERTIES INTERFACE_INCLUDE_DIRECTORIES ${CMAKE_Swift_MODULE_DIRECTORY})
target_compile_options("SDGSwiftConfigurationLoading" PRIVATE -enable-testing)
target_link_libraries("SDGSwiftConfigurationLoading" PRIVATE
  "SDGSwiftLocalizations"
  "SDGSwiftConfiguration"
  "SDGSwift"
  "SDGLogic"
  "SDGText"
  "SDGLocalization"
  "SDGVersioning"
)

add_library("SDGSwiftPackageManager"
  "../../../.build/SDG/Dependencies/SDGSwift/Sources/SDGSwiftPackageManager/CoverageRegion.swift"
  "../../../.build/SDG/Dependencies/SDGSwift/Sources/SDGSwiftPackageManager/FileTestCoverage.swift"
  "../../../.build/SDG/Dependencies/SDGSwift/Sources/SDGSwiftPackageManager/Git.swift"
  "../../../.build/SDG/Dependencies/SDGSwift/Sources/SDGSwiftPackageManager/PackageRepository.swift"
  "../../../.build/SDG/Dependencies/SDGSwift/Sources/SDGSwiftPackageManager/PackageRepositoryInitializationError.swift"
  "../../../.build/SDG/Dependencies/SDGSwift/Sources/SDGSwiftPackageManager/String.swift"
  "../../../.build/SDG/Dependencies/SDGSwift/Sources/SDGSwiftPackageManager/SwiftCompiler.swift"
  "../../../.build/SDG/Dependencies/SDGSwift/Sources/SDGSwiftPackageManager/SwiftCompilerCoverageReportingError.swift"
  "../../../.build/SDG/Dependencies/SDGSwift/Sources/SDGSwiftPackageManager/SwiftCompilerManifestLoadingError.swift"
  "../../../.build/SDG/Dependencies/SDGSwift/Sources/SDGSwiftPackageManager/TestCoverageReport.swift"
)
set_target_properties("SDGSwiftPackageManager" PROPERTIES INTERFACE_INCLUDE_DIRECTORIES ${CMAKE_Swift_MODULE_DIRECTORY})
target_compile_options("SDGSwiftPackageManager" PRIVATE -enable-testing)
target_link_libraries("SDGSwiftPackageManager" PRIVATE
  "SDGSwift"
  "SDGSwiftLocalizations"
  "SDGControlFlow"
  "SDGLogic"
  "SDGMathematics"
  "SDGCollections"
  "SDGText"
  "SDGLocalization"
  "SDGVersioning"
)

add_library("SDGXcode"
  "../../../.build/SDG/Dependencies/SDGSwift/Sources/SDGXcode/PackageRepository.swift"
  "../../../.build/SDG/Dependencies/SDGSwift/Sources/SDGXcode/SwiftCompiler.swift"
  "../../../.build/SDG/Dependencies/SDGSwift/Sources/SDGXcode/Xcode.swift"
  "../../../.build/SDG/Dependencies/SDGSwift/Sources/SDGXcode/XcodeCoverageReportingError.swift"
  "../../../.build/SDG/Dependencies/SDGSwift/Sources/SDGXcode/XcodeSDK.swift"
  "../../../.build/SDG/Dependencies/SDGSwift/Sources/SDGXcode/XcodeSchemeError.swift"
)
set_target_properties("SDGXcode" PROPERTIES INTERFACE_INCLUDE_DIRECTORIES ${CMAKE_Swift_MODULE_DIRECTORY})
target_compile_options("SDGXcode" PRIVATE -enable-testing)
target_link_libraries("SDGXcode" PRIVATE
  "SDGSwift"
  "SDGSwiftPackageManager"
  "SDGSwiftLocalizations"
  "SDGControlFlow"
  "SDGLogic"
  "SDGMathematics"
  "SDGCollections"
  "SDGText"
  "SDGLocalization"
  "SDGExternalProcess"
  "SDGVersioning"
)

add_library("SDGCSS"
  "../../../.build/SDG/Dependencies/SDGWeb/Sources/SDGCSS/CSS.swift"
  "../../../.build/SDG/Dependencies/SDGWeb/Sources/SDGCSS/Resources.swift"
)
set_target_properties("SDGCSS" PROPERTIES INTERFACE_INCLUDE_DIRECTORIES ${CMAKE_Swift_MODULE_DIRECTORY})
target_compile_options("SDGCSS" PRIVATE -enable-testing)
target_link_libraries("SDGCSS" PRIVATE
  "SDGCollections"
  "SDGText"
)

add_library("SDGWebLocalizations"
  "../../../.build/SDG/Dependencies/SDGWeb/Sources/SDGWebLocalizations/InterfaceLocalization.swift"
)
set_target_properties("SDGWebLocalizations" PROPERTIES INTERFACE_INCLUDE_DIRECTORIES ${CMAKE_Swift_MODULE_DIRECTORY})
target_compile_options("SDGWebLocalizations" PRIVATE -enable-testing)
target_link_libraries("SDGWebLocalizations" PRIVATE
  "SDGLocalization"
)

add_library("SDGHTML"
  "../../../.build/SDG/Dependencies/SDGWeb/Sources/SDGHTML/Entities.swift"
  "../../../.build/SDG/Dependencies/SDGWeb/Sources/SDGHTML/HTML.swift"
  "../../../.build/SDG/Dependencies/SDGWeb/Sources/SDGHTML/Localization.swift"
  "../../../.build/SDG/Dependencies/SDGWeb/Sources/SDGHTML/Syntax/ContentSyntaxKind.swift"
  "../../../.build/SDG/Dependencies/SDGWeb/Sources/SDGHTML/Syntax/HeadingLevel.swift"
  "../../../.build/SDG/Dependencies/SDGWeb/Sources/SDGHTML/Syntax/Nodes/AttributeSyntax.swift"
  "../../../.build/SDG/Dependencies/SDGWeb/Sources/SDGHTML/Syntax/Nodes/AttributeValueSyntax.swift"
  "../../../.build/SDG/Dependencies/SDGWeb/Sources/SDGHTML/Syntax/Nodes/AttributesSyntax.swift"
  "../../../.build/SDG/Dependencies/SDGWeb/Sources/SDGHTML/Syntax/Nodes/ClosingTagSyntax.swift"
  "../../../.build/SDG/Dependencies/SDGWeb/Sources/SDGHTML/Syntax/Nodes/CommentSyntax.swift"
  "../../../.build/SDG/Dependencies/SDGWeb/Sources/SDGHTML/Syntax/Nodes/ContentSyntax+Factories.swift"
  "../../../.build/SDG/Dependencies/SDGWeb/Sources/SDGHTML/Syntax/Nodes/ContentSyntax.swift"
  "../../../.build/SDG/Dependencies/SDGWeb/Sources/SDGHTML/Syntax/Nodes/DocumentSyntax+Factories.swift"
  "../../../.build/SDG/Dependencies/SDGWeb/Sources/SDGHTML/Syntax/Nodes/DocumentSyntax.swift"
  "../../../.build/SDG/Dependencies/SDGWeb/Sources/SDGHTML/Syntax/Nodes/ElementContinuationSyntax.swift"
  "../../../.build/SDG/Dependencies/SDGWeb/Sources/SDGHTML/Syntax/Nodes/ElementSyntax+Factories.swift"
  "../../../.build/SDG/Dependencies/SDGWeb/Sources/SDGHTML/Syntax/Nodes/ElementSyntax.swift"
  "../../../.build/SDG/Dependencies/SDGWeb/Sources/SDGHTML/Syntax/Nodes/ListSyntax.swift"
  "../../../.build/SDG/Dependencies/SDGWeb/Sources/SDGHTML/Syntax/Nodes/ListSyntaxAttributeSyntax.swift"
  "../../../.build/SDG/Dependencies/SDGWeb/Sources/SDGHTML/Syntax/Nodes/ListSyntaxContentSyntax.swift"
  "../../../.build/SDG/Dependencies/SDGWeb/Sources/SDGHTML/Syntax/Nodes/OpeningTagSyntax.swift"
  "../../../.build/SDG/Dependencies/SDGWeb/Sources/SDGHTML/Syntax/Nodes/TextSyntax.swift"
  "../../../.build/SDG/Dependencies/SDGWeb/Sources/SDGHTML/Syntax/Nodes/TokenSyntax.swift"
  "../../../.build/SDG/Dependencies/SDGWeb/Sources/SDGHTML/Syntax/Protocols/AttributedSyntax.swift"
  "../../../.build/SDG/Dependencies/SDGWeb/Sources/SDGHTML/Syntax/Protocols/ContainerSyntax.swift"
  "../../../.build/SDG/Dependencies/SDGWeb/Sources/SDGHTML/Syntax/Protocols/NamedSyntax.swift"
  "../../../.build/SDG/Dependencies/SDGWeb/Sources/SDGHTML/Syntax/Protocols/Syntax.swift"
  "../../../.build/SDG/Dependencies/SDGWeb/Sources/SDGHTML/Syntax/SyntaxError.swift"
  "../../../.build/SDG/Dependencies/SDGWeb/Sources/SDGHTML/Syntax/SyntaxStorage.swift"
  "../../../.build/SDG/Dependencies/SDGWeb/Sources/SDGHTML/Syntax/SyntaxUnfolder.swift"
  "../../../.build/SDG/Dependencies/SDGWeb/Sources/SDGHTML/Syntax/SyntaxUnfolderContext.swift"
  "../../../.build/SDG/Dependencies/SDGWeb/Sources/SDGHTML/Syntax/SyntaxUnfolderError.swift"
  "../../../.build/SDG/Dependencies/SDGWeb/Sources/SDGHTML/Syntax/SyntaxUnfolderProtocol.swift"
  "../../../.build/SDG/Dependencies/SDGWeb/Sources/SDGHTML/Syntax/TokenKind.swift"
  "../../../.build/SDG/Dependencies/SDGWeb/Sources/SDGHTML/Syntax/UnfoldingError.swift"
  "../../../.build/SDG/Dependencies/SDGWeb/Sources/SDGHTML/TextDirection.swift"
  "../../../.build/SDG/Dependencies/SDGWeb/Sources/SDGHTML/UnicodeScalar.swift"
)
set_target_properties("SDGHTML" PROPERTIES INTERFACE_INCLUDE_DIRECTORIES ${CMAKE_Swift_MODULE_DIRECTORY})
target_compile_options("SDGHTML" PRIVATE -enable-testing)
target_link_libraries("SDGHTML" PRIVATE
  "SDGWebLocalizations"
  "SDGControlFlow"
  "SDGLogic"
  "SDGMathematics"
  "SDGCollections"
  "SDGText"
  "SDGPersistence"
  "SDGLocalization"
)

add_library("SDGSwiftSource"
  "../../../.build/SDG/Dependencies/SDGSwift/Sources/SDGSwiftSource/API/APIElement.swift"
  "../../../.build/SDG/Dependencies/SDGSwift/Sources/SDGSwiftSource/API/ConformanceReference.swift"
  "../../../.build/SDG/Dependencies/SDGSwift/Sources/SDGSwiftSource/API/Protocols/APIElementProtocol.swift"
  "../../../.build/SDG/Dependencies/SDGSwift/Sources/SDGSwiftSource/API/Protocols/APIElementStorage.swift"
  "../../../.build/SDG/Dependencies/SDGSwift/Sources/SDGSwiftSource/API/Protocols/DeclaredAPIElement.swift"
  "../../../.build/SDG/Dependencies/SDGSwift/Sources/SDGSwiftSource/API/Protocols/NonOverloadableAPIElement.swift"
  "../../../.build/SDG/Dependencies/SDGSwift/Sources/SDGSwiftSource/API/Protocols/OverloadableAPIElement.swift"
  "../../../.build/SDG/Dependencies/SDGSwift/Sources/SDGSwiftSource/API/Protocols/SortableAPIElement.swift"
  "../../../.build/SDG/Dependencies/SDGSwift/Sources/SDGSwiftSource/API/Protocols/UndeclaredAPIElementProtocol.swift"
  "../../../.build/SDG/Dependencies/SDGSwift/Sources/SDGSwiftSource/API/Protocols/UndeclaredAPIElementStorage.swift"
  "../../../.build/SDG/Dependencies/SDGSwift/Sources/SDGSwiftSource/API/Protocols/UniquelyDeclaredAPIElement.swift"
  "../../../.build/SDG/Dependencies/SDGSwift/Sources/SDGSwiftSource/API/Protocols/UniquelyDeclaredManifestAPIElement.swift"
  "../../../.build/SDG/Dependencies/SDGSwift/Sources/SDGSwiftSource/API/Protocols/UniquelyDeclaredOverloadableAPIElement.swift"
  "../../../.build/SDG/Dependencies/SDGSwift/Sources/SDGSwiftSource/API/Protocols/UniquelyDeclaredSyntaxAPIElement.swift"
  "../../../.build/SDG/Dependencies/SDGSwift/Sources/SDGSwiftSource/API/SymbolDocumentation.swift"
  "../../../.build/SDG/Dependencies/SDGSwift/Sources/SDGSwiftSource/API/Types/CaseAPI.swift"
  "../../../.build/SDG/Dependencies/SDGSwift/Sources/SDGSwiftSource/API/Types/ConformanceAPI.swift"
  "../../../.build/SDG/Dependencies/SDGSwift/Sources/SDGSwiftSource/API/Types/ExtensionAPI.swift"
  "../../../.build/SDG/Dependencies/SDGSwift/Sources/SDGSwiftSource/API/Types/FunctionAPI.swift"
  "../../../.build/SDG/Dependencies/SDGSwift/Sources/SDGSwiftSource/API/Types/InitializerAPI.swift"
  "../../../.build/SDG/Dependencies/SDGSwift/Sources/SDGSwiftSource/API/Types/LibraryAPI.swift"
  "../../../.build/SDG/Dependencies/SDGSwift/Sources/SDGSwiftSource/API/Types/ModuleAPI.swift"
  "../../../.build/SDG/Dependencies/SDGSwift/Sources/SDGSwiftSource/API/Types/OperatorAPI.swift"
  "../../../.build/SDG/Dependencies/SDGSwift/Sources/SDGSwiftSource/API/Types/PackageAPI.swift"
  "../../../.build/SDG/Dependencies/SDGSwift/Sources/SDGSwiftSource/API/Types/PrecedenceAPI.swift"
  "../../../.build/SDG/Dependencies/SDGSwift/Sources/SDGSwiftSource/API/Types/ProtocolAPI.swift"
  "../../../.build/SDG/Dependencies/SDGSwift/Sources/SDGSwiftSource/API/Types/SubscriptAPI.swift"
  "../../../.build/SDG/Dependencies/SDGSwift/Sources/SDGSwiftSource/API/Types/TypeAPI.swift"
  "../../../.build/SDG/Dependencies/SDGSwift/Sources/SDGSwiftSource/API/Types/VariableAPI.swift"
  "../../../.build/SDG/Dependencies/SDGSwift/Sources/SDGSwiftSource/CMark/CMarkNode.swift"
  "../../../.build/SDG/Dependencies/SDGSwift/Sources/SDGSwiftSource/General Extensions/Mergeable.swift"
  "../../../.build/SDG/Dependencies/SDGSwift/Sources/SDGSwiftSource/General Extensions/NSCache.swift"
  "../../../.build/SDG/Dependencies/SDGSwift/Sources/SDGSwiftSource/General Extensions/Optional.swift"
  "../../../.build/SDG/Dependencies/SDGSwift/Sources/SDGSwiftSource/General Extensions/String.swift"
  "../../../.build/SDG/Dependencies/SDGSwift/Sources/SDGSwiftSource/Miscellaneous/Callout.swift"
  "../../../.build/SDG/Dependencies/SDGSwift/Sources/SDGSwiftSource/Miscellaneous/ParameterDocumentation.swift"
  "../../../.build/SDG/Dependencies/SDGSwift/Sources/SDGSwiftSource/Miscellaneous/TextFreedom.swift"
  "../../../.build/SDG/Dependencies/SDGSwift/Sources/SDGSwiftSource/Resources.swift"
  "../../../.build/SDG/Dependencies/SDGSwift/Sources/SDGSwiftSource/Scanners/FunctionalSyntaxScanner.swift"
  "../../../.build/SDG/Dependencies/SDGSwift/Sources/SDGSwiftSource/Scanners/SyntaxScanner.swift"
  "../../../.build/SDG/Dependencies/SDGSwift/Sources/SDGSwiftSource/Scanners/TriviaNormalizer.swift"
  "../../../.build/SDG/Dependencies/SDGSwift/Sources/SDGSwiftSource/Syntax/Extended Syntax Nodes/BlockCommentSyntax.swift"
  "../../../.build/SDG/Dependencies/SDGSwift/Sources/SDGSwiftSource/Syntax/Extended Syntax Nodes/BlockDeveloperCommentSyntax.swift"
  "../../../.build/SDG/Dependencies/SDGSwift/Sources/SDGSwiftSource/Syntax/Extended Syntax Nodes/BlockDocumentationSyntax.swift"
  "../../../.build/SDG/Dependencies/SDGSwift/Sources/SDGSwiftSource/Syntax/Extended Syntax Nodes/CalloutSyntax.swift"
  "../../../.build/SDG/Dependencies/SDGSwift/Sources/SDGSwiftSource/Syntax/Extended Syntax Nodes/CodeFragmentSyntax.swift"
  "../../../.build/SDG/Dependencies/SDGSwift/Sources/SDGSwiftSource/Syntax/Extended Syntax Nodes/CommentSyntax.swift"
  "../../../.build/SDG/Dependencies/SDGSwift/Sources/SDGSwiftSource/Syntax/Extended Syntax Nodes/ExtendedSyntax.swift"
  "../../../.build/SDG/Dependencies/SDGSwift/Sources/SDGSwiftSource/Syntax/Extended Syntax Nodes/ExtendedTokenKind.swift"
  "../../../.build/SDG/Dependencies/SDGSwift/Sources/SDGSwiftSource/Syntax/Extended Syntax Nodes/ExtendedTokenSyntax.swift"
  "../../../.build/SDG/Dependencies/SDGSwift/Sources/SDGSwiftSource/Syntax/Extended Syntax Nodes/FragmentSyntax.swift"
  "../../../.build/SDG/Dependencies/SDGSwift/Sources/SDGSwiftSource/Syntax/Extended Syntax Nodes/LineCommentSyntax.swift"
  "../../../.build/SDG/Dependencies/SDGSwift/Sources/SDGSwiftSource/Syntax/Extended Syntax Nodes/LineDeveloperCommentSyntax.swift"
  "../../../.build/SDG/Dependencies/SDGSwift/Sources/SDGSwiftSource/Syntax/Extended Syntax Nodes/LineDocumentationSyntax.swift"
  "../../../.build/SDG/Dependencies/SDGSwift/Sources/SDGSwiftSource/Syntax/Extended Syntax Nodes/Markdown/CodeBlockSyntax.swift"
  "../../../.build/SDG/Dependencies/SDGSwift/Sources/SDGSwiftSource/Syntax/Extended Syntax Nodes/Markdown/DocumentationSyntax.swift"
  "../../../.build/SDG/Dependencies/SDGSwift/Sources/SDGSwiftSource/Syntax/Extended Syntax Nodes/Markdown/FontSyntax.swift"
  "../../../.build/SDG/Dependencies/SDGSwift/Sources/SDGSwiftSource/Syntax/Extended Syntax Nodes/Markdown/HeadingSyntax.swift"
  "../../../.build/SDG/Dependencies/SDGSwift/Sources/SDGSwiftSource/Syntax/Extended Syntax Nodes/Markdown/ImageSyntax.swift"
  "../../../.build/SDG/Dependencies/SDGSwift/Sources/SDGSwiftSource/Syntax/Extended Syntax Nodes/Markdown/InlineCodeSyntax.swift"
  "../../../.build/SDG/Dependencies/SDGSwift/Sources/SDGSwiftSource/Syntax/Extended Syntax Nodes/Markdown/LineSeparatorSyntax.swift"
  "../../../.build/SDG/Dependencies/SDGSwift/Sources/SDGSwiftSource/Syntax/Extended Syntax Nodes/Markdown/LinkSyntax.swift"
  "../../../.build/SDG/Dependencies/SDGSwift/Sources/SDGSwiftSource/Syntax/Extended Syntax Nodes/Markdown/ListEntrySyntax.swift"
  "../../../.build/SDG/Dependencies/SDGSwift/Sources/SDGSwiftSource/Syntax/Extended Syntax Nodes/Markdown/ListSyntax.swift"
  "../../../.build/SDG/Dependencies/SDGSwift/Sources/SDGSwiftSource/Syntax/Extended Syntax Nodes/Markdown/MarkdownSyntax.swift"
  "../../../.build/SDG/Dependencies/SDGSwift/Sources/SDGSwiftSource/Syntax/Extended Syntax Nodes/Markdown/ParagraphSyntax.swift"
  "../../../.build/SDG/Dependencies/SDGSwift/Sources/SDGSwiftSource/Syntax/Extended Syntax Nodes/Markdown/QuotationSyntax.swift"
  "../../../.build/SDG/Dependencies/SDGSwift/Sources/SDGSwiftSource/Syntax/Extended Syntax Nodes/ParametersCalloutSyntax.swift"
  "../../../.build/SDG/Dependencies/SDGSwift/Sources/SDGSwiftSource/Syntax/Extended Syntax Nodes/SourceHeading.swift"
  "../../../.build/SDG/Dependencies/SDGSwift/Sources/SDGSwiftSource/Syntax/Extended Syntax Nodes/StringLiteralSyntax.swift"
  "../../../.build/SDG/Dependencies/SDGSwift/Sources/SDGSwiftSource/Syntax/Fragmentation/ExtendedSyntaxContext.swift"
  "../../../.build/SDG/Dependencies/SDGSwift/Sources/SDGSwiftSource/Syntax/Fragmentation/SyntaxContext.swift"
  "../../../.build/SDG/Dependencies/SDGSwift/Sources/SDGSwiftSource/Syntax/Fragmentation/SyntaxFragment.swift"
  "../../../.build/SDG/Dependencies/SDGSwift/Sources/SDGSwiftSource/Syntax/Fragmentation/TriviaContext.swift"
  "../../../.build/SDG/Dependencies/SDGSwift/Sources/SDGSwiftSource/Syntax/Fragmentation/TriviaPieceContext.swift"
  "../../../.build/SDG/Dependencies/SDGSwift/Sources/SDGSwiftSource/Syntax/Syntax Nodes/Protocols/APIDeclaration.swift"
  "../../../.build/SDG/Dependencies/SDGSwift/Sources/SDGSwiftSource/Syntax/Syntax Nodes/Protocols/APISyntax.swift"
  "../../../.build/SDG/Dependencies/SDGSwift/Sources/SDGSwiftSource/Syntax/Syntax Nodes/Protocols/AccessControlled.swift"
  "../../../.build/SDG/Dependencies/SDGSwift/Sources/SDGSwiftSource/Syntax/Syntax Nodes/Protocols/Accessor.swift"
  "../../../.build/SDG/Dependencies/SDGSwift/Sources/SDGSwiftSource/Syntax/Syntax Nodes/Protocols/Attributed.swift"
  "../../../.build/SDG/Dependencies/SDGSwift/Sources/SDGSwiftSource/Syntax/Syntax Nodes/Protocols/Constrained.swift"
  "../../../.build/SDG/Dependencies/SDGSwift/Sources/SDGSwiftSource/Syntax/Syntax Nodes/Protocols/Generic.swift"
  "../../../.build/SDG/Dependencies/SDGSwift/Sources/SDGSwiftSource/Syntax/Syntax Nodes/Protocols/Hidable.swift"
  "../../../.build/SDG/Dependencies/SDGSwift/Sources/SDGSwiftSource/Syntax/Syntax Nodes/Protocols/Inheritor.swift"
  "../../../.build/SDG/Dependencies/SDGSwift/Sources/SDGSwiftSource/Syntax/Syntax Nodes/Protocols/Member.swift"
  "../../../.build/SDG/Dependencies/SDGSwift/Sources/SDGSwiftSource/Syntax/Syntax Nodes/Protocols/OverloadableAPIDeclaration.swift"
  "../../../.build/SDG/Dependencies/SDGSwift/Sources/SDGSwiftSource/Syntax/Syntax Nodes/Protocols/OverridableDeclaration.swift"
  "../../../.build/SDG/Dependencies/SDGSwift/Sources/SDGSwiftSource/Syntax/Syntax Nodes/Protocols/PatternSyntax.swift"
  "../../../.build/SDG/Dependencies/SDGSwift/Sources/SDGSwiftSource/Syntax/Syntax Nodes/Protocols/SyntaxProtocol.swift"
  "../../../.build/SDG/Dependencies/SDGSwift/Sources/SDGSwiftSource/Syntax/Syntax Nodes/Protocols/TypeDeclaration.swift"
  "../../../.build/SDG/Dependencies/SDGSwift/Sources/SDGSwiftSource/Syntax/Syntax Nodes/Protocols/TypeSyntax.swift"
  "../../../.build/SDG/Dependencies/SDGSwift/Sources/SDGSwiftSource/Syntax/Syntax Nodes/Types/ArrayTypeSyntax.swift"
  "../../../.build/SDG/Dependencies/SDGSwift/Sources/SDGSwiftSource/Syntax/Syntax Nodes/Types/AssociatedtypeDeclSyntax.swift"
  "../../../.build/SDG/Dependencies/SDGSwift/Sources/SDGSwiftSource/Syntax/Syntax Nodes/Types/AttributeListSyntax.swift"
  "../../../.build/SDG/Dependencies/SDGSwift/Sources/SDGSwiftSource/Syntax/Syntax Nodes/Types/AttributeSyntax.swift"
  "../../../.build/SDG/Dependencies/SDGSwift/Sources/SDGSwiftSource/Syntax/Syntax Nodes/Types/AttributedTypeSyntax.swift"
  "../../../.build/SDG/Dependencies/SDGSwift/Sources/SDGSwiftSource/Syntax/Syntax Nodes/Types/AvailabilityArgumentSyntax.swift"
  "../../../.build/SDG/Dependencies/SDGSwift/Sources/SDGSwiftSource/Syntax/Syntax Nodes/Types/AvailabilityLabeledArgumentSyntax.swift"
  "../../../.build/SDG/Dependencies/SDGSwift/Sources/SDGSwiftSource/Syntax/Syntax Nodes/Types/AvailabilitySpecListSyntax.swift"
  "../../../.build/SDG/Dependencies/SDGSwift/Sources/SDGSwiftSource/Syntax/Syntax Nodes/Types/AvailabilityVersionRestrictionSyntax.swift"
  "../../../.build/SDG/Dependencies/SDGSwift/Sources/SDGSwiftSource/Syntax/Syntax Nodes/Types/ClassDeclSyntax.swift"
  "../../../.build/SDG/Dependencies/SDGSwift/Sources/SDGSwiftSource/Syntax/Syntax Nodes/Types/ClassRestrictionTypeSyntax.swift"
  "../../../.build/SDG/Dependencies/SDGSwift/Sources/SDGSwiftSource/Syntax/Syntax Nodes/Types/CompositionTypeElementListSyntax.swift"
  "../../../.build/SDG/Dependencies/SDGSwift/Sources/SDGSwiftSource/Syntax/Syntax Nodes/Types/CompositionTypeElementSyntax.swift"
  "../../../.build/SDG/Dependencies/SDGSwift/Sources/SDGSwiftSource/Syntax/Syntax Nodes/Types/CompositionTypeSyntax.swift"
  "../../../.build/SDG/Dependencies/SDGSwift/Sources/SDGSwiftSource/Syntax/Syntax Nodes/Types/ConformanceRequirementSyntax.swift"
  "../../../.build/SDG/Dependencies/SDGSwift/Sources/SDGSwiftSource/Syntax/Syntax Nodes/Types/CustomAttributeSyntax.swift"
  "../../../.build/SDG/Dependencies/SDGSwift/Sources/SDGSwiftSource/Syntax/Syntax Nodes/Types/DeclModifierSyntax.swift"
  "../../../.build/SDG/Dependencies/SDGSwift/Sources/SDGSwiftSource/Syntax/Syntax Nodes/Types/DictoinaryTypeSyntax.swift"
  "../../../.build/SDG/Dependencies/SDGSwift/Sources/SDGSwiftSource/Syntax/Syntax Nodes/Types/EnumCaseDeclSyntax.swift"
  "../../../.build/SDG/Dependencies/SDGSwift/Sources/SDGSwiftSource/Syntax/Syntax Nodes/Types/EnumCaseElementListSyntax.swift"
  "../../../.build/SDG/Dependencies/SDGSwift/Sources/SDGSwiftSource/Syntax/Syntax Nodes/Types/EnumCaseElementSyntax.swift"
  "../../../.build/SDG/Dependencies/SDGSwift/Sources/SDGSwiftSource/Syntax/Syntax Nodes/Types/EnumDeclSyntax.swift"
  "../../../.build/SDG/Dependencies/SDGSwift/Sources/SDGSwiftSource/Syntax/Syntax Nodes/Types/ExtensionDeclSyntax.swift"
  "../../../.build/SDG/Dependencies/SDGSwift/Sources/SDGSwiftSource/Syntax/Syntax Nodes/Types/FunctionCallExprSyntax.swift"
  "../../../.build/SDG/Dependencies/SDGSwift/Sources/SDGSwiftSource/Syntax/Syntax Nodes/Types/FunctionDeclSyntax.swift"
  "../../../.build/SDG/Dependencies/SDGSwift/Sources/SDGSwiftSource/Syntax/Syntax Nodes/Types/FunctionParameterListSyntax.swift"
  "../../../.build/SDG/Dependencies/SDGSwift/Sources/SDGSwiftSource/Syntax/Syntax Nodes/Types/FunctionParameterSyntax.swift"
  "../../../.build/SDG/Dependencies/SDGSwift/Sources/SDGSwiftSource/Syntax/Syntax Nodes/Types/FunctionSignatureSyntax.swift"
  "../../../.build/SDG/Dependencies/SDGSwift/Sources/SDGSwiftSource/Syntax/Syntax Nodes/Types/FunctionTypeSyntax.swift"
  "../../../.build/SDG/Dependencies/SDGSwift/Sources/SDGSwiftSource/Syntax/Syntax Nodes/Types/GenericArgumentClauseSyntax.swift"
  "../../../.build/SDG/Dependencies/SDGSwift/Sources/SDGSwiftSource/Syntax/Syntax Nodes/Types/GenericArgumentListSyntax.swift"
  "../../../.build/SDG/Dependencies/SDGSwift/Sources/SDGSwiftSource/Syntax/Syntax Nodes/Types/GenericArgumentSyntax.swift"
  "../../../.build/SDG/Dependencies/SDGSwift/Sources/SDGSwiftSource/Syntax/Syntax Nodes/Types/GenericParameterClauseSyntax.swift"
  "../../../.build/SDG/Dependencies/SDGSwift/Sources/SDGSwiftSource/Syntax/Syntax Nodes/Types/GenericParameterListSyntax.swift"
  "../../../.build/SDG/Dependencies/SDGSwift/Sources/SDGSwiftSource/Syntax/Syntax Nodes/Types/GenericParameterSyntax.swift"
  "../../../.build/SDG/Dependencies/SDGSwift/Sources/SDGSwiftSource/Syntax/Syntax Nodes/Types/GenericRequirementListSyntax.swift"
  "../../../.build/SDG/Dependencies/SDGSwift/Sources/SDGSwiftSource/Syntax/Syntax Nodes/Types/GenericRequirementSyntax.swift"
  "../../../.build/SDG/Dependencies/SDGSwift/Sources/SDGSwiftSource/Syntax/Syntax Nodes/Types/GenericWhereClauseSyntax.swift"
  "../../../.build/SDG/Dependencies/SDGSwift/Sources/SDGSwiftSource/Syntax/Syntax Nodes/Types/IdentifierListSyntax.swift"
  "../../../.build/SDG/Dependencies/SDGSwift/Sources/SDGSwiftSource/Syntax/Syntax Nodes/Types/IdentifierPatternSyntax.swift"
  "../../../.build/SDG/Dependencies/SDGSwift/Sources/SDGSwiftSource/Syntax/Syntax Nodes/Types/IfConfigDeclSyntax.swift"
  "../../../.build/SDG/Dependencies/SDGSwift/Sources/SDGSwiftSource/Syntax/Syntax Nodes/Types/ImplicitlyUnwrappedOptionalSyntax.swift"
  "../../../.build/SDG/Dependencies/SDGSwift/Sources/SDGSwiftSource/Syntax/Syntax Nodes/Types/InitializerClauseSyntax.swift"
  "../../../.build/SDG/Dependencies/SDGSwift/Sources/SDGSwiftSource/Syntax/Syntax Nodes/Types/InitializerDeclSyntax.swift"
  "../../../.build/SDG/Dependencies/SDGSwift/Sources/SDGSwiftSource/Syntax/Syntax Nodes/Types/MemberTypeIdentifierSyntax.swift"
  "../../../.build/SDG/Dependencies/SDGSwift/Sources/SDGSwiftSource/Syntax/Syntax Nodes/Types/MetatypeTypeSyntax.swift"
  "../../../.build/SDG/Dependencies/SDGSwift/Sources/SDGSwiftSource/Syntax/Syntax Nodes/Types/ModifierListSyntax.swift"
  "../../../.build/SDG/Dependencies/SDGSwift/Sources/SDGSwiftSource/Syntax/Syntax Nodes/Types/OperatorDeclSyntax.swift"
  "../../../.build/SDG/Dependencies/SDGSwift/Sources/SDGSwiftSource/Syntax/Syntax Nodes/Types/OperatorPrecedenceAndTypesSyntax.swift"
  "../../../.build/SDG/Dependencies/SDGSwift/Sources/SDGSwiftSource/Syntax/Syntax Nodes/Types/OptionalTypeSyntax.swift"
  "../../../.build/SDG/Dependencies/SDGSwift/Sources/SDGSwiftSource/Syntax/Syntax Nodes/Types/ParameterClauseSyntax.swift"
  "../../../.build/SDG/Dependencies/SDGSwift/Sources/SDGSwiftSource/Syntax/Syntax Nodes/Types/PatternBindingListSyntax.swift"
  "../../../.build/SDG/Dependencies/SDGSwift/Sources/SDGSwiftSource/Syntax/Syntax Nodes/Types/PatternBindingSyntax.swift"
  "../../../.build/SDG/Dependencies/SDGSwift/Sources/SDGSwiftSource/Syntax/Syntax Nodes/Types/PrecedenceGroupAssignmentSyntax.swift"
  "../../../.build/SDG/Dependencies/SDGSwift/Sources/SDGSwiftSource/Syntax/Syntax Nodes/Types/PrecedenceGroupAssociativitySyntax.swift"
  "../../../.build/SDG/Dependencies/SDGSwift/Sources/SDGSwiftSource/Syntax/Syntax Nodes/Types/PrecedenceGroupAttributeListSyntax.swift"
  "../../../.build/SDG/Dependencies/SDGSwift/Sources/SDGSwiftSource/Syntax/Syntax Nodes/Types/PrecedenceGroupDeclSyntax.swift"
  "../../../.build/SDG/Dependencies/SDGSwift/Sources/SDGSwiftSource/Syntax/Syntax Nodes/Types/PrecedenceGroupNameElementSyntax.swift"
  "../../../.build/SDG/Dependencies/SDGSwift/Sources/SDGSwiftSource/Syntax/Syntax Nodes/Types/PrecedenceGroupNameListSyntax.swift"
  "../../../.build/SDG/Dependencies/SDGSwift/Sources/SDGSwiftSource/Syntax/Syntax Nodes/Types/PrecedenceGroupRelationSyntax.swift"
  "../../../.build/SDG/Dependencies/SDGSwift/Sources/SDGSwiftSource/Syntax/Syntax Nodes/Types/ProtocolDeclSyntax.swift"
  "../../../.build/SDG/Dependencies/SDGSwift/Sources/SDGSwiftSource/Syntax/Syntax Nodes/Types/ReturnClauseSyntax.swift"
  "../../../.build/SDG/Dependencies/SDGSwift/Sources/SDGSwiftSource/Syntax/Syntax Nodes/Types/SameTypeRequirementSyntax.swift"
  "../../../.build/SDG/Dependencies/SDGSwift/Sources/SDGSwiftSource/Syntax/Syntax Nodes/Types/SimpleTypeIdentifierSyntax.swift"
  "../../../.build/SDG/Dependencies/SDGSwift/Sources/SDGSwiftSource/Syntax/Syntax Nodes/Types/StructDeclSyntax.swift"
  "../../../.build/SDG/Dependencies/SDGSwift/Sources/SDGSwiftSource/Syntax/Syntax Nodes/Types/SubscriptDeclSyntax.swift"
  "../../../.build/SDG/Dependencies/SDGSwift/Sources/SDGSwiftSource/Syntax/Syntax Nodes/Types/TokenKind.swift"
  "../../../.build/SDG/Dependencies/SDGSwift/Sources/SDGSwiftSource/Syntax/Syntax Nodes/Types/TokenSyntax.swift"
  "../../../.build/SDG/Dependencies/SDGSwift/Sources/SDGSwiftSource/Syntax/Syntax Nodes/Types/Trivia.swift"
  "../../../.build/SDG/Dependencies/SDGSwift/Sources/SDGSwiftSource/Syntax/Syntax Nodes/Types/TriviaPiece.swift"
  "../../../.build/SDG/Dependencies/SDGSwift/Sources/SDGSwiftSource/Syntax/Syntax Nodes/Types/TupleTypeElementListSyntax.swift"
  "../../../.build/SDG/Dependencies/SDGSwift/Sources/SDGSwiftSource/Syntax/Syntax Nodes/Types/TupleTypeElementSyntax.swift"
  "../../../.build/SDG/Dependencies/SDGSwift/Sources/SDGSwiftSource/Syntax/Syntax Nodes/Types/TupleTypeSyntax.swift"
  "../../../.build/SDG/Dependencies/SDGSwift/Sources/SDGSwiftSource/Syntax/Syntax Nodes/Types/TypeAnnotationSyntax.swift"
  "../../../.build/SDG/Dependencies/SDGSwift/Sources/SDGSwiftSource/Syntax/Syntax Nodes/Types/TypeInheritanceClauseSyntax.swift"
  "../../../.build/SDG/Dependencies/SDGSwift/Sources/SDGSwiftSource/Syntax/Syntax Nodes/Types/TypealiasDeclSyntax.swift"
  "../../../.build/SDG/Dependencies/SDGSwift/Sources/SDGSwiftSource/Syntax/Syntax Nodes/Types/VariableDeclSyntax.swift"
  "../../../.build/SDG/Dependencies/SDGSwift/Sources/SDGSwiftSource/Syntax/Syntax Nodes/Types/VersionTupleSyntax.swift"
  "../../../.build/SDG/Dependencies/SDGSwift/Sources/SDGSwiftSource/Syntax/SyntaxFactory.swift"
  "../../../.build/SDG/Dependencies/SDGSwift/Sources/SDGSwiftSource/SyntaxHighlighter.swift"
  "../../../.build/SDG/Dependencies/SDGSwift/Sources/SDGSwiftSource/SyntaxParser.swift"
)
set_target_properties("SDGSwiftSource" PROPERTIES INTERFACE_INCLUDE_DIRECTORIES ${CMAKE_Swift_MODULE_DIRECTORY})
target_compile_options("SDGSwiftSource" PRIVATE -enable-testing)
target_link_libraries("SDGSwiftSource" PRIVATE
  "SDGSwift"
  "SDGSwiftPackageManager"
  "SDGSwiftLocalizations"
  "SDGControlFlow"
  "SDGLogic"
  "SDGMathematics"
  "SDGCollections"
  "SDGText"
  "SDGPersistence"
  "SDGLocalization"
  "SDGHTML"
)

add_library("SDGWeb"
  "../../../.build/SDG/Dependencies/SDGWeb/Sources/SDGWeb/Copyright.swift"
  "../../../.build/SDG/Dependencies/SDGWeb/Sources/SDGWeb/PageTemplate.swift"
  "../../../.build/SDG/Dependencies/SDGWeb/Sources/SDGWeb/PageTemplateLoadingError.swift"
  "../../../.build/SDG/Dependencies/SDGWeb/Sources/SDGWeb/PageTemplateMetaDataExtractionError.swift"
  "../../../.build/SDG/Dependencies/SDGWeb/Sources/SDGWeb/PageTemplateMetaDataParsingError.swift"
  "../../../.build/SDG/Dependencies/SDGWeb/Sources/SDGWeb/RepositoryStructure.swift"
  "../../../.build/SDG/Dependencies/SDGWeb/Sources/SDGWeb/Site.swift"
  "../../../.build/SDG/Dependencies/SDGWeb/Sources/SDGWeb/SiteGenerationError.swift"
  "../../../.build/SDG/Dependencies/SDGWeb/Sources/SDGWeb/SiteSyntaxUnfolder.swift"
  "../../../.build/SDG/Dependencies/SDGWeb/Sources/SDGWeb/SiteValidationError.swift"
  "../../../.build/SDG/Dependencies/SDGWeb/Sources/SDGWeb/SyntaxUnfolder.swift"
)
set_target_properties("SDGWeb" PROPERTIES INTERFACE_INCLUDE_DIRECTORIES ${CMAKE_Swift_MODULE_DIRECTORY})
target_compile_options("SDGWeb" PRIVATE -enable-testing)
target_link_libraries("SDGWeb" PRIVATE
  "SDGWebLocalizations"
  "SDGHTML"
  "SDGCSS"
  "SDGControlFlow"
  "SDGLogic"
  "SDGMathematics"
  "SDGCollections"
  "SDGText"
  "SDGLocalization"
  "SDGCalendar"
)

add_library("WSLocalizations"
  "../../../Sources/WSLocalizations/ContentLocalization.swift"
  "../../../Sources/WSLocalizations/InterfaceLocalization.swift"
)
set_target_properties("WSLocalizations" PROPERTIES INTERFACE_INCLUDE_DIRECTORIES ${CMAKE_Swift_MODULE_DIRECTORY})
target_compile_options("WSLocalizations" PRIVATE -enable-testing)
target_link_libraries("WSLocalizations" PRIVATE
  "SDGLocalization"
)

add_library("WSGeneralImports"
  "../../../Sources/WSGeneralImports/Exports.swift"
  "../../../Sources/WSGeneralImports/ProcessInfo.swift"
)
set_target_properties("WSGeneralImports" PROPERTIES INTERFACE_INCLUDE_DIRECTORIES ${CMAKE_Swift_MODULE_DIRECTORY})
target_compile_options("WSGeneralImports" PRIVATE -enable-testing)
target_link_libraries("WSGeneralImports" PRIVATE
  "WSLocalizations"
  "SDGControlFlow"
  "SDGLogic"
  "SDGMathematics"
  "SDGCollections"
  "SDGText"
  "SDGPersistence"
  "SDGLocalization"
  "SDGExternalProcess"
  "SDGCommandLine"
  "SDGSwift"
)

add_library("WSSwift"
  "../../../Sources/WSSwift/SwiftLanguage.Casing.swift"
  "../../../Sources/WSSwift/SwiftLanguage.swift"
)
set_target_properties("WSSwift" PROPERTIES INTERFACE_INCLUDE_DIRECTORIES ${CMAKE_Swift_MODULE_DIRECTORY})
target_compile_options("WSSwift" PRIVATE -enable-testing)
target_link_libraries("WSSwift" PRIVATE
  "WSGeneralImports"
)

add_library("SwiftFormatConfiguration"
  "../../../.build/SDG/Dependencies/swift-format/Sources/SwiftFormatConfiguration/Configuration.swift"
  "../../../.build/SDG/Dependencies/swift-format/Sources/SwiftFormatConfiguration/Indent.swift"
  "../../../.build/SDG/Dependencies/swift-format/Sources/SwiftFormatConfiguration/RuleRegistry+Generated.swift"
)
set_target_properties("SwiftFormatConfiguration" PROPERTIES INTERFACE_INCLUDE_DIRECTORIES ${CMAKE_Swift_MODULE_DIRECTORY})
target_compile_options("SwiftFormatConfiguration" PRIVATE -enable-testing)

add_library("WSCrossPlatform"
  "../../../Tests/WSCrossPlatform/CrossPlatform.swift"
)
set_target_properties("WSCrossPlatform" PROPERTIES INTERFACE_INCLUDE_DIRECTORIES ${CMAKE_Swift_MODULE_DIRECTORY})
target_compile_options("WSCrossPlatform" PRIVATE -enable-testing)
target_link_libraries("WSCrossPlatform" PRIVATE
  "SwiftFormatConfiguration"
)

add_library("WSCrossPlatformTests"
  "../../../Tests/WSCrossPlatformTests/CrossPlatformTests.swift"
)
set_target_properties("WSCrossPlatformTests" PROPERTIES INTERFACE_INCLUDE_DIRECTORIES ${CMAKE_Swift_MODULE_DIRECTORY})
target_compile_options("WSCrossPlatformTests" PRIVATE -enable-testing)
target_link_libraries("WSCrossPlatformTests" PRIVATE
  "WSCrossPlatform"
  "SDGPersistence"
  "SDGXCTestUtilities"
  "SDGPersistenceTestUtilities"
)

add_executable("WSCrossPlatformTool"
  "../../../Tests/WSCrossPlatformTool/main.swift"
)
target_link_libraries("WSCrossPlatformTool" PRIVATE
  "WSCrossPlatform"
)

add_library("WorkspaceConfiguration"
  "../../../Sources/WorkspaceConfiguration/Configuration/ContinousIntegrationConfiguration.swift"
  "../../../Sources/WorkspaceConfiguration/Configuration/CustomTask.swift"
  "../../../Sources/WorkspaceConfiguration/Configuration/Documentation/APIDocumentationConfiguration.swift"
  "../../../Sources/WorkspaceConfiguration/Configuration/Documentation/DocumentationConfiguration.swift"
  "../../../Sources/WorkspaceConfiguration/Configuration/Documentation/ReadMeConfiguration.swift"
  "../../../Sources/WorkspaceConfiguration/Configuration/Documentation/RelatedProjectEntry.swift"
  "../../../Sources/WorkspaceConfiguration/Configuration/FileHeaderConfiguration.swift"
  "../../../Sources/WorkspaceConfiguration/Configuration/GitConfiguration.swift"
  "../../../Sources/WorkspaceConfiguration/Configuration/GitHub/GitHubConfiguration.swift"
  "../../../Sources/WorkspaceConfiguration/Configuration/GitHub/IssueTemplate.swift"
  "../../../Sources/WorkspaceConfiguration/Configuration/GitHub/ProvidedIssueTemplate.swift"
  "../../../Sources/WorkspaceConfiguration/Configuration/Licence/Licence.swift"
  "../../../Sources/WorkspaceConfiguration/Configuration/Licence/LicenceConfiguration.swift"
  "../../../Sources/WorkspaceConfiguration/Configuration/Proofreading/ProofreadingConfiguration.swift"
  "../../../Sources/WorkspaceConfiguration/Configuration/Proofreading/ProofreadingRule.swift"
  "../../../Sources/WorkspaceConfiguration/Configuration/Proofreading/ProofreadingRuleCategory.swift"
  "../../../Sources/WorkspaceConfiguration/Configuration/Proofreading/SwiftFormatConfiguration.swift"
  "../../../Sources/WorkspaceConfiguration/Configuration/Proofreading/UnicodeRuleScope.swift"
  "../../../Sources/WorkspaceConfiguration/Configuration/RepositoryConfiguration.swift"
  "../../../Sources/WorkspaceConfiguration/Configuration/Testing/TestCoverageExemptionToken.swift"
  "../../../Sources/WorkspaceConfiguration/Configuration/Testing/TestCoverageExemptionTokenScope.swift"
  "../../../Sources/WorkspaceConfiguration/Configuration/Testing/TestingConfiguration.swift"
  "../../../Sources/WorkspaceConfiguration/Configuration/WorkspaceConfiguration.swift"
  "../../../Sources/WorkspaceConfiguration/Configuration/XcodeConfiguration.swift"
  "../../../Sources/WorkspaceConfiguration/Context/PackageManifest.swift"
  "../../../Sources/WorkspaceConfiguration/Context/Platform.swift"
  "../../../Sources/WorkspaceConfiguration/Context/Product.swift"
  "../../../Sources/WorkspaceConfiguration/Context/ProductType.swift"
  "../../../Sources/WorkspaceConfiguration/Context/WorkspaceContext.swift"
  "../../../Sources/WorkspaceConfiguration/Exports.swift"
  "../../../Sources/WorkspaceConfiguration/General/Array.swift"
  "../../../Sources/WorkspaceConfiguration/General/Dictionary.swift"
  "../../../Sources/WorkspaceConfiguration/General/LazyOption.swift"
  "../../../Sources/WorkspaceConfiguration/General/LocalizationIdentifier.swift"
  "../../../Sources/WorkspaceConfiguration/General/Markdown.swift"
  "../../../Sources/WorkspaceConfiguration/Resources.swift"
)
set_target_properties("WorkspaceConfiguration" PROPERTIES INTERFACE_INCLUDE_DIRECTORIES ${CMAKE_Swift_MODULE_DIRECTORY})
target_compile_options("WorkspaceConfiguration" PRIVATE -enable-testing)
target_link_libraries("WorkspaceConfiguration" PRIVATE
  "WSLocalizations"
  "SDGControlFlow"
  "SDGLogic"
  "SDGCollections"
  "SDGText"
  "SDGPersistence"
  "SDGLocalization"
  "SDGCalendar"
  "SDGVersioning"
  "SDGSwiftConfiguration"
  "SwiftFormatConfiguration"
)

add_executable("WSConfigurationExample"
  "../../../Tests/WSConfigurationExample/main.swift"
)
target_link_libraries("WSConfigurationExample" PRIVATE
  "WorkspaceConfiguration"
  "SDGControlFlow"
)

add_library("WSCustomTask"
  "../../../Sources/WSCustomTask/CustomTask.swift"
)
set_target_properties("WSCustomTask" PROPERTIES INTERFACE_INCLUDE_DIRECTORIES ${CMAKE_Swift_MODULE_DIRECTORY})
target_compile_options("WSCustomTask" PRIVATE -enable-testing)
target_link_libraries("WSCustomTask" PRIVATE
  "WSGeneralImports"
  "WorkspaceConfiguration"
  "SDGSwift"
  "SDGExternalProcess"
)

add_library("WorkspaceProjectConfiguration"
  "../../../Workspace.swift"
)
set_target_properties("WorkspaceProjectConfiguration" PROPERTIES INTERFACE_INCLUDE_DIRECTORIES ${CMAKE_Swift_MODULE_DIRECTORY})
target_compile_options("WorkspaceProjectConfiguration" PRIVATE -enable-testing)
target_link_libraries("WorkspaceProjectConfiguration" PRIVATE
  "WorkspaceConfiguration"
)

add_library("WSProject"
  "../../../Sources/WSProject/BlockCommentSyntax.swift"
  "../../../Sources/WSProject/Copyright.swift"
  "../../../Sources/WSProject/Exports.swift"
  "../../../Sources/WSProject/FileSyntax.swift"
  "../../../Sources/WSProject/FileType.swift"
  "../../../Sources/WSProject/LineCommentSyntax.swift"
  "../../../Sources/WSProject/OperatingSystem.swift"
  "../../../Sources/WSProject/PackageRepository.swift"
  "../../../Sources/WSProject/ProductType.swift"
  "../../../Sources/WSProject/String.swift"
  "../../../Sources/WSProject/TextFile.swift"
  "../../../Sources/WSProject/Version.swift"
  "../../../Sources/WSProject/WorkspaceConfiguration.swift"
)
set_target_properties("WSProject" PROPERTIES INTERFACE_INCLUDE_DIRECTORIES ${CMAKE_Swift_MODULE_DIRECTORY})
target_compile_options("WSProject" PRIVATE -enable-testing)
target_link_libraries("WSProject" PRIVATE
  "WSGeneralImports"
  "WorkspaceConfiguration"
  "WorkspaceProjectConfiguration"
  "SDGCalendar"
  "SDGExternalProcess"
  "SDGVersioning"
  "SDGSwiftPackageManager"
  "SDGSwiftConfigurationLoading"
)

add_library("WSFileHeaders"
  "../../../Sources/WSFileHeaders/PackageRepository.swift"
)
set_target_properties("WSFileHeaders" PROPERTIES INTERFACE_INCLUDE_DIRECTORIES ${CMAKE_Swift_MODULE_DIRECTORY})
target_compile_options("WSFileHeaders" PRIVATE -enable-testing)
target_link_libraries("WSFileHeaders" PRIVATE
  "WSGeneralImports"
  "WSProject"
)

add_library("WSGit"
  "../../../Sources/WSGit/PackageRepository.swift"
)
set_target_properties("WSGit" PROPERTIES INTERFACE_INCLUDE_DIRECTORIES ${CMAKE_Swift_MODULE_DIRECTORY})
target_compile_options("WSGit" PRIVATE -enable-testing)
target_link_libraries("WSGit" PRIVATE
  "WSGeneralImports"
  "WSProject"
)

add_library("WSGitHub"
  "../../../Sources/WSGitHub/PackageRepository.swift"
)
set_target_properties("WSGitHub" PROPERTIES INTERFACE_INCLUDE_DIRECTORIES ${CMAKE_Swift_MODULE_DIRECTORY})
target_compile_options("WSGitHub" PRIVATE -enable-testing)
target_link_libraries("WSGitHub" PRIVATE
  "WSGeneralImports"
  "WSProject"
  "WorkspaceProjectConfiguration"
)

add_library("WSLicence"
  "../../../Sources/WSLicence/Licence.swift"
  "../../../Sources/WSLicence/PackageRepository.swift"
  "../../../Sources/WSLicence/Resources.swift"
)
set_target_properties("WSLicence" PROPERTIES INTERFACE_INCLUDE_DIRECTORIES ${CMAKE_Swift_MODULE_DIRECTORY})
target_compile_options("WSLicence" PRIVATE -enable-testing)
target_link_libraries("WSLicence" PRIVATE
  "WSGeneralImports"
  "WorkspaceConfiguration"
  "WSProject"
)

add_library("WSNormalization"
  "../../../Sources/WSNormalization/Configuration.swift"
  "../../../Sources/WSNormalization/PackageRepository.swift"
)
set_target_properties("WSNormalization" PROPERTIES INTERFACE_INCLUDE_DIRECTORIES ${CMAKE_Swift_MODULE_DIRECTORY})
target_compile_options("WSNormalization" PRIVATE -enable-testing)
target_link_libraries("WSNormalization" PRIVATE
  "WSGeneralImports"
  "WSProject"
  "SwiftFormatConfiguration"
)

add_library("WSParsing"
  "../../../Sources/WSParsing/InterfaceLocalization.swift"
  "../../../Sources/WSParsing/PatternMatch.swift"
)
set_target_properties("WSParsing" PROPERTIES INTERFACE_INCLUDE_DIRECTORIES ${CMAKE_Swift_MODULE_DIRECTORY})
target_compile_options("WSParsing" PRIVATE -enable-testing)
target_link_libraries("WSParsing" PRIVATE
  "WSGeneralImports"
  "WSLocalizations"
  "WSProject"
)

add_library("WSExamples"
  "../../../Sources/WSExamples/PackageRepository.swift"
)
set_target_properties("WSExamples" PROPERTIES INTERFACE_INCLUDE_DIRECTORIES ${CMAKE_Swift_MODULE_DIRECTORY})
target_compile_options("WSExamples" PRIVATE -enable-testing)
target_link_libraries("WSExamples" PRIVATE
  "WSGeneralImports"
  "WSProject"
  "WSParsing"
)

add_library("WSProofreading"
  "../../../Sources/WSProofreading/PackageRepository.swift"
  "../../../Sources/WSProofreading/ProofreadingReporter.swift"
  "../../../Sources/WSProofreading/ProofreadingStatus.swift"
  "../../../Sources/WSProofreading/Reporters/CommandLineProofreadingReporter.swift"
  "../../../Sources/WSProofreading/Reporters/XcodeProofreadingReporter.swift"
  "../../../Sources/WSProofreading/Rule.swift"
  "../../../Sources/WSProofreading/RuleProtocol.swift"
  "../../../Sources/WSProofreading/Rules/Deprecation/DeprecatedTestManifests.swift"
  "../../../Sources/WSProofreading/Rules/Documentation/SyntaxColouring.swift"
  "../../../Sources/WSProofreading/Rules/Functionality/CompatibilityCharacters.swift"
  "../../../Sources/WSProofreading/Rules/Functionality/Mark.swift"
  "../../../Sources/WSProofreading/Rules/Intentional/MissingImplementation.swift"
  "../../../Sources/WSProofreading/Rules/ProofreadingRule.swift"
  "../../../Sources/WSProofreading/Rules/Source Code Style/CalloutCasing.swift"
  "../../../Sources/WSProofreading/Rules/Source Code Style/ClosureSignaturePosition.swift"
  "../../../Sources/WSProofreading/Rules/Source Code Style/ParameterGrouping.swift"
  "../../../Sources/WSProofreading/Rules/Text Style/Unicode.swift"
  "../../../Sources/WSProofreading/SourceLocation.swift"
  "../../../Sources/WSProofreading/SourceRange.swift"
  "../../../Sources/WSProofreading/StyleViolation.swift"
  "../../../Sources/WSProofreading/SyntaxRule.swift"
  "../../../Sources/WSProofreading/SyntaxScanner.swift"
  "../../../Sources/WSProofreading/TextRule.swift"
  "../../../Sources/WSProofreading/Warning.swift"
  "../../../Sources/WSProofreading/Warnings/ManualWarnings.swift"
  "../../../Sources/WSProofreading/Warnings/WorkaroundReminders.swift"
)
set_target_properties("WSProofreading" PROPERTIES INTERFACE_INCLUDE_DIRECTORIES ${CMAKE_Swift_MODULE_DIRECTORY})
target_compile_options("WSProofreading" PRIVATE -enable-testing)
target_link_libraries("WSProofreading" PRIVATE
  "WSGeneralImports"
  "WSProject"
  "WSCustomTask"
  "SDGCollections"
  "SDGExternalProcess"
  "SDGVersioning"
  "SDGSwiftSource"
)

add_library("WSResources"
  "../../../Sources/WSResources/PackageRepository.swift"
  "../../../Sources/WSResources/PackageRepositoryTarget.swift"
)
set_target_properties("WSResources" PROPERTIES INTERFACE_INCLUDE_DIRECTORIES ${CMAKE_Swift_MODULE_DIRECTORY})
target_compile_options("WSResources" PRIVATE -enable-testing)
target_link_libraries("WSResources" PRIVATE
  "WSGeneralImports"
  "WSProject"
  "WSSwift"
  "SDGSwiftPackageManager"
)

add_library("WSScripts"
  "../../../Sources/WSScripts/PackageRepository.swift"
  "../../../Sources/WSScripts/Script.swift"
)
set_target_properties("WSScripts" PROPERTIES INTERFACE_INCLUDE_DIRECTORIES ${CMAKE_Swift_MODULE_DIRECTORY})
target_compile_options("WSScripts" PRIVATE -enable-testing)
target_link_libraries("WSScripts" PRIVATE
  "WSGeneralImports"
  "WSProject"
)

add_library("WSValidation"
  "../../../Sources/WSValidation/Output.swift"
  "../../../Sources/WSValidation/ReportSection.swift"
  "../../../Sources/WSValidation/ValidationStatus.swift"
)
set_target_properties("WSValidation" PROPERTIES INTERFACE_INCLUDE_DIRECTORIES ${CMAKE_Swift_MODULE_DIRECTORY})
target_compile_options("WSValidation" PRIVATE -enable-testing)
target_link_libraries("WSValidation" PRIVATE
  "WSGeneralImports"
  "WSProject"
)

add_library("WSXcode"
  "../../../Sources/WSXcode/PackageRepository.swift"
  "../../../Sources/WSXcode/Resources.swift"
)
set_target_properties("WSXcode" PROPERTIES INTERFACE_INCLUDE_DIRECTORIES ${CMAKE_Swift_MODULE_DIRECTORY})
target_compile_options("WSXcode" PRIVATE -enable-testing)
target_link_libraries("WSXcode" PRIVATE
  "WSGeneralImports"
  "WSProject"
  "WorkspaceProjectConfiguration"
  "SDGXcode"
)

add_library("WSDocumentation"
  "../../../Sources/WSDocumentation/APIElement.swift"
  "../../../Sources/WSDocumentation/CommandInterface.swift"
  "../../../Sources/WSDocumentation/CommandInterfaceInformation.swift"
  "../../../Sources/WSDocumentation/CommandPage.swift"
  "../../../Sources/WSDocumentation/DocumentationStatus.swift"
  "../../../Sources/WSDocumentation/HTML Syntax/ElementSyntax.swift"
  "../../../Sources/WSDocumentation/IndexSectionIdentifier.swift"
  "../../../Sources/WSDocumentation/LocalizationIdentifier.swift"
  "../../../Sources/WSDocumentation/PackageAPI.swift"
  "../../../Sources/WSDocumentation/PackageCLI.swift"
  "../../../Sources/WSDocumentation/PackageInterface.swift"
  "../../../Sources/WSDocumentation/PackageRepository.swift"
  "../../../Sources/WSDocumentation/Page.swift"
  "../../../Sources/WSDocumentation/Resources.swift"
  "../../../Sources/WSDocumentation/Swift Syntax/FunctionParameterSyntax.swift"
  "../../../Sources/WSDocumentation/Swift Syntax/Parameter.swift"
  "../../../Sources/WSDocumentation/Swift Syntax/SyntaxProtocol.swift"
  "../../../Sources/WSDocumentation/Swift Syntax/TupleTypeElementSyntax.swift"
  "../../../Sources/WSDocumentation/Swift Syntax/TypeSyntax.swift"
  "../../../Sources/WSDocumentation/SymbolDocumentation.swift"
  "../../../Sources/WSDocumentation/SymbolPage.swift"
)
set_target_properties("WSDocumentation" PROPERTIES INTERFACE_INCLUDE_DIRECTORIES ${CMAKE_Swift_MODULE_DIRECTORY})
target_compile_options("WSDocumentation" PRIVATE -enable-testing)
target_link_libraries("WSDocumentation" PRIVATE
  "WSGeneralImports"
  "WSProject"
  "WSParsing"
  "WSValidation"
  "WSXcode"
  "WSSwift"
  "SDGExternalProcess"
  "SDGXcode"
  "SDGSwiftSource"
  "SDGExportedCommandLineInterface"
  "SDGHTML"
  "SDGCSS"
)

add_library("WSContinuousIntegration"
  "../../../Sources/WSContinuousIntegration/ContinuousIntegrationJob.swift"
  "../../../Sources/WSContinuousIntegration/PackageGraph.swift"
  "../../../Sources/WSContinuousIntegration/PackageRepository.swift"
  "../../../Sources/WSContinuousIntegration/ResolvedTarget.swift"
)
set_target_properties("WSContinuousIntegration" PROPERTIES INTERFACE_INCLUDE_DIRECTORIES ${CMAKE_Swift_MODULE_DIRECTORY})
target_compile_options("WSContinuousIntegration" PRIVATE -enable-testing)
target_link_libraries("WSContinuousIntegration" PRIVATE
  "WSGeneralImports"
  "WSProject"
  "WSScripts"
  "WSDocumentation"
  "SDGSwiftPackageManager"
  "SDGSwiftSource"
)

add_library("WSOpenSource"
  "../../../Sources/WSOpenSource/PackageRepository.swift"
)
set_target_properties("WSOpenSource" PROPERTIES INTERFACE_INCLUDE_DIRECTORIES ${CMAKE_Swift_MODULE_DIRECTORY})
target_compile_options("WSOpenSource" PRIVATE -enable-testing)
target_link_libraries("WSOpenSource" PRIVATE
  "WSGeneralImports"
  "WSProject"
  "WSExamples"
  "WSDocumentation"
  "SDGSwiftSource"
)

add_library("WSTesting"
  "../../../Sources/WSTesting/ContinuousIntegrationJob.swift"
  "../../../Sources/WSTesting/PackageRepository.swift"
)
set_target_properties("WSTesting" PROPERTIES INTERFACE_INCLUDE_DIRECTORIES ${CMAKE_Swift_MODULE_DIRECTORY})
target_compile_options("WSTesting" PRIVATE -enable-testing)
target_link_libraries("WSTesting" PRIVATE
  "WSGeneralImports"
  "WSProject"
  "WSValidation"
  "WSContinuousIntegration"
  "WSProofreading"
  "SDGExternalProcess"
  "SDGSwiftPackageManager"
  "SDGXcode"
)

add_library("WSInterface"
  "../../../Sources/WSInterface/CheckForUpdates.swift"
  "../../../Sources/WSInterface/Document.swift"
  "../../../Sources/WSInterface/Normalize.swift"
  "../../../Sources/WSInterface/Options/ContinuousIntegrationJob.swift"
  "../../../Sources/WSInterface/Options/Options.swift"
  "../../../Sources/WSInterface/Proofread.swift"
  "../../../Sources/WSInterface/Refresh/Refresh.swift"
  "../../../Sources/WSInterface/Refresh/RefreshAll.swift"
  "../../../Sources/WSInterface/Refresh/RefreshContinuousIntegration.swift"
  "../../../Sources/WSInterface/Refresh/RefreshExamples.swift"
  "../../../Sources/WSInterface/Refresh/RefreshFileHeaders.swift"
  "../../../Sources/WSInterface/Refresh/RefreshGit.swift"
  "../../../Sources/WSInterface/Refresh/RefreshGitHub.swift"
  "../../../Sources/WSInterface/Refresh/RefreshInheritedDocumentation.swift"
  "../../../Sources/WSInterface/Refresh/RefreshLicence.swift"
  "../../../Sources/WSInterface/Refresh/RefreshReadMe.swift"
  "../../../Sources/WSInterface/Refresh/RefreshResources.swift"
  "../../../Sources/WSInterface/Refresh/RefreshScripts.swift"
  "../../../Sources/WSInterface/Refresh/RefreshXcode.swift"
  "../../../Sources/WSInterface/Test.swift"
  "../../../Sources/WSInterface/Validate/Validate.swift"
  "../../../Sources/WSInterface/Validate/ValidateAll.swift"
  "../../../Sources/WSInterface/Validate/ValidateBuild.swift"
  "../../../Sources/WSInterface/Validate/ValidateDocumentationCoverage.swift"
  "../../../Sources/WSInterface/Validate/ValidateTestCoverage.swift"
  "../../../Sources/WSInterface/Workspace.swift"
)
set_target_properties("WSInterface" PROPERTIES INTERFACE_INCLUDE_DIRECTORIES ${CMAKE_Swift_MODULE_DIRECTORY})
target_compile_options("WSInterface" PRIVATE -enable-testing)
target_link_libraries("WSInterface" PRIVATE
  "WSGeneralImports"
  "WorkspaceProjectConfiguration"
  "WSProject"
  "WSValidation"
  "WSScripts"
  "WSGit"
  "WSOpenSource"
  "WSLicence"
  "WSGitHub"
  "WSContinuousIntegration"
  "WSResources"
  "WSFileHeaders"
  "WSExamples"
  "WSNormalization"
  "WSXcode"
  "WSProofreading"
  "WSTesting"
  "WSDocumentation"
  "SDGVersioning"
)

add_library("WSGeneralTestImports"
  "../../../Sources/WSGeneralTestImports/Exports.swift"
)
set_target_properties("WSGeneralTestImports" PROPERTIES INTERFACE_INCLUDE_DIRECTORIES ${CMAKE_Swift_MODULE_DIRECTORY})
target_compile_options("WSGeneralTestImports" PRIVATE -enable-testing)
target_link_libraries("WSGeneralTestImports" PRIVATE
  "WSGeneralImports"
  "WorkspaceConfiguration"
  "WSInterface"
  "SDGPersistenceTestUtilities"
  "SDGLocalizationTestUtilities"
  "SDGXCTestUtilities"
  "SDGCommandLineTestUtilities"
)

add_library("WorkspaceLibrary"
  "../../../Sources/WorkspaceLibrary/Execution.swift"
)
set_target_properties("WorkspaceLibrary" PROPERTIES INTERFACE_INCLUDE_DIRECTORIES ${CMAKE_Swift_MODULE_DIRECTORY})
target_compile_options("WorkspaceLibrary" PRIVATE -enable-testing)
target_link_libraries("WorkspaceLibrary" PRIVATE
  "WSGeneralImports"
  "WorkspaceProjectConfiguration"
  "WSInterface"
)

add_library("WorkspaceLibraryTests"
  "../../../Tests/WorkspaceLibraryTests/APITests.swift"
  "../../../Tests/WorkspaceLibraryTests/FastTestLocalization.swift"
  "../../../Tests/WorkspaceLibraryTests/InternalTests.swift"
  "../../../Tests/WorkspaceLibraryTests/MockCommand.swift"
  "../../../Tests/WorkspaceLibraryTests/MockProject.swift"
  "../../../Tests/WorkspaceLibraryTests/NurDeutsch.swift"
  "../../../Tests/WorkspaceLibraryTests/OnlyBritish.swift"
  "../../../Tests/WorkspaceLibraryTests/RepositoryRoot.swift"
  "../../../Tests/WorkspaceLibraryTests/Test Helpers/Command.Output.swift"
  "../../../Tests/WorkspaceLibraryTests/Test Helpers/CustomTask.swift"
  "../../../Tests/WorkspaceLibraryTests/Test Helpers/WorkspaceConfiguration.swift"
)
set_target_properties("WorkspaceLibraryTests" PROPERTIES INTERFACE_INCLUDE_DIRECTORIES ${CMAKE_Swift_MODULE_DIRECTORY})
target_compile_options("WorkspaceLibraryTests" PRIVATE -enable-testing)
target_link_libraries("WorkspaceLibraryTests" PRIVATE
  "WSGeneralTestImports"
  "WSCustomTask"
  "WorkspaceProjectConfiguration"
  "SDGExternalProcess"
  "SDGCommandLine"
  "SDGHTML"
  "SDGWeb"
)

add_executable("WorkspaceTool"
  "../../../Sources/WorkspaceTool/main.swift"
)
target_link_libraries("WorkspaceTool" PRIVATE
  "WorkspaceLibrary"
)

add_executable(WindowsMain
  WindowsMain.swift
)
target_link_libraries(WindowsMain PRIVATE
  "WSCrossPlatformTests"
  "WorkspaceLibraryTests"
)
add_test(NAME WindowsMain COMMAND WindowsMain)
set_property(TEST WindowsMain PROPERTY ENVIRONMENT "LD_LIBRARY_PATH=${CMAKE_LIBRARY_OUTPUT_DIRECTORY}")
