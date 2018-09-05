/*
 PackageResources.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2018 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

/// Workspace can embed resources in Swift package targets.
///
/// ```shell
/// $ workspace refresh resources
/// ```
///
/// Workspace will find and embed any file located within a project’s `Resources` directory. The structure of the `Resources` directory reflects the targets and namespaces under which the resources will be available in Swift code. Immediate subdirectories must correspond to targets; optional deeper nested directories produce namespaces. For example, a project with the following file...
///
/// ```text
/// Resources/MyLibrary/Templates/Basic Template.txt
/// ```
/// ...can use the file from within the `MyLibrary` target like this...
///
/// ```swift
/// let template: String = Resoures.Templates.basicTemplate
/// print(template)
/// ```
///
/// By default, files are embedded as `Data`, but some file extensions will be recognized and given a more specific Swift type (such as `.txt` embedded as `String`).
public enum PackageResources {}
