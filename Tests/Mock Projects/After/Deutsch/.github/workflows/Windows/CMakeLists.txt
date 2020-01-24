

cmake_minimum_required(VERSION 3.15)

project("Deutsch" LANGUAGES Swift)

include(CTest)

set(CMAKE_Swift_MODULE_DIRECTORY ${CMAKE_BINARY_DIR}/swift)
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib)
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib)
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin)

option(BUILD_SHARED_LIBS "Use dynamic linking" YES)

add_library("Deutsch"
  "../../../Sources/Deutsch/Deutsch.swift"
)
set_target_properties("Deutsch" PROPERTIES INTERFACE_INCLUDE_DIRECTORIES ${CMAKE_Swift_MODULE_DIRECTORY})
target_compile_options("Deutsch" PRIVATE -enable-testing)

add_library("DeutschTests"
  "../../../Tests/DeutschTests/DeutschTests.swift"
  "../../../Tests/DeutschTests/XCTestManifests.swift"
)
set_target_properties("DeutschTests" PROPERTIES INTERFACE_INCLUDE_DIRECTORIES ${CMAKE_Swift_MODULE_DIRECTORY})
target_compile_options("DeutschTests" PRIVATE -enable-testing)
target_link_libraries("DeutschTests" PRIVATE
  "Deutsch"
)

add_executable("werkzeug"
  "../../../Sources/werkzeug/main.swift"
)

add_executable(WindowsMain
  WindowsMain.swift
)
target_link_libraries(WindowsMain PRIVATE
  "DeutschTests"
)
add_test(NAME WindowsMain COMMAND WindowsMain)
set_property(TEST WindowsMain PROPERTY ENVIRONMENT "LD_LIBRARY_PATH=${CMAKE_LIBRARY_OUTPUT_DIRECTORY}")
