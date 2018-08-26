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
    static let page = String(data: Data(base64Encoded: "PCFET0NUWVBFIGh0bWw+Cgo8IS0tCiBQYWdlLmh0bWwKCiBUaGlzIHNvdXJjZSBmaWxlIGlzIHBhcnQgb2YgdGhlIFdvcmtzcGFjZSBvcGVuIHNvdXJjZSBwcm9qZWN0LgogaHR0cHM6Ly9naXRodWIuY29tL1NER0dpZXNicmVjaHQvV29ya3NwYWNlI3dvcmtzcGFjZQoKIENvcHlyaWdodCDCqTIwMTggSmVyZW15IERhdmlkIEdpZXNicmVjaHQgYW5kIHRoZSBXb3Jrc3BhY2UgcHJvamVjdCBjb250cmlidXRvcnMuCgogU29saSBEZW8gZ2xvcmlhLgoKIExpY2Vuc2VkIHVuZGVyIHRoZSBBcGFjaGUgTGljZW5jZSwgVmVyc2lvbiAyLjAuCiBTZWUgaHR0cDovL3d3dy5hcGFjaGUub3JnL2xpY2Vuc2VzL0xJQ0VOU0UtMi4wIGZvciBsaWNlbmNlIGluZm9ybWF0aW9uLgogLS0+Cgo8aHRtbCBkaXI9IlsqdGV4dCBkaXJlY3Rpb24qXSIgbGFuZz0iWypsb2NhbGl6YXRpb24qXSI+CiA8aGVhZD4KICA8bWV0YSBjaGFyc2V0PSJ1dGYtOCI+CiAgPHRpdGxlPlsqdGl0bGUqXTwvdGl0bGU+CiAgPGxpbmsgcmVsPSJzdHlsZXNoZWV0IiBocmVmPSJbKnNpdGUgcm9vdCpdQ1NTL1Jvb3QuY3NzIj4KICA8bGluayByZWw9InN0eWxlc2hlZXQiIGhyZWY9Ilsqc2l0ZSByb290Kl1DU1MvU3dpZnQuY3NzIj4KICA8bGluayByZWw9InN0eWxlc2hlZXQiIGhyZWY9Ilsqc2l0ZSByb290Kl1DU1MvU2l0ZS5jc3MiPgogPC9oZWFkPgogPGJvZHk+CiAgPGhlYWRlciBjbGFzcz0ibmF2aWdhdGlvbuKAkGJhciI+CiAgIDxuYXYgY2xhc3M9Im5hdmlnYXRpb27igJBiYXIiPgogICAgPGRpdiBjbGFzcz0ibmF2aWdhdGlvbuKAkHBhdGgiIGRpcj0iWyp0ZXh0IGRpcmVjdGlvbipdIj4KClsqbmF2aWdhdGlvbiBwYXRoKl0KCiAgICA8L2Rpdj4KICAgPC9uYXY+CiAgPC9oZWFkZXI+CiAgPG1haW4+CiAgIDxkaXYgY2xhc3M9InRpdGxlIj4KICAgIFsqc3ltYm9sIHR5cGUqXQogICAgPGgxPlsqdGl0bGUqXTwvaDE+CiAgIDwvZGl2PgoKWypjb250ZW50Kl0KCiAgPC9tYWluPgogPC9ib2R5Pgo8L2h0bWw+Cg==")!, encoding: String.Encoding.utf8)!
    static let redirect = String(data: Data(base64Encoded: "PCFET0NUWVBFIGh0bWw+Cgo8IS0tCiBSZWRpcmVjdC5odG1sCgogVGhpcyBzb3VyY2UgZmlsZSBpcyBwYXJ0IG9mIHRoZSBXb3Jrc3BhY2Ugb3BlbiBzb3VyY2UgcHJvamVjdC4KIGh0dHBzOi8vZ2l0aHViLmNvbS9TREdHaWVzYnJlY2h0L1dvcmtzcGFjZSN3b3Jrc3BhY2UKCiBDb3B5cmlnaHQgwqkyMDE4IEplcmVteSBEYXZpZCBHaWVzYnJlY2h0IGFuZCB0aGUgV29ya3NwYWNlIHByb2plY3QgY29udHJpYnV0b3JzLgoKIFNvbGkgRGVvIGdsb3JpYS4KCiBMaWNlbnNlZCB1bmRlciB0aGUgQXBhY2hlIExpY2VuY2UsIFZlcnNpb24gMi4wLgogU2VlIGh0dHA6Ly93d3cuYXBhY2hlLm9yZy9saWNlbnNlcy9MSUNFTlNFLTIuMCBmb3IgbGljZW5jZSBpbmZvcm1hdGlvbi4KIC0tPgoKPGh0bWwgbGFuZz0ienh4Ij4KIDxoZWFkPgogIDxtZXRhIGNoYXJzZXQ9InV0Zi04Ij4KICA8dGl0bGU+4oazIC4uLzwvdGl0bGU+CiAgPGxpbmsgcmVsPSJjYW5vbmljYWwiIGhyZWY9IlsqdGFyZ2V0Kl0iLz4KICA8bWV0YSBodHRwLWVxdWl2PSJyZWZyZXNoIiBjb250ZW50PSIwOyB1cmw9Wyp0YXJnZXQqXSIgLz4KIDwvaGVhZD4KIDxib2R5PgogIDxwPuKGsyA8YSBocmVmPSJbKnRhcmdldCpdIj4uLi88L2E+CiA8L2JvZHk+CjwvaHRtbD4K")!, encoding: String.Encoding.utf8)!
    static let root = String(data: Data(base64Encoded: "LyoKIFJvb3QuY3NzCgogVGhpcyBzb3VyY2UgZmlsZSBpcyBwYXJ0IG9mIHRoZSBXb3Jrc3BhY2Ugb3BlbiBzb3VyY2UgcHJvamVjdC4KIGh0dHBzOi8vZ2l0aHViLmNvbS9TREdHaWVzYnJlY2h0L1dvcmtzcGFjZSN3b3Jrc3BhY2UKCiBDb3B5cmlnaHQgwqkyMDE4IEplcmVteSBEYXZpZCBHaWVzYnJlY2h0IGFuZCB0aGUgV29ya3NwYWNlIHByb2plY3QgY29udHJpYnV0b3JzLgoKIFNvbGkgRGVvIGdsb3JpYS4KCiBMaWNlbnNlZCB1bmRlciB0aGUgQXBhY2hlIExpY2VuY2UsIFZlcnNpb24gMi4wLgogU2VlIGh0dHA6Ly93d3cuYXBhY2hlLm9yZy9saWNlbnNlcy9MSUNFTlNFLTIuMCBmb3IgbGljZW5jZSBpbmZvcm1hdGlvbi4KICovCgovKiBMYXlvdXQgKi8KCmh0bWwsIGJvZHkgewogICAgbWFyZ2luOiAwOwogICAgcGFkZGluZzogMDsKfQoKLyogQ29sb3VycyAqLwoKaHRtbCB7CiAgICBiYWNrZ3JvdW5kLWNvbG9yOiAjRkZGRkZGOwogICAgY29sb3I6ICMwMDAwMDA7Cn0KCi8qIEZvbnRzICovCgpAbWVkaWEgcHJpbnQgewogICAgaHRtbCB7CiAgICAgICAgZm9udC1mYW1pbHk6IHNlcmlmOwogICAgfQp9CkBtZWRpYSBzY3JlZW4gewogICAgaHRtbCB7CiAgICAgICAgZm9udC1mYW1pbHk6IHNhbnMtc2VyaWY7CiAgICB9Cn0K")!, encoding: String.Encoding.utf8)!
    static let site = String(data: Data(base64Encoded: "LyoKIFNpdGUuY3NzCgogVGhpcyBzb3VyY2UgZmlsZSBpcyBwYXJ0IG9mIHRoZSBXb3Jrc3BhY2Ugb3BlbiBzb3VyY2UgcHJvamVjdC4KIGh0dHBzOi8vZ2l0aHViLmNvbS9TREdHaWVzYnJlY2h0L1dvcmtzcGFjZSN3b3Jrc3BhY2UKCiBDb3B5cmlnaHQgwqkyMDE4IEplcmVteSBEYXZpZCBHaWVzYnJlY2h0IGFuZCB0aGUgV29ya3NwYWNlIHByb2plY3QgY29udHJpYnV0b3JzLgoKIFNvbGkgRGVvIGdsb3JpYS4KCiBMaWNlbnNlZCB1bmRlciB0aGUgQXBhY2hlIExpY2VuY2UsIFZlcnNpb24gMi4wLgogU2VlIGh0dHA6Ly93d3cuYXBhY2hlLm9yZy9saWNlbnNlcy9MSUNFTlNFLTIuMCBmb3IgbGljZW5jZSBpbmZvcm1hdGlvbi4KICovCgovKiBHZW5lcmFsIExheW91dCAqLwoKKiwgKjo6YmVmb3JlLCAqOjphZnRlciB7CiAgICBib3gtc2l6aW5nOiBpbmhlcml0Owp9Cmh0bWwgewogICAgYm94LXNpemluZzogYm9yZGVyLWJveDsKfQoKaDEsIGgyIHsKICAgIG1hcmdpbjogMDsKfQpoMywgaDQsIGg1LCBoNiB7CiAgICBtYXJnaW4tdG9wOiAxLjRlbTsKICAgIG1hcmdpbi1ib3R0b206IDA7Cn0KCnNlY3Rpb24gewogICAgbWFyZ2luLXRvcDogM3JlbTsKfQpzZWN0aW9uOmxhc3QtY2hpbGQgewogICAgbWFyZ2luLWJvdHRvbTogM3JlbTsKfQoKcCB7CiAgICBtYXJnaW46IDA7Cn0KcDpub3QoOmZpcnN0LWNoaWxkKSB7CiAgICBtYXJnaW46IDAuN2VtOwp9CgpibG9ja3F1b3RlIHsKICAgIG1hcmdpbjogMS40ZW0gMDsKfQoKYmxvY2txdW90ZSB7CiAgICBib3JkZXItbGVmdDogMC4yNWVtIHNvbGlkICNERkUyRTU7CiAgICBwYWRkaW5nOiAwIDFlbTsKfQpibG9ja3F1b3RlID4gcCB7CiAgICBtYXJnaW46IDA7Cn0KW2Rpcj0icnRsIl0gYmxvY2txdW90ZSA+IHAuY2l0YXRpb24gewogICAgdGV4dC1hbGlnbjogbGVmdDsKfQpbZGlyPSJsdHIiXSBibG9ja3F1b3RlID4gcC5jaXRhdGlvbiB7CiAgICB0ZXh0LWFsaWduOiByaWdodDsKfQoKdWwsIG9sIHsKICAgIG1hcmdpbi10b3A6IDAuN2VtOwogICAgbWFyZ2luLWxlZnQ6IDJyZW07CiAgICBtYXJnaW4tcmlnaHQ6IDJyZW07CiAgICBtYXJnaW4tYm90dG9tOiAwOwogICAgcGFkZGluZzogMDsKfQpsaTpub3QoOmZpcnN0LWNoaWxkKSB7CiAgICBtYXJnaW4tdG9wOiAwLjdlbTsKfQoKLyogU3BlY2lmaWMgTGF5b3V0ICovCgpoZWFkZXIubmF2aWdhdGlvbuKAkGJhciB7CiAgICBib3gtc2l6aW5nOiBjb250ZW50LWJveDsKICAgIGhlaWdodDogY2FsYygoNTIgLyAxNykgKiAxcmVtKTsKICAgIHBhZGRpbmc6IDAgY2FsYygoMjIgLyAxNykgKiAxcmVtKTsKICAgIHBvc2l0aW9uOiBzdGlja3k7CiAgICAgcG9zaXRpb246IC13ZWJraXQtc3RpY2t5OwogICAgIHRvcDogMDsKfQpuYXYubmF2aWdhdGlvbuKAkGJhciB7CiAgICBkaXNwbGF5OiBmbGV4OwogICAgIGFsaWduLWl0ZW1zOiBjZW50ZXI7CiAgICAganVzdGlmeS1jb250ZW50OiBzcGFjZS1iZXR3ZWVuOwogICAgaGVpZ2h0OiAxMDAlOwp9Ci5uYXZpZ2F0aW9u4oCQcGF0aCB7CiAgICBkaXNwbGF5OiBmbGV4OwogICAgIGFsaWduLWl0ZW1zOiBjZW50ZXI7CiAgICAganVzdGlmeS1jb250ZW50OiBzcGFjZS1iZXR3ZWVuOwogICAgIG92ZXJmbG93OiBoaWRkZW47CiAgICAgZmxleC13cmFwOiBub3dyYXA7CiAgICAgd2hpdGUtc3BhY2U6IG5vd3JhcDsKICAgICB0ZXh0LW92ZXJmbG93OiBlbGxpcHNpczsKICAgIGhlaWdodDogMTAwJTsKfQpbZGlyPSJydGwiXS5uYXZpZ2F0aW9u4oCQcGF0aCBhLCBbZGlyPSJydGwiXS5uYXZpZ2F0aW9u4oCQcGF0aCBzcGFuIHsKICAgIG1hcmdpbi1yaWdodDogMS4wNTg4MnJlbTsKfQpbZGlyPSJsdHIiXS5uYXZpZ2F0aW9u4oCQcGF0aCBhLCBbZGlyPSJsdHIiXS5uYXZpZ2F0aW9u4oCQcGF0aCBzcGFuIHsKICAgIG1hcmdpbi1sZWZ0OiAxLjA1ODgycmVtOwp9Ci5uYXZpZ2F0aW9u4oCQcGF0aCBhOmZpcnN0LWNoaWxkLCAubmF2aWdhdGlvbuKAkHBhdGggc3BhbjpmaXJzdC1jaGlsZCB7CiAgICBtYXJnaW4tbGVmdDogMDsKICAgIG1hcmdpbi1yaWdodDogMDsKfQpbZGlyPSJydGwiXS5uYXZpZ2F0aW9u4oCQcGF0aCBhOjpiZWZvcmUsIFtkaXI9InJ0bCJdLm5hdmlnYXRpb27igJBwYXRoIHNwYW46OmJlZm9yZSB7CiAgICBwYWRkaW5nLWxlZnQ6IDEuMDU4ODJyZW07Cn0KW2Rpcj0ibHRyIl0ubmF2aWdhdGlvbuKAkHBhdGggYTo6YmVmb3JlLCBbZGlyPSJsdHIiXS5uYXZpZ2F0aW9u4oCQcGF0aCBzcGFuOjpiZWZvcmUgewogICAgcGFkZGluZy1yaWdodDogMS4wNTg4MnJlbTsKfQoubmF2aWdhdGlvbuKAkHBhdGggYTpmaXJzdC1jaGlsZDo6YmVmb3JlLCAubmF2aWdhdGlvbuKAkHBhdGggc3BhbjpmaXJzdC1jaGlsZDo6YmVmb3JlIHsKICAgIGRpc3BsYXk6IG5vbmU7Cn0KCi50aXRsZSB7CiAgICBtYXJnaW4tdG9wOiAycmVtOwogICAgbWFyZ2luLWJvdHRvbTogMS41cmVtOwp9Ci5zeW1ib2zigJB0eXBlIHsKICAgIG1hcmdpbi1ib3R0b206IGNhbGMoKDIwIC8gMTcpICogMXJlbSk7Cn0KCi5kZXNjcmlwdGlvbiB7CiAgICBtYXJnaW4tYm90dG9tOiAycmVtOwp9Ci5kZXNjcmlwdGlvbiBwIHsKICAgIG1hcmdpbjogMDsKfQoKLmRlY2xhcmF0aW9uOjpiZWZvcmUgewogICAgYm9yZGVyLXRvcDogMXB4IHNvbGlkICNENkQ2RDY7CiAgICBjb250ZW50OiAiIjsKICAgIGRpc3BsYXk6IGJsb2NrOwp9Ci5kZWNsYXJhdGlvbiB7CiAgICBtYXJnaW4tdG9wOiAwOwp9Ci5kZWNsYXJhdGlvbiBoMiB7CiAgICBtYXJnaW4tdG9wOiAycmVtOwp9Ci5kZWNsYXJhdGlvbiAuc3dpZnQuYmxvY2txdW90ZSB7CiAgICBtYXJnaW4tdG9wOiAxcmVtOwp9CgovKiBDb2xvdXJzICovCgpodG1sIHsKICAgIGNvbG9yOiAjMzMzMzMzOwp9Ci5uYXZpZ2F0aW9u4oCQYmFyIHsKICAgIGJhY2tncm91bmQtY29sb3I6ICMzMzM7CiAgICBjb2xvcjogI0NDQ0NDQzsKfQoKLnN5bWJvbOKAkHR5cGUgewogICAgY29sb3I6ICM2NjY7Cn0KYSB7CiAgICBjb2xvcjogIzAwNzBDOTsKfQoKLyogR2VuZXJhbCBGb250cyAqLwoKaHRtbCB7CiAgICBmb250LWZhbWlseTogIlNGIFBybyBUZXh0IiwgIlNGIFBybyBJY29ucyIsICItYXBwbGUtc3lzdGVtIiwgIkJsaW5rTWFjU3lzdGVtRm9udCIsICJIZWx2ZXRpY2EgTmV1ZSIsICJIZWx2ZXRpY2EiLCAiQXJpYWwiLCBzYW5zLXNlcmlmOwogICAgZm9udC1zaXplOiAxMDYuMjUlOwogICAgbGV0dGVyLXNwYWNpbmc6IC0wLjAyMWVtOwogICAgbGluZS1oZWlnaHQ6IDEuNTI5NDc7Cn0KCmgxLCBoMiB7CiAgICBmb250LWZhbWlseTogIlNGIFBybyBEaXNwbGF5IiwgIlNGIFBybyBJY29ucyIsICItYXBwbGUtc3lzdGVtIiwgIkJsaW5rTWFjU3lzdGVtRm9udCIsICJIZWx2ZXRpY2EgTmV1ZSIsICJIZWx2ZXRpY2EiLCAiQXJpYWwiLCBzYW5zLXNlcmlmOwp9CmgxIHsKICAgIGZvbnQtc2l6ZTogY2FsYygoNDAgLyAxNykgKiAxcmVtKTsKICAgIGZvbnQtd2VpZ2h0OiA1MDA7CiAgICBsZXR0ZXItc3BhY2luZzogMC4wMDhlbTsKICAgIGxpbmUtaGVpZ2h0OiAxLjA1Owp9CmgyIHsKICAgIGZvbnQtc2l6ZTogY2FsYygoMzIgLyAxNykgKiAxcmVtKTsKICAgIGZvbnQtd2VpZ2h0OiA1MDA7CiAgICBsZXR0ZXItc3BhY2luZzogMC4wMTFlbTsKICAgIGxpbmUtaGVpZ2h0OiAxLjA5Mzc1Owp9CmgzIHsKICAgIGZvbnQtc2l6ZTogY2FsYygoMjggLyAxNykgKiAxcmVtKTsKICAgIGZvbnQtd2VpZ2h0OiA1MDA7CiAgICBsZXR0ZXItc3BhY2luZzogMC4wMTJlbTsKICAgIGxpbmUtaGVpZ2h0OiAxLjEwNzM7Cn0KaDQsIGg1LCBoNiB7CiAgICBmb250LXdlaWdodDogNTAwOwogICAgbGV0dGVyLXNwYWNpbmc6IDAuMDE1ZW07CiAgICBsaW5lLWhlaWdodDogMS4yMDg0OTsKfQpoNCB7CiAgICBmb250LXNpemU6IGNhbGMoKDI0IC8gMTcpICogMXJlbSk7Cn0KaDUgewogICAgZm9udC1zaXplOiBjYWxjKCgyMCAvIDE3KSAqIDFyZW0pOwp9Cmg2IHsKICAgIGZvbnQtc2l6ZTogY2FsYygoMTggLyAxNykgKiAxcmVtKTsKfQoKYTpsaW5rLCBhOnZpc2l0ZWQgewogICAgdGV4dC1kZWNvcmF0aW9uOiBub25lOwp9CmE6aG92ZXIgewogICAgdGV4dC1kZWNvcmF0aW9uOiB1bmRlcmxpbmU7Cn0KCmJsb2NrcXVvdGUgewogICAgY29sb3I6ICM2QTczN0Q7Cn0KCi8qIFNwZWNpZmljIEZvbnRzICovCgoubmF2aWdhdGlvbuKAkHBhdGggewogICAgZm9udC1zaXplOiBjYWxjKCgxNSAvIDE3KSAqIDFyZW0pOwogICAgbGV0dGVyLXNwYWNpbmc6IC0wLjAxNGVtOwogICAgbGluZS1oZWlnaHQ6IDEuMjY2Njc7Cn0KLm5hdmlnYXRpb27igJBwYXRoIGE6OmJlZm9yZSwgLm5hdmlnYXRpb27igJBwYXRoIHNwYW46OmJlZm9yZSB7CiAgICBmb250LWZhbWlseTogIlNGIFBybyBJY29ucyIsICItYXBwbGUtc3lzdGVtIiwgIkJsaW5rTWFjU3lzdGVtRm9udCIsICJIZWx2ZXRpY2EgTmV1ZSIsICJIZWx2ZXRpY2EiLCAiQXJpYWwiLCBzYW5zLXNlcmlmOwogICAgY29udGVudDogIuKAoyI7CiAgICBsaW5lLWhlaWdodDogMTsKfQoKLnN5bWJvbOKAkHR5cGUgewogICAgZm9udC1mYW1pbHk6ICJTRiBQcm8gRGlzcGxheSIsICJTRiBQcm8gSWNvbnMiLCAiLWFwcGxlLXN5c3RlbSIsICJCbGlua01hY1N5c3RlbUZvbnQiLCAiSGVsdmV0aWNhIE5ldWUiLCAiSGVsdmV0aWNhIiwgIkFyaWFsIiwgc2Fucy1zZXJpZjsKICAgIGZvbnQtc2l6ZTogY2FsYygoMjIgLyAxNykgKiAxcmVtKTsKICAgIGxldHRlci1zcGFjaW5nOiAwLjAxNmVtOwogICAgbGluZS1oZWlnaHQ6IDE7Cn0KCi5kZXNjcmlwdGlvbiB7CiAgICBmb250LWZhbWlseTogIlNGIFBybyBEaXNwbGF5IiwgIlNGIFBybyBJY29ucyIsICItYXBwbGUtc3lzdGVtIiwgIkJsaW5rTWFjU3lzdGVtRm9udCIsICJIZWx2ZXRpY2EgTmV1ZSIsICJIZWx2ZXRpY2EiLCAiQXJpYWwiLCBzYW5zLXNlcmlmOwogICAgZm9udC1zaXplOiBjYWxjKCgyMiAvIDE3KSAqIDFyZW0pOwogICAgZm9udC13ZWlnaHQ6IDMwMDsKICAgIGxldHRlci1zcGFjaW5nOiAwLjAxNmVtOwogICAgbGluZS1oZWlnaHQ6IDEuNDU0NTU7Cn0KCi5kZWNsYXJhdGlvbiAuc3dpZnQuYmxvY2txdW90ZSB7CiAgICBmb250LXNpemU6IGNhbGMoKDE1IC8gMTcpICogMXJlbSk7Cn0K")!, encoding: String.Encoding.utf8)!

}
