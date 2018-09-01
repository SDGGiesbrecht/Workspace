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
    static let page = String(data: Data(base64Encoded: "PCFET0NUWVBFIGh0bWw+Cgo8IS0tCiBQYWdlLmh0bWwKCiBUaGlzIHNvdXJjZSBmaWxlIGlzIHBhcnQgb2YgdGhlIFdvcmtzcGFjZSBvcGVuIHNvdXJjZSBwcm9qZWN0LgogaHR0cHM6Ly9naXRodWIuY29tL1NER0dpZXNicmVjaHQvV29ya3NwYWNlI3dvcmtzcGFjZQoKIENvcHlyaWdodCDCqTIwMTggSmVyZW15IERhdmlkIEdpZXNicmVjaHQgYW5kIHRoZSBXb3Jrc3BhY2UgcHJvamVjdCBjb250cmlidXRvcnMuCgogU29saSBEZW8gZ2xvcmlhLgoKIExpY2Vuc2VkIHVuZGVyIHRoZSBBcGFjaGUgTGljZW5jZSwgVmVyc2lvbiAyLjAuCiBTZWUgaHR0cDovL3d3dy5hcGFjaGUub3JnL2xpY2Vuc2VzL0xJQ0VOU0UtMi4wIGZvciBsaWNlbmNlIGluZm9ybWF0aW9uLgogLS0+Cgo8aHRtbCBkaXI9IlsqdGV4dCBkaXJlY3Rpb24qXSIgbGFuZz0iWypsb2NhbGl6YXRpb24qXSI+CiA8aGVhZD4KICA8bWV0YSBjaGFyc2V0PSJ1dGYmI3gwMDJEOzgiPgogIDx0aXRsZT5bKnRpdGxlKl08L3RpdGxlPgogIDxsaW5rIHJlbD0ic3R5bGVzaGVldCIgaHJlZj0iWypzaXRlIHJvb3QqXUNTUy9Sb290LmNzcyI+CiAgPGxpbmsgcmVsPSJzdHlsZXNoZWV0IiBocmVmPSJbKnNpdGUgcm9vdCpdQ1NTL1N3aWZ0LmNzcyI+CiAgPGxpbmsgcmVsPSJzdHlsZXNoZWV0IiBocmVmPSJbKnNpdGUgcm9vdCpdQ1NTL1NpdGUuY3NzIj4KICA8c2NyaXB0IHNyYz0iWypzaXRlIHJvb3QqXUphdmFTY3JpcHQvU2l0ZS5qcyI+PC9zY3JpcHQ+CiA8L2hlYWQ+CiA8Ym9keT4KICA8aGVhZGVyIGNsYXNzPSJuYXZpZ2F0aW9u4oCQYmFyIj4KICAgPG5hdiBjbGFzcz0ibmF2aWdhdGlvbuKAkGJhciI+CiAgICA8ZGl2IGNsYXNzPSJuYXZpZ2F0aW9u4oCQcGF0aCIgZGlyPSJbKnRleHQgZGlyZWN0aW9uKl0iPgoKWypuYXZpZ2F0aW9uIHBhdGgqXQoKICAgIDwvZGl2PgogICAgPGRpdj4KICAgICBbKnBhY2thZ2UgaW1wb3J0Kl0KICAgIDwvZGl2PgogICA8L25hdj4KICA8L2hlYWRlcj4KICA8ZGl2IGNsYXNzPSJjb250ZW504oCQY29udGFpbmVyIj4KICAgPGhlYWRlciBjbGFzcz0iaW5kZXgiPgogICAgPG5hdiBjbGFzcz0iaW5kZXgiPgoKWyppbmRleCpdCgogICAgPC9uYXY+CiAgIDwvaGVhZGVyPgogICA8bWFpbj4KICAgIDxkaXYgY2xhc3M9InRpdGxlIj4KICAgICBbKnN5bWJvbCB0eXBlKl0KICAgICBbKmNvbXBpbGF0aW9uIGNvbmRpdGlvbnMqXQogICAgIDxoMT5bKnRpdGxlKl08L2gxPgogICAgPC9kaXY+CgpbKmNvbnRlbnQqXQoKICAgPC9tYWluPgogIDwvZGl2PgogIDxmb290ZXIgZGlyPSJbKnRleHQgZGlyZWN0aW9uKl0iPgogICBbKmNvcHlyaWdodCpdCiAgIFsqd29ya3NwYWNlKl0KICA8L2Zvb3Rlcj4KICA8c2NyaXB0PmNvbnRyYWN0SW5kZXgoKTs8L3NjcmlwdD4KIDwvYm9keT4KPC9odG1sPgo=")!, encoding: String.Encoding.utf8)!
    static let redirect = String(data: Data(base64Encoded: "PCFET0NUWVBFIGh0bWw+Cgo8IS0tCiBSZWRpcmVjdC5odG1sCgogVGhpcyBzb3VyY2UgZmlsZSBpcyBwYXJ0IG9mIHRoZSBXb3Jrc3BhY2Ugb3BlbiBzb3VyY2UgcHJvamVjdC4KIGh0dHBzOi8vZ2l0aHViLmNvbS9TREdHaWVzYnJlY2h0L1dvcmtzcGFjZSN3b3Jrc3BhY2UKCiBDb3B5cmlnaHQgwqkyMDE4IEplcmVteSBEYXZpZCBHaWVzYnJlY2h0IGFuZCB0aGUgV29ya3NwYWNlIHByb2plY3QgY29udHJpYnV0b3JzLgoKIFNvbGkgRGVvIGdsb3JpYS4KCiBMaWNlbnNlZCB1bmRlciB0aGUgQXBhY2hlIExpY2VuY2UsIFZlcnNpb24gMi4wLgogU2VlIGh0dHA6Ly93d3cuYXBhY2hlLm9yZy9saWNlbnNlcy9MSUNFTlNFLTIuMCBmb3IgbGljZW5jZSBpbmZvcm1hdGlvbi4KIC0tPgoKPGh0bWwgbGFuZz0ienh4Ij4KIDxoZWFkPgogIDxtZXRhIGNoYXJzZXQ9InV0Zi04Ij4KICA8dGl0bGU+4oazIC4uLzwvdGl0bGU+CiAgPGxpbmsgcmVsPSJjYW5vbmljYWwiIGhyZWY9IlsqdGFyZ2V0Kl0iLz4KICA8bWV0YSBodHRwLWVxdWl2PSJyZWZyZXNoIiBjb250ZW50PSIwOyB1cmw9Wyp0YXJnZXQqXSIgLz4KIDwvaGVhZD4KIDxib2R5PgogIDxwPuKGsyA8YSBocmVmPSJbKnRhcmdldCpdIj4uLi88L2E+CiA8L2JvZHk+CjwvaHRtbD4K")!, encoding: String.Encoding.utf8)!
    static let root = String(data: Data(base64Encoded: "LyoKIFJvb3QuY3NzCgogVGhpcyBzb3VyY2UgZmlsZSBpcyBwYXJ0IG9mIHRoZSBXb3Jrc3BhY2Ugb3BlbiBzb3VyY2UgcHJvamVjdC4KIGh0dHBzOi8vZ2l0aHViLmNvbS9TREdHaWVzYnJlY2h0L1dvcmtzcGFjZSN3b3Jrc3BhY2UKCiBDb3B5cmlnaHQgwqkyMDE4IEplcmVteSBEYXZpZCBHaWVzYnJlY2h0IGFuZCB0aGUgV29ya3NwYWNlIHByb2plY3QgY29udHJpYnV0b3JzLgoKIFNvbGkgRGVvIGdsb3JpYS4KCiBMaWNlbnNlZCB1bmRlciB0aGUgQXBhY2hlIExpY2VuY2UsIFZlcnNpb24gMi4wLgogU2VlIGh0dHA6Ly93d3cuYXBhY2hlLm9yZy9saWNlbnNlcy9MSUNFTlNFLTIuMCBmb3IgbGljZW5jZSBpbmZvcm1hdGlvbi4KICovCgovKiBMYXlvdXQgKi8KCmh0bWwsIGJvZHkgewogICAgbWFyZ2luOiAwOwogICAgcGFkZGluZzogMDsKfQoKLyogQ29sb3VycyAqLwoKaHRtbCB7CiAgICBiYWNrZ3JvdW5kLWNvbG9yOiAjRkZGRkZGOwogICAgY29sb3I6ICMwMDAwMDA7Cn0KCi8qIEZvbnRzICovCgpAbWVkaWEgcHJpbnQgewogICAgaHRtbCB7CiAgICAgICAgZm9udC1mYW1pbHk6IHNlcmlmOwogICAgfQp9CkBtZWRpYSBzY3JlZW4gewogICAgaHRtbCB7CiAgICAgICAgZm9udC1mYW1pbHk6IHNhbnMtc2VyaWY7CiAgICB9Cn0KCnNwYW5bbGFuZ10gewogICAgZm9udC1zdHlsZTogaXRhbGljOwp9Cg==")!, encoding: String.Encoding.utf8)!
    static let script = String(data: Data(base64Encoded: "LyoKIFNjcmlwdC5qcwoKIFRoaXMgc291cmNlIGZpbGUgaXMgcGFydCBvZiB0aGUgV29ya3NwYWNlIG9wZW4gc291cmNlIHByb2plY3QuCiBodHRwczovL2dpdGh1Yi5jb20vU0RHR2llc2JyZWNodC9Xb3Jrc3BhY2Ujd29ya3NwYWNlCgogQ29weXJpZ2h0IMKpMjAxOCBKZXJlbXkgRGF2aWQgR2llc2JyZWNodCBhbmQgdGhlIFdvcmtzcGFjZSBwcm9qZWN0IGNvbnRyaWJ1dG9ycy4KCiBTb2xpIERlbyBnbG9yaWEuCgogTGljZW5zZWQgdW5kZXIgdGhlIEFwYWNoZSBMaWNlbmNlLCBWZXJzaW9uIDIuMC4KIFNlZSBodHRwOi8vd3d3LmFwYWNoZS5vcmcvbGljZW5zZXMvTElDRU5TRS0yLjAgZm9yIGxpY2VuY2UgaW5mb3JtYXRpb24uCiAqLwoKZnVuY3Rpb24gdG9nZ2xlTGlua1Zpc2liaWxpdHkobGluaykgewogICAgaWYgKGxpbmsuaGFzQXR0cmlidXRlKCJzdHlsZSIpKSB7CiAgICAgICAgbGluay5yZW1vdmVBdHRyaWJ1dGUoInN0eWxlIik7CiAgICB9IGVsc2UgewogICAgICAgIGxpbmsuc3R5bGVbInBhZGRpbmctdG9wIl0gPSAwOwogICAgICAgIGxpbmsuc3R5bGVbInBhZGRpbmctYm90dG9tIl0gPSAwOwogICAgICAgIGxpbmsuc3R5bGUuaGVpZ2h0ID0gMDsKICAgIH0KfQoKZnVuY3Rpb24gdG9nZ2xlSW5kZXhTZWN0aW9uVmlzaWJpbGl0eShzZW5kZXIpIHsKICAgIHZhciBzZWN0aW9uID0gc2VuZGVyLnBhcmVudEVsZW1lbnQ7CiAgICB2YXIgbGlua3MgPSBzZWN0aW9uLmNoaWxkcmVuCiAgICBmb3IgKHZhciBsaW5rSW5kZXggPSAxOyBsaW5rSW5kZXggPCBsaW5rcy5sZW5ndGg7IGxpbmtJbmRleCsrKSB7CiAgICAgICAgdmFyIGxpbmsgPSBsaW5rc1tsaW5rSW5kZXhdCiAgICAgICAgdG9nZ2xlTGlua1Zpc2liaWxpdHkobGluaykKICAgIH0KfQoKZnVuY3Rpb24gY29udHJhY3RJbmRleCgpIHsKICAgIHZhciBpbmRleEVsZW1lbnRzID0gZG9jdW1lbnQuZ2V0RWxlbWVudHNCeUNsYXNzTmFtZSgiaW5kZXgiKTsKICAgIHZhciBpbmRleCA9IGluZGV4RWxlbWVudHMuaXRlbShpbmRleEVsZW1lbnRzLmxlbmd0aCAtIDEpOwogICAgdmFyIHNlY3Rpb25zID0gaW5kZXguY2hpbGRyZW47CiAgICBmb3IgKHZhciBzZWN0aW9uSW5kZXggPSAxOyBzZWN0aW9uSW5kZXggPCBzZWN0aW9ucy5sZW5ndGg7IHNlY3Rpb25JbmRleCsrKSB7CiAgICAgICAgdmFyIHNlY3Rpb24gPSBzZWN0aW9uc1tzZWN0aW9uSW5kZXhdCiAgICAgICAgdmFyIGxpbmtzID0gc2VjdGlvbi5jaGlsZHJlbgogICAgICAgIGZvciAodmFyIGxpbmtJbmRleCA9IDE7IGxpbmtJbmRleCA8IGxpbmtzLmxlbmd0aDsgbGlua0luZGV4KyspIHsKICAgICAgICAgICAgdmFyIGxpbmsgPSBsaW5rc1tsaW5rSW5kZXhdCiAgICAgICAgICAgIHRvZ2dsZUxpbmtWaXNpYmlsaXR5KGxpbmspCiAgICAgICAgfQogICAgfQp9Cg==")!, encoding: String.Encoding.utf8)!
    static let site = String(data: Data(base64Encoded: "LyoKIFNpdGUuY3NzCgogVGhpcyBzb3VyY2UgZmlsZSBpcyBwYXJ0IG9mIHRoZSBXb3Jrc3BhY2Ugb3BlbiBzb3VyY2UgcHJvamVjdC4KIGh0dHBzOi8vZ2l0aHViLmNvbS9TREdHaWVzYnJlY2h0L1dvcmtzcGFjZSN3b3Jrc3BhY2UKCiBDb3B5cmlnaHQgwqkyMDE4IEplcmVteSBEYXZpZCBHaWVzYnJlY2h0IGFuZCB0aGUgV29ya3NwYWNlIHByb2plY3QgY29udHJpYnV0b3JzLgoKIFNvbGkgRGVvIGdsb3JpYS4KCiBMaWNlbnNlZCB1bmRlciB0aGUgQXBhY2hlIExpY2VuY2UsIFZlcnNpb24gMi4wLgogU2VlIGh0dHA6Ly93d3cuYXBhY2hlLm9yZy9saWNlbnNlcy9MSUNFTlNFLTIuMCBmb3IgbGljZW5jZSBpbmZvcm1hdGlvbi4KICovCgovKiBHZW5lcmFsIExheW91dCAqLwoKKiwgKjo6YmVmb3JlLCAqOjphZnRlciB7CiAgICBib3gtc2l6aW5nOiBpbmhlcml0Owp9Cmh0bWwgewogICAgYm94LXNpemluZzogYm9yZGVyLWJveDsKfQoKbWFpbiB7CiAgICBtYXgtd2lkdGg6IDUwZW07Cn0KCmgxLCBoMiB7CiAgICBtYXJnaW46IDA7Cn0KaDMsIGg0LCBoNSwgaDYgewogICAgbWFyZ2luLXRvcDogMS40ZW07CiAgICBtYXJnaW4tYm90dG9tOiAwOwp9CgpzZWN0aW9uIHsKICAgIG1hcmdpbi10b3A6IDNyZW07Cn0Kc2VjdGlvbjpsYXN0LWNoaWxkIHsKICAgIG1hcmdpbi1ib3R0b206IDNyZW07Cn0KCnAgewogICAgbWFyZ2luOiAwOwp9CnA6bm90KDpmaXJzdC1jaGlsZCkgewogICAgbWFyZ2luLXRvcDogMC43ZW07Cn0KCmJsb2NrcXVvdGUgewogICAgbWFyZ2luOiAxLjRlbSAwOwp9CgpibG9ja3F1b3RlIHsKICAgIGJvcmRlci1sZWZ0OiAwLjI1ZW0gc29saWQgI0RGRTJFNTsKICAgIHBhZGRpbmc6IDAgMWVtOwp9CmJsb2NrcXVvdGUgPiBwLCBibG9ja3F1b3RlID4gcDpub3QoOmZpcnN0LWNoaWxkKSB7CiAgICBtYXJnaW46IDA7Cn0KW2Rpcj0icnRsIl0gYmxvY2txdW90ZSA+IHAuY2l0YXRpb24gewogICAgdGV4dC1hbGlnbjogbGVmdDsKfQpbZGlyPSJsdHIiXSBibG9ja3F1b3RlID4gcC5jaXRhdGlvbiB7CiAgICB0ZXh0LWFsaWduOiByaWdodDsKfQoKdWwsIG9sIHsKICAgIG1hcmdpbi10b3A6IDAuN2VtOwogICAgbWFyZ2luLWxlZnQ6IDJyZW07CiAgICBtYXJnaW4tcmlnaHQ6IDJyZW07CiAgICBtYXJnaW4tYm90dG9tOiAwOwogICAgcGFkZGluZzogMDsKfQpsaTpub3QoOmZpcnN0LWNoaWxkKSB7CiAgICBtYXJnaW4tdG9wOiAwLjdlbTsKfQoKLyogU3BlY2lmaWMgTGF5b3V0ICovCgpoZWFkZXIubmF2aWdhdGlvbuKAkGJhciB7CiAgICBib3gtc2l6aW5nOiBjb250ZW50LWJveDsKICAgIGhlaWdodDogY2FsYygoNTIgLyAxNykgKiAxcmVtKTsKICAgIHBhZGRpbmc6IDAgY2FsYygoMjIgLyAxNykgKiAxcmVtKTsKfQpuYXYubmF2aWdhdGlvbuKAkGJhciB7CiAgICBkaXNwbGF5OiBmbGV4OwogICAgIGFsaWduLWl0ZW1zOiBjZW50ZXI7CiAgICAganVzdGlmeS1jb250ZW50OiBzcGFjZS1iZXR3ZWVuOwogICAgaGVpZ2h0OiAxMDAlOwp9Ci5uYXZpZ2F0aW9u4oCQcGF0aCB7CiAgICBkaXNwbGF5OiBmbGV4OwogICAgIGFsaWduLWl0ZW1zOiBjZW50ZXI7CiAgICAganVzdGlmeS1jb250ZW50OiBzcGFjZS1iZXR3ZWVuOwogICAgIG92ZXJmbG93OiBoaWRkZW47CiAgICAgZmxleC13cmFwOiBub3dyYXA7CiAgICAgd2hpdGUtc3BhY2U6IG5vd3JhcDsKICAgICB0ZXh0LW92ZXJmbG93OiBlbGxpcHNpczsKICAgIGhlaWdodDogMTAwJTsKfQpbZGlyPSJydGwiXS5uYXZpZ2F0aW9u4oCQcGF0aCBhLCBbZGlyPSJydGwiXS5uYXZpZ2F0aW9u4oCQcGF0aCBzcGFuIHsKICAgIG1hcmdpbi1yaWdodDogMS4wNTg4MnJlbTsKfQpbZGlyPSJsdHIiXS5uYXZpZ2F0aW9u4oCQcGF0aCBhLCBbZGlyPSJsdHIiXS5uYXZpZ2F0aW9u4oCQcGF0aCBzcGFuIHsKICAgIG1hcmdpbi1sZWZ0OiAxLjA1ODgycmVtOwp9Ci5uYXZpZ2F0aW9u4oCQcGF0aCBhOmZpcnN0LWNoaWxkLCAubmF2aWdhdGlvbuKAkHBhdGggc3BhbjpmaXJzdC1jaGlsZCB7CiAgICBtYXJnaW4tbGVmdDogMDsKICAgIG1hcmdpbi1yaWdodDogMDsKfQpbZGlyPSJydGwiXS5uYXZpZ2F0aW9u4oCQcGF0aCBhOjpiZWZvcmUsIFtkaXI9InJ0bCJdLm5hdmlnYXRpb27igJBwYXRoIHNwYW46OmJlZm9yZSB7CiAgICBwYWRkaW5nLWxlZnQ6IDEuMDU4ODJyZW07Cn0KW2Rpcj0ibHRyIl0ubmF2aWdhdGlvbuKAkHBhdGggYTo6YmVmb3JlLCBbZGlyPSJsdHIiXS5uYXZpZ2F0aW9u4oCQcGF0aCBzcGFuOjpiZWZvcmUgewogICAgcGFkZGluZy1yaWdodDogMS4wNTg4MnJlbTsKfQoubmF2aWdhdGlvbuKAkHBhdGggYTpmaXJzdC1jaGlsZDo6YmVmb3JlLCAubmF2aWdhdGlvbuKAkHBhdGggc3BhbjpmaXJzdC1jaGlsZDo6YmVmb3JlIHsKICAgIGRpc3BsYXk6IG5vbmU7Cn0KCi5jb250ZW504oCQY29udGFpbmVyIHsKICAgIGhlaWdodDogY2FsYygxMDB2aCAtIGNhbGMoKDUyIC8gMTcpICogMXJlbSkgLSBjYWxjKCg0NSAvIDE3KSAqIDFyZW0pKTsKICAgIHdpZHRoOiAxMDAlOwogICAgZGlzcGxheTogZmxleDsKfQpoZWFkZXIuaW5kZXggewogICAgaGVpZ2h0OiAxMDAlOwogICAgbWF4LXdpZHRoOiAyNSU7CiAgICBwYWRkaW5nOiBjYWxjKCgxMiAvIDE3KSAqIDFyZW0pIDA7CiAgICBvdmVyZmxvdy15OiBhdXRvOwp9CgouaW5kZXggYSB7CiAgICBjdXJzb3I6IHBvaW50ZXI7CiAgICBkaXNwbGF5OiBibG9jazsKICAgIHBhZGRpbmc6IDAuMmVtIGNhbGMoKDIyIC8gMTcpICogMXJlbSk7CiAgICBvdmVyZmxvdzogaGlkZGVuOwp9Ci5pbmRleCBhOm5vdCg6Zmlyc3QtY2hpbGQpIHsKICAgIHBhZGRpbmctbGVmdDogY2FsYygxZW0gKyBjYWxjKCgyMiAvIDE3KSAqIDFyZW0pKTsKfQoKbWFpbiB7CiAgICBoZWlnaHQ6IDEwMCU7CiAgICBvdmVyZmxvdy15OiBhdXRvOwogICAgcGFkZGluZzogMCBjYWxjKCgyMiAvIDE3KSAqIDFyZW0pOwp9CgoudGl0bGUgewogICAgbWFyZ2luLXRvcDogMnJlbTsKICAgIG1hcmdpbi1ib3R0b206IDEuNXJlbTsKfQouc3ltYm9s4oCQdHlwZSB7CiAgICBtYXJnaW4tYm90dG9tOiBjYWxjKCgyMCAvIDE3KSAqIDFyZW0pOwp9CgouZGVzY3JpcHRpb24gewogICAgbWFyZ2luLWJvdHRvbTogMnJlbTsKfQouZGVzY3JpcHRpb24gcCB7CiAgICBtYXJnaW46IDA7Cn0KCi5kZWNsYXJhdGlvbjo6YmVmb3JlIHsKICAgIGJvcmRlci10b3A6IDFweCBzb2xpZCAjRDZENkQ2OwogICAgY29udGVudDogIiI7CiAgICBkaXNwbGF5OiBibG9jazsKfQouZGVjbGFyYXRpb24gewogICAgbWFyZ2luLXRvcDogMDsKfQouZGVjbGFyYXRpb24gaDIgewogICAgbWFyZ2luLXRvcDogMnJlbTsKfQouZGVjbGFyYXRpb24gLnN3aWZ0LmJsb2NrcXVvdGUgewogICAgbWFyZ2luLXRvcDogMXJlbTsKfQoKaDIgKyAuY2hpbGQgewogICAgbWFyZ2luLXRvcDogMnJlbTsKfQouY2hpbGQ6bm90KDpsYXN0LWNoaWxkKSB7CiAgICBtYXJnaW4tYm90dG9tOiAxLjVyZW07Cn0KLmNoaWxkID4gcCB7CiAgICBtYXJnaW46IDAgMi4zNTI5NHJlbTsKfQoKZm9vdGVyIHsKICAgIGRpc3BsYXk6IGZsZXg7CiAgICAgYWxpZ24taXRlbXM6IGNlbnRlcjsKICAgICBqdXN0aWZ5LWNvbnRlbnQ6IHNwYWNlLWJldHdlZW47CiAgICBoZWlnaHQ6IGNhbGMoKDQ1IC8gMTcpICogMXJlbSk7CiAgICBwYWRkaW5nOiAwIGNhbGMoKDIyIC8gMTcpICogMXJlbSk7Cn0KCi8qIENvbG91cnMgKi8KCmh0bWwgewogICAgY29sb3I6ICMzMzMzMzM7Cn0KCmEgewogICAgY29sb3I6ICMwMDcwQzk7Cn0KCmJsb2NrcXVvdGUgewogICAgY29sb3I6ICM2QTczN0Q7Cn0KCi5uYXZpZ2F0aW9u4oCQYmFyIHsKICAgIGJhY2tncm91bmQtY29sb3I6ICMzMzM7CiAgICBjb2xvcjogI0NDQ0NDQzsKfQoubmF2aWdhdGlvbuKAkHBhdGggYSB7CiAgICBjb2xvcjogI0ZGRkZGRjsKfQoKLmluZGV4IHsKICAgIGJhY2tncm91bmQtY29sb3I6ICNGMkYyRjI7Cn0KLmluZGV4IGEgewogICAgY29sb3I6ICM1NTU1NTU7Cn0KLmluZGV4IGEuaGVhZGluZyB7CiAgICBjb2xvcjogIzMzMzsKfQoKLnN5bWJvbOKAkHR5cGUgewogICAgY29sb3I6ICM2NjY7Cn0KCmZvb3RlciB7CiAgICBiYWNrZ3JvdW5kLWNvbG9yOiAjRjJGMkYyOwogICAgY29sb3I6ICM4ODg4ODg7Cn0KCgovKiBHZW5lcmFsIEZvbnRzICovCgpodG1sIHsKICAgIGZvbnQtZmFtaWx5OiAiU0YgUHJvIFRleHQiLCAiU0YgUHJvIEljb25zIiwgIi1hcHBsZS1zeXN0ZW0iLCAiQmxpbmtNYWNTeXN0ZW1Gb250IiwgIkhlbHZldGljYSBOZXVlIiwgIkhlbHZldGljYSIsICJBcmlhbCIsIHNhbnMtc2VyaWY7CiAgICBmb250LXNpemU6IDEwNi4yNSU7CiAgICBsZXR0ZXItc3BhY2luZzogLTAuMDIxZW07CiAgICBsaW5lLWhlaWdodDogMS41Mjk0NzsKfQoKaDEsIGgyIHsKICAgIGZvbnQtZmFtaWx5OiAiU0YgUHJvIERpc3BsYXkiLCAiU0YgUHJvIEljb25zIiwgIi1hcHBsZS1zeXN0ZW0iLCAiQmxpbmtNYWNTeXN0ZW1Gb250IiwgIkhlbHZldGljYSBOZXVlIiwgIkhlbHZldGljYSIsICJBcmlhbCIsIHNhbnMtc2VyaWY7Cn0KaDEgewogICAgZm9udC1zaXplOiBjYWxjKCg0MCAvIDE3KSAqIDFyZW0pOwogICAgZm9udC13ZWlnaHQ6IDUwMDsKICAgIGxldHRlci1zcGFjaW5nOiAwLjAwOGVtOwogICAgbGluZS1oZWlnaHQ6IDEuMDU7Cn0KaDIgewogICAgZm9udC1zaXplOiBjYWxjKCgzMiAvIDE3KSAqIDFyZW0pOwogICAgZm9udC13ZWlnaHQ6IDUwMDsKICAgIGxldHRlci1zcGFjaW5nOiAwLjAxMWVtOwogICAgbGluZS1oZWlnaHQ6IDEuMDkzNzU7Cn0KaDMgewogICAgZm9udC1zaXplOiBjYWxjKCgyOCAvIDE3KSAqIDFyZW0pOwogICAgZm9udC13ZWlnaHQ6IDUwMDsKICAgIGxldHRlci1zcGFjaW5nOiAwLjAxMmVtOwogICAgbGluZS1oZWlnaHQ6IDEuMTA3MzsKfQpoNCwgaDUsIGg2IHsKICAgIGZvbnQtd2VpZ2h0OiA1MDA7CiAgICBsZXR0ZXItc3BhY2luZzogMC4wMTVlbTsKICAgIGxpbmUtaGVpZ2h0OiAxLjIwODQ5Owp9Cmg0IHsKICAgIGZvbnQtc2l6ZTogY2FsYygoMjQgLyAxNykgKiAxcmVtKTsKfQpoNSB7CiAgICBmb250LXNpemU6IGNhbGMoKDIwIC8gMTcpICogMXJlbSk7Cn0KaDYgewogICAgZm9udC1zaXplOiBjYWxjKCgxOCAvIDE3KSAqIDFyZW0pOwp9CgphOmxpbmssIGE6dmlzaXRlZCB7CiAgICB0ZXh0LWRlY29yYXRpb246IG5vbmU7Cn0KYTpob3ZlciB7CiAgICB0ZXh0LWRlY29yYXRpb246IHVuZGVybGluZTsKfQoKLyogU3BlY2lmaWMgRm9udHMgKi8KCi5uYXZpZ2F0aW9u4oCQYmFyIHsKICAgIGZvbnQtc2l6ZTogY2FsYygoMTUgLyAxNykgKiAxcmVtKTsKICAgIGxldHRlci1zcGFjaW5nOiAtMC4wMTRlbTsKICAgIGxpbmUtaGVpZ2h0OiAxLjI2NjY3Owp9Ci5uYXZpZ2F0aW9u4oCQcGF0aCBhOjpiZWZvcmUsIC5uYXZpZ2F0aW9u4oCQcGF0aCBzcGFuOjpiZWZvcmUgewogICAgZm9udC1mYW1pbHk6ICJTRiBQcm8gSWNvbnMiLCAiLWFwcGxlLXN5c3RlbSIsICJCbGlua01hY1N5c3RlbUZvbnQiLCAiSGVsdmV0aWNhIE5ldWUiLCAiSGVsdmV0aWNhIiwgIkFyaWFsIiwgc2Fucy1zZXJpZjsKICAgIGNvbnRlbnQ6ICLigKMiOwogICAgbGluZS1oZWlnaHQ6IDE7Cn0KCi5pbmRleCB7CiAgICBmb250LXNpemU6IGNhbGMoKDEyIC8gMTcpICogMXJlbSk7CiAgICBsZXR0ZXItc3BhY2luZzogLjAxNWVtOwogICAgbGluZS1oZWlnaHQ6IGNhbGMoKDIwIC8gMTcpICogMXJlbSk7Cn0KLmluZGV4IGEuaGVhZGluZyB7CiAgICBmb250LXdlaWdodDogNjAwOwp9Cgouc3ltYm9s4oCQdHlwZSB7CiAgICBmb250LWZhbWlseTogIlNGIFBybyBEaXNwbGF5IiwgIlNGIFBybyBJY29ucyIsICItYXBwbGUtc3lzdGVtIiwgIkJsaW5rTWFjU3lzdGVtRm9udCIsICJIZWx2ZXRpY2EgTmV1ZSIsICJIZWx2ZXRpY2EiLCAiQXJpYWwiLCBzYW5zLXNlcmlmOwogICAgZm9udC1zaXplOiBjYWxjKCgyMiAvIDE3KSAqIDFyZW0pOwogICAgbGV0dGVyLXNwYWNpbmc6IDAuMDE2ZW07CiAgICBsaW5lLWhlaWdodDogMTsKfQoKLmRlc2NyaXB0aW9uIHsKICAgIGZvbnQtZmFtaWx5OiAiU0YgUHJvIERpc3BsYXkiLCAiU0YgUHJvIEljb25zIiwgIi1hcHBsZS1zeXN0ZW0iLCAiQmxpbmtNYWNTeXN0ZW1Gb250IiwgIkhlbHZldGljYSBOZXVlIiwgIkhlbHZldGljYSIsICJBcmlhbCIsIHNhbnMtc2VyaWY7CiAgICBmb250LXNpemU6IGNhbGMoKDIyIC8gMTcpICogMXJlbSk7CiAgICBmb250LXdlaWdodDogMzAwOwogICAgbGV0dGVyLXNwYWNpbmc6IDAuMDE2ZW07CiAgICBsaW5lLWhlaWdodDogMS40NTQ1NTsKfQoKLmRlY2xhcmF0aW9uIC5zd2lmdC5ibG9ja3F1b3RlIHsKICAgIGZvbnQtc2l6ZTogY2FsYygoMTUgLyAxNykgKiAxcmVtKTsKfQoKZm9vdGVyIHsKICAgIGZvbnQtc2l6ZTogY2FsYygoMTEgLyAxNykgKiAxcmVtKTsKICAgIGxldHRlci1zcGFjaW5nOiBjYWxjKCgwLjIzOTk5OTk5NDYzNTU4MTk3IC8gMTcpICogMXJlbSk7CiAgICBsaW5lLWhlaWdodDogY2FsYygoMTQgLyAxNykgKiAxcmVtKTsKfQo=")!, encoding: String.Encoding.utf8)!

}
