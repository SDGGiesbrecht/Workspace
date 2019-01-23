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
    static let page = String(data: Data(base64Encoded: "PCFET0NUWVBFIGh0bWw+Cgo8IS0tCiBQYWdlLmh0bWwKCiBUaGlzIHNvdXJjZSBmaWxlIGlzIHBhcnQgb2YgdGhlIFdvcmtzcGFjZSBvcGVuIHNvdXJjZSBwcm9qZWN0LgogaHR0cHM6Ly9naXRodWIuY29tL1NER0dpZXNicmVjaHQvV29ya3NwYWNlI3dvcmtzcGFjZQoKIENvcHlyaWdodCDCqTIwMTjigJMyMDE5IEplcmVteSBEYXZpZCBHaWVzYnJlY2h0IGFuZCB0aGUgV29ya3NwYWNlIHByb2plY3QgY29udHJpYnV0b3JzLgoKIFNvbGkgRGVvIGdsb3JpYS4KCiBMaWNlbnNlZCB1bmRlciB0aGUgQXBhY2hlIExpY2VuY2UsIFZlcnNpb24gMi4wLgogU2VlIGh0dHA6Ly93d3cuYXBhY2hlLm9yZy9saWNlbnNlcy9MSUNFTlNFLTIuMCBmb3IgbGljZW5jZSBpbmZvcm1hdGlvbi4KIC0tPgoKPGh0bWwgZGlyPSJbKnRleHQgZGlyZWN0aW9uKl0iIGxhbmc9IlsqbG9jYWxpemF0aW9uKl0iPgogPGhlYWQ+CiAgPG1ldGEgY2hhcnNldD0idXRmJiN4MDAyRDs4Ij4KICA8dGl0bGU+Wyp0aXRsZSpdPC90aXRsZT4KICA8bGluayByZWw9InN0eWxlc2hlZXQiIGhyZWY9Ilsqc2l0ZSByb290Kl1DU1MvUm9vdC5jc3MiPgogIDxsaW5rIHJlbD0ic3R5bGVzaGVldCIgaHJlZj0iWypzaXRlIHJvb3QqXUNTUy9Td2lmdC5jc3MiPgogIDxsaW5rIHJlbD0ic3R5bGVzaGVldCIgaHJlZj0iWypzaXRlIHJvb3QqXUNTUy9TaXRlLmNzcyI+CiAgPHNjcmlwdCBzcmM9Ilsqc2l0ZSByb290Kl1KYXZhU2NyaXB0L1NpdGUuanMiPjwvc2NyaXB0PgogPC9oZWFkPgogPGJvZHk+CiAgPGhlYWRlciBjbGFzcz0ibmF2aWdhdGlvbuKAkGJhciI+CiAgIDxuYXYgY2xhc3M9Im5hdmlnYXRpb27igJBiYXIiPgogICAgPGRpdiBjbGFzcz0ibmF2aWdhdGlvbuKAkHBhdGgiIGRpcj0iWyp0ZXh0IGRpcmVjdGlvbipdIj4KClsqbmF2aWdhdGlvbiBwYXRoKl0KCiAgICA8L2Rpdj4KICAgIDxkaXY+CiAgICAgWypwYWNrYWdlIGltcG9ydCpdCiAgICA8L2Rpdj4KICAgPC9uYXY+CiAgPC9oZWFkZXI+CiAgPGRpdiBjbGFzcz0iY29udGVudOKAkGNvbnRhaW5lciI+CiAgIDxoZWFkZXIgY2xhc3M9ImluZGV4Ij4KICAgIDxuYXYgY2xhc3M9ImluZGV4Ij4KClsqaW5kZXgqXQoKICAgIDwvbmF2PgogICA8L2hlYWRlcj4KICAgPG1haW4+CiAgICA8ZGl2IGNsYXNzPSJtb2R1bGXigJBncm91cCI+CiAgICAgPGRpdiBjbGFzcz0ibW9kdWxl4oCQZ3JvdXDigJBoZWFkZXLigJBiYXIiPgoKWyptb2R1bGUgZ3JvdXAgaGVhZGVyKl0KCiAgICAgPC9kaXY+CiAgICAgPGRpdiBjbGFzcz0ibWFpbuKAkHRleHTigJBjb2x1bW4iPgogICAgICA8ZGl2IGNsYXNzPSJ0aXRsZSI+CiAgICAgICBbKnN5bWJvbCB0eXBlKl0KICAgICAgIFsqY29tcGlsYXRpb24gY29uZGl0aW9ucypdCiAgICAgICA8aDE+Wyp0aXRsZSpdPC9oMT4KICAgICAgIFsqY29uc3RyYWludHMqXQogICAgICA8L2Rpdj4KClsqY29udGVudCpdCgogICAgIDwvZGl2PgogICAgPC9kaXY+CiAgIDwvbWFpbj4KICA8L2Rpdj4KICA8Zm9vdGVyIGRpcj0iWyp0ZXh0IGRpcmVjdGlvbipdIj4KICAgWypjb3B5cmlnaHQqXQogICBbKndvcmtzcGFjZSpdCiAgPC9mb290ZXI+CiAgPHNjcmlwdD5jb250cmFjdEluZGV4KCk7PC9zY3JpcHQ+CiA8L2JvZHk+CjwvaHRtbD4K")!, encoding: String.Encoding.utf8)!
    static let redirect = String(data: Data(base64Encoded: "PCFET0NUWVBFIGh0bWw+Cgo8IS0tCiBSZWRpcmVjdC5odG1sCgogVGhpcyBzb3VyY2UgZmlsZSBpcyBwYXJ0IG9mIHRoZSBXb3Jrc3BhY2Ugb3BlbiBzb3VyY2UgcHJvamVjdC4KIGh0dHBzOi8vZ2l0aHViLmNvbS9TREdHaWVzYnJlY2h0L1dvcmtzcGFjZSN3b3Jrc3BhY2UKCiBDb3B5cmlnaHQgwqkyMDE44oCTMjAxOSBKZXJlbXkgRGF2aWQgR2llc2JyZWNodCBhbmQgdGhlIFdvcmtzcGFjZSBwcm9qZWN0IGNvbnRyaWJ1dG9ycy4KCiBTb2xpIERlbyBnbG9yaWEuCgogTGljZW5zZWQgdW5kZXIgdGhlIEFwYWNoZSBMaWNlbmNlLCBWZXJzaW9uIDIuMC4KIFNlZSBodHRwOi8vd3d3LmFwYWNoZS5vcmcvbGljZW5zZXMvTElDRU5TRS0yLjAgZm9yIGxpY2VuY2UgaW5mb3JtYXRpb24uCiAtLT4KCjxodG1sIGxhbmc9Inp4eCI+CiA8aGVhZD4KICA8bWV0YSBjaGFyc2V0PSJ1dGYmI3gwMDJEOzgiPgogIDx0aXRsZT7ihrMgLi4vPC90aXRsZT4KICA8bGluayByZWw9ImNhbm9uaWNhbCIgaHJlZj0iWyp0YXJnZXQqXSIvPgogIDxtZXRhIGh0dHAtZXF1aXY9InJlZnJlc2giIGNvbnRlbnQ9IjA7IHVybD1bKnRhcmdldCpdIiAvPgogPC9oZWFkPgogPGJvZHk+CiAgPHA+4oazIDxhIGhyZWY9IlsqdGFyZ2V0Kl0iPi4uLzwvYT4KIDwvYm9keT4KPC9odG1sPgo=")!, encoding: String.Encoding.utf8)!
    static let root = String(data: Data(base64Encoded: "LyoKIFJvb3QuY3NzCgogVGhpcyBzb3VyY2UgZmlsZSBpcyBwYXJ0IG9mIHRoZSBXb3Jrc3BhY2Ugb3BlbiBzb3VyY2UgcHJvamVjdC4KIGh0dHBzOi8vZ2l0aHViLmNvbS9TREdHaWVzYnJlY2h0L1dvcmtzcGFjZSN3b3Jrc3BhY2UKCiBDb3B5cmlnaHQgwqkyMDE44oCTMjAxOSBKZXJlbXkgRGF2aWQgR2llc2JyZWNodCBhbmQgdGhlIFdvcmtzcGFjZSBwcm9qZWN0IGNvbnRyaWJ1dG9ycy4KCiBTb2xpIERlbyBnbG9yaWEuCgogTGljZW5zZWQgdW5kZXIgdGhlIEFwYWNoZSBMaWNlbmNlLCBWZXJzaW9uIDIuMC4KIFNlZSBodHRwOi8vd3d3LmFwYWNoZS5vcmcvbGljZW5zZXMvTElDRU5TRS0yLjAgZm9yIGxpY2VuY2UgaW5mb3JtYXRpb24uCiAqLwoKLyogTGF5b3V0ICovCgpodG1sLCBib2R5IHsKICAgIG1hcmdpbjogMDsKICAgIHBhZGRpbmc6IDA7Cn0KCi8qIENvbG91cnMgKi8KCmh0bWwgewogICAgYmFja2dyb3VuZC1jb2xvcjogI0ZGRkZGRjsKICAgIGNvbG9yOiAjMDAwMDAwOwp9CgovKiBGb250cyAqLwoKQG1lZGlhIHByaW50IHsKICAgIGh0bWwgewogICAgICAgIGZvbnQtZmFtaWx5OiBzZXJpZjsKICAgIH0KfQpAbWVkaWEgc2NyZWVuIHsKICAgIGh0bWwgewogICAgICAgIGZvbnQtZmFtaWx5OiBzYW5zLXNlcmlmOwogICAgfQp9CgpzcGFuW2xhbmddIHsKICAgIGZvbnQtc3R5bGU6IGl0YWxpYzsKfQo=")!, encoding: String.Encoding.utf8)!
    static let script = String(data: Data(base64Encoded: "LyoKIFNjcmlwdC5qcwoKIFRoaXMgc291cmNlIGZpbGUgaXMgcGFydCBvZiB0aGUgV29ya3NwYWNlIG9wZW4gc291cmNlIHByb2plY3QuCiBodHRwczovL2dpdGh1Yi5jb20vU0RHR2llc2JyZWNodC9Xb3Jrc3BhY2Ujd29ya3NwYWNlCgogQ29weXJpZ2h0IMKpMjAxOOKAkzIwMTkgSmVyZW15IERhdmlkIEdpZXNicmVjaHQgYW5kIHRoZSBXb3Jrc3BhY2UgcHJvamVjdCBjb250cmlidXRvcnMuCgogU29saSBEZW8gZ2xvcmlhLgoKIExpY2Vuc2VkIHVuZGVyIHRoZSBBcGFjaGUgTGljZW5jZSwgVmVyc2lvbiAyLjAuCiBTZWUgaHR0cDovL3d3dy5hcGFjaGUub3JnL2xpY2Vuc2VzL0xJQ0VOU0UtMi4wIGZvciBsaWNlbmNlIGluZm9ybWF0aW9uLgogKi8KCmZ1bmN0aW9uIHRvZ2dsZUxpbmtWaXNpYmlsaXR5KGxpbmspIHsKICAgIGlmIChsaW5rLmhhc0F0dHJpYnV0ZSgic3R5bGUiKSkgewogICAgICAgIGxpbmsucmVtb3ZlQXR0cmlidXRlKCJzdHlsZSIpOwogICAgfSBlbHNlIHsKICAgICAgICBsaW5rLnN0eWxlWyJwYWRkaW5nLXRvcCJdID0gMDsKICAgICAgICBsaW5rLnN0eWxlWyJwYWRkaW5nLWJvdHRvbSJdID0gMDsKICAgICAgICBsaW5rLnN0eWxlLmhlaWdodCA9IDA7CiAgICB9Cn0KCmZ1bmN0aW9uIHRvZ2dsZUluZGV4U2VjdGlvblZpc2liaWxpdHkoc2VuZGVyKSB7CiAgICB2YXIgc2VjdGlvbiA9IHNlbmRlci5wYXJlbnRFbGVtZW50OwogICAgdmFyIGxpbmtzID0gc2VjdGlvbi5jaGlsZHJlbgogICAgZm9yICh2YXIgbGlua0luZGV4ID0gMTsgbGlua0luZGV4IDwgbGlua3MubGVuZ3RoOyBsaW5rSW5kZXgrKykgewogICAgICAgIHZhciBsaW5rID0gbGlua3NbbGlua0luZGV4XQogICAgICAgIHRvZ2dsZUxpbmtWaXNpYmlsaXR5KGxpbmspCiAgICB9Cn0KCmZ1bmN0aW9uIGNvbnRyYWN0SW5kZXgoKSB7CiAgICB2YXIgaW5kZXhFbGVtZW50cyA9IGRvY3VtZW50LmdldEVsZW1lbnRzQnlDbGFzc05hbWUoImluZGV4Iik7CiAgICB2YXIgaW5kZXggPSBpbmRleEVsZW1lbnRzLml0ZW0oaW5kZXhFbGVtZW50cy5sZW5ndGggLSAxKTsKICAgIHZhciBzZWN0aW9ucyA9IGluZGV4LmNoaWxkcmVuOwogICAgZm9yICh2YXIgc2VjdGlvbkluZGV4ID0gMTsgc2VjdGlvbkluZGV4IDwgc2VjdGlvbnMubGVuZ3RoOyBzZWN0aW9uSW5kZXgrKykgewogICAgICAgIHZhciBzZWN0aW9uID0gc2VjdGlvbnNbc2VjdGlvbkluZGV4XQogICAgICAgIHZhciBsaW5rcyA9IHNlY3Rpb24uY2hpbGRyZW4KICAgICAgICBmb3IgKHZhciBsaW5rSW5kZXggPSAxOyBsaW5rSW5kZXggPCBsaW5rcy5sZW5ndGg7IGxpbmtJbmRleCsrKSB7CiAgICAgICAgICAgIHZhciBsaW5rID0gbGlua3NbbGlua0luZGV4XQogICAgICAgICAgICB0b2dnbGVMaW5rVmlzaWJpbGl0eShsaW5rKQogICAgICAgIH0KICAgIH0KfQo=")!, encoding: String.Encoding.utf8)!
    static let site = String(data: Data(base64Encoded: "LyoKIFNpdGUuY3NzCgogVGhpcyBzb3VyY2UgZmlsZSBpcyBwYXJ0IG9mIHRoZSBXb3Jrc3BhY2Ugb3BlbiBzb3VyY2UgcHJvamVjdC4KIGh0dHBzOi8vZ2l0aHViLmNvbS9TREdHaWVzYnJlY2h0L1dvcmtzcGFjZSN3b3Jrc3BhY2UKCiBDb3B5cmlnaHQgwqkyMDE44oCTMjAxOSBKZXJlbXkgRGF2aWQgR2llc2JyZWNodCBhbmQgdGhlIFdvcmtzcGFjZSBwcm9qZWN0IGNvbnRyaWJ1dG9ycy4KCiBTb2xpIERlbyBnbG9yaWEuCgogTGljZW5zZWQgdW5kZXIgdGhlIEFwYWNoZSBMaWNlbmNlLCBWZXJzaW9uIDIuMC4KIFNlZSBodHRwOi8vd3d3LmFwYWNoZS5vcmcvbGljZW5zZXMvTElDRU5TRS0yLjAgZm9yIGxpY2VuY2UgaW5mb3JtYXRpb24uCiAqLwoKLyogR2VuZXJhbCBMYXlvdXQgKi8KCiosICo6OmJlZm9yZSwgKjo6YWZ0ZXIgewogICAgYm94LXNpemluZzogaW5oZXJpdDsKfQpodG1sIHsKICAgIGJveC1zaXppbmc6IGJvcmRlci1ib3g7Cn0KCi5tYWlu4oCQdGV4dOKAkGNvbHVtbiB7CiAgICBtYXgtd2lkdGg6IDUwZW07Cn0KCmgxLCBoMiB7CiAgICBtYXJnaW46IDA7Cn0KaDMsIGg0LCBoNSwgaDYgewogICAgbWFyZ2luLXRvcDogMS40ZW07CiAgICBtYXJnaW4tYm90dG9tOiAwOwp9CgpzZWN0aW9uIHsKICAgIG1hcmdpbi10b3A6IDNyZW07Cn0Kc2VjdGlvbjpsYXN0LWNoaWxkIHsKICAgIG1hcmdpbi1ib3R0b206IDNyZW07Cn0KCnAgewogICAgbWFyZ2luOiAwOwp9CnA6bm90KDpmaXJzdC1jaGlsZCkgewogICAgbWFyZ2luLXRvcDogMC43ZW07Cn0KCmJsb2NrcXVvdGUgewogICAgbWFyZ2luOiAxLjRlbSAwOwp9CgpibG9ja3F1b3RlIHsKICAgIGJvcmRlci1sZWZ0OiAwLjI1ZW0gc29saWQgI0RGRTJFNTsKICAgIHBhZGRpbmc6IDAgMWVtOwp9CmJsb2NrcXVvdGUgPiBwLCBibG9ja3F1b3RlID4gcDpub3QoOmZpcnN0LWNoaWxkKSB7CiAgICBtYXJnaW46IDA7Cn0KW2Rpcj0icnRsIl0gYmxvY2txdW90ZSA+IHAuY2l0YXRpb24gewogICAgdGV4dC1hbGlnbjogbGVmdDsKfQpbZGlyPSJsdHIiXSBibG9ja3F1b3RlID4gcC5jaXRhdGlvbiB7CiAgICB0ZXh0LWFsaWduOiByaWdodDsKfQoKdWwsIG9sIHsKICAgIG1hcmdpbi10b3A6IDAuN2VtOwogICAgbWFyZ2luLWxlZnQ6IDJyZW07CiAgICBtYXJnaW4tcmlnaHQ6IDJyZW07CiAgICBtYXJnaW4tYm90dG9tOiAwOwogICAgcGFkZGluZzogMDsKfQpsaTpub3QoOmZpcnN0LWNoaWxkKSB7CiAgICBtYXJnaW4tdG9wOiAwLjdlbTsKfQoKZHQgewogICAgcGFkZGluZy1sZWZ0OiAxcmVtOwogICAgcGFkZGluZy10b3A6IDEuNjQ3MDZyZW07Cn0KZHQ6Zmlyc3QtY2hpbGQgewogICAgcGFkZGluZy10b3A6IDA7Cn0KCi5jYWxsb3V0IHsKICAgIGJvcmRlci1sZWZ0LXdpZHRoOiBjYWxjKCg2IC8gMTcpICogMXJlbSk7CiAgICBib3JkZXItbGVmdC1zdHlsZTogc29saWQ7CiAgICBib3JkZXItcmlnaHQtY29sb3I6IHRyYW5zcGFyZW50OwogICAgYm9yZGVyLXJpZ2h0LXdpZHRoOiBjYWxjKCg2IC8gMTcpICogMXJlbSk7CiAgICBib3JkZXItcmlnaHQtc3R5bGU6IHNvbGlkOwogICAgYm9yZGVyLXJhZGl1czogY2FsYygoNiAvIDE3KSAqIDFyZW0pOwogICAgbWFyZ2luLXRvcDogMS40ZW07CiAgICBwYWRkaW5nOiAwLjk0MTE4cmVtOwp9CgovKiBTcGVjaWZpYyBMYXlvdXQgKi8KCmhlYWRlci5uYXZpZ2F0aW9u4oCQYmFyIHsKICAgIGJveC1zaXppbmc6IGNvbnRlbnQtYm94OwogICAgaGVpZ2h0OiBjYWxjKCg1MiAvIDE3KSAqIDFyZW0pOwogICAgcGFkZGluZzogMCBjYWxjKCgyMiAvIDE3KSAqIDFyZW0pOwp9Cm5hdi5uYXZpZ2F0aW9u4oCQYmFyIHsKICAgIGRpc3BsYXk6IGZsZXg7CiAgICAgYWxpZ24taXRlbXM6IGNlbnRlcjsKICAgICBqdXN0aWZ5LWNvbnRlbnQ6IHNwYWNlLWJldHdlZW47CiAgICBoZWlnaHQ6IDEwMCU7Cn0KLm5hdmlnYXRpb27igJBwYXRoIHsKICAgIGRpc3BsYXk6IGZsZXg7CiAgICAgYWxpZ24taXRlbXM6IGNlbnRlcjsKICAgICBqdXN0aWZ5LWNvbnRlbnQ6IHNwYWNlLWJldHdlZW47CiAgICAgb3ZlcmZsb3c6IGhpZGRlbjsKICAgICBmbGV4LXdyYXA6IG5vd3JhcDsKICAgICB3aGl0ZS1zcGFjZTogbm93cmFwOwogICAgIHRleHQtb3ZlcmZsb3c6IGVsbGlwc2lzOwogICAgaGVpZ2h0OiAxMDAlOwp9CltkaXI9InJ0bCJdLm5hdmlnYXRpb27igJBwYXRoIGEsIFtkaXI9InJ0bCJdLm5hdmlnYXRpb27igJBwYXRoIHNwYW4gewogICAgbWFyZ2luLXJpZ2h0OiAxLjA1ODgycmVtOwp9CltkaXI9Imx0ciJdLm5hdmlnYXRpb27igJBwYXRoIGEsIFtkaXI9Imx0ciJdLm5hdmlnYXRpb27igJBwYXRoIHNwYW4gewogICAgbWFyZ2luLWxlZnQ6IDEuMDU4ODJyZW07Cn0KLm5hdmlnYXRpb27igJBwYXRoIGE6Zmlyc3QtY2hpbGQsIC5uYXZpZ2F0aW9u4oCQcGF0aCBzcGFuOmZpcnN0LWNoaWxkIHsKICAgIG1hcmdpbi1sZWZ0OiAwOwogICAgbWFyZ2luLXJpZ2h0OiAwOwp9CltkaXI9InJ0bCJdLm5hdmlnYXRpb27igJBwYXRoIGE6OmJlZm9yZSwgW2Rpcj0icnRsIl0ubmF2aWdhdGlvbuKAkHBhdGggc3Bhbjo6YmVmb3JlIHsKICAgIHBhZGRpbmctbGVmdDogMS4wNTg4MnJlbTsKfQpbZGlyPSJsdHIiXS5uYXZpZ2F0aW9u4oCQcGF0aCBhOjpiZWZvcmUsIFtkaXI9Imx0ciJdLm5hdmlnYXRpb27igJBwYXRoIHNwYW46OmJlZm9yZSB7CiAgICBwYWRkaW5nLXJpZ2h0OiAxLjA1ODgycmVtOwp9Ci5uYXZpZ2F0aW9u4oCQcGF0aCBhOmZpcnN0LWNoaWxkOjpiZWZvcmUsIC5uYXZpZ2F0aW9u4oCQcGF0aCBzcGFuOmZpcnN0LWNoaWxkOjpiZWZvcmUgewogICAgZGlzcGxheTogbm9uZTsKfQoKLmNvbnRlbnTigJBjb250YWluZXIgewogICAgaGVpZ2h0OiBjYWxjKDEwMHZoIC0gY2FsYygoNTIgLyAxNykgKiAxcmVtKSAtIGNhbGMoKDQ1IC8gMTcpICogMXJlbSkpOwogICAgd2lkdGg6IDEwMCU7CiAgICBkaXNwbGF5OiBmbGV4Owp9CmhlYWRlci5pbmRleCB7CiAgICBoZWlnaHQ6IDEwMCU7CiAgICBtYXgtd2lkdGg6IDI1JTsKICAgIHBhZGRpbmc6IGNhbGMoKDEyIC8gMTcpICogMXJlbSkgMDsKICAgIG92ZXJmbG93LXk6IGF1dG87Cn0KCi5pbmRleCBhIHsKICAgIGN1cnNvcjogcG9pbnRlcjsKICAgIGRpc3BsYXk6IGJsb2NrOwogICAgcGFkZGluZzogMC4yZW0gY2FsYygoMjIgLyAxNykgKiAxcmVtKTsKICAgIG92ZXJmbG93OiBoaWRkZW47Cn0KLmluZGV4IGE6bm90KDpmaXJzdC1jaGlsZCkgewogICAgcGFkZGluZy1sZWZ0OiBjYWxjKDFlbSArIGNhbGMoKDIyIC8gMTcpICogMXJlbSkpOwp9CgptYWluIHsKICAgIGZsZXgtZ3JvdzogMTsKICAgIGhlaWdodDogMTAwJTsKICAgIG92ZXJmbG93LXk6IGF1dG87Cn0KLm1vZHVsZeKAkGdyb3VwIHsKICAgIGRpc3BsYXk6IGZsZXg7Cn0KLm1haW7igJB0ZXh04oCQY29sdW1uIHsKICAgIGZsZXgtZ3JvdzogMTsKICAgIHBhZGRpbmc6IDAgY2FsYygoMjIgLyAxNykgKiAxcmVtKTsKfQoKLm1vZHVsZeKAkGdyb3Vw4oCQaGVhZGVy4oCQYmFyIHsKICAgIHdpZHRoOiBjYWxjKCg1MiAvIDE3KSAqIDFyZW0pOwp9Ci5tb2R1bGXigJBncm91cOKAkGhlYWRlciB7CiAgICB0cmFuc2Zvcm06IHJvdGF0ZSgxODBkZWcpOwogICAgd3JpdGluZy1tb2RlOiB2ZXJ0aWNhbC1ybDsKfQoubW9kdWxl4oCQZ3JvdXDigJBoZWFkZXIgLnN3aWZ0LmJsb2NrcXVvdGUgewogICAgLyogUm90YXRlcyBtYXJnaW5zLiAqLwogICAgbWFyZ2luOiAwOwogICAgcGFkZGluZzogMC45NDExOGVtIDAuMzUyOTRlbTsKfQoKLnRpdGxlIHsKICAgIG1hcmdpbi10b3A6IDJyZW07CiAgICBtYXJnaW4tYm90dG9tOiAxLjVyZW07Cn0KLnN5bWJvbOKAkHR5cGUgewogICAgbWFyZ2luLWJvdHRvbTogY2FsYygoMjAgLyAxNykgKiAxcmVtKTsKfQoKLmRlc2NyaXB0aW9uIHsKICAgIG1hcmdpbi1ib3R0b206IDJyZW07Cn0KLmRlc2NyaXB0aW9uIHAgewogICAgbWFyZ2luOiAwOwp9CgouZGVjbGFyYXRpb246OmJlZm9yZSB7CiAgICBib3JkZXItdG9wOiAxcHggc29saWQgI0Q2RDZENjsKICAgIGNvbnRlbnQ6ICIiOwogICAgZGlzcGxheTogYmxvY2s7Cn0KLmRlY2xhcmF0aW9uIHsKICAgIG1hcmdpbi10b3A6IDA7Cn0KLmRlY2xhcmF0aW9uIGgyIHsKICAgIG1hcmdpbi10b3A6IDJyZW07Cn0KLmRlY2xhcmF0aW9uIC5zd2lmdC5ibG9ja3F1b3RlIHsKICAgIG1hcmdpbi10b3A6IDFyZW07Cn0KCmgyICsgLmNoaWxkIHsKICAgIG1hcmdpbi10b3A6IDJyZW07Cn0KLmNoaWxkOm5vdCg6bGFzdC1jaGlsZCkgewogICAgbWFyZ2luLWJvdHRvbTogMS41cmVtOwp9Ci5jaGlsZCA+IHAgewogICAgbWFyZ2luOiAwIDIuMzUyOTRyZW07Cn0KCmZvb3RlciB7CiAgICBkaXNwbGF5OiBmbGV4OwogICAgIGFsaWduLWl0ZW1zOiBjZW50ZXI7CiAgICAganVzdGlmeS1jb250ZW50OiBzcGFjZS1iZXR3ZWVuOwogICAgaGVpZ2h0OiBjYWxjKCg0NSAvIDE3KSAqIDFyZW0pOwogICAgcGFkZGluZzogMCBjYWxjKCgyMiAvIDE3KSAqIDFyZW0pOwp9CgovKiBDb2xvdXJzICovCgpodG1sIHsKICAgIGNvbG9yOiAjMzMzMzMzOwp9CgphIHsKICAgIGNvbG9yOiAjMDA3MEM5Owp9CgpibG9ja3F1b3RlIHsKICAgIGNvbG9yOiAjNkE3MzdEOwp9CgoubmF2aWdhdGlvbuKAkGJhciB7CiAgICBiYWNrZ3JvdW5kLWNvbG9yOiAjMzMzOwogICAgY29sb3I6ICNDQ0NDQ0M7Cn0KLm5hdmlnYXRpb27igJBwYXRoIGEgewogICAgY29sb3I6ICNGRkZGRkY7Cn0KCi5pbmRleCB7CiAgICBiYWNrZ3JvdW5kLWNvbG9yOiAjRjJGMkYyOwp9Ci5pbmRleCBhIHsKICAgIGNvbG9yOiAjNTU1NTU1Owp9Ci5pbmRleCBhLmhlYWRpbmcgewogICAgY29sb3I6ICMzMzM7Cn0KCi5tb2R1bGXigJBncm91cOKAkGhlYWRlcuKAkGJhcjpub3QoOmZpcnN0LWNoaWxkKSB7CiAgICBib3JkZXItdG9wOiAxcHggc29saWQgI0Q2RDZENjsKfQoKLnN5bWJvbOKAkHR5cGUgewogICAgY29sb3I6ICM2NjY7Cn0KCi5jYWxsb3V0IHsKICAgIGJhY2tncm91bmQtY29sb3I6ICNGQUZBRkE7CiAgICBib3JkZXItbGVmdC1jb2xvcjogI0U2RTZFNjsKfQouY2FsbG91dC5hdHRlbnRpb24sIC5jYWxsb3V0LmltcG9ydGFudCB7CiAgICBiYWNrZ3JvdW5kLWNvbG9yOiAjRkJGOEU4OwogICAgYm9yZGVyLWxlZnQtY29sb3I6ICNGRUU0NTA7Cn0KLmNhbGxvdXQud2FybmluZyB7CiAgICBiYWNrZ3JvdW5kLWNvbG9yOiAjRjJEQkRDOwogICAgYm9yZGVyLWxlZnQtY29sb3I6ICNBRTI3MkY7Cn0KCmZvb3RlciB7CiAgICBiYWNrZ3JvdW5kLWNvbG9yOiAjRjJGMkYyOwogICAgY29sb3I6ICM4ODg4ODg7Cn0KCi8qIEdlbmVyYWwgRm9udHMgKi8KCmh0bWwgewogICAgZm9udC1mYW1pbHk6ICJTRiBQcm8gVGV4dCIsICJTRiBQcm8gSWNvbnMiLCAiLWFwcGxlLXN5c3RlbSIsICJCbGlua01hY1N5c3RlbUZvbnQiLCAiSGVsdmV0aWNhIE5ldWUiLCAiSGVsdmV0aWNhIiwgIkFyaWFsIiwgc2Fucy1zZXJpZjsKICAgIGZvbnQtc2l6ZTogMTA2LjI1JTsKICAgIGxldHRlci1zcGFjaW5nOiAtMC4wMjFlbTsKICAgIGxpbmUtaGVpZ2h0OiAxLjUyOTQ3Owp9CgpoMSwgaDIgewogICAgZm9udC1mYW1pbHk6ICJTRiBQcm8gRGlzcGxheSIsICJTRiBQcm8gSWNvbnMiLCAiLWFwcGxlLXN5c3RlbSIsICJCbGlua01hY1N5c3RlbUZvbnQiLCAiSGVsdmV0aWNhIE5ldWUiLCAiSGVsdmV0aWNhIiwgIkFyaWFsIiwgc2Fucy1zZXJpZjsKfQpoMSB7CiAgICBmb250LXNpemU6IGNhbGMoKDQwIC8gMTcpICogMXJlbSk7CiAgICBmb250LXdlaWdodDogNTAwOwogICAgbGV0dGVyLXNwYWNpbmc6IDAuMDA4ZW07CiAgICBsaW5lLWhlaWdodDogMS4wNTsKfQpoMiB7CiAgICBmb250LXNpemU6IGNhbGMoKDMyIC8gMTcpICogMXJlbSk7CiAgICBmb250LXdlaWdodDogNTAwOwogICAgbGV0dGVyLXNwYWNpbmc6IDAuMDExZW07CiAgICBsaW5lLWhlaWdodDogMS4wOTM3NTsKfQpoMyB7CiAgICBmb250LXNpemU6IGNhbGMoKDI4IC8gMTcpICogMXJlbSk7CiAgICBmb250LXdlaWdodDogNTAwOwogICAgbGV0dGVyLXNwYWNpbmc6IDAuMDEyZW07CiAgICBsaW5lLWhlaWdodDogMS4xMDczOwp9Cmg0LCBoNSwgaDYgewogICAgZm9udC13ZWlnaHQ6IDUwMDsKICAgIGxldHRlci1zcGFjaW5nOiAwLjAxNWVtOwogICAgbGluZS1oZWlnaHQ6IDEuMjA4NDk7Cn0KaDQgewogICAgZm9udC1zaXplOiBjYWxjKCgyNCAvIDE3KSAqIDFyZW0pOwp9Cmg1IHsKICAgIGZvbnQtc2l6ZTogY2FsYygoMjAgLyAxNykgKiAxcmVtKTsKfQpoNiB7CiAgICBmb250LXNpemU6IGNhbGMoKDE4IC8gMTcpICogMXJlbSk7Cn0KCmE6bGluaywgYTp2aXNpdGVkIHsKICAgIHRleHQtZGVjb3JhdGlvbjogbm9uZTsKfQphOmhvdmVyIHsKICAgIHRleHQtZGVjb3JhdGlvbjogdW5kZXJsaW5lOwp9CgouY2FsbG91dOKAkGxhYmVsIHsKICAgIGZvbnQtd2VpZ2h0OiA2MDA7Cn0KCi8qIFNwZWNpZmljIEZvbnRzICovCgoubmF2aWdhdGlvbuKAkGJhciB7CiAgICBmb250LXNpemU6IGNhbGMoKDE1IC8gMTcpICogMXJlbSk7CiAgICBsZXR0ZXItc3BhY2luZzogLTAuMDE0ZW07CiAgICBsaW5lLWhlaWdodDogMS4yNjY2NzsKfQoubmF2aWdhdGlvbuKAkHBhdGggYTo6YmVmb3JlLCAubmF2aWdhdGlvbuKAkHBhdGggc3Bhbjo6YmVmb3JlIHsKICAgIGZvbnQtZmFtaWx5OiAiU0YgUHJvIEljb25zIiwgIi1hcHBsZS1zeXN0ZW0iLCAiQmxpbmtNYWNTeXN0ZW1Gb250IiwgIkhlbHZldGljYSBOZXVlIiwgIkhlbHZldGljYSIsICJBcmlhbCIsIHNhbnMtc2VyaWY7CiAgICBjb250ZW50OiAi4oCjIjsKICAgIGxpbmUtaGVpZ2h0OiAxOwp9CgouaW5kZXggewogICAgZm9udC1zaXplOiBjYWxjKCgxMiAvIDE3KSAqIDFyZW0pOwogICAgbGV0dGVyLXNwYWNpbmc6IC4wMTVlbTsKICAgIGxpbmUtaGVpZ2h0OiBjYWxjKCgyMCAvIDE3KSAqIDFyZW0pOwp9Ci5pbmRleCBhLmhlYWRpbmcgewogICAgZm9udC13ZWlnaHQ6IDYwMDsKfQoKLnN5bWJvbOKAkHR5cGUgewogICAgZm9udC1mYW1pbHk6ICJTRiBQcm8gRGlzcGxheSIsICJTRiBQcm8gSWNvbnMiLCAiLWFwcGxlLXN5c3RlbSIsICJCbGlua01hY1N5c3RlbUZvbnQiLCAiSGVsdmV0aWNhIE5ldWUiLCAiSGVsdmV0aWNhIiwgIkFyaWFsIiwgc2Fucy1zZXJpZjsKICAgIGZvbnQtc2l6ZTogY2FsYygoMjIgLyAxNykgKiAxcmVtKTsKICAgIGxldHRlci1zcGFjaW5nOiAwLjAxNmVtOwogICAgbGluZS1oZWlnaHQ6IDE7Cn0KCi5kZXNjcmlwdGlvbiB7CiAgICBmb250LWZhbWlseTogIlNGIFBybyBEaXNwbGF5IiwgIlNGIFBybyBJY29ucyIsICItYXBwbGUtc3lzdGVtIiwgIkJsaW5rTWFjU3lzdGVtRm9udCIsICJIZWx2ZXRpY2EgTmV1ZSIsICJIZWx2ZXRpY2EiLCAiQXJpYWwiLCBzYW5zLXNlcmlmOwogICAgZm9udC1zaXplOiBjYWxjKCgyMiAvIDE3KSAqIDFyZW0pOwogICAgZm9udC13ZWlnaHQ6IDMwMDsKICAgIGxldHRlci1zcGFjaW5nOiAwLjAxNmVtOwogICAgbGluZS1oZWlnaHQ6IDEuNDU0NTU7Cn0KCi5kZWNsYXJhdGlvbiAuc3dpZnQuYmxvY2txdW90ZSB7CiAgICBmb250LXNpemU6IGNhbGMoKDE1IC8gMTcpICogMXJlbSk7Cn0KCmZvb3RlciB7CiAgICBmb250LXNpemU6IGNhbGMoKDExIC8gMTcpICogMXJlbSk7CiAgICBsZXR0ZXItc3BhY2luZzogY2FsYygoMC4yMzk5OTk5OTQ2MzU1ODE5NyAvIDE3KSAqIDFyZW0pOwogICAgbGluZS1oZWlnaHQ6IGNhbGMoKDE0IC8gMTcpICogMXJlbSk7Cn0K")!, encoding: String.Encoding.utf8)!

}
