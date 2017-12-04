/*
 Resources.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2017 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import Foundation

internal enum Resources {}

extension Resources {
    enum ReadMe {
        static let customReadMe = String(data: Data(base64Encoded: "PCEtLQogQ3VzdG9tIFJlYWTigJBNZS5tZAoKIFRoaXMgc291cmNlIGZpbGUgaXMgcGFydCBvZiB0aGUgV29ya3NwYWNlIG9wZW4gc291cmNlIHByb2plY3QuCiBodHRwczovL2dpdGh1Yi5jb20vU0RHR2llc2JyZWNodC9Xb3Jrc3BhY2Ujd29ya3NwYWNlCgogQ29weXJpZ2h0IMKpMjAxNyBKZXJlbXkgRGF2aWQgR2llc2JyZWNodCBhbmQgdGhlIFdvcmtzcGFjZSBwcm9qZWN0IGNvbnRyaWJ1dG9ycy4KCiBTb2xpIERlbyBnbG9yaWEuCgogTGljZW5zZWQgdW5kZXIgdGhlIEFwYWNoZSBMaWNlbmNlLCBWZXJzaW9uIDIuMC4KIFNlZSBodHRwOi8vd3d3LmFwYWNoZS5vcmcvbGljZW5zZXMvTElDRU5TRS0yLjAgZm9yIGxpY2VuY2UgaW5mb3JtYXRpb24uCiAtLT4KClvwn4eo8J+HpkVOXShEb2N1bWVudGF0aW9uL/Cfh6jwn4emRU4lMjBSZWFkJTIwTWUubWQpIDwhLS1Ta2lwIGluIEphenp5LS0+CgptYWNPUyDigKIgTGludXgg4oCiIGlPUyDigKIgd2F0Y2hPUyDigKIgdHZPUwoKIyBNeVByb2plY3QKCj4gW0JsYWggYmxhaCBibGFoLi4uXShodHRwOi8vc29tZXdoZXJlLmNvbSkKCiMjIEluc3RhbGxhdGlvbgoKQnVpbGQgZnJvbSBzb3VyY2UgYXQgdGFnIGAxLjIuM2Agb2YgYGh0dHBzOi8vZ2l0aHViLmNvbS9Vc2VyL1JlcG9zaXRvcnlgLgoKIyMgRXhhbXBsZSBVc2FnZQoKYGBgc3dpZnQKbGV0IHggPSBzb21ldGhpbmcoKQpgYGAK")!, encoding: String.Encoding.utf8)!
        static let customWorkspaceConfiguration = String(data: Data(base64Encoded: "KCgKICAgIEN1c3RvbS5Xb3Jrc3BhY2UgQ29uZmlndXJhdGlvbi50eHQKCiAgICBUaGlzIHNvdXJjZSBmaWxlIGlzIHBhcnQgb2YgdGhlIFdvcmtzcGFjZSBvcGVuIHNvdXJjZSBwcm9qZWN0LgogICAgaHR0cHM6Ly9naXRodWIuY29tL1NER0dpZXNicmVjaHQvV29ya3NwYWNlI3dvcmtzcGFjZQoKICAgIENvcHlyaWdodCDCqTIwMTcgSmVyZW15IERhdmlkIEdpZXNicmVjaHQgYW5kIHRoZSBXb3Jrc3BhY2UgcHJvamVjdCBjb250cmlidXRvcnMuCgogICAgU29saSBEZW8gZ2xvcmlhLgoKICAgIExpY2Vuc2VkIHVuZGVyIHRoZSBBcGFjaGUgTGljZW5jZSwgVmVyc2lvbiAyLjAuCiAgICBTZWUgaHR0cDovL3d3dy5hcGFjaGUub3JnL2xpY2Vuc2VzL0xJQ0VOU0UtMi4wIGZvciBsaWNlbmNlIGluZm9ybWF0aW9uLgogICAgKSkKCk1hbmFnZSBSZWFk4oCQTWU6IFRydWUKQ3VycmVudCBWZXJzaW9uOiAxLjIuMwpSZXBvc2l0b3J5IFVSTDogaHR0cHM6Ly9naXRodWIuY29tL1VzZXIvUmVwb3NpdG9yeQoKW19CZWdpbiBMb2NhbGl6YXRpb25zX10K8J+HqPCfh6ZFTgpbX0VuZF9dCgpRdW90YXRpb246IEJsYWggYmxhaCBibGFoLi4uCltfQmVnaW4gUXVvdGF0aW9uIFVSTF9dCltf8J+HqPCfh6ZFTl9dCmh0dHA6Ly9zb21ld2hlcmUuY29tCltfRW5kX10KCltfQmVnaW4gSW5zdGFsbGF0aW9uIEluc3RydWN0aW9uc19dCltf8J+HqPCfh6ZFTl9dCiMjIEluc3RhbGxhdGlvbgoKQnVpbGQgZnJvbSBzb3VyY2UgYXQgdGFnIGBbX0N1cnJlbnQgVmVyc2lvbl9dYCBvZiBgW19SZXBvc2l0b3J5IFVSTF9dYC4KW19FbmRfXQoKW19CZWdpbiBFeGFtcGxlIFVzYWdlX10KW1/wn4eo8J+HpkVOX10KYGBgc3dpZnQKbGV0IHggPSBzb21ldGhpbmcoKQpgYGAKW19FbmRfXQo=")!, encoding: String.Encoding.utf8)!
        static let elaborateReadMe = String(data: Data(base64Encoded: "PCEtLQogRWxhYm9yYXRlIFJlYWTigJBNZS5tZAoKIFRoaXMgc291cmNlIGZpbGUgaXMgcGFydCBvZiB0aGUgV29ya3NwYWNlIG9wZW4gc291cmNlIHByb2plY3QuCiBodHRwczovL2dpdGh1Yi5jb20vU0RHR2llc2JyZWNodC9Xb3Jrc3BhY2Ujd29ya3NwYWNlCgogQ29weXJpZ2h0IMKpMjAxNyBKZXJlbXkgRGF2aWQgR2llc2JyZWNodCBhbmQgdGhlIFdvcmtzcGFjZSBwcm9qZWN0IGNvbnRyaWJ1dG9ycy4KCiBTb2xpIERlbyBnbG9yaWEuCgogTGljZW5zZWQgdW5kZXIgdGhlIEFwYWNoZSBMaWNlbmNlLCBWZXJzaW9uIDIuMC4KIFNlZSBodHRwOi8vd3d3LmFwYWNoZS5vcmcvbGljZW5zZXMvTElDRU5TRS0yLjAgZm9yIGxpY2VuY2UgaW5mb3JtYXRpb24uCiAtLT4KClvwn4eo8J+HpkVOXShEb2N1bWVudGF0aW9uL/Cfh6jwn4emRU4lMjBSZWFkJTIwTWUubWQpIOKAoiBb8J+HrPCfh6dFTl0oRG9jdW1lbnRhdGlvbi/wn4es8J+Hp0VOJTIwUmVhZCUyME1lLm1kKSDigKIgW/Cfh7rwn4e4RU5dKERvY3VtZW50YXRpb24v8J+HuvCfh7hFTiUyMFJlYWQlMjBNZS5tZCkg4oCiIFvwn4ep8J+HqkRFXShEb2N1bWVudGF0aW9uL/Cfh6nwn4eqREUlMjBMaWVzJTIwbWljaC5tZCkg4oCiIFvwn4er8J+Ht0ZSXShEb2N1bWVudGF0aW9uL/Cfh6vwn4e3RlIlMjBMaXNleiUyMG1vaS5tZCkg4oCiIFvwn4es8J+Ht86VzptdKERvY3VtZW50YXRpb24v8J+HrPCfh7fOlc6bJTIwzpzOtSUyMM60zrnOsc6yzrHMgc+Dz4TOtS5tZCkg4oCiIFvwn4eu8J+Hsdei15FdKERvY3VtZW50YXRpb24v8J+HrvCfh7HXoteRJTIw16fXqNeQJTIw15DXldeq15kubWQpIOKAoiBbW3p4eF1dKERvY3VtZW50YXRpb24vW3p4eF0lMjBSZWFkJTIwTWUubWQpIDwhLS1Ta2lwIGluIEphenp5LS0+CgptYWNPUyDigKIgTGludXgg4oCiIGlPUyDigKIgd2F0Y2hPUyDigKIgdHZPUwoKQVBJczogW015UHJvamVjdF0oZG9jdW1lbnRhdGlvbi5leGFtcGxlLmNvbS9NeVByb2plY3QpCgojIE15UHJvamVjdAoKTXlQcm9qZWN0IGRvZXMgc3R1ZmYuCgo+IFvCqyAuLi4gwrs8YnI+4oCcLi4u4oCdXShodHRwczovL3d3dy5iaWJsZWdhdGV3YXkuY29tL3Bhc3NhZ2UvP3NlYXJjaD1DaGFwdGVyKzEmdmVyc2lvbj1XTEM7TklWKTxicj4mbmJzcDsmbmJzcDsmbmJzcDsmbmJzcDsmbmJzcDsmbmJzcDsmbmJzcDsmbmJzcDsmbmJzcDsmbmJzcDsmbmJzcDsmbmJzcDsmbmJzcDsmbmJzcDsmbmJzcDsmbmJzcDsmbmJzcDsmbmJzcDsmbmJzcDsmbmJzcDsmbmJzcDsmbmJzcDsmbmJzcDsmbmJzcDsmbmJzcDsmbmJzcDsmbmJzcDsmbmJzcDsmbmJzcDsmbmJzcDsmbmJzcDsmbmJzcDsmbmJzcDsmbmJzcDsmbmJzcDsmbmJzcDsmbmJzcDsmbmJzcDsmbmJzcDsmbmJzcDsmbmJzcDsmbmJzcDsmbmJzcDsmbmJzcDsmbmJzcDsmbmJzcDsmbmJzcDsmbmJzcDsmbmJzcDsmbmJzcDsmbmJzcDsmbmJzcDsmbmJzcDsmbmJzcDsmbmJzcDsmbmJzcDsmbmJzcDsmbmJzcDsmbmJzcDsmbmJzcDsmbmJzcDsmbmJzcDsmbmJzcDsmbmJzcDsmbmJzcDsmbmJzcDsmbmJzcDsmbmJzcDsmbmJzcDsmbmJzcDsmbmJzcDsmbmJzcDsmbmJzcDsmbmJzcDsmbmJzcDsmbmJzcDsmbmJzcDsmbmJzcDsmbmJzcDsmbmJzcDsmbmJzcDsmbmJzcDsmbmJzcDsmbmJzcDsmbmJzcDsmbmJzcDsmbmJzcDsmbmJzcDsmbmJzcDsmbmJzcDsmbmJzcDsmbmJzcDsmbmJzcDsmbmJzcDsmbmJzcDsmbmJzcDsmbmJzcDsmbmJzcDsmbmJzcDsmbmJzcDvigJVzb21lb25lCgojIyBGZWF0dXJlcwoKLSBTdHVmZi4KLSBNb3JlIHN0dWZmLgotIEV2ZW4gbW9yZSBzdHVmZi4KCihGb3IgYSBsaXN0IG9mIHJlbGF0ZWQgcHJvamVjdHMsIHNlZSBbaGVyZV0oRG9jdW1lbnRhdGlvbi/wn4eo8J+HpkVOJTIwUmVsYXRlZCUyMFByb2plY3RzLm1kKS4pIDwhLS1Ta2lwIGluIEphenp5LS0+CgojIyBJbXBvcnRpbmcKCmBNeVByb2plY3RgIGlzIGludGVuZGVkIGZvciB1c2Ugd2l0aCB0aGUgW1N3aWZ0IFBhY2thZ2UgTWFuYWdlcl0oaHR0cHM6Ly9zd2lmdC5vcmcvcGFja2FnZS1tYW5hZ2VyLykuCgpTaW1wbHkgYWRkIGBNeVByb2plY3RgIGFzIGEgZGVwZW5kZW5jeSBpbiBgUGFja2FnZS5zd2lmdGA6CgpgYGBzd2lmdApsZXQgcGFja2FnZSA9IFBhY2thZ2UoCiAgICBuYW1lOiAiTXlQYWNrYWdlIiwKICAgIGRlcGVuZGVuY2llczogWwogICAgICAgIC5wYWNrYWdlKHVybDogImh0dHBzOi8vZ2l0aHViLmNvbS9Vc2VyL1Byb2plY3QiLCBmcm9tOiBWZXJzaW9uKDEsIDIsIDMpKSwKICAgIF0sCiAgICB0YXJnZXRzOiBbCiAgICAgICAgLnRhcmdldChuYW1lOiAiTXlUYXJnZXQiLCBkZXBlbmRlbmNpZXM6IFsKICAgICAgICAgICAgLnByb2R1Y3RJdGVtKG5hbWU6ICJNeVByb2plY3QiLCBwYWNrYWdlOiAiTXlQcm9qZWN0IiksCiAgICAgICAgXSkKICAgIF0KKQpgYGAKCmBNeVByb2plY3RgIGNhbiB0aGVuIGJlIGltcG9ydGVkIGluIHNvdXJjZSBmaWxlczoKCmBgYHN3aWZ0CmltcG9ydCBNeVByb2plY3QKYGBgCgojIyBFeGFtcGxlIFVzYWdlCgpgYGBzd2lmdApkb1NvbWV0aGluZygpCmBgYAoKIyMgT3RoZXIKCi4uLgoKIyMgQWJvdXQKClRoaXMgcHJvamVjdCBpcyBqdXN0IGEgdGVzdC4K")!, encoding: String.Encoding.utf8)!
        static let elaborateWorkspaceConfiguration = String(data: Data(base64Encoded: "KCgKICAgIEVsYWJvcmF0ZS5Xb3Jrc3BhY2UgQ29uZmlndXJhdGlvbi50eHQKCiAgICBUaGlzIHNvdXJjZSBmaWxlIGlzIHBhcnQgb2YgdGhlIFdvcmtzcGFjZSBvcGVuIHNvdXJjZSBwcm9qZWN0LgogICAgaHR0cHM6Ly9naXRodWIuY29tL1NER0dpZXNicmVjaHQvV29ya3NwYWNlI3dvcmtzcGFjZQoKICAgIENvcHlyaWdodCDCqTIwMTcgSmVyZW15IERhdmlkIEdpZXNicmVjaHQgYW5kIHRoZSBXb3Jrc3BhY2UgcHJvamVjdCBjb250cmlidXRvcnMuCgogICAgU29saSBEZW8gZ2xvcmlhLgoKICAgIExpY2Vuc2VkIHVuZGVyIHRoZSBBcGFjaGUgTGljZW5jZSwgVmVyc2lvbiAyLjAuCiAgICBTZWUgaHR0cDovL3d3dy5hcGFjaGUub3JnL2xpY2Vuc2VzL0xJQ0VOU0UtMi4wIGZvciBsaWNlbmNlIGluZm9ybWF0aW9uLgogICAgKSkKCkN1cnJlbnQgVmVyc2lvbjogMS4yLjMKClByb2plY3QgV2Vic2l0ZTogcHJvamVjdC5leGFtcGxlLmNvbQpEb2N1bWVudGF0aW9uIFVSTDogZG9jdW1lbnRhdGlvbi5leGFtcGxlLmNvbQpSZXBvc2l0b3J5IFVSTDogaHR0cHM6Ly9naXRodWIuY29tL1VzZXIvUHJvamVjdAoKQXV0aG9yOiBTb21lb25lCkFkbWluaXN0cmF0b3JzOiBTb21lb25lCgpNYW5hZ2UgUmVhZOKAkE1lOiBUcnVlCgpbX0JlZ2luIExvY2FsaXphdGlvbnNfXQrwn4eo8J+HpkVOCvCfh6zwn4enRU4K8J+HuvCfh7hFTgrwn4ep8J+HqkRFCvCfh6vwn4e3RlIK8J+HrPCfh7fOlc6bCvCfh67wn4ex16LXkQp6eHgKW19FbmRfXQoKW19CZWdpbiBTaG9ydCBQcm9qZWN0IERlc2NyaXB0aW9uX10KW1/wn4eo8J+HpkVOX10KTXlQcm9qZWN0IGRvZXMgc3R1ZmYuCltf8J+HrPCfh6dFTl9dCi4uLgpbX/Cfh7rwn4e4RU5fXQouLi4KW1/wn4ep8J+HqkRFX10KLi4uCltf8J+Hq/Cfh7dGUl9dCi4uLgpbX/Cfh6zwn4e3zpXOm19dCi4uLgpbX/Cfh67wn4ex16LXkV9dCi4uLgpbX3p4eF9dCi4uLgpbX0VuZF9dCgpbX0JlZ2luIFF1b3RhdGlvbl9dCsKrIC4uLiDCuwpbX0VuZF9dCgpbX0JlZ2luIFF1b3RhdGlvbiBUcmFuc2xhdGlvbl9dCltf8J+HqPCfh6ZFTl9dCuKAnC4uLuKAnQpbX/Cfh6zwn4enRU5fXQouLi4KW1/wn4e68J+HuEVOX10KLi4uCltf8J+HqfCfh6pERV9dCi4uLgpbX/Cfh6vwn4e3RlJfXQouLi4KW1/wn4es8J+Ht86VzptfXQouLi4KW1/wn4eu8J+Hsdei15FfXQouLi4KW196eHhfXQouLi4KW19FbmRfXQoKUXVvdGF0aW9uIFRlc3RhbWVudDog16rXoNe015oKUXVvdGF0aW9uIENoYXB0ZXI6IENoYXB0ZXIgMQoKW19CZWdpbiBDaXRhdGlvbl9dCltf8J+HqPCfh6ZFTl9dCnNvbWVvbmUKW1/wn4es8J+Hp0VOX10KLi4uCltf8J+HuvCfh7hFTl9dCi4uLgpbX/Cfh6nwn4eqREVfXQouLi4KW1/wn4er8J+Ht0ZSX10KLi4uCltf8J+HrPCfh7fOlc6bX10KLi4uCltf8J+HrvCfh7HXoteRX10KLi4uCltfenh4X10KLi4uCltfRW5kX10KCltfQmVnaW4gRmVhdHVyZSBMaXN0X10KW1/wn4eo8J+HpkVOX10KLSBTdHVmZi4KLSBNb3JlIHN0dWZmLgotIEV2ZW4gbW9yZSBzdHVmZi4KW1/wn4es8J+Hp0VOX10KLi4uCltf8J+HuvCfh7hFTl9dCi4uLgpbX/Cfh6nwn4eqREVfXQouLi4KW1/wn4er8J+Ht0ZSX10KLi4uCltf8J+HrPCfh7fOlc6bX10KLi4uCltf8J+HrvCfh7HXoteRX10KLi4uCltfenh4X10KLi4uCltfRW5kX10KCltfQmVnaW4gT3RoZXIgUmVhZOKAkE1lIENvbnRlbnRfXQpbX/Cfh6jwn4emRU5fXQojIyBPdGhlcgoKLi4uCltf8J+HrPCfh6dFTl9dCi4uLgpbX/Cfh7rwn4e4RU5fXQouLi4KW1/wn4ep8J+HqkRFX10KLi4uCltf8J+Hq/Cfh7dGUl9dCi4uLgpbX/Cfh6zwn4e3zpXOm19dCi4uLgpbX/Cfh67wn4ex16LXkV9dCi4uLgpbX3p4eF9dCi4uLgpbX0VuZF9dCgpbX0JlZ2luIFJlYWTigJBNZSBBYm91dCBTZWN0aW9uX10KW1/wn4eo8J+HpkVOX10KVGhpcyBwcm9qZWN0IGlzIGp1c3QgYSB0ZXN0LgpbX/Cfh6zwn4enRU5fXQouLi4KW1/wn4e68J+HuEVOX10KLi4uCltf8J+HqfCfh6pERV9dCi4uLgpbX/Cfh6vwn4e3RlJfXQouLi4KW1/wn4es8J+Ht86VzptfXQouLi4KW1/wn4eu8J+Hsdei15FfXQouLi4KW196eHhfXQouLi4KW19FbmRfXQoKW19CZWdpbiBSZWxhdGVkIFByb2plY3RzX10KaHR0cHM6Ly9naXRodWIuY29tL1NER0dpZXNicmVjaHQvV29ya3NwYWNlCltfRW5kX10K")!, encoding: String.Encoding.utf8)!
        static let elaborateΜεΔιαβάστε = String(data: Data(base64Encoded: "PCEtLQogRWxhYm9yYXRlIM6czrXigJDOtM65zrHOss6xzIHPg8+EzrUubWQKCiBUaGlzIHNvdXJjZSBmaWxlIGlzIHBhcnQgb2YgdGhlIFdvcmtzcGFjZSBvcGVuIHNvdXJjZSBwcm9qZWN0LgogaHR0cHM6Ly9naXRodWIuY29tL1NER0dpZXNicmVjaHQvV29ya3NwYWNlI3dvcmtzcGFjZQoKIENvcHlyaWdodCDCqTIwMTcgSmVyZW15IERhdmlkIEdpZXNicmVjaHQgYW5kIHRoZSBXb3Jrc3BhY2UgcHJvamVjdCBjb250cmlidXRvcnMuCgogU29saSBEZW8gZ2xvcmlhLgoKIExpY2Vuc2VkIHVuZGVyIHRoZSBBcGFjaGUgTGljZW5jZSwgVmVyc2lvbiAyLjAuCiBTZWUgaHR0cDovL3d3dy5hcGFjaGUub3JnL2xpY2Vuc2VzL0xJQ0VOU0UtMi4wIGZvciBsaWNlbmNlIGluZm9ybWF0aW9uLgogLS0+Cgpb8J+HqPCfh6ZFTl0o8J+HqPCfh6ZFTiUyMFJlYWQlMjBNZS5tZCkg4oCiIFvwn4es8J+Hp0VOXSjwn4es8J+Hp0VOJTIwUmVhZCUyME1lLm1kKSDigKIgW/Cfh7rwn4e4RU5dKPCfh7rwn4e4RU4lMjBSZWFkJTIwTWUubWQpIOKAoiBb8J+HqfCfh6pERV0o8J+HqfCfh6pERSUyMExpZXMlMjBtaWNoLm1kKSDigKIgW/Cfh6vwn4e3RlJdKPCfh6vwn4e3RlIlMjBMaXNleiUyMG1vaS5tZCkg4oCiIFvwn4es8J+Ht86VzptdKPCfh6zwn4e3zpXOmyUyMM6czrUlMjDOtM65zrHOss6xzIHPg8+EzrUubWQpIOKAoiBb8J+HrvCfh7HXoteRXSjwn4eu8J+Hsdei15ElMjDXp9eo15AlMjDXkNeV16rXmS5tZCkg4oCiIFtbenh4XV0oW3p4eF0lMjBSZWFkJTIwTWUubWQpIDwhLS1Ta2lwIGluIEphenp5LS0+CgrOnM6xzrrigJDOn+KAkM6Vz4Ig4oCiIM6bzrnMgc69zr/Phc6+IOKAoiDOkc654oCQzp/igJDOlc+CIOKAoiDOn8+FzrHPhM+D4oCQzp/igJDOlc+CIOKAoiDOpM654oCQzpLOueKAkM6f4oCQzpXPggoKzpTOoM6VOiBbTXlQcm9qZWN0XShkb2N1bWVudGF0aW9uLmV4YW1wbGUuY29tL015UHJvamVjdCkKCiMgTXlQcm9qZWN0CgouLi4KCj4gW8KrIC4uLiDCuzxicj4uLi5dKGh0dHBzOi8vd3d3LmJpYmxlZ2F0ZXdheS5jb20vcGFzc2FnZS8/c2VhcmNoPUNoYXB0ZXIrMSZ2ZXJzaW9uPVdMQztOSVZVSyk8YnI+Jm5ic3A7Jm5ic3A7Jm5ic3A7Jm5ic3A7Jm5ic3A7Jm5ic3A7Jm5ic3A7Jm5ic3A7Jm5ic3A7Jm5ic3A7Jm5ic3A7Jm5ic3A7Jm5ic3A7Jm5ic3A7Jm5ic3A7Jm5ic3A7Jm5ic3A7Jm5ic3A7Jm5ic3A7Jm5ic3A7Jm5ic3A7Jm5ic3A7Jm5ic3A7Jm5ic3A7Jm5ic3A7Jm5ic3A7Jm5ic3A7Jm5ic3A7Jm5ic3A7Jm5ic3A7Jm5ic3A7Jm5ic3A7Jm5ic3A7Jm5ic3A7Jm5ic3A7Jm5ic3A7Jm5ic3A7Jm5ic3A7Jm5ic3A7Jm5ic3A7Jm5ic3A7Jm5ic3A7Jm5ic3A7Jm5ic3A7Jm5ic3A7Jm5ic3A7Jm5ic3A7Jm5ic3A7Jm5ic3A7Jm5ic3A7Jm5ic3A7Jm5ic3A7Jm5ic3A7Jm5ic3A7Jm5ic3A7Jm5ic3A7Jm5ic3A7Jm5ic3A7Jm5ic3A7Jm5ic3A7Jm5ic3A7Jm5ic3A7Jm5ic3A7Jm5ic3A7Jm5ic3A7Jm5ic3A7Jm5ic3A7Jm5ic3A7Jm5ic3A7Jm5ic3A7Jm5ic3A7Jm5ic3A7Jm5ic3A7Jm5ic3A7Jm5ic3A7Jm5ic3A7Jm5ic3A7Jm5ic3A7Jm5ic3A7Jm5ic3A7Jm5ic3A7Jm5ic3A7Jm5ic3A7Jm5ic3A7Jm5ic3A7Jm5ic3A7Jm5ic3A7Jm5ic3A7Jm5ic3A7Jm5ic3A7Jm5ic3A7Jm5ic3A7Jm5ic3A7Jm5ic3A7Jm5ic3A7Jm5ic3A7Jm5ic3A7Jm5ic3A7Jm5ic3A7Jm5ic3A74oCVLi4uCgojIyDOp86xz4HOsc66z4TOt8+BzrnPg8+EzrnOus6xzIEKCi4uLgoKKM6TzrnOsSDOtcyBzr3OsSDOus6xz4TOscyBzrvOv86zzr8gz4PPhc6zzrPOtc69zrnOus+JzIHOvSDOtcyBz4HOs8+Jzr0sIM60zrXOucyBz4TOtSBbzrXOtM+JzIFdKPCfh6zwn4e3zpXOmyUyMM6jz4XOs86zzrXOvc65zrrOscyBJTIwzrXMgc+BzrPOsS5tZCkuKSA8IS0tU2tpcCBpbiBKYXp6eS0tPgoKIyMgzpXOuc+DzrHOs8+JzrPOt8yBCgpgTXlQcm9qZWN0YCDPgM+Bzr/Ov8+BzrnMgc62zrXPhM6xzrkgzrPOuc6xIM+Hz4HOt8yBz4POtyDOvM61IM+Ezr/OvSBbzrTOuc6xz4fOtc65z4HOuc+Dz4TOt8yBIM+AzrHOus61zIHPhM+Jzr0gz4TOv8+FIM6jzr/Phc65z4bPhF0oaHR0cHM6Ly9zd2lmdC5vcmcvcGFja2FnZS1tYW5hZ2VyLykuCgrOoM+Bzr/Mgc+DzrjOtc+DzrUgz4TOv869IGBNeVByb2plY3RgIM6xz4DOu86xzIEgz4PPhM6/IM66zrHPhM6xzIHOu86/zrPOvyDPhM+Jzr0gzrXOvs6xz4HPhM63zIHPg861z4nOvSDPg8+Ezr8gYFBhY2thZ2Uuc3dpZnRgOgoKYGBgc3dpZnQKbGV0IM+AzrHOus61zIHPhM6/ID0gUGFja2FnZSgKICAgIG5hbWU6ICLOoM6xzrrOtcyBz4TOv86czr/PhSIsCiAgICBkZXBlbmRlbmNpZXM6IFsKICAgICAgICAucGFja2FnZSh1cmw6ICJodHRwczovL2dpdGh1Yi5jb20vVXNlci9Qcm9qZWN0IiwgZnJvbTogVmVyc2lvbigxLCAyLCAzKSksCiAgICBdLAogICAgdGFyZ2V0czogWwogICAgICAgIC50YXJnZXQobmFtZTogIs6jz4TOv8yBz4fOv8+CzpzOv8+FIiwgZGVwZW5kZW5jaWVzOiBbCiAgICAgICAgICAgIC5wcm9kdWN0SXRlbShuYW1lOiAiTXlQcm9qZWN0IiwgcGFja2FnZTogIk15UHJvamVjdCIpLAogICAgICAgIF0pCiAgICBdCikKYGBgCgrOlcyBz4DOtc65z4TOsSBgTXlQcm9qZWN0YCDOvM+Azr/Pgc61zrnMgSDOvc6xIM61zrnPg86xzIHOs861z4TOsc65IM+Dz4TOsSDPgM63zrPOsc65zIHOsSDOsc+Bz4fOtc65zIHOsToKCmBgYHN3aWZ0CmltcG9ydCBNeVByb2plY3QKYGBgCgojIyDOoM6xz4HOscyBzrTOtc65zrPOvM6xz4TOsSDPh8+BzrfMgc+DzrfPggoKYGBgc3dpZnQKLi4uCmBgYAoKLi4uCgojIyDOoM67zrfPgc6/z4bOv8+BzrnMgc61z4IKCi4uLgo=")!, encoding: String.Encoding.utf8)!
        static let partialReadMe = String(data: Data(base64Encoded: "PCEtLQogUGFydGlhbCBSZWFk4oCQTWUubWQKCiBUaGlzIHNvdXJjZSBmaWxlIGlzIHBhcnQgb2YgdGhlIFdvcmtzcGFjZSBvcGVuIHNvdXJjZSBwcm9qZWN0LgogaHR0cHM6Ly9naXRodWIuY29tL1NER0dpZXNicmVjaHQvV29ya3NwYWNlI3dvcmtzcGFjZQoKIENvcHlyaWdodCDCqTIwMTcgSmVyZW15IERhdmlkIEdpZXNicmVjaHQgYW5kIHRoZSBXb3Jrc3BhY2UgcHJvamVjdCBjb250cmlidXRvcnMuCgogU29saSBEZW8gZ2xvcmlhLgoKIExpY2Vuc2VkIHVuZGVyIHRoZSBBcGFjaGUgTGljZW5jZSwgVmVyc2lvbiAyLjAuCiBTZWUgaHR0cDovL3d3dy5hcGFjaGUub3JnL2xpY2Vuc2VzL0xJQ0VOU0UtMi4wIGZvciBsaWNlbmNlIGluZm9ybWF0aW9uLgogLS0+Cgpb8J+HqPCfh6ZFTl0oRG9jdW1lbnRhdGlvbi/wn4eo8J+HpkVOJTIwUmVhZCUyME1lLm1kKSA8IS0tU2tpcCBpbiBKYXp6eS0tPgoKbWFjT1Mg4oCiIExpbnV4IOKAoiBpT1Mg4oCiIHdhdGNoT1Mg4oCiIHR2T1MKCiMgTXlQcm9qZWN0Cgo+IEJsYWggYmxhaCBibGFoLi4uCgojIyBJbXBvcnRpbmcKCmBNeVByb2plY3RgIGlzIGludGVuZGVkIGZvciB1c2Ugd2l0aCB0aGUgW1N3aWZ0IFBhY2thZ2UgTWFuYWdlcl0oaHR0cHM6Ly9zd2lmdC5vcmcvcGFja2FnZS1tYW5hZ2VyLykuCgpTaW1wbHkgYWRkIGBNeVByb2plY3RgIGFzIGEgZGVwZW5kZW5jeSBpbiBgUGFja2FnZS5zd2lmdGA6CgpgYGBzd2lmdAogICAgbGV0IHBhY2thZ2UgPSBQYWNrYWdlKAogICAgbmFtZTogIk15UGFja2FnZSIsCiAgICBkZXBlbmRlbmNpZXM6IFsKICAgICAgICAucGFja2FnZSh1cmw6ICJodHRwczovL3NvbWV3aGVyZS5jb20iLCAudXBUb05leHRNaW5vcihmcm9tOiBWZXJzaW9uKDAsIDEsIDApKSksCiAgICBdLAogICAgdGFyZ2V0czogWwogICAgICAgIC50YXJnZXQobmFtZTogIk15VGFyZ2V0IiwgZGVwZW5kZW5jaWVzOiBbCiAgICAgICAgICAgIC5wcm9kdWN0SXRlbShuYW1lOiAiTXlQcm9qZWN0IiwgcGFja2FnZTogIk15UHJvamVjdCIpLAogICAgICAgIF0pCiAgICBdCikKYGBgCgpgTXlQcm9qZWN0YCBjYW4gdGhlbiBiZSBpbXBvcnRlZCBpbiBzb3VyY2UgZmlsZXM6CgpgYGBzd2lmdAppbXBvcnQgTXlQcm9qZWN0CmBgYAo=")!, encoding: String.Encoding.utf8)!
        static let partialWorkspaceConfiguration = String(data: Data(base64Encoded: "KCgKICAgIFBhcnRpYWwuV29ya3NwYWNlIENvbmZpZ3VyYXRpb24udHh0CgogICAgVGhpcyBzb3VyY2UgZmlsZSBpcyBwYXJ0IG9mIHRoZSBXb3Jrc3BhY2Ugb3BlbiBzb3VyY2UgcHJvamVjdC4KICAgIGh0dHBzOi8vZ2l0aHViLmNvbS9TREdHaWVzYnJlY2h0L1dvcmtzcGFjZSN3b3Jrc3BhY2UKCiAgICBDb3B5cmlnaHQgwqkyMDE3IEplcmVteSBEYXZpZCBHaWVzYnJlY2h0IGFuZCB0aGUgV29ya3NwYWNlIHByb2plY3QgY29udHJpYnV0b3JzLgoKICAgIFNvbGkgRGVvIGdsb3JpYS4KCiAgICBMaWNlbnNlZCB1bmRlciB0aGUgQXBhY2hlIExpY2VuY2UsIFZlcnNpb24gMi4wLgogICAgU2VlIGh0dHA6Ly93d3cuYXBhY2hlLm9yZy9saWNlbnNlcy9MSUNFTlNFLTIuMCBmb3IgbGljZW5jZSBpbmZvcm1hdGlvbi4KICAgICkpCgpNYW5hZ2UgUmVhZOKAkE1lOiBUcnVlCkN1cnJlbnQgVmVyc2lvbjogMC4xLjAKUmVwb3NpdG9yeSBVUkw6IGh0dHBzOi8vc29tZXdoZXJlLmNvbQoKW19CZWdpbiBMb2NhbGl6YXRpb25zX10K8J+HqPCfh6ZFTgpbX0VuZF9dCgpRdW90YXRpb246IEJsYWggYmxhaCBibGFoLi4uCg==")!, encoding: String.Encoding.utf8)!
        static let skeletonReadMe = String(data: Data(base64Encoded: "PCEtLQogU2tlbGV0b24gUmVhZOKAkE1lLm1kCgogVGhpcyBzb3VyY2UgZmlsZSBpcyBwYXJ0IG9mIHRoZSBXb3Jrc3BhY2Ugb3BlbiBzb3VyY2UgcHJvamVjdC4KIGh0dHBzOi8vZ2l0aHViLmNvbS9TREdHaWVzYnJlY2h0L1dvcmtzcGFjZSN3b3Jrc3BhY2UKCiBDb3B5cmlnaHQgwqkyMDE3IEplcmVteSBEYXZpZCBHaWVzYnJlY2h0IGFuZCB0aGUgV29ya3NwYWNlIHByb2plY3QgY29udHJpYnV0b3JzLgoKIFNvbGkgRGVvIGdsb3JpYS4KCiBMaWNlbnNlZCB1bmRlciB0aGUgQXBhY2hlIExpY2VuY2UsIFZlcnNpb24gMi4wLgogU2VlIGh0dHA6Ly93d3cuYXBhY2hlLm9yZy9saWNlbnNlcy9MSUNFTlNFLTIuMCBmb3IgbGljZW5jZSBpbmZvcm1hdGlvbi4KIC0tPgoKW/Cfh6jwn4emRU5dKERvY3VtZW50YXRpb24v8J+HqPCfh6ZFTiUyMFJlYWQlMjBNZS5tZCkgPCEtLVNraXAgaW4gSmF6enktLT4KCm1hY09TIOKAoiBMaW51eCDigKIgaU9TIOKAoiB3YXRjaE9TIOKAoiB0dk9TCgojIE15UHJvamVjdAoKIyMgSW1wb3J0aW5nCgpgTXlQcm9qZWN0YCBpcyBpbnRlbmRlZCBmb3IgdXNlIHdpdGggdGhlIFtTd2lmdCBQYWNrYWdlIE1hbmFnZXJdKGh0dHBzOi8vc3dpZnQub3JnL3BhY2thZ2UtbWFuYWdlci8pLgoKU2ltcGx5IGFkZCBgTXlQcm9qZWN0YCBhcyBhIGRlcGVuZGVuY3kgaW4gYFBhY2thZ2Uuc3dpZnRgLgoKYE15UHJvamVjdGAgY2FuIHRoZW4gYmUgaW1wb3J0ZWQgaW4gc291cmNlIGZpbGVzOgoKYGBgc3dpZnQKaW1wb3J0IE15UHJvamVjdApgYGAK")!, encoding: String.Encoding.utf8)!
        static let skeletonWorkspaceConfiguration = String(data: Data(base64Encoded: "KCgKICAgIFNrZWxldG9uLldvcmtzcGFjZSBDb25maWd1cmF0aW9uLnR4dAoKICAgIFRoaXMgc291cmNlIGZpbGUgaXMgcGFydCBvZiB0aGUgV29ya3NwYWNlIG9wZW4gc291cmNlIHByb2plY3QuCiAgICBodHRwczovL2dpdGh1Yi5jb20vU0RHR2llc2JyZWNodC9Xb3Jrc3BhY2Ujd29ya3NwYWNlCgogICAgQ29weXJpZ2h0IMKpMjAxNyBKZXJlbXkgRGF2aWQgR2llc2JyZWNodCBhbmQgdGhlIFdvcmtzcGFjZSBwcm9qZWN0IGNvbnRyaWJ1dG9ycy4KCiAgICBTb2xpIERlbyBnbG9yaWEuCgogICAgTGljZW5zZWQgdW5kZXIgdGhlIEFwYWNoZSBMaWNlbmNlLCBWZXJzaW9uIDIuMC4KICAgIFNlZSBodHRwOi8vd3d3LmFwYWNoZS5vcmcvbGljZW5zZXMvTElDRU5TRS0yLjAgZm9yIGxpY2VuY2UgaW5mb3JtYXRpb24uCiAgICApKQoKTWFuYWdlIFJlYWTigJBNZTogVHJ1ZQoKW19CZWdpbiBMb2NhbGl6YXRpb25zX10K8J+HqPCfh6ZFTgpbX0VuZF9dCg==")!, encoding: String.Encoding.utf8)!
    }

}
