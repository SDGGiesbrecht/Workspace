

cmake_minimum_required(VERSION 3.15)

project("ContinuousIntegrationWithoutScripts" LANGUAGES Swift)

include(CTest)

set(CMAKE_Swift_MODULE_DIRECTORY ${CMAKE_BINARY_DIR}/swift)
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib)
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib)
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin)

option(BUILD_SHARED_LIBS "Use dynamic linking" YES)

add_library("ContinuousIntegrationWithoutScripts"
  "../../../Sources/ContinuousIntegrationWithoutScripts/ContinuousIntegrationWithoutScripts.swift"
)
set_target_properties("ContinuousIntegrationWithoutScripts" PROPERTIES INTERFACE_INCLUDE_DIRECTORIES ${CMAKE_Swift_MODULE_DIRECTORY})
target_compile_options("ContinuousIntegrationWithoutScripts" PRIVATE -enable-testing)

add_library("ContinuousIntegrationWithoutScriptsTests"
  "../../../Tests/ContinuousIntegrationWithoutScriptsTests/ContinuousIntegrationWithoutScriptsTests.swift"
  "../../../Tests/ContinuousIntegrationWithoutScriptsTests/XCTestManifests.swift"
)
set_target_properties("ContinuousIntegrationWithoutScriptsTests" PROPERTIES INTERFACE_INCLUDE_DIRECTORIES ${CMAKE_Swift_MODULE_DIRECTORY})
target_compile_options("ContinuousIntegrationWithoutScriptsTests" PRIVATE -enable-testing)
target_link_libraries("ContinuousIntegrationWithoutScriptsTests" PRIVATE
  "ContinuousIntegrationWithoutScripts"
)

add_executable(WindowsMain
  WindowsMain.swift
)
target_link_libraries(WindowsMain PRIVATE
  "ContinuousIntegrationWithoutScriptsTests"
)
add_test(NAME WindowsMain COMMAND WindowsMain)
set_property(TEST WindowsMain PROPERTY ENVIRONMENT "LD_LIBRARY_PATH=${CMAKE_LIBRARY_OUTPUT_DIRECTORY}")
