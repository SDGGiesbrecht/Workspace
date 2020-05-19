/*
 Resources.swift

 This source file is part of the Workspace open source project.
 Diese Quelldatei ist Teil des quelloffenen Arbeitsbereich‐Projekt.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2018–2020 Jeremy David Giesbrecht and the Workspace project contributors.
 Urheberrecht ©2018–2020 Jeremy David Giesbrecht und die Mitwirkenden des Arbeitsbereich‐Projekts.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import Foundation

internal enum Resources {}
internal typealias Ressourcen = Resources

extension Resources {
  static let proofreadScheme = String(
    data: Data(
      base64Encoded:
        "PCEtLQogUHJvb2ZyZWFkIFNjaGVtZS54Y3NjaGVtZQoKIFRoaXMgc291cmNlIGZpbGUgaXMgcGFydCBvZiB0aGUgV29ya3NwYWNlIG9wZW4gc291cmNlIHByb2plY3QuCiBEaWVzZSBRdWVsbGRhdGVpIGlzdCBUZWlsIGRlcyBxdWVsbG9mZmVuZW4gQXJiZWl0c2JlcmVpY2jigJBQcm9qZWt0LgogaHR0cHM6Ly9naXRodWIuY29tL1NER0dpZXNicmVjaHQvV29ya3NwYWNlI3dvcmtzcGFjZQoKIENvcHlyaWdodCDCqTIwMTjigJMyMDIwIEplcmVteSBEYXZpZCBHaWVzYnJlY2h0IGFuZCB0aGUgV29ya3NwYWNlIHByb2plY3QgY29udHJpYnV0b3JzLgogVXJoZWJlcnJlY2h0IMKpMjAxOOKAkzIwMjAgSmVyZW15IERhdmlkIEdpZXNicmVjaHQgdW5kIGRpZSBNaXR3aXJrZW5kZW4gZGVzIEFyYmVpdHNiZXJlaWNo4oCQUHJvamVrdHMuCgogU29saSBEZW8gZ2xvcmlhLgoKIExpY2Vuc2VkIHVuZGVyIHRoZSBBcGFjaGUgTGljZW5jZSwgVmVyc2lvbiAyLjAuCiBTZWUgaHR0cDovL3d3dy5hcGFjaGUub3JnL2xpY2Vuc2VzL0xJQ0VOU0UtMi4wIGZvciBsaWNlbmNlIGluZm9ybWF0aW9uLgogLS0+Cgo8P3htbCB2ZXJzaW9uPSIxLjAiIGVuY29kaW5nPSJVVEYtOCI/Pgo8U2NoZW1lCiAgIExhc3RVcGdyYWRlVmVyc2lvbiA9ICIxMDAwIgogICB2ZXJzaW9uID0gIjEuMyI+CiAgIDxCdWlsZEFjdGlvbj4KICAgICAgPEJ1aWxkQWN0aW9uRW50cmllcz4KICAgICAgICAgPEJ1aWxkQWN0aW9uRW50cnk+CiAgICAgICAgICAgIDxCdWlsZGFibGVSZWZlcmVuY2UKICAgICAgICAgICAgICAgQnVpbGRhYmxlSWRlbnRpZmllciA9ICJwcmltYXJ5IgogICAgICAgICAgICAgICBCbHVlcHJpbnRJZGVudGlmaWVyID0gIldPUktTUEFDRV9QUk9PRlJFQURfVEFSR0VUIgogICAgICAgICAgICAgICBCdWlsZGFibGVOYW1lID0gIlByb29mcmVhZCIKICAgICAgICAgICAgICAgQmx1ZXByaW50TmFtZSA9ICJQcm9vZnJlYWQiCiAgICAgICAgICAgICAgIFJlZmVyZW5jZWRDb250YWluZXIgPSAiY29udGFpbmVyOlsqcHJvamVjdCpdIj4KICAgICAgICAgICAgPC9CdWlsZGFibGVSZWZlcmVuY2U+CiAgICAgICAgIDwvQnVpbGRBY3Rpb25FbnRyeT4KICAgICAgPC9CdWlsZEFjdGlvbkVudHJpZXM+CiAgIDwvQnVpbGRBY3Rpb24+CjwvU2NoZW1lPgo="
    )!,
    encoding: String.Encoding.utf8
  )!

}