/*
 Resources.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2018–2019 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import Foundation

internal enum Resources {}

extension Resources {
    static let page = String(data: Data(base64Encoded: "PCFET0NUWVBFIGh0bWw+Cgo8IS0tCiBQYWdlLmh0bWwKCiBUaGlzIHNvdXJjZSBmaWxlIGlzIHBhcnQgb2YgdGhlIFdvcmtzcGFjZSBvcGVuIHNvdXJjZSBwcm9qZWN0LgogaHR0cHM6Ly9naXRodWIuY29tL1NER0dpZXNicmVjaHQvV29ya3NwYWNlI3dvcmtzcGFjZQoKIENvcHlyaWdodCDCqTIwMTjigJMyMDE5IEplcmVteSBEYXZpZCBHaWVzYnJlY2h0IGFuZCB0aGUgV29ya3NwYWNlIHByb2plY3QgY29udHJpYnV0b3JzLgoKIFNvbGkgRGVvIGdsb3JpYS4KCiBMaWNlbnNlZCB1bmRlciB0aGUgQXBhY2hlIExpY2VuY2UsIFZlcnNpb24gMi4wLgogU2VlIGh0dHA6Ly93d3cuYXBhY2hlLm9yZy9saWNlbnNlcy9MSUNFTlNFLTIuMCBmb3IgbGljZW5jZSBpbmZvcm1hdGlvbi4KIC0tPgoKPGh0bWwgZGlyPSJbKnRleHQgZGlyZWN0aW9uKl0iIGxhbmc9IlsqbG9jYWxpemF0aW9uKl0iPgogPGhlYWQ+CiAgPG1ldGEgY2hhcnNldD0idXRmJiN4MDAyRDs4Ij4KICA8dGl0bGU+Wyp0aXRsZSpdPC90aXRsZT4KICA8bGluayByZWw9InN0eWxlc2hlZXQiIGhyZWY9Ilsqc2l0ZSByb290Kl1DU1MvUm9vdC5jc3MiPgogIDxsaW5rIHJlbD0ic3R5bGVzaGVldCIgaHJlZj0iWypzaXRlIHJvb3QqXUNTUy9Td2lmdC5jc3MiPgogIDxsaW5rIHJlbD0ic3R5bGVzaGVldCIgaHJlZj0iWypzaXRlIHJvb3QqXUNTUy9TaXRlLmNzcyI+CiAgPHNjcmlwdCBzcmM9Ilsqc2l0ZSByb290Kl1KYXZhU2NyaXB0L1NpdGUuanMiPjwvc2NyaXB0PgogPC9oZWFkPgogPGJvZHk+CiAgPGhlYWRlciBjbGFzcz0ibmF2aWdhdGlvbuKAkGJhciI+CiAgIDxuYXYgY2xhc3M9Im5hdmlnYXRpb27igJBiYXIiPgogICAgPGRpdiBjbGFzcz0ibmF2aWdhdGlvbuKAkHBhdGgiIGRpcj0iWyp0ZXh0IGRpcmVjdGlvbipdIj4KClsqbmF2aWdhdGlvbiBwYXRoKl0KCiAgICA8L2Rpdj4KICAgIDxkaXY+CiAgICAgWypwYWNrYWdlIGltcG9ydCpdCiAgICA8L2Rpdj4KICAgPC9uYXY+CiAgPC9oZWFkZXI+CiAgPGRpdiBjbGFzcz0iY29udGVudOKAkGNvbnRhaW5lciI+CiAgIDxoZWFkZXIgY2xhc3M9ImluZGV4Ij4KICAgIDxuYXYgY2xhc3M9ImluZGV4Ij4KClsqaW5kZXgqXQoKICAgIDwvbmF2PgogICA8L2hlYWRlcj4KICAgPG1haW4+CiAgICA8ZGl2IGNsYXNzPSJtYWlu4oCQdGV4dOKAkGNvbHVtbiI+CiAgICAgPGRpdiBjbGFzcz0idGl0bGUiPgogICAgICBbKnN5bWJvbCB0eXBlKl0KICAgICAgWypjb21waWxhdGlvbiBjb25kaXRpb25zKl0KICAgICAgPGgxPlsqdGl0bGUqXTwvaDE+CiAgICAgIFsqY29uc3RyYWludHMqXQogICAgIDwvZGl2PgoKWypjb250ZW50Kl0KCiAgICA8L2Rpdj4KICAgPC9tYWluPgogIDwvZGl2PgogIDxmb290ZXIgZGlyPSJbKnRleHQgZGlyZWN0aW9uKl0iPgogICBbKmNvcHlyaWdodCpdCiAgIFsqd29ya3NwYWNlKl0KICA8L2Zvb3Rlcj4KICA8c2NyaXB0PmNvbnRyYWN0SW5kZXgoKTs8L3NjcmlwdD4KIDwvYm9keT4KPC9odG1sPgo=")!, encoding: String.Encoding.utf8)!
    static let redirect = String(data: Data(base64Encoded: "PCFET0NUWVBFIGh0bWw+Cgo8IS0tCiBSZWRpcmVjdC5odG1sCgogVGhpcyBzb3VyY2UgZmlsZSBpcyBwYXJ0IG9mIHRoZSBXb3Jrc3BhY2Ugb3BlbiBzb3VyY2UgcHJvamVjdC4KIGh0dHBzOi8vZ2l0aHViLmNvbS9TREdHaWVzYnJlY2h0L1dvcmtzcGFjZSN3b3Jrc3BhY2UKCiBDb3B5cmlnaHQgwqkyMDE44oCTMjAxOSBKZXJlbXkgRGF2aWQgR2llc2JyZWNodCBhbmQgdGhlIFdvcmtzcGFjZSBwcm9qZWN0IGNvbnRyaWJ1dG9ycy4KCiBTb2xpIERlbyBnbG9yaWEuCgogTGljZW5zZWQgdW5kZXIgdGhlIEFwYWNoZSBMaWNlbmNlLCBWZXJzaW9uIDIuMC4KIFNlZSBodHRwOi8vd3d3LmFwYWNoZS5vcmcvbGljZW5zZXMvTElDRU5TRS0yLjAgZm9yIGxpY2VuY2UgaW5mb3JtYXRpb24uCiAtLT4KCjxodG1sIGxhbmc9Inp4eCI+CiA8aGVhZD4KICA8bWV0YSBjaGFyc2V0PSJ1dGYmI3gwMDJEOzgiPgogIDx0aXRsZT7ihrMgLi4vPC90aXRsZT4KICA8bGluayByZWw9ImNhbm9uaWNhbCIgaHJlZj0iWyp0YXJnZXQqXSIvPgogIDxtZXRhIGh0dHAtZXF1aXY9InJlZnJlc2giIGNvbnRlbnQ9IjA7IHVybD1bKnRhcmdldCpdIiAvPgogPC9oZWFkPgogPGJvZHk+CiAgPHA+4oazIDxhIGhyZWY9IlsqdGFyZ2V0Kl0iPi4uLzwvYT4KIDwvYm9keT4KPC9odG1sPgo=")!, encoding: String.Encoding.utf8)!
    static let root = String(data: Data(base64Encoded: "LyoKIFJvb3QuY3NzCgogVGhpcyBzb3VyY2UgZmlsZSBpcyBwYXJ0IG9mIHRoZSBXb3Jrc3BhY2Ugb3BlbiBzb3VyY2UgcHJvamVjdC4KIGh0dHBzOi8vZ2l0aHViLmNvbS9TREdHaWVzYnJlY2h0L1dvcmtzcGFjZSN3b3Jrc3BhY2UKCiBDb3B5cmlnaHQgwqkyMDE44oCTMjAxOSBKZXJlbXkgRGF2aWQgR2llc2JyZWNodCBhbmQgdGhlIFdvcmtzcGFjZSBwcm9qZWN0IGNvbnRyaWJ1dG9ycy4KCiBTb2xpIERlbyBnbG9yaWEuCgogTGljZW5zZWQgdW5kZXIgdGhlIEFwYWNoZSBMaWNlbmNlLCBWZXJzaW9uIDIuMC4KIFNlZSBodHRwOi8vd3d3LmFwYWNoZS5vcmcvbGljZW5zZXMvTElDRU5TRS0yLjAgZm9yIGxpY2VuY2UgaW5mb3JtYXRpb24uCiAqLwoKLyogTGF5b3V0ICovCgpodG1sLCBib2R5IHsKICAgIG1hcmdpbjogMDsKICAgIHBhZGRpbmc6IDA7Cn0KCi8qIENvbG91cnMgKi8KCmh0bWwgewogICAgYmFja2dyb3VuZC1jb2xvcjogI0ZGRkZGRjsKICAgIGNvbG9yOiAjMDAwMDAwOwp9CgovKiBGb250cyAqLwoKQG1lZGlhIHByaW50IHsKICAgIGh0bWwgewogICAgICAgIGZvbnQtZmFtaWx5OiBzZXJpZjsKICAgIH0KfQpAbWVkaWEgc2NyZWVuIHsKICAgIGh0bWwgewogICAgICAgIGZvbnQtZmFtaWx5OiBzYW5zLXNlcmlmOwogICAgfQp9CgpzcGFuW2xhbmddIHsKICAgIGZvbnQtc3R5bGU6IGl0YWxpYzsKfQo=")!, encoding: String.Encoding.utf8)!
    static let script = String(data: Data(base64Encoded: "LyoKIFNjcmlwdC5qcwoKIFRoaXMgc291cmNlIGZpbGUgaXMgcGFydCBvZiB0aGUgV29ya3NwYWNlIG9wZW4gc291cmNlIHByb2plY3QuCiBodHRwczovL2dpdGh1Yi5jb20vU0RHR2llc2JyZWNodC9Xb3Jrc3BhY2Ujd29ya3NwYWNlCgogQ29weXJpZ2h0IMKpMjAxOOKAkzIwMTkgSmVyZW15IERhdmlkIEdpZXNicmVjaHQgYW5kIHRoZSBXb3Jrc3BhY2UgcHJvamVjdCBjb250cmlidXRvcnMuCgogU29saSBEZW8gZ2xvcmlhLgoKIExpY2Vuc2VkIHVuZGVyIHRoZSBBcGFjaGUgTGljZW5jZSwgVmVyc2lvbiAyLjAuCiBTZWUgaHR0cDovL3d3dy5hcGFjaGUub3JnL2xpY2Vuc2VzL0xJQ0VOU0UtMi4wIGZvciBsaWNlbmNlIGluZm9ybWF0aW9uLgogKi8KCmZ1bmN0aW9uIHRvZ2dsZUxpbmtWaXNpYmlsaXR5KGxpbmspIHsKICAgIGlmIChsaW5rLmhhc0F0dHJpYnV0ZSgic3R5bGUiKSkgewogICAgICAgIGxpbmsucmVtb3ZlQXR0cmlidXRlKCJzdHlsZSIpOwogICAgfSBlbHNlIHsKICAgICAgICBsaW5rLnN0eWxlWyJwYWRkaW5nLXRvcCJdID0gMDsKICAgICAgICBsaW5rLnN0eWxlWyJwYWRkaW5nLWJvdHRvbSJdID0gMDsKICAgICAgICBsaW5rLnN0eWxlLmhlaWdodCA9IDA7CiAgICB9Cn0KCmZ1bmN0aW9uIHRvZ2dsZUluZGV4U2VjdGlvblZpc2liaWxpdHkoc2VuZGVyKSB7CiAgICB2YXIgc2VjdGlvbiA9IHNlbmRlci5wYXJlbnRFbGVtZW50OwogICAgdmFyIGxpbmtzID0gc2VjdGlvbi5jaGlsZHJlbgogICAgZm9yICh2YXIgbGlua0luZGV4ID0gMTsgbGlua0luZGV4IDwgbGlua3MubGVuZ3RoOyBsaW5rSW5kZXgrKykgewogICAgICAgIHZhciBsaW5rID0gbGlua3NbbGlua0luZGV4XQogICAgICAgIHRvZ2dsZUxpbmtWaXNpYmlsaXR5KGxpbmspCiAgICB9Cn0KCmZ1bmN0aW9uIGNvbnRyYWN0SW5kZXgoKSB7CiAgICB2YXIgaW5kZXhFbGVtZW50cyA9IGRvY3VtZW50LmdldEVsZW1lbnRzQnlDbGFzc05hbWUoImluZGV4Iik7CiAgICB2YXIgaW5kZXggPSBpbmRleEVsZW1lbnRzLml0ZW0oaW5kZXhFbGVtZW50cy5sZW5ndGggLSAxKTsKICAgIHZhciBzZWN0aW9ucyA9IGluZGV4LmNoaWxkcmVuOwogICAgZm9yICh2YXIgc2VjdGlvbkluZGV4ID0gMTsgc2VjdGlvbkluZGV4IDwgc2VjdGlvbnMubGVuZ3RoOyBzZWN0aW9uSW5kZXgrKykgewogICAgICAgIHZhciBzZWN0aW9uID0gc2VjdGlvbnNbc2VjdGlvbkluZGV4XQogICAgICAgIHZhciBsaW5rcyA9IHNlY3Rpb24uY2hpbGRyZW4KICAgICAgICBmb3IgKHZhciBsaW5rSW5kZXggPSAxOyBsaW5rSW5kZXggPCBsaW5rcy5sZW5ndGg7IGxpbmtJbmRleCsrKSB7CiAgICAgICAgICAgIHZhciBsaW5rID0gbGlua3NbbGlua0luZGV4XQogICAgICAgICAgICB0b2dnbGVMaW5rVmlzaWJpbGl0eShsaW5rKQogICAgICAgIH0KICAgIH0KfQo=")!, encoding: String.Encoding.utf8)!
    static let site = String(data: Data(base64Encoded: "LyoKIFNpdGUuY3NzCgogVGhpcyBzb3VyY2UgZmlsZSBpcyBwYXJ0IG9mIHRoZSBXb3Jrc3BhY2Ugb3BlbiBzb3VyY2UgcHJvamVjdC4KIGh0dHBzOi8vZ2l0aHViLmNvbS9TREdHaWVzYnJlY2h0L1dvcmtzcGFjZSN3b3Jrc3BhY2UKCiBDb3B5cmlnaHQgwqkyMDE44oCTMjAxOSBKZXJlbXkgRGF2aWQgR2llc2JyZWNodCBhbmQgdGhlIFdvcmtzcGFjZSBwcm9qZWN0IGNvbnRyaWJ1dG9ycy4KCiBTb2xpIERlbyBnbG9yaWEuCgogTGljZW5zZWQgdW5kZXIgdGhlIEFwYWNoZSBMaWNlbmNlLCBWZXJzaW9uIDIuMC4KIFNlZSBodHRwOi8vd3d3LmFwYWNoZS5vcmcvbGljZW5zZXMvTElDRU5TRS0yLjAgZm9yIGxpY2VuY2UgaW5mb3JtYXRpb24uCiAqLwoKLyogR2VuZXJhbCBMYXlvdXQgKi8KCiosICo6OmJlZm9yZSwgKjo6YWZ0ZXIgewogICAgYm94LXNpemluZzogaW5oZXJpdDsKfQpodG1sIHsKICAgIGJveC1zaXppbmc6IGJvcmRlci1ib3g7Cn0KCi5tYWlu4oCQdGV4dOKAkGNvbHVtbiB7CiAgICBtYXgtd2lkdGg6IDUwZW07Cn0KCmgxLCBoMiB7CiAgICBtYXJnaW46IDA7Cn0KaDMsIGg0LCBoNSwgaDYgewogICAgbWFyZ2luLXRvcDogMS40ZW07CiAgICBtYXJnaW4tYm90dG9tOiAwOwp9CgpzZWN0aW9uIHsKICAgIG1hcmdpbi10b3A6IDNyZW07Cn0Kc2VjdGlvbjpsYXN0LWNoaWxkIHsKICAgIG1hcmdpbi1ib3R0b206IDNyZW07Cn0KCnAgewogICAgbWFyZ2luOiAwOwp9CnA6bm90KDpmaXJzdC1jaGlsZCkgewogICAgbWFyZ2luLXRvcDogMC43ZW07Cn0KCmJsb2NrcXVvdGUgewogICAgbWFyZ2luOiAxLjRlbSAwOwp9CgpibG9ja3F1b3RlIHsKICAgIGJvcmRlci1sZWZ0OiAwLjI1ZW0gc29saWQgI0RGRTJFNTsKICAgIHBhZGRpbmc6IDAgMWVtOwp9CmJsb2NrcXVvdGUgPiBwLCBibG9ja3F1b3RlID4gcDpub3QoOmZpcnN0LWNoaWxkKSB7CiAgICBtYXJnaW46IDA7Cn0KW2Rpcj0icnRsIl0gYmxvY2txdW90ZSA+IHAuY2l0YXRpb24gewogICAgdGV4dC1hbGlnbjogbGVmdDsKfQpbZGlyPSJsdHIiXSBibG9ja3F1b3RlID4gcC5jaXRhdGlvbiB7CiAgICB0ZXh0LWFsaWduOiByaWdodDsKfQoKdWwsIG9sIHsKICAgIG1hcmdpbi10b3A6IDAuN2VtOwogICAgbWFyZ2luLWxlZnQ6IDJyZW07CiAgICBtYXJnaW4tcmlnaHQ6IDJyZW07CiAgICBtYXJnaW4tYm90dG9tOiAwOwogICAgcGFkZGluZzogMDsKfQpsaTpub3QoOmZpcnN0LWNoaWxkKSB7CiAgICBtYXJnaW4tdG9wOiAwLjdlbTsKfQoKLmNhbGxvdXQgewogICAgYm9yZGVyLWxlZnQtd2lkdGg6IGNhbGMoKDYgLyAxNykgKiAxcmVtKTsKICAgIGJvcmRlci1sZWZ0LXN0eWxlOiBzb2xpZDsKICAgIGJvcmRlci1yaWdodC1jb2xvcjogdHJhbnNwYXJlbnQ7CiAgICBib3JkZXItcmlnaHQtd2lkdGg6IGNhbGMoKDYgLyAxNykgKiAxcmVtKTsKICAgIGJvcmRlci1yaWdodC1zdHlsZTogc29saWQ7CiAgICBib3JkZXItcmFkaXVzOiBjYWxjKCg2IC8gMTcpICogMXJlbSk7CiAgICBtYXJnaW4tdG9wOiAxLjRlbTsKICAgIHBhZGRpbmc6IDAuOTQxMThyZW07Cn0KCi8qIFNwZWNpZmljIExheW91dCAqLwoKaGVhZGVyLm5hdmlnYXRpb27igJBiYXIgewogICAgYm94LXNpemluZzogY29udGVudC1ib3g7CiAgICBoZWlnaHQ6IGNhbGMoKDUyIC8gMTcpICogMXJlbSk7CiAgICBwYWRkaW5nOiAwIGNhbGMoKDIyIC8gMTcpICogMXJlbSk7Cn0KbmF2Lm5hdmlnYXRpb27igJBiYXIgewogICAgZGlzcGxheTogZmxleDsKICAgICBhbGlnbi1pdGVtczogY2VudGVyOwogICAgIGp1c3RpZnktY29udGVudDogc3BhY2UtYmV0d2VlbjsKICAgIGhlaWdodDogMTAwJTsKfQoubmF2aWdhdGlvbuKAkHBhdGggewogICAgZGlzcGxheTogZmxleDsKICAgICBhbGlnbi1pdGVtczogY2VudGVyOwogICAgIGp1c3RpZnktY29udGVudDogc3BhY2UtYmV0d2VlbjsKICAgICBvdmVyZmxvdzogaGlkZGVuOwogICAgIGZsZXgtd3JhcDogbm93cmFwOwogICAgIHdoaXRlLXNwYWNlOiBub3dyYXA7CiAgICAgdGV4dC1vdmVyZmxvdzogZWxsaXBzaXM7CiAgICBoZWlnaHQ6IDEwMCU7Cn0KW2Rpcj0icnRsIl0ubmF2aWdhdGlvbuKAkHBhdGggYSwgW2Rpcj0icnRsIl0ubmF2aWdhdGlvbuKAkHBhdGggc3BhbiB7CiAgICBtYXJnaW4tcmlnaHQ6IDEuMDU4ODJyZW07Cn0KW2Rpcj0ibHRyIl0ubmF2aWdhdGlvbuKAkHBhdGggYSwgW2Rpcj0ibHRyIl0ubmF2aWdhdGlvbuKAkHBhdGggc3BhbiB7CiAgICBtYXJnaW4tbGVmdDogMS4wNTg4MnJlbTsKfQoubmF2aWdhdGlvbuKAkHBhdGggYTpmaXJzdC1jaGlsZCwgLm5hdmlnYXRpb27igJBwYXRoIHNwYW46Zmlyc3QtY2hpbGQgewogICAgbWFyZ2luLWxlZnQ6IDA7CiAgICBtYXJnaW4tcmlnaHQ6IDA7Cn0KW2Rpcj0icnRsIl0ubmF2aWdhdGlvbuKAkHBhdGggYTo6YmVmb3JlLCBbZGlyPSJydGwiXS5uYXZpZ2F0aW9u4oCQcGF0aCBzcGFuOjpiZWZvcmUgewogICAgcGFkZGluZy1sZWZ0OiAxLjA1ODgycmVtOwp9CltkaXI9Imx0ciJdLm5hdmlnYXRpb27igJBwYXRoIGE6OmJlZm9yZSwgW2Rpcj0ibHRyIl0ubmF2aWdhdGlvbuKAkHBhdGggc3Bhbjo6YmVmb3JlIHsKICAgIHBhZGRpbmctcmlnaHQ6IDEuMDU4ODJyZW07Cn0KLm5hdmlnYXRpb27igJBwYXRoIGE6Zmlyc3QtY2hpbGQ6OmJlZm9yZSwgLm5hdmlnYXRpb27igJBwYXRoIHNwYW46Zmlyc3QtY2hpbGQ6OmJlZm9yZSB7CiAgICBkaXNwbGF5OiBub25lOwp9CgouY29udGVudOKAkGNvbnRhaW5lciB7CiAgICBoZWlnaHQ6IGNhbGMoMTAwdmggLSBjYWxjKCg1MiAvIDE3KSAqIDFyZW0pIC0gY2FsYygoNDUgLyAxNykgKiAxcmVtKSk7CiAgICB3aWR0aDogMTAwJTsKICAgIGRpc3BsYXk6IGZsZXg7Cn0KaGVhZGVyLmluZGV4IHsKICAgIGhlaWdodDogMTAwJTsKICAgIG1heC13aWR0aDogMjUlOwogICAgcGFkZGluZzogY2FsYygoMTIgLyAxNykgKiAxcmVtKSAwOwogICAgb3ZlcmZsb3cteTogYXV0bzsKfQoKLmluZGV4IGEgewogICAgY3Vyc29yOiBwb2ludGVyOwogICAgZGlzcGxheTogYmxvY2s7CiAgICBwYWRkaW5nOiAwLjJlbSBjYWxjKCgyMiAvIDE3KSAqIDFyZW0pOwogICAgb3ZlcmZsb3c6IGhpZGRlbjsKfQouaW5kZXggYTpub3QoOmZpcnN0LWNoaWxkKSB7CiAgICBwYWRkaW5nLWxlZnQ6IGNhbGMoMWVtICsgY2FsYygoMjIgLyAxNykgKiAxcmVtKSk7Cn0KCm1haW4gewogICAgZmxleC1ncm93OiAxOwogICAgaGVpZ2h0OiAxMDAlOwogICAgb3ZlcmZsb3cteTogYXV0bzsKfQoubWFpbuKAkHRleHTigJBjb2x1bW4gewogICAgcGFkZGluZzogMCBjYWxjKCgyMiAvIDE3KSAqIDFyZW0pOwp9CgoudGl0bGUgewogICAgbWFyZ2luLXRvcDogMnJlbTsKICAgIG1hcmdpbi1ib3R0b206IDEuNXJlbTsKfQouc3ltYm9s4oCQdHlwZSB7CiAgICBtYXJnaW4tYm90dG9tOiBjYWxjKCgyMCAvIDE3KSAqIDFyZW0pOwp9CgouZGVzY3JpcHRpb24gewogICAgbWFyZ2luLWJvdHRvbTogMnJlbTsKfQouZGVzY3JpcHRpb24gcCB7CiAgICBtYXJnaW46IDA7Cn0KCi5kZWNsYXJhdGlvbjo6YmVmb3JlIHsKICAgIGJvcmRlci10b3A6IDFweCBzb2xpZCAjRDZENkQ2OwogICAgY29udGVudDogIiI7CiAgICBkaXNwbGF5OiBibG9jazsKfQouZGVjbGFyYXRpb24gewogICAgbWFyZ2luLXRvcDogMDsKfQouZGVjbGFyYXRpb24gaDIgewogICAgbWFyZ2luLXRvcDogMnJlbTsKfQouZGVjbGFyYXRpb24gLnN3aWZ0LmJsb2NrcXVvdGUgewogICAgbWFyZ2luLXRvcDogMXJlbTsKfQoKaDIgKyAuY2hpbGQgewogICAgbWFyZ2luLXRvcDogMnJlbTsKfQouY2hpbGQ6bm90KDpsYXN0LWNoaWxkKSB7CiAgICBtYXJnaW4tYm90dG9tOiAxLjVyZW07Cn0KLmNoaWxkID4gcCB7CiAgICBtYXJnaW46IDAgMi4zNTI5NHJlbTsKfQoKZm9vdGVyIHsKICAgIGRpc3BsYXk6IGZsZXg7CiAgICAgYWxpZ24taXRlbXM6IGNlbnRlcjsKICAgICBqdXN0aWZ5LWNvbnRlbnQ6IHNwYWNlLWJldHdlZW47CiAgICBoZWlnaHQ6IGNhbGMoKDQ1IC8gMTcpICogMXJlbSk7CiAgICBwYWRkaW5nOiAwIGNhbGMoKDIyIC8gMTcpICogMXJlbSk7Cn0KCi8qIENvbG91cnMgKi8KCmh0bWwgewogICAgY29sb3I6ICMzMzMzMzM7Cn0KCmEgewogICAgY29sb3I6ICMwMDcwQzk7Cn0KCmJsb2NrcXVvdGUgewogICAgY29sb3I6ICM2QTczN0Q7Cn0KCi5uYXZpZ2F0aW9u4oCQYmFyIHsKICAgIGJhY2tncm91bmQtY29sb3I6ICMzMzM7CiAgICBjb2xvcjogI0NDQ0NDQzsKfQoubmF2aWdhdGlvbuKAkHBhdGggYSB7CiAgICBjb2xvcjogI0ZGRkZGRjsKfQoKLmluZGV4IHsKICAgIGJhY2tncm91bmQtY29sb3I6ICNGMkYyRjI7Cn0KLmluZGV4IGEgewogICAgY29sb3I6ICM1NTU1NTU7Cn0KLmluZGV4IGEuaGVhZGluZyB7CiAgICBjb2xvcjogIzMzMzsKfQoKLnN5bWJvbOKAkHR5cGUgewogICAgY29sb3I6ICM2NjY7Cn0KCi5jYWxsb3V0IHsKICAgIGJhY2tncm91bmQtY29sb3I6ICNGQUZBRkE7CiAgICBib3JkZXItbGVmdC1jb2xvcjogI0U2RTZFNjsKfQouY2FsbG91dC5hdHRlbnRpb24sIC5jYWxsb3V0LmltcG9ydGFudCB7CiAgICBiYWNrZ3JvdW5kLWNvbG9yOiAjRkJGOEU4OwogICAgYm9yZGVyLWxlZnQtY29sb3I6ICNGRUU0NTA7Cn0KLmNhbGxvdXQud2FybmluZyB7CiAgICBiYWNrZ3JvdW5kLWNvbG9yOiAjRjJEQkRDOwogICAgYm9yZGVyLWxlZnQtY29sb3I6ICNBRTI3MkY7Cn0KCmZvb3RlciB7CiAgICBiYWNrZ3JvdW5kLWNvbG9yOiAjRjJGMkYyOwogICAgY29sb3I6ICM4ODg4ODg7Cn0KCi8qIEdlbmVyYWwgRm9udHMgKi8KCmh0bWwgewogICAgZm9udC1mYW1pbHk6ICJTRiBQcm8gVGV4dCIsICJTRiBQcm8gSWNvbnMiLCAiLWFwcGxlLXN5c3RlbSIsICJCbGlua01hY1N5c3RlbUZvbnQiLCAiSGVsdmV0aWNhIE5ldWUiLCAiSGVsdmV0aWNhIiwgIkFyaWFsIiwgc2Fucy1zZXJpZjsKICAgIGZvbnQtc2l6ZTogMTA2LjI1JTsKICAgIGxldHRlci1zcGFjaW5nOiAtMC4wMjFlbTsKICAgIGxpbmUtaGVpZ2h0OiAxLjUyOTQ3Owp9CgpoMSwgaDIgewogICAgZm9udC1mYW1pbHk6ICJTRiBQcm8gRGlzcGxheSIsICJTRiBQcm8gSWNvbnMiLCAiLWFwcGxlLXN5c3RlbSIsICJCbGlua01hY1N5c3RlbUZvbnQiLCAiSGVsdmV0aWNhIE5ldWUiLCAiSGVsdmV0aWNhIiwgIkFyaWFsIiwgc2Fucy1zZXJpZjsKfQpoMSB7CiAgICBmb250LXNpemU6IGNhbGMoKDQwIC8gMTcpICogMXJlbSk7CiAgICBmb250LXdlaWdodDogNTAwOwogICAgbGV0dGVyLXNwYWNpbmc6IDAuMDA4ZW07CiAgICBsaW5lLWhlaWdodDogMS4wNTsKfQpoMiB7CiAgICBmb250LXNpemU6IGNhbGMoKDMyIC8gMTcpICogMXJlbSk7CiAgICBmb250LXdlaWdodDogNTAwOwogICAgbGV0dGVyLXNwYWNpbmc6IDAuMDExZW07CiAgICBsaW5lLWhlaWdodDogMS4wOTM3NTsKfQpoMyB7CiAgICBmb250LXNpemU6IGNhbGMoKDI4IC8gMTcpICogMXJlbSk7CiAgICBmb250LXdlaWdodDogNTAwOwogICAgbGV0dGVyLXNwYWNpbmc6IDAuMDEyZW07CiAgICBsaW5lLWhlaWdodDogMS4xMDczOwp9Cmg0LCBoNSwgaDYgewogICAgZm9udC13ZWlnaHQ6IDUwMDsKICAgIGxldHRlci1zcGFjaW5nOiAwLjAxNWVtOwogICAgbGluZS1oZWlnaHQ6IDEuMjA4NDk7Cn0KaDQgewogICAgZm9udC1zaXplOiBjYWxjKCgyNCAvIDE3KSAqIDFyZW0pOwp9Cmg1IHsKICAgIGZvbnQtc2l6ZTogY2FsYygoMjAgLyAxNykgKiAxcmVtKTsKfQpoNiB7CiAgICBmb250LXNpemU6IGNhbGMoKDE4IC8gMTcpICogMXJlbSk7Cn0KCmE6bGluaywgYTp2aXNpdGVkIHsKICAgIHRleHQtZGVjb3JhdGlvbjogbm9uZTsKfQphOmhvdmVyIHsKICAgIHRleHQtZGVjb3JhdGlvbjogdW5kZXJsaW5lOwp9CgouY2FsbG91dOKAkGxhYmVsIHsKICAgIGZvbnQtd2VpZ2h0OiA2MDA7Cn0KCi8qIFNwZWNpZmljIEZvbnRzICovCgoubmF2aWdhdGlvbuKAkGJhciB7CiAgICBmb250LXNpemU6IGNhbGMoKDE1IC8gMTcpICogMXJlbSk7CiAgICBsZXR0ZXItc3BhY2luZzogLTAuMDE0ZW07CiAgICBsaW5lLWhlaWdodDogMS4yNjY2NzsKfQoubmF2aWdhdGlvbuKAkHBhdGggYTo6YmVmb3JlLCAubmF2aWdhdGlvbuKAkHBhdGggc3Bhbjo6YmVmb3JlIHsKICAgIGZvbnQtZmFtaWx5OiAiU0YgUHJvIEljb25zIiwgIi1hcHBsZS1zeXN0ZW0iLCAiQmxpbmtNYWNTeXN0ZW1Gb250IiwgIkhlbHZldGljYSBOZXVlIiwgIkhlbHZldGljYSIsICJBcmlhbCIsIHNhbnMtc2VyaWY7CiAgICBjb250ZW50OiAi4oCjIjsKICAgIGxpbmUtaGVpZ2h0OiAxOwp9CgouaW5kZXggewogICAgZm9udC1zaXplOiBjYWxjKCgxMiAvIDE3KSAqIDFyZW0pOwogICAgbGV0dGVyLXNwYWNpbmc6IC4wMTVlbTsKICAgIGxpbmUtaGVpZ2h0OiBjYWxjKCgyMCAvIDE3KSAqIDFyZW0pOwp9Ci5pbmRleCBhLmhlYWRpbmcgewogICAgZm9udC13ZWlnaHQ6IDYwMDsKfQoKLnN5bWJvbOKAkHR5cGUgewogICAgZm9udC1mYW1pbHk6ICJTRiBQcm8gRGlzcGxheSIsICJTRiBQcm8gSWNvbnMiLCAiLWFwcGxlLXN5c3RlbSIsICJCbGlua01hY1N5c3RlbUZvbnQiLCAiSGVsdmV0aWNhIE5ldWUiLCAiSGVsdmV0aWNhIiwgIkFyaWFsIiwgc2Fucy1zZXJpZjsKICAgIGZvbnQtc2l6ZTogY2FsYygoMjIgLyAxNykgKiAxcmVtKTsKICAgIGxldHRlci1zcGFjaW5nOiAwLjAxNmVtOwogICAgbGluZS1oZWlnaHQ6IDE7Cn0KCi5kZXNjcmlwdGlvbiB7CiAgICBmb250LWZhbWlseTogIlNGIFBybyBEaXNwbGF5IiwgIlNGIFBybyBJY29ucyIsICItYXBwbGUtc3lzdGVtIiwgIkJsaW5rTWFjU3lzdGVtRm9udCIsICJIZWx2ZXRpY2EgTmV1ZSIsICJIZWx2ZXRpY2EiLCAiQXJpYWwiLCBzYW5zLXNlcmlmOwogICAgZm9udC1zaXplOiBjYWxjKCgyMiAvIDE3KSAqIDFyZW0pOwogICAgZm9udC13ZWlnaHQ6IDMwMDsKICAgIGxldHRlci1zcGFjaW5nOiAwLjAxNmVtOwogICAgbGluZS1oZWlnaHQ6IDEuNDU0NTU7Cn0KCi5kZWNsYXJhdGlvbiAuc3dpZnQuYmxvY2txdW90ZSB7CiAgICBmb250LXNpemU6IGNhbGMoKDE1IC8gMTcpICogMXJlbSk7Cn0KCmZvb3RlciB7CiAgICBmb250LXNpemU6IGNhbGMoKDExIC8gMTcpICogMXJlbSk7CiAgICBsZXR0ZXItc3BhY2luZzogY2FsYygoMC4yMzk5OTk5OTQ2MzU1ODE5NyAvIDE3KSAqIDFyZW0pOwogICAgbGluZS1oZWlnaHQ6IGNhbGMoKDE0IC8gMTcpICogMXJlbSk7Cn0K")!, encoding: String.Encoding.utf8)!

}
