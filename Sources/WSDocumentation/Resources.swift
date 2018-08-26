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
    static let site = String(data: Data(base64Encoded: "LyoKIFNpdGUuY3NzCgogVGhpcyBzb3VyY2UgZmlsZSBpcyBwYXJ0IG9mIHRoZSBXb3Jrc3BhY2Ugb3BlbiBzb3VyY2UgcHJvamVjdC4KIGh0dHBzOi8vZ2l0aHViLmNvbS9TREdHaWVzYnJlY2h0L1dvcmtzcGFjZSN3b3Jrc3BhY2UKCiBDb3B5cmlnaHQgwqkyMDE4IEplcmVteSBEYXZpZCBHaWVzYnJlY2h0IGFuZCB0aGUgV29ya3NwYWNlIHByb2plY3QgY29udHJpYnV0b3JzLgoKIFNvbGkgRGVvIGdsb3JpYS4KCiBMaWNlbnNlZCB1bmRlciB0aGUgQXBhY2hlIExpY2VuY2UsIFZlcnNpb24gMi4wLgogU2VlIGh0dHA6Ly93d3cuYXBhY2hlLm9yZy9saWNlbnNlcy9MSUNFTlNFLTIuMCBmb3IgbGljZW5jZSBpbmZvcm1hdGlvbi4KICovCgovKiBHZW5lcmFsIExheW91dCAqLwoKKiwgKjo6YmVmb3JlLCAqOjphZnRlciB7CiAgICBib3gtc2l6aW5nOiBpbmhlcml0Owp9Cmh0bWwgewogICAgYm94LXNpemluZzogYm9yZGVyLWJveDsKfQoKaDEsIGgyIHsKICAgIG1hcmdpbjogMDsKfQpoMywgaDQsIGg1LCBoNiB7CiAgICBtYXJnaW4tdG9wOiAxLjRlbTsKICAgIG1hcmdpbi1ib3R0b206IDA7Cn0KCnNlY3Rpb24gewogICAgbWFyZ2luLXRvcDogM3JlbTsKfQpzZWN0aW9uOmxhc3QtY2hpbGQgewogICAgbWFyZ2luLWJvdHRvbTogM3JlbTsKfQoKcCB7CiAgICBtYXJnaW46IDA7Cn0KcDpub3QoOmZpcnN0LWNoaWxkKSB7CiAgICBtYXJnaW4tdG9wOiAwLjdlbTsKfQoKYmxvY2txdW90ZSB7CiAgICBtYXJnaW46IDEuNGVtIDA7Cn0KCmJsb2NrcXVvdGUgewogICAgYm9yZGVyLWxlZnQ6IDAuMjVlbSBzb2xpZCAjREZFMkU1OwogICAgcGFkZGluZzogMCAxZW07Cn0KYmxvY2txdW90ZSA+IHAsIGJsb2NrcXVvdGUgPiBwOm5vdCg6Zmlyc3QtY2hpbGQpIHsKICAgIG1hcmdpbjogMDsKfQpbZGlyPSJydGwiXSBibG9ja3F1b3RlID4gcC5jaXRhdGlvbiB7CiAgICB0ZXh0LWFsaWduOiBsZWZ0Owp9CltkaXI9Imx0ciJdIGJsb2NrcXVvdGUgPiBwLmNpdGF0aW9uIHsKICAgIHRleHQtYWxpZ246IHJpZ2h0Owp9Cgp1bCwgb2wgewogICAgbWFyZ2luLXRvcDogMC43ZW07CiAgICBtYXJnaW4tbGVmdDogMnJlbTsKICAgIG1hcmdpbi1yaWdodDogMnJlbTsKICAgIG1hcmdpbi1ib3R0b206IDA7CiAgICBwYWRkaW5nOiAwOwp9CmxpOm5vdCg6Zmlyc3QtY2hpbGQpIHsKICAgIG1hcmdpbi10b3A6IDAuN2VtOwp9CgovKiBTcGVjaWZpYyBMYXlvdXQgKi8KCmhlYWRlci5uYXZpZ2F0aW9u4oCQYmFyIHsKICAgIGJveC1zaXppbmc6IGNvbnRlbnQtYm94OwogICAgaGVpZ2h0OiBjYWxjKCg1MiAvIDE3KSAqIDFyZW0pOwogICAgcGFkZGluZzogMCBjYWxjKCgyMiAvIDE3KSAqIDFyZW0pOwogICAgcG9zaXRpb246IHN0aWNreTsKICAgICBwb3NpdGlvbjogLXdlYmtpdC1zdGlja3k7CiAgICAgdG9wOiAwOwp9Cm5hdi5uYXZpZ2F0aW9u4oCQYmFyIHsKICAgIGRpc3BsYXk6IGZsZXg7CiAgICAgYWxpZ24taXRlbXM6IGNlbnRlcjsKICAgICBqdXN0aWZ5LWNvbnRlbnQ6IHNwYWNlLWJldHdlZW47CiAgICBoZWlnaHQ6IDEwMCU7Cn0KLm5hdmlnYXRpb27igJBwYXRoIHsKICAgIGRpc3BsYXk6IGZsZXg7CiAgICAgYWxpZ24taXRlbXM6IGNlbnRlcjsKICAgICBqdXN0aWZ5LWNvbnRlbnQ6IHNwYWNlLWJldHdlZW47CiAgICAgb3ZlcmZsb3c6IGhpZGRlbjsKICAgICBmbGV4LXdyYXA6IG5vd3JhcDsKICAgICB3aGl0ZS1zcGFjZTogbm93cmFwOwogICAgIHRleHQtb3ZlcmZsb3c6IGVsbGlwc2lzOwogICAgaGVpZ2h0OiAxMDAlOwp9CltkaXI9InJ0bCJdLm5hdmlnYXRpb27igJBwYXRoIGEsIFtkaXI9InJ0bCJdLm5hdmlnYXRpb27igJBwYXRoIHNwYW4gewogICAgbWFyZ2luLXJpZ2h0OiAxLjA1ODgycmVtOwp9CltkaXI9Imx0ciJdLm5hdmlnYXRpb27igJBwYXRoIGEsIFtkaXI9Imx0ciJdLm5hdmlnYXRpb27igJBwYXRoIHNwYW4gewogICAgbWFyZ2luLWxlZnQ6IDEuMDU4ODJyZW07Cn0KLm5hdmlnYXRpb27igJBwYXRoIGE6Zmlyc3QtY2hpbGQsIC5uYXZpZ2F0aW9u4oCQcGF0aCBzcGFuOmZpcnN0LWNoaWxkIHsKICAgIG1hcmdpbi1sZWZ0OiAwOwogICAgbWFyZ2luLXJpZ2h0OiAwOwp9CltkaXI9InJ0bCJdLm5hdmlnYXRpb27igJBwYXRoIGE6OmJlZm9yZSwgW2Rpcj0icnRsIl0ubmF2aWdhdGlvbuKAkHBhdGggc3Bhbjo6YmVmb3JlIHsKICAgIHBhZGRpbmctbGVmdDogMS4wNTg4MnJlbTsKfQpbZGlyPSJsdHIiXS5uYXZpZ2F0aW9u4oCQcGF0aCBhOjpiZWZvcmUsIFtkaXI9Imx0ciJdLm5hdmlnYXRpb27igJBwYXRoIHNwYW46OmJlZm9yZSB7CiAgICBwYWRkaW5nLXJpZ2h0OiAxLjA1ODgycmVtOwp9Ci5uYXZpZ2F0aW9u4oCQcGF0aCBhOmZpcnN0LWNoaWxkOjpiZWZvcmUsIC5uYXZpZ2F0aW9u4oCQcGF0aCBzcGFuOmZpcnN0LWNoaWxkOjpiZWZvcmUgewogICAgZGlzcGxheTogbm9uZTsKfQoKLnRpdGxlIHsKICAgIG1hcmdpbi10b3A6IDJyZW07CiAgICBtYXJnaW4tYm90dG9tOiAxLjVyZW07Cn0KLnN5bWJvbOKAkHR5cGUgewogICAgbWFyZ2luLWJvdHRvbTogY2FsYygoMjAgLyAxNykgKiAxcmVtKTsKfQoKLmRlc2NyaXB0aW9uIHsKICAgIG1hcmdpbi1ib3R0b206IDJyZW07Cn0KLmRlc2NyaXB0aW9uIHAgewogICAgbWFyZ2luOiAwOwp9CgouZGVjbGFyYXRpb246OmJlZm9yZSB7CiAgICBib3JkZXItdG9wOiAxcHggc29saWQgI0Q2RDZENjsKICAgIGNvbnRlbnQ6ICIiOwogICAgZGlzcGxheTogYmxvY2s7Cn0KLmRlY2xhcmF0aW9uIHsKICAgIG1hcmdpbi10b3A6IDA7Cn0KLmRlY2xhcmF0aW9uIGgyIHsKICAgIG1hcmdpbi10b3A6IDJyZW07Cn0KLmRlY2xhcmF0aW9uIC5zd2lmdC5ibG9ja3F1b3RlIHsKICAgIG1hcmdpbi10b3A6IDFyZW07Cn0KCi8qIENvbG91cnMgKi8KCmh0bWwgewogICAgY29sb3I6ICMzMzMzMzM7Cn0KLm5hdmlnYXRpb27igJBiYXIgewogICAgYmFja2dyb3VuZC1jb2xvcjogIzMzMzsKICAgIGNvbG9yOiAjQ0NDQ0NDOwp9Cgouc3ltYm9s4oCQdHlwZSB7CiAgICBjb2xvcjogIzY2NjsKfQphIHsKICAgIGNvbG9yOiAjMDA3MEM5Owp9CgovKiBHZW5lcmFsIEZvbnRzICovCgpodG1sIHsKICAgIGZvbnQtZmFtaWx5OiAiU0YgUHJvIFRleHQiLCAiU0YgUHJvIEljb25zIiwgIi1hcHBsZS1zeXN0ZW0iLCAiQmxpbmtNYWNTeXN0ZW1Gb250IiwgIkhlbHZldGljYSBOZXVlIiwgIkhlbHZldGljYSIsICJBcmlhbCIsIHNhbnMtc2VyaWY7CiAgICBmb250LXNpemU6IDEwNi4yNSU7CiAgICBsZXR0ZXItc3BhY2luZzogLTAuMDIxZW07CiAgICBsaW5lLWhlaWdodDogMS41Mjk0NzsKfQoKaDEsIGgyIHsKICAgIGZvbnQtZmFtaWx5OiAiU0YgUHJvIERpc3BsYXkiLCAiU0YgUHJvIEljb25zIiwgIi1hcHBsZS1zeXN0ZW0iLCAiQmxpbmtNYWNTeXN0ZW1Gb250IiwgIkhlbHZldGljYSBOZXVlIiwgIkhlbHZldGljYSIsICJBcmlhbCIsIHNhbnMtc2VyaWY7Cn0KaDEgewogICAgZm9udC1zaXplOiBjYWxjKCg0MCAvIDE3KSAqIDFyZW0pOwogICAgZm9udC13ZWlnaHQ6IDUwMDsKICAgIGxldHRlci1zcGFjaW5nOiAwLjAwOGVtOwogICAgbGluZS1oZWlnaHQ6IDEuMDU7Cn0KaDIgewogICAgZm9udC1zaXplOiBjYWxjKCgzMiAvIDE3KSAqIDFyZW0pOwogICAgZm9udC13ZWlnaHQ6IDUwMDsKICAgIGxldHRlci1zcGFjaW5nOiAwLjAxMWVtOwogICAgbGluZS1oZWlnaHQ6IDEuMDkzNzU7Cn0KaDMgewogICAgZm9udC1zaXplOiBjYWxjKCgyOCAvIDE3KSAqIDFyZW0pOwogICAgZm9udC13ZWlnaHQ6IDUwMDsKICAgIGxldHRlci1zcGFjaW5nOiAwLjAxMmVtOwogICAgbGluZS1oZWlnaHQ6IDEuMTA3MzsKfQpoNCwgaDUsIGg2IHsKICAgIGZvbnQtd2VpZ2h0OiA1MDA7CiAgICBsZXR0ZXItc3BhY2luZzogMC4wMTVlbTsKICAgIGxpbmUtaGVpZ2h0OiAxLjIwODQ5Owp9Cmg0IHsKICAgIGZvbnQtc2l6ZTogY2FsYygoMjQgLyAxNykgKiAxcmVtKTsKfQpoNSB7CiAgICBmb250LXNpemU6IGNhbGMoKDIwIC8gMTcpICogMXJlbSk7Cn0KaDYgewogICAgZm9udC1zaXplOiBjYWxjKCgxOCAvIDE3KSAqIDFyZW0pOwp9CgphOmxpbmssIGE6dmlzaXRlZCB7CiAgICB0ZXh0LWRlY29yYXRpb246IG5vbmU7Cn0KYTpob3ZlciB7CiAgICB0ZXh0LWRlY29yYXRpb246IHVuZGVybGluZTsKfQoKYmxvY2txdW90ZSB7CiAgICBjb2xvcjogIzZBNzM3RDsKfQoKLyogU3BlY2lmaWMgRm9udHMgKi8KCi5uYXZpZ2F0aW9u4oCQcGF0aCB7CiAgICBmb250LXNpemU6IGNhbGMoKDE1IC8gMTcpICogMXJlbSk7CiAgICBsZXR0ZXItc3BhY2luZzogLTAuMDE0ZW07CiAgICBsaW5lLWhlaWdodDogMS4yNjY2NzsKfQoubmF2aWdhdGlvbuKAkHBhdGggYTo6YmVmb3JlLCAubmF2aWdhdGlvbuKAkHBhdGggc3Bhbjo6YmVmb3JlIHsKICAgIGZvbnQtZmFtaWx5OiAiU0YgUHJvIEljb25zIiwgIi1hcHBsZS1zeXN0ZW0iLCAiQmxpbmtNYWNTeXN0ZW1Gb250IiwgIkhlbHZldGljYSBOZXVlIiwgIkhlbHZldGljYSIsICJBcmlhbCIsIHNhbnMtc2VyaWY7CiAgICBjb250ZW50OiAi4oCjIjsKICAgIGxpbmUtaGVpZ2h0OiAxOwp9Cgouc3ltYm9s4oCQdHlwZSB7CiAgICBmb250LWZhbWlseTogIlNGIFBybyBEaXNwbGF5IiwgIlNGIFBybyBJY29ucyIsICItYXBwbGUtc3lzdGVtIiwgIkJsaW5rTWFjU3lzdGVtRm9udCIsICJIZWx2ZXRpY2EgTmV1ZSIsICJIZWx2ZXRpY2EiLCAiQXJpYWwiLCBzYW5zLXNlcmlmOwogICAgZm9udC1zaXplOiBjYWxjKCgyMiAvIDE3KSAqIDFyZW0pOwogICAgbGV0dGVyLXNwYWNpbmc6IDAuMDE2ZW07CiAgICBsaW5lLWhlaWdodDogMTsKfQoKLmRlc2NyaXB0aW9uIHsKICAgIGZvbnQtZmFtaWx5OiAiU0YgUHJvIERpc3BsYXkiLCAiU0YgUHJvIEljb25zIiwgIi1hcHBsZS1zeXN0ZW0iLCAiQmxpbmtNYWNTeXN0ZW1Gb250IiwgIkhlbHZldGljYSBOZXVlIiwgIkhlbHZldGljYSIsICJBcmlhbCIsIHNhbnMtc2VyaWY7CiAgICBmb250LXNpemU6IGNhbGMoKDIyIC8gMTcpICogMXJlbSk7CiAgICBmb250LXdlaWdodDogMzAwOwogICAgbGV0dGVyLXNwYWNpbmc6IDAuMDE2ZW07CiAgICBsaW5lLWhlaWdodDogMS40NTQ1NTsKfQoKLmRlY2xhcmF0aW9uIC5zd2lmdC5ibG9ja3F1b3RlIHsKICAgIGZvbnQtc2l6ZTogY2FsYygoMTUgLyAxNykgKiAxcmVtKTsKfQo=")!, encoding: String.Encoding.utf8)!

}
