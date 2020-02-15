

cmake_minimum_required(VERSION 3.15)

project("Workspace" LANGUAGES Swift C)

include(CTest)

set(CMAKE_Swift_MODULE_DIRECTORY ${CMAKE_BINARY_DIR}/swift)
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib)
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib)
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin)

option(BUILD_SHARED_LIBS "Use dynamic linking" YES)

add_library("WSWindowsC"
  "../../../Tests/WSWindowsC/WSWindowsC.c"
)
set_target_properties("WSWindowsC" PROPERTIES INTERFACE_INCLUDE_DIRECTORIES ${CMAKE_Swift_MODULE_DIRECTORY})
target_compile_options("WSWindowsC" PRIVATE -enable-testing)

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
set_target_properties("WSWindowsTests" PROPERTIES INTERFACE_INCLUDE_DIRECTORIES ${CMAKE_Swift_MODULE_DIRECTORY}
    ../../../Tests/WSWindowsC/include
)
target_compile_options("WSWindowsTests" PRIVATE -enable-testing)
target_link_libraries("WSWindowsTests" PRIVATE
  "WSWindowsLibrary"
  "WSWindowsC"
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
  "WSWindowsTests"
)
add_test(NAME WindowsMain COMMAND WindowsMain)
set_property(TEST WindowsMain PROPERTY ENVIRONMENT "LD_LIBRARY_PATH=${CMAKE_LIBRARY_OUTPUT_DIRECTORY}")
