// Package.swift
//
// This source file is part of the Workspace open source project.
//
// Copyright ©2017 Jeremy David Giesbrecht and the Workspace contributors.
//
// Soli Deo gloria
//
// Licensed under the Apache License, Version 2.0
// See http://www.apache.org/licenses/LICENSE-2.0 for licence information.

import PackageDescription

let package = Package(
    name: "Workspace",
    dependencies: [
        .Package(url: "https://github.com/SDGGiesbrecht/SDGCaching", versions: "1.0.0" ..< "2.0.0"),
        
        .Package(url: "https://github.com/SDGGiesbrecht/SDGLogic", versions: "1.1.0" ..< "2.0.0"),
        .Package(url: "https://github.com/SDGGiesbrecht/SDGMathematics", versions: "1.0.1" ..< "2.0.0"),
    ]
)
