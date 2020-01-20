

cmake_minimum_required(VERSION 3.15)

project("Workspace" LANGUAGES Swift)

add_library("WSWindowsLibrary"
  "../../../Tests/WSWindowsLibrary/WSWindowsLibrary.swift"
)
target_compile_options("WSWindowsLibrary" PUBLIC -enable-testing)

add_executable("WSWindowsTool"
  "../../../Tests/WSWindowsTool/main.swift"
)
target_link_libraries("WSWindowsTool"
  "WSWindowsLibrary"
)

add_library("WSWindowsTests"
  "../../../Tests/WSWindowsTests/WSWindowsTests.swift"
)
target_link_libraries("WSWindowsTests"
  "WSWindowsLibrary"
)
