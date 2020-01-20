

cmake_minimum_required(VERSION 3.15)

project("Workspace" LANGUAGES Swift)

add_library("WSWindowsLibrary"
  "../../../Tests/WSWindowsLibrary/WSWindowsLibrary.swift"
)
set_target_properties(WSWindowsLibrary PROPERTIES INTERFACE_INCLUDE_DIRECTORIES ${CMAKE_CURRENT_BINARY_DIR})
target_compile_options("WSWindowsLibrary" PRIVATE -enable-testing)

add_executable("WSWindowsTool"
  "../../../Tests/WSWindowsTool/main.swift"
)
target_link_libraries("WSWindowsTool" PRIVATE
  "WSWindowsLibrary"
)

add_library("WSWindowsTests"
  "../../../Tests/WSWindowsTests/WSWindowsTests.swift"
)
target_link_libraries("WSWindowsTests" PRIVATE
  "WSWindowsLibrary"
)
