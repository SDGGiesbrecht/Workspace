

cmake_minimum_required(VERSION 3.15)

project("Workspace" LANGUAGES Swift)

include(CTest)

set(CMAKE_Swift_MODULE_DIRECTORY ${CMAKE_BINARY_DIR}/swift)
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib)
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib)
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin)

option(BUILD_SHARED_LIBS "Use dynamic linking" YES)

add_library("WSWindowsLibrary"
  "../../../Tests/WSWindowsLibrary/WSWindowsLibrary.swift"
)
set_target_properties("WSWindowsLibrary" PROPERTIES INTERFACE_INCLUDE_DIRECTORIES ${CMAKE_Swift_MODULE_DIRECTORY})
target_compile_options("WSWindowsLibrary" PRIVATE -enable-testing)

add_executable("WSWindowsTests"
  "../../../Tests/WSWindowsTests/WSWindowsTests.swift"
)
target_link_libraries("WSWindowsTests" PRIVATE
  "WSWindowsLibrary"
)
add_test(NAME "WSWindowsTests" COMMAND "WSWindowsTests")
set_property(TEST "WSWindowsTests" PROPERTY ENVIRONMENT "LD_LIBRARY_PATH=${CMAKE_BINARY_DIR}/lib")

add_executable("WSWindowsTool"
  "../../../Tests/WSWindowsTool/main.swift"
)
target_link_libraries("WSWindowsTool" PRIVATE
  "WSWindowsLibrary"
)
