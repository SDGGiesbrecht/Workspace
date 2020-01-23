

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

add_executable("WindowsMain"
  "WindowsMain.swift"
)
target_link_libraries("WindowsMain" PRIVATE
  "WSWindowsTests"
)
add_test(NAME "WindowsMain" COMMAND "WindowsMain")
set_property(TEST "WindowsMain" PROPERTY ENVIRONMENT "LD_LIBRARY_PATH=${CMAKE_LIBRARY_OUTPUT_DIRECTORY}")
