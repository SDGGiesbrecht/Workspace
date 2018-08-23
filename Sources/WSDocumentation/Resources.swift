/*
 Resources.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2018 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import Foundation

internal enum Resources {}

extension Resources {
    static let page = String(data: Data(base64Encoded: "PCFET0NUWVBFIGh0bWw+Cgo8IS0tCiBQYWdlLmh0bWwKCiBUaGlzIHNvdXJjZSBmaWxlIGlzIHBhcnQgb2YgdGhlIFdvcmtzcGFjZSBvcGVuIHNvdXJjZSBwcm9qZWN0LgogaHR0cHM6Ly9naXRodWIuY29tL1NER0dpZXNicmVjaHQvV29ya3NwYWNlI3dvcmtzcGFjZQoKIENvcHlyaWdodCDCqTIwMTggSmVyZW15IERhdmlkIEdpZXNicmVjaHQgYW5kIHRoZSBXb3Jrc3BhY2UgcHJvamVjdCBjb250cmlidXRvcnMuCgogU29saSBEZW8gZ2xvcmlhLgoKIExpY2Vuc2VkIHVuZGVyIHRoZSBBcGFjaGUgTGljZW5jZSwgVmVyc2lvbiAyLjAuCiBTZWUgaHR0cDovL3d3dy5hcGFjaGUub3JnL2xpY2Vuc2VzL0xJQ0VOU0UtMi4wIGZvciBsaWNlbmNlIGluZm9ybWF0aW9uLgogLS0+Cgo8aHRtbCBkaXI9IlsqdGV4dCBkaXJlY3Rpb24qXSIgbGFuZz0iWypsb2NhbGl6YXRpb24qXSI+CiA8aGVhZD4KICA8bWV0YSBjaGFyc2V0PSJ1dGYtOCI+CiAgPHRpdGxlPlsqdGl0bGUqXTwvdGl0bGU+CiAgPGxpbmsgcmVsPSJzdHlsZXNoZWV0IiBocmVmPSJbKnNpdGUgcm9vdCpdQ1NTL1Jvb3QuY3NzIj4KICA8bGluayByZWw9InN0eWxlc2hlZXQiIGhyZWY9Ilsqc2l0ZSByb290Kl1DU1MvU2l0ZS5jc3MiPgogPC9oZWFkPgogPGJvZHk+CiAgPG1haW4+CgogICBbKnN5bWJvbCB0eXBlKl0KICAgPGgxPlsqdGl0bGUqXTwvaDE+CgpbKmNvbnRlbnQqXQoKICA8L21haW4+CiA8L2JvZHk+CjwvaHRtbD4K")!, encoding: String.Encoding.utf8)!
    static let redirect = String(data: Data(base64Encoded: "PCFET0NUWVBFIGh0bWw+Cgo8IS0tCiBSZWRpcmVjdC5odG1sCgogVGhpcyBzb3VyY2UgZmlsZSBpcyBwYXJ0IG9mIHRoZSBXb3Jrc3BhY2Ugb3BlbiBzb3VyY2UgcHJvamVjdC4KIGh0dHBzOi8vZ2l0aHViLmNvbS9TREdHaWVzYnJlY2h0L1dvcmtzcGFjZSN3b3Jrc3BhY2UKCiBDb3B5cmlnaHQgwqkyMDE4IEplcmVteSBEYXZpZCBHaWVzYnJlY2h0IGFuZCB0aGUgV29ya3NwYWNlIHByb2plY3QgY29udHJpYnV0b3JzLgoKIFNvbGkgRGVvIGdsb3JpYS4KCiBMaWNlbnNlZCB1bmRlciB0aGUgQXBhY2hlIExpY2VuY2UsIFZlcnNpb24gMi4wLgogU2VlIGh0dHA6Ly93d3cuYXBhY2hlLm9yZy9saWNlbnNlcy9MSUNFTlNFLTIuMCBmb3IgbGljZW5jZSBpbmZvcm1hdGlvbi4KIC0tPgoKPGh0bWwgbGFuZz0ienh4Ij4KIDxoZWFkPgogIDxtZXRhIGNoYXJzZXQ9InV0Zi04Ij4KICA8dGl0bGU+4oazIC4uLzwvdGl0bGU+CiAgPGxpbmsgcmVsPSJjYW5vbmljYWwiIGhyZWY9IlsqdGFyZ2V0Kl0iLz4KICA8bWV0YSBodHRwLWVxdWl2PSJyZWZyZXNoIiBjb250ZW50PSIwOyB1cmw9Wyp0YXJnZXQqXSIgLz4KIDwvaGVhZD4KIDxib2R5PgogIDxwPuKGsyA8YSBocmVmPSJbKnRhcmdldCpdIj4uLi88L2E+CiA8L2JvZHk+CjwvaHRtbD4K")!, encoding: String.Encoding.utf8)!
    static let root = String(data: Data(base64Encoded: "LyoKIFJvb3QuY3NzCgogVGhpcyBzb3VyY2UgZmlsZSBpcyBwYXJ0IG9mIHRoZSBXb3Jrc3BhY2Ugb3BlbiBzb3VyY2UgcHJvamVjdC4KIGh0dHBzOi8vZ2l0aHViLmNvbS9TREdHaWVzYnJlY2h0L1dvcmtzcGFjZSN3b3Jrc3BhY2UKCiBDb3B5cmlnaHQgwqkyMDE4IEplcmVteSBEYXZpZCBHaWVzYnJlY2h0IGFuZCB0aGUgV29ya3NwYWNlIHByb2plY3QgY29udHJpYnV0b3JzLgoKIFNvbGkgRGVvIGdsb3JpYS4KCiBMaWNlbnNlZCB1bmRlciB0aGUgQXBhY2hlIExpY2VuY2UsIFZlcnNpb24gMi4wLgogU2VlIGh0dHA6Ly93d3cuYXBhY2hlLm9yZy9saWNlbnNlcy9MSUNFTlNFLTIuMCBmb3IgbGljZW5jZSBpbmZvcm1hdGlvbi4KICovCgovKiBMYXlvdXQgKi8KCmh0bWwsIGJvZHkgewogICAgbWFyZ2luOiAwOwogICAgcGFkZGluZzogMDsKfQoKLyogQ29sb3VycyAqLwoKaHRtbCB7CiAgICBiYWNrZ3JvdW5kLWNvbG9yOiAjRkZGRkZGOwogICAgY29sb3I6ICMwMDAwMDA7Cn0KCi8qIEZvbnRzICovCgpAbWVkaWEgcHJpbnQgewogICAgaHRtbCB7CiAgICAgICAgZm9udC1mYW1pbHk6IHNlcmlmOwogICAgfQp9CkBtZWRpYSBzY3JlZW4gewogICAgaHRtbCB7CiAgICAgICAgZm9udC1mYW1pbHk6IHNhbnMtc2VyaWY7CiAgICB9Cn0K")!, encoding: String.Encoding.utf8)!
    static let site = String(data: Data(base64Encoded: "LyoKIFNpdGUuY3NzCgogVGhpcyBzb3VyY2UgZmlsZSBpcyBwYXJ0IG9mIHRoZSBXb3Jrc3BhY2Ugb3BlbiBzb3VyY2UgcHJvamVjdC4KIGh0dHBzOi8vZ2l0aHViLmNvbS9TREdHaWVzYnJlY2h0L1dvcmtzcGFjZSN3b3Jrc3BhY2UKCiBDb3B5cmlnaHQgwqkyMDE4IEplcmVteSBEYXZpZCBHaWVzYnJlY2h0IGFuZCB0aGUgV29ya3NwYWNlIHByb2plY3QgY29udHJpYnV0b3JzLgoKIFNvbGkgRGVvIGdsb3JpYS4KCiBMaWNlbnNlZCB1bmRlciB0aGUgQXBhY2hlIExpY2VuY2UsIFZlcnNpb24gMi4wLgogU2VlIGh0dHA6Ly93d3cuYXBhY2hlLm9yZy9saWNlbnNlcy9MSUNFTlNFLTIuMCBmb3IgbGljZW5jZSBpbmZvcm1hdGlvbi4KICovCgovKiBMYXlvdXQgKi8KCiosICo6YmVmb3JlLCAqOmFmdGVyIHsKICAgIGJveC1zaXppbmc6IGluaGVyaXQ7Cn0KaHRtbCB7CiAgICBib3gtc2l6aW5nOiBib3JkZXItYm94Owp9CgpoMSB7CiAgICBtYXJnaW4tdG9wOiAycmVtOwogICAgbWFyZ2luLWJvdHRvbTogMS41cmVtOwp9CgouZGVzY3JpcHRpb24gewogICAgbWFyZ2luLWJvdHRvbTogMnJlbTsKfQouZGVzY3JpcHRpb24gcCB7CiAgICBtYXJnaW46IDA7Cn0KCi8qIENvbG91cnMgKi8KCmh0bWwgewogICAgY29sb3I6ICMzMzMzMzM7Cn0KYSB7CiAgICBjb2xvcjogIzAwNzBDOTsKfQoKLyogRm9udHMgKi8KCmh0bWwgewogICAgZm9udC1mYW1pbHk6ICJTRiBQcm8gVGV4dCIsICJTRiBQcm8gSWNvbnMiLCAiSGVsdmV0aWNhIE5ldWUiLCAiSGVsdmV0aWNhIiwgIkFyaWFsIiwgc2Fucy1zZXJpZjsKICAgIGZvbnQtc2l6ZTogMTA2LjI1JTsKICAgIGxldHRlci1zcGFjaW5nOiAtMC4wMjFlbTsKICAgIGxpbmUtaGVpZ2h0OiAxLjUyOTQ3Owp9CgphOmxpbmssIGE6dmlzaXRlZCB7CiAgICB0ZXh0LWRlY29yYXRpb246IG5vbmU7Cn0KYTpob3ZlciB7CiAgICB0ZXh0LWRlY29yYXRpb246IHVuZGVybGluZTsKfQoKaDEgewogICAgZm9udC1mYW1pbHk6ICJTRiBQcm8gRGlzcGxheSIsICJTRiBQcm8gSWNvbnMiLCAiSGVsdmV0aWNhIE5ldWUiLCAiSGVsdmV0aWNhIiwgIkFyaWFsIiwgc2Fucy1zZXJpZjsKICAgIGZvbnQtc2l6ZTogY2FsYygoNDAgLyAxNykgKiAxcmVtKTsKICAgIGZvbnQtd2VpZ2h0OiA1MDA7CiAgICBsZXR0ZXItc3BhY2luZzogMC4wMDhlbTsKICAgIGxpbmUtaGVpZ2h0OiAxLjA1Owp9CgouZGVzY3JpcHRpb24gewogICAgZm9udC1mYW1pbHk6ICJTRiBQcm8gRGlzcGxheSIsICJTRiBQcm8gSWNvbnMiLCAiSGVsdmV0aWNhIE5ldWUiLCAiSGVsdmV0aWNhIiwgIkFyaWFsIiwgc2Fucy1zZXJpZjsKICAgIGZvbnQtc2l6ZTogY2FsYygoMjIgLyAxNykgKiAxcmVtKTsKICAgIGZvbnQtd2VpZ2h0OiAzMDA7CiAgICBsZXR0ZXItc3BhY2luZzogMC4wMTZlbTsKICAgIGxpbmUtaGVpZ2h0OiAxLjQ1NDU1Owp9Cg==")!, encoding: String.Encoding.utf8)!

}
