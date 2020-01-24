

cmake_minimum_required(VERSION 3.15)

project("AllTasks" LANGUAGES Swift)

include(CTest)

set(CMAKE_Swift_MODULE_DIRECTORY ${CMAKE_BINARY_DIR}/swift)
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib)
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib)
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin)

option(BUILD_SHARED_LIBS "Use dynamic linking" YES)

add_library("AllTasks"
  "../../../Sources/AllTasks/AllTasks.swift"
)
set_target_properties("AllTasks" PROPERTIES INTERFACE_INCLUDE_DIRECTORIES ${CMAKE_Swift_MODULE_DIRECTORY})
target_compile_options("AllTasks" PRIVATE -enable-testing)

add_library("AllTasksTests"
  "../../../Tests/AllTasksTests/AllTasksTests.swift"
  "../../../Tests/AllTasksTests/XCTestManifests.swift"
)
set_target_properties("AllTasksTests" PROPERTIES INTERFACE_INCLUDE_DIRECTORIES ${CMAKE_Swift_MODULE_DIRECTORY})
target_compile_options("AllTasksTests" PRIVATE -enable-testing)
target_link_libraries("AllTasksTests" PRIVATE
  "AllTasks"
)

add_executable(WindowsMain
  WindowsMain.swift
)
target_link_libraries(WindowsMain PRIVATE
  "AllTasksTests"
)
add_test(NAME WindowsMain COMMAND WindowsMain)
set_property(TEST WindowsMain PROPERTY ENVIRONMENT "LD_LIBRARY_PATH=${CMAKE_LIBRARY_OUTPUT_DIRECTORY}")
