/*
 Resources 2.swift

 This source file is part of the Workspace open source project.
 Diese Quelldatei ist Teil des quelloffenen Arbeitsbereich‐Projekt.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2022 Jeremy David Giesbrecht and the Workspace project contributors.
 Urheberrecht ©2022 Jeremy David Giesbrecht und die Mitwirkenden des Arbeitsbereich‐Projekts.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import Foundation

extension Resources {
  #if os(WASI)
    private static let mitwirkenVorlage0: [UInt8] = [
      0x23, 0x20,
      0x42, 0x65, 0x69, 0x20,
      0x23, 0x70,
      0x61, 0x63, 0x6B, 0x61, 0x67, 0x65, 0x4E, 0x61, 0x6D, 0x65, 0x20,
      0x6D, 0x69, 0x74, 0x77, 0x69, 0x72, 0x6B, 0x65, 0x6E, 0x0A, 0x0A, 0x4A, 0x65, 0x64, 0x65,
      0x72, 0x20,
      0x69, 0x73, 0x74, 0x20,
      0x77, 0x69, 0x6C, 0x6C, 0x6B, 0x6F, 0x6D, 0x6D, 0x65, 0x6E, 0x2C, 0x20,
      0x62, 0x65, 0x69, 0x20,
      0x23, 0x70,
      0x61, 0x63, 0x6B, 0x61, 0x67, 0x65, 0x4E, 0x61, 0x6D, 0x65, 0x20,
      0x6D, 0x69, 0x74, 0x7A, 0x75, 0x77, 0x69, 0x72, 0x6B, 0x65, 0x6E, 0x21, 0x0A, 0x0A, 0x23,
      0x23, 0x20,
      0x53, 0x63, 0x68, 0x72, 0x69, 0x74, 0x74, 0x20,
      0x31, 0x3A, 0x20,
      0x4D, 0x65, 0x6C, 0x64, 0x65, 0x6E, 0x0A, 0x0A, 0x56, 0x6F, 0x6D, 0x20,
      0x6B, 0x65, 0x69, 0x6E, 0x73, 0x74, 0x65, 0x6E, 0x20,
      0x54, 0x69, 0x70,
      0x70,
      0x66, 0x65, 0x68, 0x6C, 0x65, 0x72, 0x20,
      0x62, 0x69, 0x73, 0x20,
      0x7A, 0x75, 0x6D, 0x20,
      0x73, 0x63, 0x68, 0x6C, 0x69, 0x6D, 0x6D, 0x73, 0x74, 0x65, 0x72, 0x20,
      0x41, 0x62, 0x73, 0x74, 0x75, 0x72, 0x7A, 0x2C, 0x20,
      0x6F, 0x62, 0x20,
      0x7A, 0x75, 0x6D, 0x20,
      0x6D, 0x65, 0x6C, 0x64, 0x65, 0x6E, 0x20,
      0x65, 0x69, 0x6E, 0x65, 0x73, 0x20,
      0x46, 0x65, 0x68, 0x6C, 0x65, 0x72, 0x73, 0x20,
      0x6F, 0x64, 0x65, 0x72, 0x20,
      0x7A, 0x75, 0x6D, 0x20,
      0x61, 0x6E, 0x66, 0x6F, 0x72, 0x64, 0x65, 0x72, 0x6E, 0x20,
      0x65, 0x69, 0x6E, 0x65, 0x73, 0x20,
      0x6E, 0x65, 0x75, 0x65, 0x73, 0x20,
      0x4D, 0x65, 0x72, 0x6B, 0x6D, 0x61, 0x6C, 0x73, 0x2C, 0x20,
      0x6F, 0x62, 0x20,
      0x53, 0x69, 0x65, 0x20,
      0x73, 0x63, 0x68, 0x6F, 0x6E, 0x20,
      0x76, 0x6F, 0x6E, 0x20,
      0x65, 0x69, 0x6E, 0x65, 0x72, 0x20,
      0x4C, 0x6F, 0xCC, 0x88, 0x73, 0x75, 0x6E, 0x67, 0x20,
      0x77, 0x65, 0x69, 0xC3, 0x9F, 0x20,
      0x6F, 0x64, 0x65, 0x72, 0x20,
      0x6E, 0x69, 0x63, 0x68, 0x74, 0x2C, 0x20,
      0x62, 0x69, 0x74, 0x74, 0x65, 0x20,
      0x2A, 0x2A, 0x6D, 0x65, 0x6C, 0x64, 0x65, 0x6E, 0x20,
      0x53, 0x69, 0x65, 0x20,
      0x65, 0x73, 0x20,
      0x69, 0x6D, 0x6D, 0x65, 0x72, 0x20,
      0x7A, 0x75, 0x65, 0x72, 0x73, 0x74, 0x20,
      0x61, 0x6E, 0x2A, 0x2A, 0x2E, 0x0A, 0x0A, 0x42, 0x69, 0x74, 0x74, 0x65, 0x20,
      0x73, 0x75, 0x63, 0x68, 0x65, 0x6E, 0x20,
      0x53, 0x69, 0x65, 0x20,
      0x64, 0x69, 0x65, 0x20,
      0x5B, 0x62, 0x65, 0x72, 0x65, 0x69, 0x74, 0x73, 0x20,
      0x62, 0x65, 0x73, 0x74, 0x65, 0x68, 0x65, 0x6E, 0x64, 0x65, 0x20,
      0x54, 0x68, 0x65, 0x6D, 0x65, 0x6E, 0x5D, 0x28, 0x2E, 0x2E, 0x2F, 0x2E, 0x2E, 0x2F, 0x69,
      0x73, 0x73, 0x75, 0x65, 0x73, 0x29, 0x2C, 0x20,
      0x66, 0x61, 0x6C, 0x6C, 0x73, 0x20,
      0x61, 0xCC, 0x88, 0x68, 0x6E, 0x6C, 0x69, 0x63, 0x68, 0x65, 0x73, 0x20,
      0x73, 0x63, 0x68, 0x6F, 0x6E, 0x20,
      0x67, 0x65, 0x6D, 0x65, 0x6C, 0x64, 0x65, 0x74, 0x20,
      0x69, 0x73, 0x74, 0x2E, 0x0A, 0x0A, 0x2D, 0x20,
      0x57, 0x65, 0x6E, 0x6E, 0x20,
      0x65, 0x69, 0x6E, 0x65, 0x20,
      0x61, 0xCC, 0x88, 0x68, 0x6E, 0x6C, 0x69, 0x63, 0x68, 0x65, 0x20,
      0x54, 0x68, 0x65, 0x6D, 0x61, 0x20,
      0x73, 0x63, 0x68, 0x6F, 0x6E, 0x20,
      0x62, 0x65, 0x73, 0x74, 0x65, 0x68, 0x65, 0x74, 0x2C, 0x20,
      0x62, 0x69, 0x74, 0x74, 0x65, 0x20,
      0x6E, 0x65, 0x68, 0x6D, 0x65, 0x6E, 0x20,
      0x53, 0x69, 0x65, 0x20,
      0x74, 0x65, 0x69, 0x6C, 0x20,
      0x69, 0x6E, 0x20,
      0x64, 0x65, 0x6D, 0x20,
      0x47, 0x65, 0x73, 0x70,
      0x72, 0x61, 0xCC, 0x88, 0x63, 0x68, 0x20,
      0x75, 0x6E, 0x64, 0x20,
      0x6D, 0x65, 0x6C, 0x64, 0x65, 0x6E, 0x20,
      0x53, 0x69, 0x65, 0x20,
      0x69, 0x72, 0x67, 0x65, 0x6E, 0x77, 0x65, 0x6C, 0x63, 0x68, 0x65, 0x20,
      0x4E, 0x65, 0x75, 0x69, 0x67, 0x6B, 0x65, 0x69, 0x74, 0x65, 0x6E, 0x20,
      0x64, 0x6F, 0x72, 0x74, 0x2E, 0x0A, 0x2D, 0x20,
      0x53, 0x6F, 0x6E, 0x73, 0x74, 0x20,
      0x6F, 0xCC, 0x88, 0x66, 0x66, 0x6E, 0x65, 0x6E, 0x20,
      0x53, 0x69, 0x65, 0x20,
      0x65, 0x69, 0x6E, 0x65, 0x20,
      0x5B, 0x6E, 0x65, 0x75, 0x65, 0x20,
      0x54, 0x68, 0x65, 0x6D, 0x61, 0x5D, 0x28, 0x2E, 0x2E, 0x2F, 0x2E, 0x2E, 0x2F, 0x69, 0x73,
      0x73, 0x75, 0x65, 0x73, 0x2F, 0x6E, 0x65, 0x77, 0x29, 0x2E, 0x0A, 0x0A, 0x53, 0x65, 0x6C,
      0x62, 0x73, 0x74, 0x20,
      0x77, 0x65, 0x6E, 0x6E, 0x20,
      0x53, 0x69, 0x65, 0x20,
      0x64, 0x69, 0x65, 0x20,
      0x4C, 0x6F, 0xCC, 0x88, 0x73, 0x75, 0x6E, 0x67, 0x20,
      0x7A, 0x75, 0x20,
      0x68, 0x61, 0x62, 0x65, 0x6E, 0x20,
      0x67, 0x6C, 0x61, 0x75, 0x62, 0x65, 0x6E, 0x2C, 0x20,
      0x62, 0x69, 0x74, 0x74, 0x65, 0x20,
      0x2A, 0x2A, 0x66, 0x61, 0x6E, 0x67, 0x65, 0x6E, 0x20,
      0x53, 0x69, 0x65, 0x20,
      0x6E, 0x69, 0x63, 0x68, 0x74, 0x20,
      0x61, 0x6E, 0x2A, 0x2A, 0x20,
      0x62, 0x69, 0x73, 0x20,
      0x53, 0x69, 0x65, 0x20,
      0x76, 0x6F, 0x6E, 0x20,
      0x65, 0x69, 0x6E, 0x65, 0x6D, 0x20,
      0x64, 0x65, 0x72, 0x20,
      0x56, 0x65, 0x72, 0x77, 0x61, 0x6C, 0x74, 0x65, 0x72, 0x20,
      0x67, 0x65, 0x68, 0x6F, 0xCC, 0x88, 0x72, 0x74, 0x20,
      0x68, 0x61, 0x62, 0x65, 0x6E, 0x2E, 0x20,
      0x53, 0x6F, 0x20,
      0x6B, 0x6F, 0xCC, 0x88, 0x6E, 0x6E, 0x65, 0x6E, 0x20,
      0x53, 0x69, 0x65, 0x20,
      0x73, 0x69, 0x63, 0x68, 0x20,
      0x41, 0x72, 0x62, 0x65, 0x69, 0x74, 0x20,
      0x73, 0x70,
      0x61, 0x72, 0x65, 0x6E, 0x2C, 0x20,
      0x77, 0x65, 0x6E, 0x6E, 0x20,
      0x73, 0x6F, 0x6E, 0x73, 0x74, 0x20,
      0x6A, 0x65, 0x6D, 0x61, 0x6E, 0x64, 0x20,
      0x64, 0x61, 0x73, 0x20,
      0x73, 0x65, 0x6C, 0x62, 0x65, 0x20,
      0x73, 0x63, 0x68, 0x6F, 0x6E, 0x20,
      0x61, 0x6E, 0x67, 0x65, 0x66, 0x61, 0x6E, 0x67, 0x65, 0x6E, 0x20,
      0x68, 0x61, 0x74, 0x2C, 0x20,
      0x6F, 0x64, 0x65, 0x72, 0x20,
      0x77, 0x65, 0x6E, 0x6E, 0x20,
      0x65, 0x6E, 0x74, 0x73, 0x63, 0x68, 0x69, 0x65, 0x64, 0x65, 0x6E, 0x20,
      0x77, 0x69, 0x72, 0x64, 0x2C, 0x20,
      0x64, 0x61, 0x73, 0x73, 0x20,
      0x49, 0x68, 0x72, 0x65, 0x20,
      0x49, 0x64, 0x65, 0x65, 0x20,
      0x73, 0x69, 0x63, 0x68, 0x20,
      0x64, 0x6F, 0x63, 0x68, 0x20,
      0x61, 0x75, 0xC3, 0x9F, 0x65, 0x72, 0x68, 0x61, 0x6C, 0x62, 0x20,
      0x64, 0x65, 0x72, 0x20,
      0x50,
      0x72, 0x6F, 0x6A, 0x65, 0x6B, 0x74, 0x7A, 0x69, 0x65, 0x6C, 0x65, 0x20,
      0x62, 0x65, 0x66, 0x69, 0x6E, 0x64, 0x65, 0x74, 0x2E, 0x0A, 0x0A, 0x23, 0x23, 0x20,
      0x53, 0x63, 0x68, 0x72, 0x69, 0x74, 0x74, 0x20,
      0x32, 0x3A, 0x20,
      0x41, 0x62, 0x7A, 0x77, 0x65, 0x69, 0x67, 0x65, 0x6E, 0x0A, 0x0A, 0x4E, 0x61, 0x63, 0x68,
      0x64, 0x65, 0x6D, 0x20,
      0x53, 0x69, 0x65, 0x20,
      0x49, 0x68, 0x72, 0x65, 0x20,
      0x49, 0x64, 0x65, 0x65, 0x20,
      0x5B, 0x67, 0x65, 0x6D, 0x65, 0x6C, 0x64, 0x65, 0x74, 0x5D, 0x28, 0x23, 0x73, 0x63, 0x68,
      0x72, 0x69, 0x74, 0x74, 0x2D, 0x31, 0x2D, 0x6D, 0x65, 0x6C, 0x64, 0x65, 0x6E, 0x29, 0x20,
      0x68, 0x61, 0x62, 0x65, 0x6E, 0x20,
      0x75, 0x6E, 0x64, 0x20,
      0x65, 0x69, 0x6E, 0x20,
      0x56, 0x65, 0x72, 0x77, 0x61, 0x6C, 0x74, 0x65, 0x72, 0x20,
      0x49, 0x68, 0x6E, 0x65, 0x6E, 0x20,
      0x65, 0x69, 0x6E, 0x20,
      0x67, 0x72, 0x75, 0xCC, 0x88, 0x6E, 0x65, 0x73, 0x20,
      0x4C, 0x69, 0x63, 0x68, 0x74, 0x20,
      0x67, 0x65, 0x67, 0x65, 0x62, 0x65, 0x6E, 0x20,
      0x68, 0x61, 0x74, 0x2C, 0x20,
      0x66, 0x6F, 0x6C, 0x67, 0x65, 0x6E, 0x20,
      0x53, 0x69, 0x65, 0x20,
      0x64, 0x69, 0x65, 0x73, 0x65, 0x20,
      0x53, 0x63, 0x68, 0x72, 0x69, 0x74, 0x74, 0x65, 0x20,
      0x75, 0x6D, 0x20,
      0x65, 0x69, 0x6E, 0x65, 0x20,
      0x6C, 0x6F, 0x6B, 0x61, 0x6C, 0x65, 0x20,
      0x4B, 0x6F, 0x70,
      0x69, 0x65, 0x20,
      0x7A, 0x75, 0x20,
      0x68, 0x65, 0x72, 0x7A, 0x75, 0x73, 0x74, 0x65, 0x6C, 0x6C, 0x65, 0x6E, 0x2C, 0x20,
      0x64, 0x69, 0x65, 0x20,
      0x53, 0x69, 0x65, 0x20,
      0x76, 0x65, 0x72, 0x61, 0x72, 0x62, 0x65, 0x69, 0x74, 0x65, 0x6E, 0x20,
      0x6B, 0x6F, 0xCC, 0x88, 0x6E, 0x6E, 0x65, 0x6E, 0x2E, 0x0A, 0x0A, 0x31, 0x2E, 0x20,
      0x2A, 0x2A, 0x44, 0x61, 0x73, 0x20,
      0x4C, 0x61, 0x67, 0x65, 0x72, 0x20,
      0x28, 0x2A, 0x72, 0x65, 0x70,
      0x6F, 0x73, 0x69, 0x74, 0x6F, 0x72, 0x79, 0x2A, 0x29, 0x20,
      0x61, 0x75, 0x66, 0x73, 0x70,
      0x61, 0x6C, 0x74, 0x65, 0x6E, 0x20,
      0x28, 0x2A, 0x66, 0x6F, 0x72, 0x6B, 0x2A, 0x29, 0x2A, 0x2A, 0x2E, 0x20,
      0x41, 0x75, 0x66, 0x20,
      0xE2, 0x80,
      0x9E, 0x46, 0x6F, 0x72, 0x6B, 0xE2, 0x80,
      0x9C, 0x20,
      0x6F, 0x62, 0x65, 0x6E, 0x20,
      0x72, 0x65, 0x63, 0x68, 0x74, 0x73, 0x20,
      0x61, 0x75, 0x66, 0x20,
      0x64, 0x65, 0x72, 0x20,
      0x4C, 0x61, 0x67, 0x65, 0x72, 0x73, 0x65, 0x69, 0x74, 0x65, 0x20,
      0x6B, 0x6C, 0x69, 0x63, 0x6B, 0x65, 0x6E, 0x2E, 0x20,
      0x28, 0x44, 0x69, 0x65, 0x73, 0x65, 0x6E, 0x20,
      0x53, 0x63, 0x68, 0x72, 0x69, 0x74, 0x74, 0x20,
      0x75, 0xCC, 0x88, 0x62, 0x65, 0x72, 0x73, 0x70,
      0x72, 0x69, 0x6E, 0x67, 0x65, 0x6E, 0x2C, 0x20,
      0x77, 0x65, 0x6E, 0x6E, 0x20,
      0x73, 0x69, 0x65, 0x20,
      0x73, 0x63, 0x68, 0x6F, 0x6E, 0x20,
      0x53, 0x63, 0x68, 0x72, 0x65, 0x69, 0x62, 0x7A, 0x75, 0x67, 0x72, 0x69, 0x66, 0x66, 0x20,
      0x68, 0x61, 0x62, 0x65, 0x6E, 0x2E, 0x29, 0x0A, 0x32, 0x2E, 0x20,
      0x2A, 0x2A, 0x45, 0x69, 0x6E, 0x65, 0x6E, 0x20,
      0x6C, 0x6F, 0x6B, 0x61, 0x6C, 0x65, 0x6E, 0x20,
      0x4E, 0x61, 0x63, 0x68, 0x62, 0x61, 0x75, 0x20,
      0x28, 0x2A, 0x63, 0x6C, 0x6F, 0x6E, 0x65, 0x2A, 0x29, 0x20,
      0x65, 0x72, 0x73, 0x74, 0x65, 0x6C, 0x6C, 0x65, 0x6E, 0x2A, 0x2A, 0x2E, 0x23, 0x63, 0x6C,
      0x6F, 0x6E, 0x65, 0x53, 0x63, 0x72, 0x69, 0x70,
      0x74, 0x0A, 0x33, 0x2E, 0x20,
      0x2A, 0x2A, 0x45, 0x69, 0x6E, 0x65, 0x6E, 0x20,
      0x45, 0x6E, 0x74, 0x77, 0x69, 0x63, 0x6B, 0x6C, 0x75, 0x6E, 0x67, 0x73, 0x7A, 0x77, 0x65,
      0x69, 0x67, 0x20,
      0x28, 0x2A, 0x62, 0x72, 0x61, 0x6E, 0x63, 0x68, 0x2A, 0x29, 0x20,
      0x65, 0x72, 0x73, 0x74, 0x65, 0x6C, 0x6C, 0x65, 0x6E, 0x2A, 0x2A, 0x2E, 0x20,
      0x60,
      0x67, 0x69, 0x74, 0x20,
      0x63, 0x68, 0x65, 0x63, 0x6B, 0x6F, 0x75, 0x74, 0x20,
      0x2D, 0x62, 0x20,
      0x69, 0x67, 0x72, 0x65, 0x6E, 0x64, 0x77, 0x65, 0x6C, 0x63, 0x68, 0x65, 0x72, 0xE2, 0x80,
      0x90,
      0x6E, 0x65, 0x75, 0x65, 0x72, 0xE2, 0x80,
      0x90,
      0x7A, 0x77, 0x65, 0x69, 0x67, 0x6E, 0x61, 0x6D, 0x65, 0x60,
      0x0A, 0x34, 0x2E, 0x20,
      0x2A, 0x2A, 0x44, 0x65, 0x6E, 0x20,
      0x41, 0x72, 0x62, 0x65, 0x69, 0x74, 0x73, 0x62, 0x65, 0x72, 0x65, 0x69, 0x63, 0x68, 0x20,
      0x61, 0x75, 0x66, 0x73, 0x74, 0x65, 0x6C, 0x6C, 0x65, 0x6E, 0x2A, 0x2A, 0x2E, 0x20,
      0x41, 0x75, 0x66, 0x20,
      0x60,
      0x52, 0x65, 0x66, 0x72, 0x65, 0x73, 0x68, 0x60,
      0x20,
      0x28, 0x2A, 0x61, 0x75, 0x66, 0x66, 0x72, 0x69, 0x73, 0x63, 0x68, 0x65, 0x6E, 0x2A, 0x29,
      0x20,
      0x69, 0x6E, 0x20,
      0x64, 0x65, 0x72, 0x20,
      0x4C, 0x61, 0x67, 0x65, 0x72, 0x77, 0x75, 0x72, 0x7A, 0x65, 0x6C, 0x20,
      0x64, 0x6F, 0x70,
      0x70,
      0x65, 0x6C, 0x6B, 0x6C, 0x69, 0x63, 0x6B, 0x65, 0x6E, 0x2E, 0x20,
      0x28, 0x57, 0x65, 0x6E, 0x6E, 0x20,
      0x49, 0x68, 0x72, 0x20,
      0x53, 0x79, 0x73, 0x74, 0x65, 0x6D, 0x20,
      0x73, 0x6F, 0x20,
      0x65, 0x69, 0x6E, 0x67, 0x65, 0x73, 0x74, 0x65, 0x6C, 0x6C, 0x74, 0x20,
      0x69, 0x73, 0x74, 0x2C, 0x20,
      0x64, 0x61, 0x73, 0x73, 0x20,
      0x65, 0x73, 0x20,
      0x64, 0x61, 0x73, 0x20,
      0x2A, 0x56, 0x65, 0x72, 0x61, 0x72, 0x62, 0x65, 0x69, 0x74, 0x65, 0x6E, 0x2A, 0x20,
      0x76, 0x6F, 0x6E, 0x20,
      0x53, 0x6B, 0x72, 0x69, 0x70,
      0x74, 0x73, 0x20,
      0x62, 0x65, 0x76, 0x6F, 0x72, 0x7A, 0x75, 0x67, 0x74, 0x2C, 0x20,
      0x61, 0x6E, 0x73, 0x74, 0x61, 0x74, 0x74, 0x20,
      0x64, 0x61, 0x73, 0x20,
      0x2A, 0x41, 0x75, 0x73, 0x66, 0x75, 0xCC, 0x88, 0x68, 0x72, 0x65, 0x6E, 0x2A, 0x2C, 0x20,
      0x64, 0x61, 0x6E, 0x6E, 0x20,
      0x6D, 0x75, 0xCC, 0x88, 0x73, 0x73, 0x65, 0x6E, 0x20,
      0x53, 0x69, 0x65, 0x20,
      0x76, 0x69, 0x65, 0x6C, 0x6C, 0x65, 0x69, 0x63, 0x68, 0x74, 0x20,
      0x73, 0x74, 0x61, 0x74, 0x74, 0x64, 0x65, 0x73, 0x73, 0x65, 0x6E, 0x20,
      0x64, 0x61, 0x73, 0x20,
      0x53, 0x6B, 0x72, 0x69, 0x70,
      0x74, 0x20,
      0x69, 0x6E, 0x20,
      0x65, 0x69, 0x6E, 0x65, 0x6D, 0x20,
      0x54, 0x65, 0x72, 0x6D, 0x69, 0x6E, 0x61, 0x6C, 0x20,
      0x61, 0x75, 0x73, 0x66, 0x75, 0xCC, 0x88, 0x68, 0x72, 0x65, 0x6E, 0x2E, 0x29, 0x0A, 0x0A,
      0x4A, 0x65, 0x74, 0x7A, 0x74, 0x20,
      0x73, 0x69, 0x6E, 0x64, 0x20,
      0x53, 0x69, 0x65, 0x20,
      0x62, 0x65, 0x72, 0x65, 0x69, 0x74, 0x2C, 0x20,
      0x49, 0x68, 0x72, 0x65, 0x20,
      0x49, 0x64, 0x65, 0x65, 0x20,
      0x7A, 0x75, 0x20,
      0x70,
      0x72, 0x6F, 0x62, 0x69, 0x65, 0x72, 0x65, 0x6E, 0x2E, 0x0A, 0x0A, 0x23, 0x23, 0x20,
      0x53, 0x63, 0x68, 0x72, 0x69, 0x74, 0x74, 0x20,
      0x33, 0x3A, 0x20,
      0x45, 0x69, 0x6E, 0x72, 0x65, 0x69, 0x63, 0x68, 0x65, 0x6E, 0x0A, 0x0A, 0x4E, 0x61, 0x63,
      0x68, 0x64, 0x65, 0x6D, 0x20,
      0x49, 0x68, 0x72, 0x65, 0x20,
      0x49, 0x64, 0x65, 0x65, 0x20,
      0x67, 0x75, 0x74, 0x20,
      0x66, 0x75, 0x6E, 0x6B, 0x74, 0x69, 0x6F, 0x6E, 0x69, 0x65, 0x72, 0x74, 0x2C, 0x20,
      0x66, 0x6F, 0x6C, 0x67, 0x65, 0x6E, 0x20,
      0x53, 0x69, 0x65, 0x20,
      0x64, 0x69, 0x65, 0x73, 0x65, 0x20,
      0x53, 0x63, 0x68, 0x72, 0x69, 0x74, 0x74, 0x65, 0x20,
      0x75, 0x6D, 0x20,
      0x49, 0x68, 0x72, 0x65, 0x20,
      0x41, 0xCC, 0x88, 0x6E, 0x64, 0x65, 0x72, 0x75, 0x6E, 0x67, 0x65, 0x6E, 0x20,
      0x65, 0x69, 0x6E, 0x7A, 0x75, 0x72, 0x65, 0x69, 0x63, 0x68, 0x65, 0x6E, 0x2E, 0x0A, 0x0A,
      0x31, 0x2E, 0x20,
      0x2A, 0x2A, 0x49, 0x68, 0x72, 0x65, 0x20,
      0x41, 0xCC, 0x88, 0x6E, 0x64, 0x65, 0x72, 0x75, 0x6E, 0x67, 0x65, 0x6E, 0x20,
      0x75, 0xCC, 0x88, 0x62, 0x65, 0x72, 0x70,
      0x72, 0x75, 0xCC, 0x88, 0x66, 0x65, 0x6E, 0x2A, 0x2A, 0x2E, 0x20,
      0x41, 0x75, 0x66, 0x20,
      0x60,
      0x56, 0x61, 0x6C, 0x69, 0x64, 0x61, 0x74, 0x65, 0x60,
      0x20,
      0x69, 0x6E, 0x20,
      0x64, 0x65, 0x72, 0x20,
      0x4C, 0x61, 0x67, 0x65, 0x72, 0x77, 0x75, 0x72, 0x7A, 0x65, 0x6C, 0x20,
      0x64, 0x6F, 0x70,
      0x70,
      0x65, 0x6C, 0x6B, 0x6C, 0x69, 0x63, 0x6B, 0x65, 0x6E, 0x2E, 0x0A, 0x32, 0x2E, 0x20,
      0x2A, 0x2A, 0x49, 0x68, 0x72, 0x65, 0x20,
      0x41, 0xCC, 0x88, 0x6E, 0x64, 0x65, 0x72, 0x75, 0x6E, 0x67, 0x65, 0x6E, 0x20,
      0x75, 0xCC, 0x88, 0x62, 0x65, 0x72, 0x67, 0x65, 0x62, 0x65, 0x6E, 0x20,
      0x28, 0x2A, 0x63, 0x6F, 0x6D, 0x6D, 0x69, 0x74, 0x2A, 0x29, 0x2A, 0x2A, 0x2E, 0x20,
      0x60,
      0x67, 0x69, 0x74, 0x20,
      0x63, 0x6F, 0x6D, 0x6D, 0x69, 0x74, 0x20,
      0x2D, 0x6D, 0x20,
      0x22, 0x49, 0x72, 0x67, 0x65, 0x6E, 0x64, 0x77, 0x65, 0x6C, 0x63, 0x68, 0x65, 0x20,
      0x42, 0x65, 0x73, 0x63, 0x68, 0x72, 0x65, 0x69, 0x62, 0x75, 0x6E, 0x67, 0x20,
      0x64, 0x65, 0x72, 0x20,
      0x41, 0xCC, 0x88, 0x6E, 0x64, 0x65, 0x72, 0x75, 0x6E, 0x67, 0x65, 0x6E, 0x2E, 0x22, 0x60,
      0x0A, 0x33, 0x2E, 0x20,
      0x2A, 0x2A, 0x49, 0x68, 0x72, 0x65, 0x20,
      0x41, 0xCC, 0x88, 0x6E, 0x64, 0x65, 0x72, 0x75, 0x6E, 0x67, 0x65, 0x6E, 0x20,
      0x73, 0x74, 0x6F, 0xC3, 0x9F, 0x65, 0x6E, 0x20,
      0x28, 0x2A, 0x70,
      0x75, 0x73, 0x68, 0x2A, 0x29, 0x2A, 0x2A, 0x2E, 0x20,
      0x60,
      0x67, 0x69, 0x74, 0x20,
      0x70,
      0x75, 0x73, 0x68, 0x60,
      0x0A, 0x34, 0x2E, 0x20,
      0x2A, 0x2A, 0x45, 0x69, 0x6E, 0x65, 0x20,
      0x41, 0x62, 0x7A, 0x69, 0x65, 0x68, 0x75, 0x6E, 0x67, 0x73, 0x61, 0x6E, 0x66, 0x6F, 0x72,
      0x64, 0x65, 0x72, 0x75, 0x6E, 0x67, 0x20,
      0x28, 0x2A, 0x70,
      0x75, 0x6C, 0x6C, 0x20,
      0x72, 0x65, 0x71, 0x75, 0x65, 0x73, 0x74, 0x2A, 0x29, 0x2A, 0x2A, 0x2E, 0x20,
      0xE2, 0x80,
      0x9E, 0x4E, 0x65, 0x77, 0x20,
      0x50,
      0x75, 0x6C, 0x6C, 0x20,
      0x52, 0x65, 0x71, 0x75, 0x65, 0x73, 0x74, 0xE2, 0x80,
      0x9C, 0x20,
      0x69, 0x6E, 0x20,
      0x64, 0x65, 0x72, 0x20,
      0x5A, 0x77, 0x65, 0x69, 0x67, 0x6C, 0x69, 0x73, 0x74, 0x65, 0x20,
      0x62, 0x65, 0x69, 0x20,
      0x47, 0x69, 0x74, 0x48, 0x75, 0x62, 0x2E, 0x0A, 0x35, 0x2E, 0x20,
      0x2A, 0x2A, 0x41, 0x75, 0x66, 0x20,
      0x64, 0x69, 0x65, 0x20,
      0x75, 0xCC, 0x88, 0x62, 0x65, 0x72, 0x70,
      0x72, 0x75, 0xCC, 0x88, 0x66, 0x75, 0x6E, 0x67, 0x20,
      0x64, 0x65, 0x72, 0x20,
      0x66, 0x6F, 0x72, 0x74, 0x6C, 0x61, 0x75, 0x66, 0x65, 0x6E, 0x64, 0x65, 0x6E, 0x20,
      0x45, 0x69, 0x6E, 0x62, 0x69, 0x6E, 0x64, 0x75, 0x6E, 0x67, 0x20,
      0x28, 0x2A, 0x63, 0x6F, 0x6E, 0x74, 0x69, 0x6E, 0x75, 0x6F, 0x75, 0x73, 0x20,
      0x69, 0x6E, 0x74, 0x65, 0x67, 0x72, 0x61, 0x74, 0x69, 0x6F, 0x6E, 0x2A, 0x29, 0x20,
      0x77, 0x61, 0x72, 0x74, 0x65, 0x6E, 0x2A, 0x2A, 0x2E, 0x0A, 0x36, 0x2E, 0x20,
      0x2A, 0x2A, 0x45, 0x69, 0x6E, 0x65, 0x20,
      0x42, 0x65, 0x77, 0x65, 0x72, 0x74, 0x75, 0x6E, 0x67, 0x20,
      0x28, 0x2A, 0x72, 0x65, 0x76, 0x69, 0x65, 0x77, 0x2A, 0x29, 0x20,
      0x76, 0x6F, 0x6E, 0x20,
      0x23, 0x61, 0x64, 0x6D, 0x69, 0x6E, 0x69, 0x73, 0x74, 0x72, 0x61, 0x74, 0x6F, 0x72, 0x73,
      0x20,
      0x61, 0x6E, 0x66, 0x6F, 0x72, 0x64, 0x65, 0x72, 0x6E, 0x2A, 0x2A, 0x2E, 0x20,
      0x41, 0x75, 0x66, 0x20,
      0x64, 0x65, 0x6E, 0x20,
      0x5A, 0x61, 0x68, 0x6E, 0x72, 0x61, 0x64, 0x20,
      0x6F, 0x62, 0x65, 0x6E, 0x20,
      0x72, 0x65, 0x63, 0x68, 0x74, 0x73, 0x20,
      0x61, 0x75, 0x66, 0x20,
      0x64, 0x65, 0x72, 0x20,
      0x53, 0x65, 0x69, 0x74, 0x65, 0x20,
      0x64, 0x65, 0x72, 0x20,
      0x41, 0x62, 0x7A, 0x69, 0x65, 0x68, 0x75, 0x6E, 0x67, 0x73, 0x61, 0x6E, 0x66, 0x6F, 0x72,
      0x64, 0x65, 0x72, 0x75, 0x6E, 0x67, 0x20,
      0x6B, 0x6C, 0x69, 0x63, 0x6B, 0x65, 0x6E, 0x2E, 0x0A,
    ]
    internal static var mitwirkenVorlage: String {
      return String(
        data: Data(([mitwirkenVorlage0] as [[UInt8]]).lazy.joined()),
        encoding: String.Encoding.utf8
      )!
    }
  #else
    internal static var mitwirkenVorlage: String {
      return String(
        data: try! Data(
          contentsOf: moduleBundle.url(forResource: "Mitwirken Vorlage", withExtension: "txt")!,
          options: [.mappedIfSafe]
        ),
        encoding: String.Encoding.utf8
      )!
    }
  #endif
}
