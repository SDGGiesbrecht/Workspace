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
    static let page = String(data: Data(base64Encoded: "PCFET0NUWVBFIGh0bWw+Cgo8IS0tCiBQYWdlLmh0bWwKCiBUaGlzIHNvdXJjZSBmaWxlIGlzIHBhcnQgb2YgdGhlIFdvcmtzcGFjZSBvcGVuIHNvdXJjZSBwcm9qZWN0LgogaHR0cHM6Ly9naXRodWIuY29tL1NER0dpZXNicmVjaHQvV29ya3NwYWNlI3dvcmtzcGFjZQoKIENvcHlyaWdodCDCqTIwMTggSmVyZW15IERhdmlkIEdpZXNicmVjaHQgYW5kIHRoZSBXb3Jrc3BhY2UgcHJvamVjdCBjb250cmlidXRvcnMuCgogU29saSBEZW8gZ2xvcmlhLgoKIExpY2Vuc2VkIHVuZGVyIHRoZSBBcGFjaGUgTGljZW5jZSwgVmVyc2lvbiAyLjAuCiBTZWUgaHR0cDovL3d3dy5hcGFjaGUub3JnL2xpY2Vuc2VzL0xJQ0VOU0UtMi4wIGZvciBsaWNlbmNlIGluZm9ybWF0aW9uLgogLS0+Cgo8aHRtbCBkaXI9IlsqdGV4dCBkaXJlY3Rpb24qXSIgbGFuZz0iWypsb2NhbGl6YXRpb24qXSI+CiA8aGVhZD4KICA8bWV0YSBjaGFyc2V0PSJ1dGYtOCI+CiAgPHRpdGxlPlsqdGl0bGUqXTwvdGl0bGU+CiAgPGxpbmsgcmVsPSJzdHlsZXNoZWV0IiBocmVmPSJbKnNpdGUgcm9vdCpdQ1NTL1Jvb3QuY3NzIj4KICA8bGluayByZWw9InN0eWxlc2hlZXQiIGhyZWY9Ilsqc2l0ZSByb290Kl1DU1MvU3dpZnQuY3NzIj4KICA8bGluayByZWw9InN0eWxlc2hlZXQiIGhyZWY9Ilsqc2l0ZSByb290Kl1DU1MvU2l0ZS5jc3MiPgogPC9oZWFkPgogPGJvZHk+CiAgPGhlYWRlciBjbGFzcz0ibmF2aWdhdGlvbuKAkGJhciI+CiAgIDxuYXYgY2xhc3M9Im5hdmlnYXRpb27igJBiYXIiPgogICAgPGRpdiBjbGFzcz0ibmF2aWdhdGlvbuKAkHBhdGgiIGRpcj0iWyp0ZXh0IGRpcmVjdGlvbipdIj4KClsqbmF2aWdhdGlvbiBwYXRoKl0KCiAgICA8L2Rpdj4KICAgPC9uYXY+CiAgPC9oZWFkZXI+CiAgPG1haW4+CiAgIDxkaXYgY2xhc3M9InRpdGxlIj4KICAgIFsqc3ltYm9sIHR5cGUqXQogICAgWypjb21waWxhdGlvbiBjb25kaXRpb25zKl0KICAgIDxoMT5bKnRpdGxlKl08L2gxPgogICA8L2Rpdj4KClsqY29udGVudCpdCgogIDwvbWFpbj4KIDwvYm9keT4KPC9odG1sPgo=")!, encoding: String.Encoding.utf8)!
    static let redirect = String(data: Data(base64Encoded: "PCFET0NUWVBFIGh0bWw+Cgo8IS0tCiBSZWRpcmVjdC5odG1sCgogVGhpcyBzb3VyY2UgZmlsZSBpcyBwYXJ0IG9mIHRoZSBXb3Jrc3BhY2Ugb3BlbiBzb3VyY2UgcHJvamVjdC4KIGh0dHBzOi8vZ2l0aHViLmNvbS9TREdHaWVzYnJlY2h0L1dvcmtzcGFjZSN3b3Jrc3BhY2UKCiBDb3B5cmlnaHQgwqkyMDE4IEplcmVteSBEYXZpZCBHaWVzYnJlY2h0IGFuZCB0aGUgV29ya3NwYWNlIHByb2plY3QgY29udHJpYnV0b3JzLgoKIFNvbGkgRGVvIGdsb3JpYS4KCiBMaWNlbnNlZCB1bmRlciB0aGUgQXBhY2hlIExpY2VuY2UsIFZlcnNpb24gMi4wLgogU2VlIGh0dHA6Ly93d3cuYXBhY2hlLm9yZy9saWNlbnNlcy9MSUNFTlNFLTIuMCBmb3IgbGljZW5jZSBpbmZvcm1hdGlvbi4KIC0tPgoKPGh0bWwgbGFuZz0ienh4Ij4KIDxoZWFkPgogIDxtZXRhIGNoYXJzZXQ9InV0Zi04Ij4KICA8dGl0bGU+4oazIC4uLzwvdGl0bGU+CiAgPGxpbmsgcmVsPSJjYW5vbmljYWwiIGhyZWY9IlsqdGFyZ2V0Kl0iLz4KICA8bWV0YSBodHRwLWVxdWl2PSJyZWZyZXNoIiBjb250ZW50PSIwOyB1cmw9Wyp0YXJnZXQqXSIgLz4KIDwvaGVhZD4KIDxib2R5PgogIDxwPuKGsyA8YSBocmVmPSJbKnRhcmdldCpdIj4uLi88L2E+CiA8L2JvZHk+CjwvaHRtbD4K")!, encoding: String.Encoding.utf8)!
    static let root = String(data: Data(base64Encoded: "LyoKIFJvb3QuY3NzCgogVGhpcyBzb3VyY2UgZmlsZSBpcyBwYXJ0IG9mIHRoZSBXb3Jrc3BhY2Ugb3BlbiBzb3VyY2UgcHJvamVjdC4KIGh0dHBzOi8vZ2l0aHViLmNvbS9TREdHaWVzYnJlY2h0L1dvcmtzcGFjZSN3b3Jrc3BhY2UKCiBDb3B5cmlnaHQgwqkyMDE4IEplcmVteSBEYXZpZCBHaWVzYnJlY2h0IGFuZCB0aGUgV29ya3NwYWNlIHByb2plY3QgY29udHJpYnV0b3JzLgoKIFNvbGkgRGVvIGdsb3JpYS4KCiBMaWNlbnNlZCB1bmRlciB0aGUgQXBhY2hlIExpY2VuY2UsIFZlcnNpb24gMi4wLgogU2VlIGh0dHA6Ly93d3cuYXBhY2hlLm9yZy9saWNlbnNlcy9MSUNFTlNFLTIuMCBmb3IgbGljZW5jZSBpbmZvcm1hdGlvbi4KICovCgovKiBMYXlvdXQgKi8KCmh0bWwsIGJvZHkgewogICAgbWFyZ2luOiAwOwogICAgcGFkZGluZzogMDsKfQoKLyogQ29sb3VycyAqLwoKaHRtbCB7CiAgICBiYWNrZ3JvdW5kLWNvbG9yOiAjRkZGRkZGOwogICAgY29sb3I6ICMwMDAwMDA7Cn0KCi8qIEZvbnRzICovCgpAbWVkaWEgcHJpbnQgewogICAgaHRtbCB7CiAgICAgICAgZm9udC1mYW1pbHk6IHNlcmlmOwogICAgfQp9CkBtZWRpYSBzY3JlZW4gewogICAgaHRtbCB7CiAgICAgICAgZm9udC1mYW1pbHk6IHNhbnMtc2VyaWY7CiAgICB9Cn0K")!, encoding: String.Encoding.utf8)!
    static let site = String(data: Data(base64Encoded: "LyoKIFNpdGUuY3NzCgogVGhpcyBzb3VyY2UgZmlsZSBpcyBwYXJ0IG9mIHRoZSBXb3Jrc3BhY2Ugb3BlbiBzb3VyY2UgcHJvamVjdC4KIGh0dHBzOi8vZ2l0aHViLmNvbS9TREdHaWVzYnJlY2h0L1dvcmtzcGFjZSN3b3Jrc3BhY2UKCiBDb3B5cmlnaHQgwqkyMDE4IEplcmVteSBEYXZpZCBHaWVzYnJlY2h0IGFuZCB0aGUgV29ya3NwYWNlIHByb2plY3QgY29udHJpYnV0b3JzLgoKIFNvbGkgRGVvIGdsb3JpYS4KCiBMaWNlbnNlZCB1bmRlciB0aGUgQXBhY2hlIExpY2VuY2UsIFZlcnNpb24gMi4wLgogU2VlIGh0dHA6Ly93d3cuYXBhY2hlLm9yZy9saWNlbnNlcy9MSUNFTlNFLTIuMCBmb3IgbGljZW5jZSBpbmZvcm1hdGlvbi4KICovCgovKiBHZW5lcmFsIExheW91dCAqLwoKKiwgKjo6YmVmb3JlLCAqOjphZnRlciB7CiAgICBib3gtc2l6aW5nOiBpbmhlcml0Owp9Cmh0bWwgewogICAgYm94LXNpemluZzogYm9yZGVyLWJveDsKfQoKaDEsIGgyIHsKICAgIG1hcmdpbjogMDsKfQpoMywgaDQsIGg1LCBoNiB7CiAgICBtYXJnaW4tdG9wOiAxLjRlbTsKICAgIG1hcmdpbi1ib3R0b206IDA7Cn0KCnNlY3Rpb24gewogICAgbWFyZ2luLXRvcDogM3JlbTsKfQpzZWN0aW9uOmxhc3QtY2hpbGQgewogICAgbWFyZ2luLWJvdHRvbTogM3JlbTsKfQoKcCB7CiAgICBtYXJnaW46IDA7Cn0KcDpub3QoOmZpcnN0LWNoaWxkKSB7CiAgICBtYXJnaW4tdG9wOiAwLjdlbTsKfQoKYmxvY2txdW90ZSB7CiAgICBtYXJnaW46IDEuNGVtIDA7Cn0KCmJsb2NrcXVvdGUgewogICAgYm9yZGVyLWxlZnQ6IDAuMjVlbSBzb2xpZCAjREZFMkU1OwogICAgcGFkZGluZzogMCAxZW07Cn0KYmxvY2txdW90ZSA+IHAsIGJsb2NrcXVvdGUgPiBwOm5vdCg6Zmlyc3QtY2hpbGQpIHsKICAgIG1hcmdpbjogMDsKfQpbZGlyPSJydGwiXSBibG9ja3F1b3RlID4gcC5jaXRhdGlvbiB7CiAgICB0ZXh0LWFsaWduOiBsZWZ0Owp9CltkaXI9Imx0ciJdIGJsb2NrcXVvdGUgPiBwLmNpdGF0aW9uIHsKICAgIHRleHQtYWxpZ246IHJpZ2h0Owp9Cgp1bCwgb2wgewogICAgbWFyZ2luLXRvcDogMC43ZW07CiAgICBtYXJnaW4tbGVmdDogMnJlbTsKICAgIG1hcmdpbi1yaWdodDogMnJlbTsKICAgIG1hcmdpbi1ib3R0b206IDA7CiAgICBwYWRkaW5nOiAwOwp9CmxpOm5vdCg6Zmlyc3QtY2hpbGQpIHsKICAgIG1hcmdpbi10b3A6IDAuN2VtOwp9CgovKiBTcGVjaWZpYyBMYXlvdXQgKi8KCmhlYWRlci5uYXZpZ2F0aW9u4oCQYmFyIHsKICAgIGJveC1zaXppbmc6IGNvbnRlbnQtYm94OwogICAgaGVpZ2h0OiBjYWxjKCg1MiAvIDE3KSAqIDFyZW0pOwogICAgcGFkZGluZzogMCBjYWxjKCgyMiAvIDE3KSAqIDFyZW0pOwogICAgcG9zaXRpb246IHN0aWNreTsKICAgICBwb3NpdGlvbjogLXdlYmtpdC1zdGlja3k7CiAgICAgdG9wOiAwOwp9Cm5hdi5uYXZpZ2F0aW9u4oCQYmFyIHsKICAgIGRpc3BsYXk6IGZsZXg7CiAgICAgYWxpZ24taXRlbXM6IGNlbnRlcjsKICAgICBqdXN0aWZ5LWNvbnRlbnQ6IHNwYWNlLWJldHdlZW47CiAgICBoZWlnaHQ6IDEwMCU7Cn0KLm5hdmlnYXRpb27igJBwYXRoIHsKICAgIGRpc3BsYXk6IGZsZXg7CiAgICAgYWxpZ24taXRlbXM6IGNlbnRlcjsKICAgICBqdXN0aWZ5LWNvbnRlbnQ6IHNwYWNlLWJldHdlZW47CiAgICAgb3ZlcmZsb3c6IGhpZGRlbjsKICAgICBmbGV4LXdyYXA6IG5vd3JhcDsKICAgICB3aGl0ZS1zcGFjZTogbm93cmFwOwogICAgIHRleHQtb3ZlcmZsb3c6IGVsbGlwc2lzOwogICAgaGVpZ2h0OiAxMDAlOwp9CltkaXI9InJ0bCJdLm5hdmlnYXRpb27igJBwYXRoIGEsIFtkaXI9InJ0bCJdLm5hdmlnYXRpb27igJBwYXRoIHNwYW4gewogICAgbWFyZ2luLXJpZ2h0OiAxLjA1ODgycmVtOwp9CltkaXI9Imx0ciJdLm5hdmlnYXRpb27igJBwYXRoIGEsIFtkaXI9Imx0ciJdLm5hdmlnYXRpb27igJBwYXRoIHNwYW4gewogICAgbWFyZ2luLWxlZnQ6IDEuMDU4ODJyZW07Cn0KLm5hdmlnYXRpb27igJBwYXRoIGE6Zmlyc3QtY2hpbGQsIC5uYXZpZ2F0aW9u4oCQcGF0aCBzcGFuOmZpcnN0LWNoaWxkIHsKICAgIG1hcmdpbi1sZWZ0OiAwOwogICAgbWFyZ2luLXJpZ2h0OiAwOwp9CltkaXI9InJ0bCJdLm5hdmlnYXRpb27igJBwYXRoIGE6OmJlZm9yZSwgW2Rpcj0icnRsIl0ubmF2aWdhdGlvbuKAkHBhdGggc3Bhbjo6YmVmb3JlIHsKICAgIHBhZGRpbmctbGVmdDogMS4wNTg4MnJlbTsKfQpbZGlyPSJsdHIiXS5uYXZpZ2F0aW9u4oCQcGF0aCBhOjpiZWZvcmUsIFtkaXI9Imx0ciJdLm5hdmlnYXRpb27igJBwYXRoIHNwYW46OmJlZm9yZSB7CiAgICBwYWRkaW5nLXJpZ2h0OiAxLjA1ODgycmVtOwp9Ci5uYXZpZ2F0aW9u4oCQcGF0aCBhOmZpcnN0LWNoaWxkOjpiZWZvcmUsIC5uYXZpZ2F0aW9u4oCQcGF0aCBzcGFuOmZpcnN0LWNoaWxkOjpiZWZvcmUgewogICAgZGlzcGxheTogbm9uZTsKfQoKLnRpdGxlIHsKICAgIG1hcmdpbi10b3A6IDJyZW07CiAgICBtYXJnaW4tYm90dG9tOiAxLjVyZW07Cn0KLnN5bWJvbOKAkHR5cGUgewogICAgbWFyZ2luLWJvdHRvbTogY2FsYygoMjAgLyAxNykgKiAxcmVtKTsKfQoKLmRlc2NyaXB0aW9uIHsKICAgIG1hcmdpbi1ib3R0b206IDJyZW07Cn0KLmRlc2NyaXB0aW9uIHAgewogICAgbWFyZ2luOiAwOwp9CgouZGVjbGFyYXRpb246OmJlZm9yZSB7CiAgICBib3JkZXItdG9wOiAxcHggc29saWQgI0Q2RDZENjsKICAgIGNvbnRlbnQ6ICIiOwogICAgZGlzcGxheTogYmxvY2s7Cn0KLmRlY2xhcmF0aW9uIHsKICAgIG1hcmdpbi10b3A6IDA7Cn0KLmRlY2xhcmF0aW9uIGgyIHsKICAgIG1hcmdpbi10b3A6IDJyZW07Cn0KLmRlY2xhcmF0aW9uIC5zd2lmdC5ibG9ja3F1b3RlIHsKICAgIG1hcmdpbi10b3A6IDFyZW07Cn0KCmgyICsgLmNoaWxkIHsKICAgIG1hcmdpbi10b3A6IDJyZW07Cn0KLmNoaWxkOm5vdCg6bGFzdC1jaGlsZCkgewogICAgbWFyZ2luLWJvdHRvbTogMS41cmVtOwp9Ci5jaGlsZCA+IHAgewogICAgbWFyZ2luOiAwIDIuMzUyOTRyZW07Cn0KCi8qIENvbG91cnMgKi8KCmh0bWwgewogICAgY29sb3I6ICMzMzMzMzM7Cn0KCmEgewogICAgY29sb3I6ICMwMDcwQzk7Cn0KCmJsb2NrcXVvdGUgewogICAgY29sb3I6ICM2QTczN0Q7Cn0KCi5uYXZpZ2F0aW9u4oCQYmFyIHsKICAgIGJhY2tncm91bmQtY29sb3I6ICMzMzM7CiAgICBjb2xvcjogI0NDQ0NDQzsKfQoubmF2aWdhdGlvbuKAkGJhciBhIHsKICAgIGNvbG9yOiAjRkZGRkZGOwp9Cgouc3ltYm9s4oCQdHlwZSB7CiAgICBjb2xvcjogIzY2NjsKfQoKCi8qIEdlbmVyYWwgRm9udHMgKi8KCmh0bWwgewogICAgZm9udC1mYW1pbHk6ICJTRiBQcm8gVGV4dCIsICJTRiBQcm8gSWNvbnMiLCAiLWFwcGxlLXN5c3RlbSIsICJCbGlua01hY1N5c3RlbUZvbnQiLCAiSGVsdmV0aWNhIE5ldWUiLCAiSGVsdmV0aWNhIiwgIkFyaWFsIiwgc2Fucy1zZXJpZjsKICAgIGZvbnQtc2l6ZTogMTA2LjI1JTsKICAgIGxldHRlci1zcGFjaW5nOiAtMC4wMjFlbTsKICAgIGxpbmUtaGVpZ2h0OiAxLjUyOTQ3Owp9CgpoMSwgaDIgewogICAgZm9udC1mYW1pbHk6ICJTRiBQcm8gRGlzcGxheSIsICJTRiBQcm8gSWNvbnMiLCAiLWFwcGxlLXN5c3RlbSIsICJCbGlua01hY1N5c3RlbUZvbnQiLCAiSGVsdmV0aWNhIE5ldWUiLCAiSGVsdmV0aWNhIiwgIkFyaWFsIiwgc2Fucy1zZXJpZjsKfQpoMSB7CiAgICBmb250LXNpemU6IGNhbGMoKDQwIC8gMTcpICogMXJlbSk7CiAgICBmb250LXdlaWdodDogNTAwOwogICAgbGV0dGVyLXNwYWNpbmc6IDAuMDA4ZW07CiAgICBsaW5lLWhlaWdodDogMS4wNTsKfQpoMiB7CiAgICBmb250LXNpemU6IGNhbGMoKDMyIC8gMTcpICogMXJlbSk7CiAgICBmb250LXdlaWdodDogNTAwOwogICAgbGV0dGVyLXNwYWNpbmc6IDAuMDExZW07CiAgICBsaW5lLWhlaWdodDogMS4wOTM3NTsKfQpoMyB7CiAgICBmb250LXNpemU6IGNhbGMoKDI4IC8gMTcpICogMXJlbSk7CiAgICBmb250LXdlaWdodDogNTAwOwogICAgbGV0dGVyLXNwYWNpbmc6IDAuMDEyZW07CiAgICBsaW5lLWhlaWdodDogMS4xMDczOwp9Cmg0LCBoNSwgaDYgewogICAgZm9udC13ZWlnaHQ6IDUwMDsKICAgIGxldHRlci1zcGFjaW5nOiAwLjAxNWVtOwogICAgbGluZS1oZWlnaHQ6IDEuMjA4NDk7Cn0KaDQgewogICAgZm9udC1zaXplOiBjYWxjKCgyNCAvIDE3KSAqIDFyZW0pOwp9Cmg1IHsKICAgIGZvbnQtc2l6ZTogY2FsYygoMjAgLyAxNykgKiAxcmVtKTsKfQpoNiB7CiAgICBmb250LXNpemU6IGNhbGMoKDE4IC8gMTcpICogMXJlbSk7Cn0KCmE6bGluaywgYTp2aXNpdGVkIHsKICAgIHRleHQtZGVjb3JhdGlvbjogbm9uZTsKfQphOmhvdmVyIHsKICAgIHRleHQtZGVjb3JhdGlvbjogdW5kZXJsaW5lOwp9CgovKiBTcGVjaWZpYyBGb250cyAqLwoKLm5hdmlnYXRpb27igJBwYXRoIHsKICAgIGZvbnQtc2l6ZTogY2FsYygoMTUgLyAxNykgKiAxcmVtKTsKICAgIGxldHRlci1zcGFjaW5nOiAtMC4wMTRlbTsKICAgIGxpbmUtaGVpZ2h0OiAxLjI2NjY3Owp9Ci5uYXZpZ2F0aW9u4oCQcGF0aCBhOjpiZWZvcmUsIC5uYXZpZ2F0aW9u4oCQcGF0aCBzcGFuOjpiZWZvcmUgewogICAgZm9udC1mYW1pbHk6ICJTRiBQcm8gSWNvbnMiLCAiLWFwcGxlLXN5c3RlbSIsICJCbGlua01hY1N5c3RlbUZvbnQiLCAiSGVsdmV0aWNhIE5ldWUiLCAiSGVsdmV0aWNhIiwgIkFyaWFsIiwgc2Fucy1zZXJpZjsKICAgIGNvbnRlbnQ6ICLigKMiOwogICAgbGluZS1oZWlnaHQ6IDE7Cn0KCi5zeW1ib2zigJB0eXBlIHsKICAgIGZvbnQtZmFtaWx5OiAiU0YgUHJvIERpc3BsYXkiLCAiU0YgUHJvIEljb25zIiwgIi1hcHBsZS1zeXN0ZW0iLCAiQmxpbmtNYWNTeXN0ZW1Gb250IiwgIkhlbHZldGljYSBOZXVlIiwgIkhlbHZldGljYSIsICJBcmlhbCIsIHNhbnMtc2VyaWY7CiAgICBmb250LXNpemU6IGNhbGMoKDIyIC8gMTcpICogMXJlbSk7CiAgICBsZXR0ZXItc3BhY2luZzogMC4wMTZlbTsKICAgIGxpbmUtaGVpZ2h0OiAxOwp9CgouZGVzY3JpcHRpb24gewogICAgZm9udC1mYW1pbHk6ICJTRiBQcm8gRGlzcGxheSIsICJTRiBQcm8gSWNvbnMiLCAiLWFwcGxlLXN5c3RlbSIsICJCbGlua01hY1N5c3RlbUZvbnQiLCAiSGVsdmV0aWNhIE5ldWUiLCAiSGVsdmV0aWNhIiwgIkFyaWFsIiwgc2Fucy1zZXJpZjsKICAgIGZvbnQtc2l6ZTogY2FsYygoMjIgLyAxNykgKiAxcmVtKTsKICAgIGZvbnQtd2VpZ2h0OiAzMDA7CiAgICBsZXR0ZXItc3BhY2luZzogMC4wMTZlbTsKICAgIGxpbmUtaGVpZ2h0OiAxLjQ1NDU1Owp9CgouZGVjbGFyYXRpb24gLnN3aWZ0LmJsb2NrcXVvdGUgewogICAgZm9udC1zaXplOiBjYWxjKCgxNSAvIDE3KSAqIDFyZW0pOwp9Cg==")!, encoding: String.Encoding.utf8)!

}
