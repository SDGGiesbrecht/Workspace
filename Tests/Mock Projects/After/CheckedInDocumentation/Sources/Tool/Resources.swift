

import Foundation

internal enum Resources {}
internal typealias Ressourcen = Resources

extension Resources {
    static let english = String(data: Data(base64Encoded: "ewogICJhcmd1bWVudHMiIDogWwogICAgewogICAgICAiZGVzY3JpcHRpb24iIDogIkFuIGFyYml0cmFyeSBzdHJpbmcuIiwKICAgICAgImlkZW50aWZpZXIiIDogInN0cmluZyIsCiAgICAgICJuYW1lIiA6ICJzdHJpbmciCiAgICB9CiAgXSwKICAiZGVzY3JpcHRpb24iIDogImRvZXMgc29tZXRoaW5nLiIsCiAgImRpc2N1c3Npb24iIDogIlBhcmFncmFwaCBvbmUuXG5MaW5lIHR3by5cblxuUGFyYWdyYXBoIHR3by4iLAogICJpZGVudGlmaWVyIiA6ICJkb+KAkHNvbWV0aGluZyIsCiAgIm5hbWUiIDogImRv4oCQc29tZXRoaW5nIiwKICAib3B0aW9ucyIgOiBbCiAgICB7CiAgICAgICJkZXNjcmlwdGlvbiIgOiAiQW4gYWx0ZXJuYXRpdmUuIiwKICAgICAgImlkZW50aWZpZXIiIDogImFsdGVybmF0aXZlIiwKICAgICAgIm5hbWUiIDogImFsdGVybmF0aXZlIiwKICAgICAgInR5cGUiIDogewogICAgICAgICJkZXNjcmlwdGlvbiIgOiAiQW4gYXJiaXRyYXJ5IHN0cmluZy4iLAogICAgICAgICJpZGVudGlmaWVyIiA6ICJzdHJpbmciLAogICAgICAgICJuYW1lIiA6ICJzdHJpbmciCiAgICAgIH0KICAgIH0sCiAgICB7CiAgICAgICJkZXNjcmlwdGlvbiIgOiAiUmVtb3ZlcyBjb2xvdXIgZnJvbSB0aGUgb3V0cHV0LiIsCiAgICAgICJpZGVudGlmaWVyIiA6ICJub+KAkGNvbG91ciIsCiAgICAgICJuYW1lIiA6ICJub+KAkGNvbG91ciIsCiAgICAgICJ0eXBlIiA6IHsKICAgICAgICAiZGVzY3JpcHRpb24iIDogIiIsCiAgICAgICAgImlkZW50aWZpZXIiIDogIkJvb2xlYW4iLAogICAgICAgICJuYW1lIiA6ICJCb29sZWFuIgogICAgICB9CiAgICB9LAogICAgewogICAgICAiZGVzY3JpcHRpb24iIDogIkEgbGFuZ3VhZ2UgdG8gdXNlIGluc3RlYWQgb2YgdGhlIG9uZSBzcGVjaWZpZWQgaW4gcHJlZmVyZW5jZXMuIiwKICAgICAgImlkZW50aWZpZXIiIDogImxhbmd1YWdlIiwKICAgICAgIm5hbWUiIDogImxhbmd1YWdlIiwKICAgICAgInR5cGUiIDogewogICAgICAgICJkZXNjcmlwdGlvbiIgOiAiQSBsaXN0IG9mIElFVEYgbGFuZ3VhZ2UgdGFncyBvciBsYW5ndWFnZSBpY29ucy4gU2VtaWNvbG9ucyBpbmRpY2F0ZSBmYWxsYmFjayBvcmRlci4gQ29tbWFzIGluZGljYXRlIHRoYXQgbXVsdGlwbGUgbGFuZ3VhZ2VzIHNob3VsZCBiZSB1c2VkLiBFeGFtcGxlczog4oCYZW4tR0LigJkgb3Ig4oCY8J+HrPCfh6dFTuKAmSDihpIgQnJpdGlzaCBFbmdsaXNoLCDigJhjeSxlbjtmcuKAmSDihpIgYm90aCBXZWxzaCBhbmQgRW5nbGlzaCwgb3RoZXJ3aXNlIEZyZW5jaCIsCiAgICAgICAgImlkZW50aWZpZXIiIDogImxhbmd1YWdlIHByZWZlcmVuY2UiLAogICAgICAgICJuYW1lIiA6ICJsYW5ndWFnZSBwcmVmZXJlbmNlIgogICAgICB9CiAgICB9CiAgXSwKICAic3ViY29tbWFuZHMiIDogWwogICAgewogICAgICAiYXJndW1lbnRzIiA6IFsKCiAgICAgIF0sCiAgICAgICJkZXNjcmlwdGlvbiIgOiAiZGlzcGxheXMgdXNhZ2UgaW5mb3JtYXRpb24uIiwKICAgICAgImRpc2N1c3Npb24iIDogbnVsbCwKICAgICAgImlkZW50aWZpZXIiIDogItei15bXqNeUIiwKICAgICAgIm5hbWUiIDogImhlbHAiLAogICAgICAib3B0aW9ucyIgOiBbCiAgICAgICAgewogICAgICAgICAgImRlc2NyaXB0aW9uIiA6ICJSZW1vdmVzIGNvbG91ciBmcm9tIHRoZSBvdXRwdXQuIiwKICAgICAgICAgICJpZGVudGlmaWVyIiA6ICJub+KAkGNvbG91ciIsCiAgICAgICAgICAibmFtZSIgOiAibm/igJBjb2xvdXIiLAogICAgICAgICAgInR5cGUiIDogewogICAgICAgICAgICAiZGVzY3JpcHRpb24iIDogIiIsCiAgICAgICAgICAgICJpZGVudGlmaWVyIiA6ICJCb29sZWFuIiwKICAgICAgICAgICAgIm5hbWUiIDogIkJvb2xlYW4iCiAgICAgICAgICB9CiAgICAgICAgfSwKICAgICAgICB7CiAgICAgICAgICAiZGVzY3JpcHRpb24iIDogIkEgbGFuZ3VhZ2UgdG8gdXNlIGluc3RlYWQgb2YgdGhlIG9uZSBzcGVjaWZpZWQgaW4gcHJlZmVyZW5jZXMuIiwKICAgICAgICAgICJpZGVudGlmaWVyIiA6ICJsYW5ndWFnZSIsCiAgICAgICAgICAibmFtZSIgOiAibGFuZ3VhZ2UiLAogICAgICAgICAgInR5cGUiIDogewogICAgICAgICAgICAiZGVzY3JpcHRpb24iIDogIkEgbGlzdCBvZiBJRVRGIGxhbmd1YWdlIHRhZ3Mgb3IgbGFuZ3VhZ2UgaWNvbnMuIFNlbWljb2xvbnMgaW5kaWNhdGUgZmFsbGJhY2sgb3JkZXIuIENvbW1hcyBpbmRpY2F0ZSB0aGF0IG11bHRpcGxlIGxhbmd1YWdlcyBzaG91bGQgYmUgdXNlZC4gRXhhbXBsZXM6IOKAmGVuLUdC4oCZIG9yIOKAmPCfh6zwn4enRU7igJkg4oaSIEJyaXRpc2ggRW5nbGlzaCwg4oCYY3ksZW47ZnLigJkg4oaSIGJvdGggV2Vsc2ggYW5kIEVuZ2xpc2gsIG90aGVyd2lzZSBGcmVuY2giLAogICAgICAgICAgICAiaWRlbnRpZmllciIgOiAibGFuZ3VhZ2UgcHJlZmVyZW5jZSIsCiAgICAgICAgICAgICJuYW1lIiA6ICJsYW5ndWFnZSBwcmVmZXJlbmNlIgogICAgICAgICAgfQogICAgICAgIH0KICAgICAgXSwKICAgICAgInN1YmNvbW1hbmRzIiA6IFsKCiAgICAgIF0KICAgIH0sCiAgICB7CiAgICAgICJhcmd1bWVudHMiIDogWwoKICAgICAgXSwKICAgICAgImRlc2NyaXB0aW9uIiA6ICJkaXNwbGF5cyB0aGUgdmVyc2lvbiBpbiB1c2UuIiwKICAgICAgImRpc2N1c3Npb24iIDogbnVsbCwKICAgICAgImlkZW50aWZpZXIiIDogInZlcnNpb24iLAogICAgICAibmFtZSIgOiAidmVyc2lvbiIsCiAgICAgICJvcHRpb25zIiA6IFsKICAgICAgICB7CiAgICAgICAgICAiZGVzY3JpcHRpb24iIDogIlJlbW92ZXMgY29sb3VyIGZyb20gdGhlIG91dHB1dC4iLAogICAgICAgICAgImlkZW50aWZpZXIiIDogIm5v4oCQY29sb3VyIiwKICAgICAgICAgICJuYW1lIiA6ICJub+KAkGNvbG91ciIsCiAgICAgICAgICAidHlwZSIgOiB7CiAgICAgICAgICAgICJkZXNjcmlwdGlvbiIgOiAiIiwKICAgICAgICAgICAgImlkZW50aWZpZXIiIDogIkJvb2xlYW4iLAogICAgICAgICAgICAibmFtZSIgOiAiQm9vbGVhbiIKICAgICAgICAgIH0KICAgICAgICB9LAogICAgICAgIHsKICAgICAgICAgICJkZXNjcmlwdGlvbiIgOiAiQSBsYW5ndWFnZSB0byB1c2UgaW5zdGVhZCBvZiB0aGUgb25lIHNwZWNpZmllZCBpbiBwcmVmZXJlbmNlcy4iLAogICAgICAgICAgImlkZW50aWZpZXIiIDogImxhbmd1YWdlIiwKICAgICAgICAgICJuYW1lIiA6ICJsYW5ndWFnZSIsCiAgICAgICAgICAidHlwZSIgOiB7CiAgICAgICAgICAgICJkZXNjcmlwdGlvbiIgOiAiQSBsaXN0IG9mIElFVEYgbGFuZ3VhZ2UgdGFncyBvciBsYW5ndWFnZSBpY29ucy4gU2VtaWNvbG9ucyBpbmRpY2F0ZSBmYWxsYmFjayBvcmRlci4gQ29tbWFzIGluZGljYXRlIHRoYXQgbXVsdGlwbGUgbGFuZ3VhZ2VzIHNob3VsZCBiZSB1c2VkLiBFeGFtcGxlczog4oCYZW4tR0LigJkgb3Ig4oCY8J+HrPCfh6dFTuKAmSDihpIgQnJpdGlzaCBFbmdsaXNoLCDigJhjeSxlbjtmcuKAmSDihpIgYm90aCBXZWxzaCBhbmQgRW5nbGlzaCwgb3RoZXJ3aXNlIEZyZW5jaCIsCiAgICAgICAgICAgICJpZGVudGlmaWVyIiA6ICJsYW5ndWFnZSBwcmVmZXJlbmNlIiwKICAgICAgICAgICAgIm5hbWUiIDogImxhbmd1YWdlIHByZWZlcmVuY2UiCiAgICAgICAgICB9CiAgICAgICAgfQogICAgICBdLAogICAgICAic3ViY29tbWFuZHMiIDogWwogICAgICAgIHsKICAgICAgICAgICJhcmd1bWVudHMiIDogWwoKICAgICAgICAgIF0sCiAgICAgICAgICAiZGVzY3JpcHRpb24iIDogImRpc3BsYXlzIHVzYWdlIGluZm9ybWF0aW9uLiIsCiAgICAgICAgICAiZGlzY3Vzc2lvbiIgOiBudWxsLAogICAgICAgICAgImlkZW50aWZpZXIiIDogItei15bXqNeUIiwKICAgICAgICAgICJuYW1lIiA6ICJoZWxwIiwKICAgICAgICAgICJvcHRpb25zIiA6IFsKICAgICAgICAgICAgewogICAgICAgICAgICAgICJkZXNjcmlwdGlvbiIgOiAiUmVtb3ZlcyBjb2xvdXIgZnJvbSB0aGUgb3V0cHV0LiIsCiAgICAgICAgICAgICAgImlkZW50aWZpZXIiIDogIm5v4oCQY29sb3VyIiwKICAgICAgICAgICAgICAibmFtZSIgOiAibm/igJBjb2xvdXIiLAogICAgICAgICAgICAgICJ0eXBlIiA6IHsKICAgICAgICAgICAgICAgICJkZXNjcmlwdGlvbiIgOiAiIiwKICAgICAgICAgICAgICAgICJpZGVudGlmaWVyIiA6ICJCb29sZWFuIiwKICAgICAgICAgICAgICAgICJuYW1lIiA6ICJCb29sZWFuIgogICAgICAgICAgICAgIH0KICAgICAgICAgICAgfSwKICAgICAgICAgICAgewogICAgICAgICAgICAgICJkZXNjcmlwdGlvbiIgOiAiQSBsYW5ndWFnZSB0byB1c2UgaW5zdGVhZCBvZiB0aGUgb25lIHNwZWNpZmllZCBpbiBwcmVmZXJlbmNlcy4iLAogICAgICAgICAgICAgICJpZGVudGlmaWVyIiA6ICJsYW5ndWFnZSIsCiAgICAgICAgICAgICAgIm5hbWUiIDogImxhbmd1YWdlIiwKICAgICAgICAgICAgICAidHlwZSIgOiB7CiAgICAgICAgICAgICAgICAiZGVzY3JpcHRpb24iIDogIkEgbGlzdCBvZiBJRVRGIGxhbmd1YWdlIHRhZ3Mgb3IgbGFuZ3VhZ2UgaWNvbnMuIFNlbWljb2xvbnMgaW5kaWNhdGUgZmFsbGJhY2sgb3JkZXIuIENvbW1hcyBpbmRpY2F0ZSB0aGF0IG11bHRpcGxlIGxhbmd1YWdlcyBzaG91bGQgYmUgdXNlZC4gRXhhbXBsZXM6IOKAmGVuLUdC4oCZIG9yIOKAmPCfh6zwn4enRU7igJkg4oaSIEJyaXRpc2ggRW5nbGlzaCwg4oCYY3ksZW47ZnLigJkg4oaSIGJvdGggV2Vsc2ggYW5kIEVuZ2xpc2gsIG90aGVyd2lzZSBGcmVuY2giLAogICAgICAgICAgICAgICAgImlkZW50aWZpZXIiIDogImxhbmd1YWdlIHByZWZlcmVuY2UiLAogICAgICAgICAgICAgICAgIm5hbWUiIDogImxhbmd1YWdlIHByZWZlcmVuY2UiCiAgICAgICAgICAgICAgfQogICAgICAgICAgICB9CiAgICAgICAgICBdLAogICAgICAgICAgInN1YmNvbW1hbmRzIiA6IFsKCiAgICAgICAgICBdCiAgICAgICAgfQogICAgICBdCiAgICB9LAogICAgewogICAgICAiYXJndW1lbnRzIiA6IFsKICAgICAgICB7CiAgICAgICAgICAiZGVzY3JpcHRpb24iIDogIkEgbGlzdCBvZiBJRVRGIGxhbmd1YWdlIHRhZ3Mgb3IgbGFuZ3VhZ2UgaWNvbnMuIFNlbWljb2xvbnMgaW5kaWNhdGUgZmFsbGJhY2sgb3JkZXIuIENvbW1hcyBpbmRpY2F0ZSB0aGF0IG11bHRpcGxlIGxhbmd1YWdlcyBzaG91bGQgYmUgdXNlZC4gRXhhbXBsZXM6IOKAmGVuLUdC4oCZIG9yIOKAmPCfh6zwn4enRU7igJkg4oaSIEJyaXRpc2ggRW5nbGlzaCwg4oCYY3ksZW47ZnLigJkg4oaSIGJvdGggV2Vsc2ggYW5kIEVuZ2xpc2gsIG90aGVyd2lzZSBGcmVuY2giLAogICAgICAgICAgImlkZW50aWZpZXIiIDogImxhbmd1YWdlIHByZWZlcmVuY2UiLAogICAgICAgICAgIm5hbWUiIDogImxhbmd1YWdlIHByZWZlcmVuY2UiCiAgICAgICAgfQogICAgICBdLAogICAgICAiZGVzY3JpcHRpb24iIDogInNldHMgdGhlIGxhbmd1YWdlIHByZWZlcmVuY2UuIChPbWl0IHRoZSBhcmd1bWVudCB0byByZXZlcnQgdG8gdGhlIHN5c3RlbSBwcmVmZXJlbmNlcy4pIiwKICAgICAgImRpc2N1c3Npb24iIDogbnVsbCwKICAgICAgImlkZW50aWZpZXIiIDogInNldOKAkGxhbmd1YWdlIiwKICAgICAgIm5hbWUiIDogInNldOKAkGxhbmd1YWdlIiwKICAgICAgIm9wdGlvbnMiIDogWwogICAgICAgIHsKICAgICAgICAgICJkZXNjcmlwdGlvbiIgOiAiUmVtb3ZlcyBjb2xvdXIgZnJvbSB0aGUgb3V0cHV0LiIsCiAgICAgICAgICAiaWRlbnRpZmllciIgOiAibm/igJBjb2xvdXIiLAogICAgICAgICAgIm5hbWUiIDogIm5v4oCQY29sb3VyIiwKICAgICAgICAgICJ0eXBlIiA6IHsKICAgICAgICAgICAgImRlc2NyaXB0aW9uIiA6ICIiLAogICAgICAgICAgICAiaWRlbnRpZmllciIgOiAiQm9vbGVhbiIsCiAgICAgICAgICAgICJuYW1lIiA6ICJCb29sZWFuIgogICAgICAgICAgfQogICAgICAgIH0sCiAgICAgICAgewogICAgICAgICAgImRlc2NyaXB0aW9uIiA6ICJBIGxhbmd1YWdlIHRvIHVzZSBpbnN0ZWFkIG9mIHRoZSBvbmUgc3BlY2lmaWVkIGluIHByZWZlcmVuY2VzLiIsCiAgICAgICAgICAiaWRlbnRpZmllciIgOiAibGFuZ3VhZ2UiLAogICAgICAgICAgIm5hbWUiIDogImxhbmd1YWdlIiwKICAgICAgICAgICJ0eXBlIiA6IHsKICAgICAgICAgICAgImRlc2NyaXB0aW9uIiA6ICJBIGxpc3Qgb2YgSUVURiBsYW5ndWFnZSB0YWdzIG9yIGxhbmd1YWdlIGljb25zLiBTZW1pY29sb25zIGluZGljYXRlIGZhbGxiYWNrIG9yZGVyLiBDb21tYXMgaW5kaWNhdGUgdGhhdCBtdWx0aXBsZSBsYW5ndWFnZXMgc2hvdWxkIGJlIHVzZWQuIEV4YW1wbGVzOiDigJhlbi1HQuKAmSBvciDigJjwn4es8J+Hp0VO4oCZIOKGkiBCcml0aXNoIEVuZ2xpc2gsIOKAmGN5LGVuO2Zy4oCZIOKGkiBib3RoIFdlbHNoIGFuZCBFbmdsaXNoLCBvdGhlcndpc2UgRnJlbmNoIiwKICAgICAgICAgICAgImlkZW50aWZpZXIiIDogImxhbmd1YWdlIHByZWZlcmVuY2UiLAogICAgICAgICAgICAibmFtZSIgOiAibGFuZ3VhZ2UgcHJlZmVyZW5jZSIKICAgICAgICAgIH0KICAgICAgICB9CiAgICAgIF0sCiAgICAgICJzdWJjb21tYW5kcyIgOiBbCiAgICAgICAgewogICAgICAgICAgImFyZ3VtZW50cyIgOiBbCgogICAgICAgICAgXSwKICAgICAgICAgICJkZXNjcmlwdGlvbiIgOiAiZGlzcGxheXMgdXNhZ2UgaW5mb3JtYXRpb24uIiwKICAgICAgICAgICJkaXNjdXNzaW9uIiA6IG51bGwsCiAgICAgICAgICAiaWRlbnRpZmllciIgOiAi16LXlteo15QiLAogICAgICAgICAgIm5hbWUiIDogImhlbHAiLAogICAgICAgICAgIm9wdGlvbnMiIDogWwogICAgICAgICAgICB7CiAgICAgICAgICAgICAgImRlc2NyaXB0aW9uIiA6ICJSZW1vdmVzIGNvbG91ciBmcm9tIHRoZSBvdXRwdXQuIiwKICAgICAgICAgICAgICAiaWRlbnRpZmllciIgOiAibm/igJBjb2xvdXIiLAogICAgICAgICAgICAgICJuYW1lIiA6ICJub+KAkGNvbG91ciIsCiAgICAgICAgICAgICAgInR5cGUiIDogewogICAgICAgICAgICAgICAgImRlc2NyaXB0aW9uIiA6ICIiLAogICAgICAgICAgICAgICAgImlkZW50aWZpZXIiIDogIkJvb2xlYW4iLAogICAgICAgICAgICAgICAgIm5hbWUiIDogIkJvb2xlYW4iCiAgICAgICAgICAgICAgfQogICAgICAgICAgICB9LAogICAgICAgICAgICB7CiAgICAgICAgICAgICAgImRlc2NyaXB0aW9uIiA6ICJBIGxhbmd1YWdlIHRvIHVzZSBpbnN0ZWFkIG9mIHRoZSBvbmUgc3BlY2lmaWVkIGluIHByZWZlcmVuY2VzLiIsCiAgICAgICAgICAgICAgImlkZW50aWZpZXIiIDogImxhbmd1YWdlIiwKICAgICAgICAgICAgICAibmFtZSIgOiAibGFuZ3VhZ2UiLAogICAgICAgICAgICAgICJ0eXBlIiA6IHsKICAgICAgICAgICAgICAgICJkZXNjcmlwdGlvbiIgOiAiQSBsaXN0IG9mIElFVEYgbGFuZ3VhZ2UgdGFncyBvciBsYW5ndWFnZSBpY29ucy4gU2VtaWNvbG9ucyBpbmRpY2F0ZSBmYWxsYmFjayBvcmRlci4gQ29tbWFzIGluZGljYXRlIHRoYXQgbXVsdGlwbGUgbGFuZ3VhZ2VzIHNob3VsZCBiZSB1c2VkLiBFeGFtcGxlczog4oCYZW4tR0LigJkgb3Ig4oCY8J+HrPCfh6dFTuKAmSDihpIgQnJpdGlzaCBFbmdsaXNoLCDigJhjeSxlbjtmcuKAmSDihpIgYm90aCBXZWxzaCBhbmQgRW5nbGlzaCwgb3RoZXJ3aXNlIEZyZW5jaCIsCiAgICAgICAgICAgICAgICAiaWRlbnRpZmllciIgOiAibGFuZ3VhZ2UgcHJlZmVyZW5jZSIsCiAgICAgICAgICAgICAgICAibmFtZSIgOiAibGFuZ3VhZ2UgcHJlZmVyZW5jZSIKICAgICAgICAgICAgICB9CiAgICAgICAgICAgIH0KICAgICAgICAgIF0sCiAgICAgICAgICAic3ViY29tbWFuZHMiIDogWwoKICAgICAgICAgIF0KICAgICAgICB9CiAgICAgIF0KICAgIH0sCiAgICB7CiAgICAgICJhcmd1bWVudHMiIDogWwoKICAgICAgXSwKICAgICAgImRlc2NyaXB0aW9uIiA6ICJyZW1vdmVzIGFueSBjYWNoZWQgZGF0YS4iLAogICAgICAiZGlzY3Vzc2lvbiIgOiBudWxsLAogICAgICAiaWRlbnRpZmllciIgOiAiZW1wdHnigJBjYWNoZSIsCiAgICAgICJuYW1lIiA6ICJlbXB0eeKAkGNhY2hlIiwKICAgICAgIm9wdGlvbnMiIDogWwogICAgICAgIHsKICAgICAgICAgICJkZXNjcmlwdGlvbiIgOiAiUmVtb3ZlcyBjb2xvdXIgZnJvbSB0aGUgb3V0cHV0LiIsCiAgICAgICAgICAiaWRlbnRpZmllciIgOiAibm/igJBjb2xvdXIiLAogICAgICAgICAgIm5hbWUiIDogIm5v4oCQY29sb3VyIiwKICAgICAgICAgICJ0eXBlIiA6IHsKICAgICAgICAgICAgImRlc2NyaXB0aW9uIiA6ICIiLAogICAgICAgICAgICAiaWRlbnRpZmllciIgOiAiQm9vbGVhbiIsCiAgICAgICAgICAgICJuYW1lIiA6ICJCb29sZWFuIgogICAgICAgICAgfQogICAgICAgIH0sCiAgICAgICAgewogICAgICAgICAgImRlc2NyaXB0aW9uIiA6ICJBIGxhbmd1YWdlIHRvIHVzZSBpbnN0ZWFkIG9mIHRoZSBvbmUgc3BlY2lmaWVkIGluIHByZWZlcmVuY2VzLiIsCiAgICAgICAgICAiaWRlbnRpZmllciIgOiAibGFuZ3VhZ2UiLAogICAgICAgICAgIm5hbWUiIDogImxhbmd1YWdlIiwKICAgICAgICAgICJ0eXBlIiA6IHsKICAgICAgICAgICAgImRlc2NyaXB0aW9uIiA6ICJBIGxpc3Qgb2YgSUVURiBsYW5ndWFnZSB0YWdzIG9yIGxhbmd1YWdlIGljb25zLiBTZW1pY29sb25zIGluZGljYXRlIGZhbGxiYWNrIG9yZGVyLiBDb21tYXMgaW5kaWNhdGUgdGhhdCBtdWx0aXBsZSBsYW5ndWFnZXMgc2hvdWxkIGJlIHVzZWQuIEV4YW1wbGVzOiDigJhlbi1HQuKAmSBvciDigJjwn4es8J+Hp0VO4oCZIOKGkiBCcml0aXNoIEVuZ2xpc2gsIOKAmGN5LGVuO2Zy4oCZIOKGkiBib3RoIFdlbHNoIGFuZCBFbmdsaXNoLCBvdGhlcndpc2UgRnJlbmNoIiwKICAgICAgICAgICAgImlkZW50aWZpZXIiIDogImxhbmd1YWdlIHByZWZlcmVuY2UiLAogICAgICAgICAgICAibmFtZSIgOiAibGFuZ3VhZ2UgcHJlZmVyZW5jZSIKICAgICAgICAgIH0KICAgICAgICB9CiAgICAgIF0sCiAgICAgICJzdWJjb21tYW5kcyIgOiBbCiAgICAgICAgewogICAgICAgICAgImFyZ3VtZW50cyIgOiBbCgogICAgICAgICAgXSwKICAgICAgICAgICJkZXNjcmlwdGlvbiIgOiAiZGlzcGxheXMgdXNhZ2UgaW5mb3JtYXRpb24uIiwKICAgICAgICAgICJkaXNjdXNzaW9uIiA6IG51bGwsCiAgICAgICAgICAiaWRlbnRpZmllciIgOiAi16LXlteo15QiLAogICAgICAgICAgIm5hbWUiIDogImhlbHAiLAogICAgICAgICAgIm9wdGlvbnMiIDogWwogICAgICAgICAgICB7CiAgICAgICAgICAgICAgImRlc2NyaXB0aW9uIiA6ICJSZW1vdmVzIGNvbG91ciBmcm9tIHRoZSBvdXRwdXQuIiwKICAgICAgICAgICAgICAiaWRlbnRpZmllciIgOiAibm/igJBjb2xvdXIiLAogICAgICAgICAgICAgICJuYW1lIiA6ICJub+KAkGNvbG91ciIsCiAgICAgICAgICAgICAgInR5cGUiIDogewogICAgICAgICAgICAgICAgImRlc2NyaXB0aW9uIiA6ICIiLAogICAgICAgICAgICAgICAgImlkZW50aWZpZXIiIDogIkJvb2xlYW4iLAogICAgICAgICAgICAgICAgIm5hbWUiIDogIkJvb2xlYW4iCiAgICAgICAgICAgICAgfQogICAgICAgICAgICB9LAogICAgICAgICAgICB7CiAgICAgICAgICAgICAgImRlc2NyaXB0aW9uIiA6ICJBIGxhbmd1YWdlIHRvIHVzZSBpbnN0ZWFkIG9mIHRoZSBvbmUgc3BlY2lmaWVkIGluIHByZWZlcmVuY2VzLiIsCiAgICAgICAgICAgICAgImlkZW50aWZpZXIiIDogImxhbmd1YWdlIiwKICAgICAgICAgICAgICAibmFtZSIgOiAibGFuZ3VhZ2UiLAogICAgICAgICAgICAgICJ0eXBlIiA6IHsKICAgICAgICAgICAgICAgICJkZXNjcmlwdGlvbiIgOiAiQSBsaXN0IG9mIElFVEYgbGFuZ3VhZ2UgdGFncyBvciBsYW5ndWFnZSBpY29ucy4gU2VtaWNvbG9ucyBpbmRpY2F0ZSBmYWxsYmFjayBvcmRlci4gQ29tbWFzIGluZGljYXRlIHRoYXQgbXVsdGlwbGUgbGFuZ3VhZ2VzIHNob3VsZCBiZSB1c2VkLiBFeGFtcGxlczog4oCYZW4tR0LigJkgb3Ig4oCY8J+HrPCfh6dFTuKAmSDihpIgQnJpdGlzaCBFbmdsaXNoLCDigJhjeSxlbjtmcuKAmSDihpIgYm90aCBXZWxzaCBhbmQgRW5nbGlzaCwgb3RoZXJ3aXNlIEZyZW5jaCIsCiAgICAgICAgICAgICAgICAiaWRlbnRpZmllciIgOiAibGFuZ3VhZ2UgcHJlZmVyZW5jZSIsCiAgICAgICAgICAgICAgICAibmFtZSIgOiAibGFuZ3VhZ2UgcHJlZmVyZW5jZSIKICAgICAgICAgICAgICB9CiAgICAgICAgICAgIH0KICAgICAgICAgIF0sCiAgICAgICAgICAic3ViY29tbWFuZHMiIDogWwoKICAgICAgICAgIF0KICAgICAgICB9CiAgICAgIF0KICAgIH0KICBdCn0=")!, encoding: String.Encoding.utf8)!

}
