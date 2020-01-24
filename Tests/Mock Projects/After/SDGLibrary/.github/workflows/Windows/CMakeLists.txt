

cmake_minimum_required(VERSION 3.15)

project("SDG" LANGUAGES Swift)

include(CTest)

set(CMAKE_Swift_MODULE_DIRECTORY ${CMAKE_BINARY_DIR}/swift)
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib)
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib)
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin)

option(BUILD_SHARED_LIBS "Use dynamic linking" YES)

add_library("Dependency"
  "../../../.build/SDG/Dependencies/Dependency/Sources/Dependency/Dependency.swift"
)
set_target_properties("Dependency" PROPERTIES INTERFACE_INCLUDE_DIRECTORIES ${CMAKE_Swift_MODULE_DIRECTORY})
target_compile_options("Dependency" PRIVATE -enable-testing)

add_library("Library"
  "../../../Sources/Library/Resources.swift"
  "../../../Sources/Library/SDG.swift"
)
set_target_properties("Library" PROPERTIES INTERFACE_INCLUDE_DIRECTORIES ${CMAKE_Swift_MODULE_DIRECTORY})
target_compile_options("Library" PRIVATE -enable-testing)
target_link_libraries("Library" PRIVATE
  "Dependency"
)

add_library("SDGTests"
  "../../../Tests/SDGTests/Resources.swift"
  "../../../Tests/SDGTests/SDGTests.swift"
)
set_target_properties("SDGTests" PROPERTIES INTERFACE_INCLUDE_DIRECTORIES ${CMAKE_Swift_MODULE_DIRECTORY})
target_compile_options("SDGTests" PRIVATE -enable-testing)
target_link_libraries("SDGTests" PRIVATE
  "Library"
)

add_executable(WindowsMain
  WindowsMain.swift
)
target_link_libraries(WindowsMain PRIVATE
  "SDGTests"
)
add_test(NAME WindowsMain COMMAND WindowsMain)
set_property(TEST WindowsMain PROPERTY ENVIRONMENT "LD_LIBRARY_PATH=${CMAKE_LIBRARY_OUTPUT_DIRECTORY}")
