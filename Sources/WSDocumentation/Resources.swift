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
    static let page = String(data: Data(base64Encoded: "PCFET0NUWVBFIGh0bWw+Cgo8IS0tCiBQYWdlLmh0bWwKCiBUaGlzIHNvdXJjZSBmaWxlIGlzIHBhcnQgb2YgdGhlIFdvcmtzcGFjZSBvcGVuIHNvdXJjZSBwcm9qZWN0LgogaHR0cHM6Ly9naXRodWIuY29tL1NER0dpZXNicmVjaHQvV29ya3NwYWNlI3dvcmtzcGFjZQoKIENvcHlyaWdodCDCqTIwMTjigJMyMDE5IEplcmVteSBEYXZpZCBHaWVzYnJlY2h0IGFuZCB0aGUgV29ya3NwYWNlIHByb2plY3QgY29udHJpYnV0b3JzLgoKIFNvbGkgRGVvIGdsb3JpYS4KCiBMaWNlbnNlZCB1bmRlciB0aGUgQXBhY2hlIExpY2VuY2UsIFZlcnNpb24gMi4wLgogU2VlIGh0dHA6Ly93d3cuYXBhY2hlLm9yZy9saWNlbnNlcy9MSUNFTlNFLTIuMCBmb3IgbGljZW5jZSBpbmZvcm1hdGlvbi4KIC0tPgoKPGh0bWwgZGlyPSJbKnRleHQgZGlyZWN0aW9uKl0iIGxhbmc9IlsqbG9jYWxpemF0aW9uKl0iPgogPGhlYWQ+CiAgPG1ldGEgY2hhcnNldD0idXRmJiN4MDAyRDs4Ij4KICA8dGl0bGU+Wyp0aXRsZSpdPC90aXRsZT4KICA8bGluayByZWw9InN0eWxlc2hlZXQiIGhyZWY9Ilsqc2l0ZSByb290Kl1DU1MvUm9vdC5jc3MiPgogIDxsaW5rIHJlbD0ic3R5bGVzaGVldCIgaHJlZj0iWypzaXRlIHJvb3QqXUNTUy9Td2lmdC5jc3MiPgogIDxsaW5rIHJlbD0ic3R5bGVzaGVldCIgaHJlZj0iWypzaXRlIHJvb3QqXUNTUy9TaXRlLmNzcyI+CiAgPHNjcmlwdCBzcmM9Ilsqc2l0ZSByb290Kl1KYXZhU2NyaXB0L1NpdGUuanMiPjwvc2NyaXB0PgogPC9oZWFkPgogPGJvZHk+CiAgPGhlYWRlciBjbGFzcz0ibmF2aWdhdGlvbuKAkGJhciI+CiAgIDxuYXYgY2xhc3M9Im5hdmlnYXRpb27igJBiYXIiPgogICAgPGRpdiBjbGFzcz0ibmF2aWdhdGlvbuKAkHBhdGgiIGRpcj0iWyp0ZXh0IGRpcmVjdGlvbipdIj4KClsqbmF2aWdhdGlvbiBwYXRoKl0KCiAgICA8L2Rpdj4KICAgIDxkaXY+CiAgICAgWypwYWNrYWdlIGltcG9ydCpdCiAgICA8L2Rpdj4KICAgPC9uYXY+CiAgPC9oZWFkZXI+CiAgPGRpdiBjbGFzcz0iY29udGVudOKAkGNvbnRhaW5lciI+CiAgIDxoZWFkZXIgY2xhc3M9ImluZGV4Ij4KICAgIDxuYXYgY2xhc3M9ImluZGV4Ij4KClsqaW5kZXgqXQoKICAgIDwvbmF2PgogICA8L2hlYWRlcj4KICAgPG1haW4+CgpbKmltcG9ydHMqXQoKICAgIDxkaXYgY2xhc3M9Im1haW7igJB0ZXh04oCQY29sdW1uIj4KICAgICA8ZGl2IGNsYXNzPSJ0aXRsZSI+CiAgICAgIFsqc3ltYm9sIHR5cGUqXQogICAgICBbKmNvbXBpbGF0aW9uIGNvbmRpdGlvbnMqXQogICAgICA8aDE+Wyp0aXRsZSpdPC9oMT4KICAgICAgWypjb25zdHJhaW50cypdCiAgICAgPC9kaXY+CgpbKmNvbnRlbnQqXQoKICAgIDwvZGl2PgoKWypleHRlbnNpb25zKl0KCiAgIDwvbWFpbj4KICAgPGhlYWRlciBjbGFzcz0icGxhdGZvcm1zIj4KWypwbGF0Zm9ybXMqXQogICA8L2hlYWRlcj4KICA8L2Rpdj4KICA8Zm9vdGVyIGRpcj0iWyp0ZXh0IGRpcmVjdGlvbipdIj4KICAgWypjb3B5cmlnaHQqXQogICBbKndvcmtzcGFjZSpdCiAgPC9mb290ZXI+CiAgPHNjcmlwdD5jb250cmFjdEluZGV4KCk7PC9zY3JpcHQ+CiA8L2JvZHk+CjwvaHRtbD4K")!, encoding: String.Encoding.utf8)!
    static let script = String(data: Data(base64Encoded: "LyoKIFNjcmlwdC5qcwoKIFRoaXMgc291cmNlIGZpbGUgaXMgcGFydCBvZiB0aGUgV29ya3NwYWNlIG9wZW4gc291cmNlIHByb2plY3QuCiBodHRwczovL2dpdGh1Yi5jb20vU0RHR2llc2JyZWNodC9Xb3Jrc3BhY2Ujd29ya3NwYWNlCgogQ29weXJpZ2h0IMKpMjAxOOKAkzIwMTkgSmVyZW15IERhdmlkIEdpZXNicmVjaHQgYW5kIHRoZSBXb3Jrc3BhY2UgcHJvamVjdCBjb250cmlidXRvcnMuCgogU29saSBEZW8gZ2xvcmlhLgoKIExpY2Vuc2VkIHVuZGVyIHRoZSBBcGFjaGUgTGljZW5jZSwgVmVyc2lvbiAyLjAuCiBTZWUgaHR0cDovL3d3dy5hcGFjaGUub3JnL2xpY2Vuc2VzL0xJQ0VOU0UtMi4wIGZvciBsaWNlbmNlIGluZm9ybWF0aW9uLgogKi8KCmZ1bmN0aW9uIGhpZGVFbGVtZW50KGVsZW1lbnQpIHsKICAgIGVsZW1lbnQuc3R5bGVbInBhZGRpbmctdG9wIl0gPSAwOwogICAgZWxlbWVudC5zdHlsZVsicGFkZGluZy1ib3R0b20iXSA9IDA7CiAgICBlbGVtZW50LnN0eWxlLmhlaWdodCA9IDA7CiAgICBlbGVtZW50LnN0eWxlWyJvdmVyZmxvdyJdID0gImhpZGRlbiI7Cn0KCmZ1bmN0aW9uIHVuaGlkZUVsZW1lbnQoZWxlbWVudCkgewogICAgZWxlbWVudC5yZW1vdmVBdHRyaWJ1dGUoInN0eWxlIik7Cn0KCmZ1bmN0aW9uIHRvZ2dsZUxpbmtWaXNpYmlsaXR5KGxpbmspIHsKICAgIGlmIChsaW5rLmhhc0F0dHJpYnV0ZSgic3R5bGUiKSkgewogICAgICAgIHVuaGlkZUVsZW1lbnQobGluayk7CiAgICB9IGVsc2UgewogICAgICAgIGhpZGVFbGVtZW50KGxpbmspOwogICAgfQp9CgpmdW5jdGlvbiB0b2dnbGVJbmRleFNlY3Rpb25WaXNpYmlsaXR5KHNlbmRlcikgewogICAgdmFyIHNlY3Rpb24gPSBzZW5kZXIucGFyZW50RWxlbWVudDsKICAgIHZhciBsaW5rcyA9IHNlY3Rpb24uY2hpbGRyZW4KICAgIGZvciAodmFyIGxpbmtJbmRleCA9IDE7IGxpbmtJbmRleCA8IGxpbmtzLmxlbmd0aDsgbGlua0luZGV4KyspIHsKICAgICAgICB2YXIgbGluayA9IGxpbmtzW2xpbmtJbmRleF0KICAgICAgICB0b2dnbGVMaW5rVmlzaWJpbGl0eShsaW5rKQogICAgfQp9CgpmdW5jdGlvbiBjb250cmFjdEluZGV4KCkgewogICAgdmFyIGluZGV4RWxlbWVudHMgPSBkb2N1bWVudC5nZXRFbGVtZW50c0J5Q2xhc3NOYW1lKCJpbmRleCIpOwogICAgdmFyIGluZGV4ID0gaW5kZXhFbGVtZW50cy5pdGVtKGluZGV4RWxlbWVudHMubGVuZ3RoIC0gMSk7CiAgICB2YXIgc2VjdGlvbnMgPSBpbmRleC5jaGlsZHJlbjsKICAgIGZvciAodmFyIHNlY3Rpb25JbmRleCA9IDE7IHNlY3Rpb25JbmRleCA8IHNlY3Rpb25zLmxlbmd0aDsgc2VjdGlvbkluZGV4KyspIHsKICAgICAgICB2YXIgc2VjdGlvbiA9IHNlY3Rpb25zW3NlY3Rpb25JbmRleF0KICAgICAgICB2YXIgbGlua3MgPSBzZWN0aW9uLmNoaWxkcmVuCiAgICAgICAgZm9yICh2YXIgbGlua0luZGV4ID0gMTsgbGlua0luZGV4IDwgbGlua3MubGVuZ3RoOyBsaW5rSW5kZXgrKykgewogICAgICAgICAgICB2YXIgbGluayA9IGxpbmtzW2xpbmtJbmRleF0KICAgICAgICAgICAgdG9nZ2xlTGlua1Zpc2liaWxpdHkobGluaykKICAgICAgICB9CiAgICB9Cn0KCmZ1bmN0aW9uIHN3aXRjaENvbmZvcm1hbmNlTW9kZShzZW5kZXIpIHsKICAgIHZhciBjaGlsZHJlbiA9IGRvY3VtZW50LmdldEVsZW1lbnRzQnlDbGFzc05hbWUoImNoaWxkIik7CiAgICBmb3IgKHZhciBpbmRleCA9IDA7IGluZGV4IDwgY2hpbGRyZW4ubGVuZ3RoOyArK2luZGV4KSB7CiAgICAgICAgbGV0IGNoaWxkID0gY2hpbGRyZW5baW5kZXhdOwogICAgICAgIGlmIChzZW5kZXIudmFsdWUgPT0gInJlcXVpcmVkIikgewogICAgICAgICAgICBpZiAoY2hpbGQuZ2V0QXR0cmlidXRlKCJkYXRhLWNvbmZvcm1hbmNlIikgPT0gInJlcXVpcmVtZW50IikgewogICAgICAgICAgICAgICAgdW5oaWRlRWxlbWVudChjaGlsZCk7CiAgICAgICAgICAgIH0gZWxzZSB7CiAgICAgICAgICAgICAgICBoaWRlRWxlbWVudChjaGlsZCk7CiAgICAgICAgICAgIH0KICAgICAgICB9IGVsc2UgaWYgKHNlbmRlci52YWx1ZSA9PSAiY3VzdG9taXphYmxlIikgewogICAgICAgICAgICBpZiAoY2hpbGQuZ2V0QXR0cmlidXRlKCJkYXRhLWNvbmZvcm1hbmNlIikgPT0gInJlcXVpcmVtZW50IgogICAgICAgICAgICAgICAgfHwgY2hpbGQuZ2V0QXR0cmlidXRlKCJkYXRhLWNvbmZvcm1hbmNlIikgPT0gImN1c3RvbWl6YWJsZSIpIHsKICAgICAgICAgICAgICAgIHVuaGlkZUVsZW1lbnQoY2hpbGQpOwogICAgICAgICAgICB9IGVsc2UgewogICAgICAgICAgICAgICAgaGlkZUVsZW1lbnQoY2hpbGQpOwogICAgICAgICAgICB9CiAgICAgICAgfSBlbHNlIHsKICAgICAgICAgICAgdW5oaWRlRWxlbWVudChjaGlsZCk7CiAgICAgICAgfQogICAgfQp9Cg==")!, encoding: String.Encoding.utf8)!
    static let site = String(data: Data(base64Encoded: "LyoKIFNpdGUuY3NzCgogVGhpcyBzb3VyY2UgZmlsZSBpcyBwYXJ0IG9mIHRoZSBXb3Jrc3BhY2Ugb3BlbiBzb3VyY2UgcHJvamVjdC4KIGh0dHBzOi8vZ2l0aHViLmNvbS9TREdHaWVzYnJlY2h0L1dvcmtzcGFjZSN3b3Jrc3BhY2UKCiBDb3B5cmlnaHQgwqkyMDE44oCTMjAxOSBKZXJlbXkgRGF2aWQgR2llc2JyZWNodCBhbmQgdGhlIFdvcmtzcGFjZSBwcm9qZWN0IGNvbnRyaWJ1dG9ycy4KCiBTb2xpIERlbyBnbG9yaWEuCgogTGljZW5zZWQgdW5kZXIgdGhlIEFwYWNoZSBMaWNlbmNlLCBWZXJzaW9uIDIuMC4KIFNlZSBodHRwOi8vd3d3LmFwYWNoZS5vcmcvbGljZW5zZXMvTElDRU5TRS0yLjAgZm9yIGxpY2VuY2UgaW5mb3JtYXRpb24uCiAqLwoKLyogR2VuZXJhbCBMYXlvdXQgKi8KCiosICo6OmJlZm9yZSwgKjo6YWZ0ZXIgewogICAgYm94LXNpemluZzogaW5oZXJpdDsKfQpodG1sIHsKICAgIGJveC1zaXppbmc6IGJvcmRlci1ib3g7Cn0KCi5tYWlu4oCQdGV4dOKAkGNvbHVtbiB7CiAgICBtYXgtd2lkdGg6IDUwZW07Cn0KCmgxLCBoMiB7CiAgICBtYXJnaW46IDA7Cn0KaDMsIGg0LCBoNSwgaDYgewogICAgbWFyZ2luLXRvcDogMS40ZW07CiAgICBtYXJnaW4tYm90dG9tOiAwOwp9CgpzZWN0aW9uIHsKICAgIG1hcmdpbi10b3A6IDNyZW07Cn0Kc2VjdGlvbjpsYXN0LWNoaWxkIHsKICAgIG1hcmdpbi1ib3R0b206IDNyZW07Cn0KCnAgewogICAgbWFyZ2luOiAwOwp9CnA6bm90KDpmaXJzdC1jaGlsZCkgewogICAgbWFyZ2luLXRvcDogMC43ZW07Cn0KCmJsb2NrcXVvdGUgewogICAgbWFyZ2luOiAxLjRlbSAwOwp9CgpibG9ja3F1b3RlIHsKICAgIGJvcmRlci1sZWZ0OiAwLjI1ZW0gc29saWQgI0RGRTJFNTsKICAgIHBhZGRpbmc6IDAgMWVtOwp9CmJsb2NrcXVvdGUgPiBwLCBibG9ja3F1b3RlID4gcDpub3QoOmZpcnN0LWNoaWxkKSB7CiAgICBtYXJnaW46IDA7Cn0KW2Rpcj0icnRsIl0gYmxvY2txdW90ZSA+IHAuY2l0YXRpb24gewogICAgdGV4dC1hbGlnbjogbGVmdDsKfQpbZGlyPSJsdHIiXSBibG9ja3F1b3RlID4gcC5jaXRhdGlvbiB7CiAgICB0ZXh0LWFsaWduOiByaWdodDsKfQoKdWwsIG9sIHsKICAgIG1hcmdpbi10b3A6IDAuN2VtOwogICAgbWFyZ2luLWxlZnQ6IDJyZW07CiAgICBtYXJnaW4tcmlnaHQ6IDJyZW07CiAgICBtYXJnaW4tYm90dG9tOiAwOwogICAgcGFkZGluZzogMDsKfQpsaTpub3QoOmZpcnN0LWNoaWxkKSB7CiAgICBtYXJnaW4tdG9wOiAwLjdlbTsKfQoKZHQgewogICAgcGFkZGluZy1sZWZ0OiAxcmVtOwogICAgcGFkZGluZy10b3A6IDEuNjQ3MDZyZW07Cn0KZHQ6Zmlyc3QtY2hpbGQgewogICAgcGFkZGluZy10b3A6IDA7Cn0KCi5jYWxsb3V0LCAuY29uZm9ybWFuY2XigJBmaWx0ZXIgewogICAgYm9yZGVyLWxlZnQtd2lkdGg6IGNhbGMoKDYgLyAxNykgKiAxcmVtKTsKICAgIGJvcmRlci1sZWZ0LXN0eWxlOiBzb2xpZDsKICAgIGJvcmRlci1yaWdodC1jb2xvcjogdHJhbnNwYXJlbnQ7CiAgICBib3JkZXItcmlnaHQtd2lkdGg6IGNhbGMoKDYgLyAxNykgKiAxcmVtKTsKICAgIGJvcmRlci1yaWdodC1zdHlsZTogc29saWQ7CiAgICBib3JkZXItcmFkaXVzOiBjYWxjKCg2IC8gMTcpICogMXJlbSk7CiAgICBtYXJnaW4tdG9wOiAxLjRlbTsKICAgIHBhZGRpbmc6IDAuOTQxMThyZW07Cn0KCi5jb25mb3JtYW5jZeKAkGZpbHRlciA+IGlucHV0IHsKICAgIG1hcmdpbi1sZWZ0OiAyZW07Cn0KCi8qIFNwZWNpZmljIExheW91dCAqLwoKaGVhZGVyLm5hdmlnYXRpb27igJBiYXIsIC5pbXBvcnTigJBoZWFkZXIgewogICAgYm94LXNpemluZzogY29udGVudC1ib3g7CiAgICBoZWlnaHQ6IGNhbGMoKDUyIC8gMTcpICogMXJlbSk7CiAgICBwYWRkaW5nOiAwIGNhbGMoKDIyIC8gMTcpICogMXJlbSk7Cn0KbmF2Lm5hdmlnYXRpb27igJBiYXIgewogICAgZGlzcGxheTogZmxleDsKICAgICBhbGlnbi1pdGVtczogY2VudGVyOwogICAgIGp1c3RpZnktY29udGVudDogc3BhY2UtYmV0d2VlbjsKICAgIGhlaWdodDogMTAwJTsKfQoubmF2aWdhdGlvbuKAkHBhdGggewogICAgZGlzcGxheTogZmxleDsKICAgICBhbGlnbi1pdGVtczogY2VudGVyOwogICAgIGp1c3RpZnktY29udGVudDogc3BhY2UtYmV0d2VlbjsKICAgICBvdmVyZmxvdzogaGlkZGVuOwogICAgIGZsZXgtd3JhcDogbm93cmFwOwogICAgIHdoaXRlLXNwYWNlOiBub3dyYXA7CiAgICAgdGV4dC1vdmVyZmxvdzogZWxsaXBzaXM7CiAgICBoZWlnaHQ6IDEwMCU7Cn0KW2Rpcj0icnRsIl0ubmF2aWdhdGlvbuKAkHBhdGggYSwgW2Rpcj0icnRsIl0ubmF2aWdhdGlvbuKAkHBhdGggc3BhbiB7CiAgICBtYXJnaW4tcmlnaHQ6IDEuMDU4ODJyZW07Cn0KW2Rpcj0ibHRyIl0ubmF2aWdhdGlvbuKAkHBhdGggYSwgW2Rpcj0ibHRyIl0ubmF2aWdhdGlvbuKAkHBhdGggc3BhbiB7CiAgICBtYXJnaW4tbGVmdDogMS4wNTg4MnJlbTsKfQoubmF2aWdhdGlvbuKAkHBhdGggYTpmaXJzdC1jaGlsZCwgLm5hdmlnYXRpb27igJBwYXRoIHNwYW46Zmlyc3QtY2hpbGQgewogICAgbWFyZ2luLWxlZnQ6IDA7CiAgICBtYXJnaW4tcmlnaHQ6IDA7Cn0KW2Rpcj0icnRsIl0ubmF2aWdhdGlvbuKAkHBhdGggYTo6YmVmb3JlLCBbZGlyPSJydGwiXS5uYXZpZ2F0aW9u4oCQcGF0aCBzcGFuOjpiZWZvcmUgewogICAgcGFkZGluZy1sZWZ0OiAxLjA1ODgycmVtOwp9CltkaXI9Imx0ciJdLm5hdmlnYXRpb27igJBwYXRoIGE6OmJlZm9yZSwgW2Rpcj0ibHRyIl0ubmF2aWdhdGlvbuKAkHBhdGggc3Bhbjo6YmVmb3JlIHsKICAgIHBhZGRpbmctcmlnaHQ6IDEuMDU4ODJyZW07Cn0KLm5hdmlnYXRpb27igJBwYXRoIGE6Zmlyc3QtY2hpbGQ6OmJlZm9yZSwgLm5hdmlnYXRpb27igJBwYXRoIHNwYW46Zmlyc3QtY2hpbGQ6OmJlZm9yZSB7CiAgICBkaXNwbGF5OiBub25lOwp9CgpoZWFkZXIubmF2aWdhdGlvbuKAkGJhciAuc3dpZnQuYmxvY2txdW90ZSwgLmltcG9ydOKAkGhlYWRlciAuc3dpZnQuYmxvY2txdW90ZSB7CiAgICBtYXJnaW46IDA7Cn0KLmltcG9ydOKAkGhlYWRlciAuc3dpZnQuYmxvY2txdW90ZTpub3QoOmZpcnN0LWNoaWxkKSB7CiAgICBtYXJnaW4tbGVmdDogY2FsYygoMjIgLyAxNykgKiAxcmVtKQp9CgouY29udGVudOKAkGNvbnRhaW5lciB7CiAgICBoZWlnaHQ6IGNhbGMoMTAwdmggLSBjYWxjKCg1MiAvIDE3KSAqIDFyZW0pIC0gY2FsYygoNDUgLyAxNykgKiAxcmVtKSk7CiAgICB3aWR0aDogMTAwJTsKICAgIGRpc3BsYXk6IGZsZXg7Cn0KaGVhZGVyLmluZGV4LCBoZWFkZXIucGxhdGZvcm1zIHsKICAgIGhlaWdodDogMTAwJTsKICAgIG1heC13aWR0aDogMjUlOwogICAgcGFkZGluZzogY2FsYygoMTIgLyAxNykgKiAxcmVtKSAwOwogICAgb3ZlcmZsb3cteTogYXV0bzsKfQoKLmluZGV4IGEsIC5wbGF0Zm9ybXMgYSB7CiAgICBjdXJzb3I6IHBvaW50ZXI7CiAgICBkaXNwbGF5OiBibG9jazsKICAgIHBhZGRpbmc6IDAuMmVtIGNhbGMoKDIyIC8gMTcpICogMXJlbSk7CiAgICBvdmVyZmxvdzogaGlkZGVuOwp9Ci5pbmRleCBhOm5vdCg6Zmlyc3QtY2hpbGQpLCAucGxhdGZvcm1zIGE6bm90KDpmaXJzdC1jaGlsZCkgewogICAgcGFkZGluZy1sZWZ0OiBjYWxjKDFlbSArIGNhbGMoKDIyIC8gMTcpICogMXJlbSkpOwp9CgptYWluIHsKICAgIGZsZXgtZ3JvdzogMTsKICAgIGhlaWdodDogMTAwJTsKICAgIG92ZXJmbG93LXk6IGF1dG87Cn0KLmltcG9ydOKAkGhlYWRlciB7CiAgICBkaXNwbGF5OiBmbGV4OwogICAgIGFsaWduLWl0ZW1zOiBjZW50ZXI7CiAgICAganVzdGlmeS1jb250ZW50OiBmbGV4LWVuZDsKCiAgICAgcG9zaXRpb246IC13ZWJraXQtc3RpY2t5OwogICAgcG9zaXRpb246IHN0aWNreTsKICAgIHRvcDogMDsKfQoubWFpbuKAkHRleHTigJBjb2x1bW4gewogICAgcGFkZGluZzogMCBjYWxjKCgyMiAvIDE3KSAqIDFyZW0pOwp9CgoudGl0bGUgewogICAgbWFyZ2luLXRvcDogMnJlbTsKICAgIG1hcmdpbi1ib3R0b206IDEuNXJlbTsKfQouc3ltYm9s4oCQdHlwZSB7CiAgICBtYXJnaW4tYm90dG9tOiBjYWxjKCgyMCAvIDE3KSAqIDFyZW0pOwp9CgouZGVzY3JpcHRpb24gewogICAgbWFyZ2luLWJvdHRvbTogMnJlbTsKfQouZGVzY3JpcHRpb24gcCB7CiAgICBtYXJnaW46IDA7Cn0KCi5kZWNsYXJhdGlvbjo6YmVmb3JlIHsKICAgIGJvcmRlci10b3A6IDFweCBzb2xpZCAjRDZENkQ2OwogICAgY29udGVudDogIiI7CiAgICBkaXNwbGF5OiBibG9jazsKfQouZGVjbGFyYXRpb24gewogICAgbWFyZ2luLXRvcDogMDsKfQouZGVjbGFyYXRpb24gaDIgewogICAgbWFyZ2luLXRvcDogMnJlbTsKfQouZGVjbGFyYXRpb24gLnN3aWZ0LmJsb2NrcXVvdGUgewogICAgbWFyZ2luLXRvcDogMXJlbTsKfQoKaDIgKyAuY2hpbGQgewogICAgbWFyZ2luLXRvcDogMnJlbTsKfQouY2hpbGQ6bm90KDpsYXN0LWNoaWxkKSB7CiAgICBtYXJnaW4tYm90dG9tOiAxLjVyZW07Cn0KLmNoaWxkID4gcCB7CiAgICBtYXJnaW46IDAgMi4zNTI5NHJlbTsKfQoKZm9vdGVyIHsKICAgIGRpc3BsYXk6IGZsZXg7CiAgICAgYWxpZ24taXRlbXM6IGNlbnRlcjsKICAgICBqdXN0aWZ5LWNvbnRlbnQ6IHNwYWNlLWJldHdlZW47CiAgICBoZWlnaHQ6IGNhbGMoKDQ1IC8gMTcpICogMXJlbSk7CiAgICBwYWRkaW5nOiAwIGNhbGMoKDIyIC8gMTcpICogMXJlbSk7Cn0KCi8qIENvbG91cnMgKi8KCmh0bWwgewogICAgY29sb3I6ICMzMzMzMzM7Cn0KCmEgewogICAgY29sb3I6ICMwMDcwQzk7Cn0KCmJsb2NrcXVvdGUgewogICAgY29sb3I6ICM2QTczN0Q7Cn0KCi5uYXZpZ2F0aW9u4oCQYmFyIHsKICAgIGJhY2tncm91bmQtY29sb3I6ICMzMzM7CiAgICBjb2xvcjogI0NDQ0NDQzsKfQoubmF2aWdhdGlvbuKAkHBhdGggYSB7CiAgICBjb2xvcjogI0ZGRkZGRjsKfQoKLmluZGV4LCAucGxhdGZvcm1zIHsKICAgIGJhY2tncm91bmQtY29sb3I6ICNGMkYyRjI7Cn0KLmluZGV4IGEsIC5wbGF0Zm9ybXMgYSB7CiAgICBjb2xvcjogIzU1NTU1NTsKfQouaW5kZXggYS5oZWFkaW5nLCAucGxhdGZvcm1zIGEuaGVhZGluZyB7CiAgICBjb2xvcjogIzMzMzsKfQoKLmltcG9ydOKAkGhlYWRlciB7CiAgICBiYWNrZ3JvdW5kLWNvbG9yOiAjRjJGMkYyOwp9Cgouc3ltYm9s4oCQdHlwZSB7CiAgICBjb2xvcjogIzY2NjsKfQoKLmNhbGxvdXQsIC5jb25mb3JtYW5jZeKAkGZpbHRlciB7CiAgICBiYWNrZ3JvdW5kLWNvbG9yOiAjRkFGQUZBOwogICAgYm9yZGVyLWxlZnQtY29sb3I6ICNFNkU2RTY7Cn0KLmNhbGxvdXQuYXR0ZW50aW9uLCAuY2FsbG91dC5pbXBvcnRhbnQgewogICAgYmFja2dyb3VuZC1jb2xvcjogI0ZCRjhFODsKICAgIGJvcmRlci1sZWZ0LWNvbG9yOiAjRkVFNDUwOwp9Ci5jYWxsb3V0Lndhcm5pbmcgewogICAgYmFja2dyb3VuZC1jb2xvcjogI0YyREJEQzsKICAgIGJvcmRlci1sZWZ0LWNvbG9yOiAjQUUyNzJGOwp9Cgpmb290ZXIgewogICAgYmFja2dyb3VuZC1jb2xvcjogI0YyRjJGMjsKICAgIGNvbG9yOiAjODg4ODg4Owp9CgovKiBHZW5lcmFsIEZvbnRzICovCgpodG1sIHsKICAgIGZvbnQtZmFtaWx5OiAiU0YgUHJvIFRleHQiLCAiU0YgUHJvIEljb25zIiwgIi1hcHBsZS1zeXN0ZW0iLCAiQmxpbmtNYWNTeXN0ZW1Gb250IiwgIkhlbHZldGljYSBOZXVlIiwgIkhlbHZldGljYSIsICJBcmlhbCIsIHNhbnMtc2VyaWY7CiAgICBmb250LXNpemU6IDEwNi4yNSU7CiAgICBsZXR0ZXItc3BhY2luZzogLTAuMDIxZW07CiAgICBsaW5lLWhlaWdodDogMS41Mjk0NzsKfQoKaDEsIGgyIHsKICAgIGZvbnQtZmFtaWx5OiAiU0YgUHJvIERpc3BsYXkiLCAiU0YgUHJvIEljb25zIiwgIi1hcHBsZS1zeXN0ZW0iLCAiQmxpbmtNYWNTeXN0ZW1Gb250IiwgIkhlbHZldGljYSBOZXVlIiwgIkhlbHZldGljYSIsICJBcmlhbCIsIHNhbnMtc2VyaWY7Cn0KaDEgewogICAgZm9udC1zaXplOiBjYWxjKCg0MCAvIDE3KSAqIDFyZW0pOwogICAgZm9udC13ZWlnaHQ6IDUwMDsKICAgIGxldHRlci1zcGFjaW5nOiAwLjAwOGVtOwogICAgbGluZS1oZWlnaHQ6IDEuMDU7Cn0KaDIgewogICAgZm9udC1zaXplOiBjYWxjKCgzMiAvIDE3KSAqIDFyZW0pOwogICAgZm9udC13ZWlnaHQ6IDUwMDsKICAgIGxldHRlci1zcGFjaW5nOiAwLjAxMWVtOwogICAgbGluZS1oZWlnaHQ6IDEuMDkzNzU7Cn0KaDMgewogICAgZm9udC1zaXplOiBjYWxjKCgyOCAvIDE3KSAqIDFyZW0pOwogICAgZm9udC13ZWlnaHQ6IDUwMDsKICAgIGxldHRlci1zcGFjaW5nOiAwLjAxMmVtOwogICAgbGluZS1oZWlnaHQ6IDEuMTA3MzsKfQpoNCwgaDUsIGg2IHsKICAgIGZvbnQtd2VpZ2h0OiA1MDA7CiAgICBsZXR0ZXItc3BhY2luZzogMC4wMTVlbTsKICAgIGxpbmUtaGVpZ2h0OiAxLjIwODQ5Owp9Cmg0IHsKICAgIGZvbnQtc2l6ZTogY2FsYygoMjQgLyAxNykgKiAxcmVtKTsKfQpoNSB7CiAgICBmb250LXNpemU6IGNhbGMoKDIwIC8gMTcpICogMXJlbSk7Cn0KaDYgewogICAgZm9udC1zaXplOiBjYWxjKCgxOCAvIDE3KSAqIDFyZW0pOwp9CgphOmxpbmssIGE6dmlzaXRlZCB7CiAgICB0ZXh0LWRlY29yYXRpb246IG5vbmU7Cn0KYTpob3ZlciB7CiAgICB0ZXh0LWRlY29yYXRpb246IHVuZGVybGluZTsKfQoKLmNhbGxvdXTigJBsYWJlbCwgLmNvbmZvcm1hbmNl4oCQZmlsdGVy4oCQbGFiZWwgewogICAgZm9udC13ZWlnaHQ6IDYwMDsKfQoKLyogU3BlY2lmaWMgRm9udHMgKi8KCi5uYXZpZ2F0aW9u4oCQYmFyLCAuaW1wb3J04oCQaGVhZGVyIHsKICAgIGZvbnQtc2l6ZTogY2FsYygoMTUgLyAxNykgKiAxcmVtKTsKICAgIGxldHRlci1zcGFjaW5nOiAtMC4wMTRlbTsKICAgIGxpbmUtaGVpZ2h0OiAxLjI2NjY3Owp9Ci5uYXZpZ2F0aW9u4oCQcGF0aCBhOjpiZWZvcmUsIC5uYXZpZ2F0aW9u4oCQcGF0aCBzcGFuOjpiZWZvcmUgewogICAgZm9udC1mYW1pbHk6ICJTRiBQcm8gSWNvbnMiLCAiLWFwcGxlLXN5c3RlbSIsICJCbGlua01hY1N5c3RlbUZvbnQiLCAiSGVsdmV0aWNhIE5ldWUiLCAiSGVsdmV0aWNhIiwgIkFyaWFsIiwgc2Fucy1zZXJpZjsKICAgIGNvbnRlbnQ6ICLigKMiOwogICAgbGluZS1oZWlnaHQ6IDE7Cn0KCi5pbmRleCwgLnBsYXRmb3JtcyB7CiAgICBmb250LXNpemU6IGNhbGMoKDEyIC8gMTcpICogMXJlbSk7CiAgICBsZXR0ZXItc3BhY2luZzogLjAxNWVtOwogICAgbGluZS1oZWlnaHQ6IGNhbGMoKDIwIC8gMTcpICogMXJlbSk7Cn0KLmluZGV4IGEuaGVhZGluZywgLnBsYXRmb3JtcyBhLmhlYWRpbmcgewogICAgZm9udC13ZWlnaHQ6IDYwMDsKfQoKLnN5bWJvbOKAkHR5cGUgewogICAgZm9udC1mYW1pbHk6ICJTRiBQcm8gRGlzcGxheSIsICJTRiBQcm8gSWNvbnMiLCAiLWFwcGxlLXN5c3RlbSIsICJCbGlua01hY1N5c3RlbUZvbnQiLCAiSGVsdmV0aWNhIE5ldWUiLCAiSGVsdmV0aWNhIiwgIkFyaWFsIiwgc2Fucy1zZXJpZjsKICAgIGZvbnQtc2l6ZTogY2FsYygoMjIgLyAxNykgKiAxcmVtKTsKICAgIGxldHRlci1zcGFjaW5nOiAwLjAxNmVtOwogICAgbGluZS1oZWlnaHQ6IDE7Cn0KCi5kZXNjcmlwdGlvbiB7CiAgICBmb250LWZhbWlseTogIlNGIFBybyBEaXNwbGF5IiwgIlNGIFBybyBJY29ucyIsICItYXBwbGUtc3lzdGVtIiwgIkJsaW5rTWFjU3lzdGVtRm9udCIsICJIZWx2ZXRpY2EgTmV1ZSIsICJIZWx2ZXRpY2EiLCAiQXJpYWwiLCBzYW5zLXNlcmlmOwogICAgZm9udC1zaXplOiBjYWxjKCgyMiAvIDE3KSAqIDFyZW0pOwogICAgZm9udC13ZWlnaHQ6IDMwMDsKICAgIGxldHRlci1zcGFjaW5nOiAwLjAxNmVtOwogICAgbGluZS1oZWlnaHQ6IDEuNDU0NTU7Cn0KCi5kZWNsYXJhdGlvbiAuc3dpZnQuYmxvY2txdW90ZSB7CiAgICBmb250LXNpemU6IGNhbGMoKDE1IC8gMTcpICogMXJlbSk7Cn0KCmZvb3RlciB7CiAgICBmb250LXNpemU6IGNhbGMoKDExIC8gMTcpICogMXJlbSk7CiAgICBsZXR0ZXItc3BhY2luZzogY2FsYygoMC4yMzk5OTk5OTQ2MzU1ODE5NyAvIDE3KSAqIDFyZW0pOwogICAgbGluZS1oZWlnaHQ6IGNhbGMoKDE0IC8gMTcpICogMXJlbSk7Cn0K")!, encoding: String.Encoding.utf8)!

}
