

cmake_minimum_required(VERSION 3.15)

project("Workspace" LANGUAGES Swift)

add_library("WSWindowsLibrary" SHARED
  "../../../Tests/WSWindowsLibrary/WSWindowsLibrary.swift"
)
target_compile_options("WSWindowsLibrary" PUBLIC -enable-testing)
set_target_properties(WSWindowsLibrary PROPERTIES INTERFACE_INCLUDE_DIRECTORIES ${CMAKE_CURRENT_BINARY_DIR})

add_executable("WSWindowsTool"
  "../../../Tests/WSWindowsTool/main.swift"
)
target_link_libraries("WSWindowsTool"
  "WSWindowsLibrary"
)

add_library("WSWindowsTests" SHARED
  "../../../Tests/WSWindowsTests/WSWindowsTests.swift"
)
target_link_libraries("WSWindowsTests"
  "WSWindowsLibrary"
)
