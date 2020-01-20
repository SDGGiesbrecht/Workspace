

cmake_minimum_required(VERSION 3.15)

project("Workspace" LANGUAGES Swift)

add_library("WSWindowsLibrary"
  "../../../Tests/WSWindowsLibrary/WSWindowsLibrary.swift"
)
