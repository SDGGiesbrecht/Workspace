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
    static let contributingTemplate = String(data: Data(base64Encoded: "IyBDb250cmlidXRpbmcgdG8gI3BhY2thZ2VOYW1lCgpFdmVyeW9uZSBpcyB3ZWxjb21lIHRvIGNvbnRyaWJ1dGUgdG8gI3BhY2thZ2VOYW1lIQoKIyMgU3RlcCAxOiBSZXBvcnQKCkZyb20gdGhlIHNtYWxsZXN0IHR5cG8gdG8gdGhlIHNldmVyZXN0IGNyYXNoLCB3aGV0aGVyIHlvdSBhcmUgcmVwb3J0aW5nIGEgYnVnIG9yIHJlcXVlc3RpbmcgYSBuZXcgZmVhdHVyZSwgd2hldGhlciB5b3UgYWxyZWFkeSBoYXZlIGEgc29sdXRpb24gaW4gbWluZCBvciBub3QsIHBsZWFzZSAqKmFsd2F5cyBzdGFydCBieSByZXBvcnRpbmcgaXQqKi4KClBsZWFzZSBzdGFydCBieSBzZWFyY2hpbmcgdGhlIFtleGlzdGluZyBpc3N1ZXNdKC4uLy4uL2lzc3VlcykgdG8gc2VlIGlmIHNvbWV0aGluZyByZWxhdGVkIGhhcyBhbHJlYWR5IGJlZW4gcmVwb3J0ZWQuCgotIElmIHRoZXJlIGlzIGFscmVhZHkgYSByZWxhdGVkIGlzc3VlLCBwbGVhc2Ugam9pbiB0aGF0IGNvbnZlcnNhdGlvbiBhbmQgc2hhcmUgYW55IGFkZGl0aW9uYWwgaW5mb3JtYXRpb24geW91IGhhdmUuCi0gT3RoZXJ3aXNlLCBvcGVuIGEgW25ldyBpc3N1ZV0oLi4vLi4vaXNzdWVzL25ldykuIFBsZWFzZSBwcm92aWRlIGFzIG11Y2ggb2YgdGhlIGZvbGxvd2luZyBhcyB5b3UgY2FuOgoKICAgIDEuIEEgY29uY2lzZSBhbmQgc3BlY2lmaWMgZGVzY3JpcHRpb24gb2YgdGhlIGJ1ZyBvciBmZWF0dXJlLgogICAgMi4gSWYgaXQgaXMgYSBidWcsIHRyeSB0byBwcm92aWRlIGEgZGVtb25zdHJhdGlvbiBvZiB0aGUgcHJvYmxlbToKICAgICAgICAtIE9wdGltYWxseSwgcHJvdmlkZSBhIG1pbmltYWwgZXhhbXBsZeKAlGEgZmV3IHNob3J0IGxpbmVzIG9mIHNvdXJjZSB0aGF0IHRyaWdnZXIgdGhlIHByb2JsZW0gd2hlbiB0aGV5IGFyZSBjb3BpZWQsIHBhc3RlZCBhbmQgcnVuLgogICAgICAgIC0gQXMgYSBmYWxsYmFjayBvcHRpb24sIGlmIHlvdXIgb3duIGNvZGUgaXMgcHVibGljLCB5b3UgY291bGQgcHJvdmlkZSBhIGxpbmsgdG8geW91ciBzb3VyY2UgY29kZSBhdCB0aGUgcG9pbnQgd2hlcmUgdGhlIHByb2JsZW0gb2NjdXJzLgogICAgICAgIC0gSWYgbmVpdGhlciBvZiB0aGUgYWJvdmUgb3B0aW9ucyBpcyBwb3NzaWJsZSwgcGxlYXNlIGF0IGxlYXN0IHRyeSB0byBkZXNjcmliZSBpbiB3b3JkcyBob3cgdG8gcmVwcm9kdWNlIHRoZSBwcm9ibGVtLgogICAgMy4gU2F5IHdoZXRoZXIgb3Igbm90IHlvdSB3b3VsZCBsaWtlIHRoZSBob25vdXIgb2YgaGVscGluZyBpbXBsZW1lbnQgdGhlIGZpeCBvciBmZWF0dXJlIHlvdXJzZWxmLgogICAgNC4gU2hhcmUgYW55IGlkZWFzIHlvdSBtYXkgaGF2ZSBvZiBwb3NzaWJsZSBzb2x1dGlvbnMgb3IgZGVzaWducy4KCkV2ZW4gaWYgeW91IHRoaW5rIHlvdSBoYXZlIHRoZSBzb2x1dGlvbiwgcGxlYXNlICoqZG8gbm90IHN0YXJ0IHdvcmtpbmcgb24gaXQqKiB1bnRpbCB5b3UgaGVhciBmcm9tIG9uZSBvZiB0aGUgcHJvamVjdCBhZG1pbmlzdHJhdG9ycy4gVGhpcyBtYXkgc2F2ZSB5b3Ugc29tZSB3b3JrIGluIHRoZSBldmVudCB0aGF0IHNvbWVvbmUgZWxzZSBpcyBhbHJlYWR5IHdvcmtpbmcgb24gaXQsIG9yIGlmIHlvdXIgaWRlYSBlbmRzIHVwIGRlZW1lZCBiZXlvbmQgdGhlIHNjb3BlIG9mIHRoZSBwcm9qZWN0IGdvYWxzLgoKIyMgU3RlcCAyOiBCcmFuY2gKCklmIHlvdSBoYXZlIFtyZXBvcnRlZF0oI3N0ZXAtMS1yZXBvcnQpIHlvdXIgaWRlYSBhbmQgYW4gYWRtaW5pc3RyYXRvciBoYXMgZ2l2ZW4geW91IHRoZSBncmVlbiBsaWdodCwgZm9sbG93IHRoZXNlIHN0ZXBzIHRvIGdldCBhIGxvY2FsIGNvcHkgeW91IGNhbiB3b3JrIG9uLgoKMS4gKipGb3JrIHRoZSByZXBvc2l0b3J5KiogYnkgY2xpY2tpbmcg4oCcRm9ya+KAnSBpbiB0aGUgdG9w4oCQcmlnaHQgb2YgdGhlIHJlcG9zaXRvcnkgcGFnZS4gKFNraXAgdGhpcyBzdGVwIGlmIHlvdSBoYXZlIGJlZW4gZ2l2ZW4gd3JpdGUgYWNjZXNzLikKMi4gKipDcmVhdGUgYSBsb2NhbCBjbG9uZSoqLiNjbG9uZVNjcmlwdAozLiAqKkNyZWF0ZSBhIGRldmVsb3BtZW50IGJyYW5jaCoqLiBgZ2l0IGNoZWNrb3V0IC1iIHNvbWXigJBuZXfigJBicmFuY2jigJBuYW1lYAo0LiAqKlNldCB1cCB0aGUgd29ya3NwYWNlKiogYnkgZG91Ymxl4oCQY2xpY2tpbmcgYFJlZnJlc2hgIGluIHRoZSByb290IGZvbGRlci4KCk5vdyB5b3UgYXJlIGFsbCBzZXQgdG8gdHJ5IG91dCB5b3VyIGlkZWEuCgojIyBTdGVwIDM6IFN1Ym1pdAoKT25jZSB5b3UgaGF2ZSB5b3VyIGlkZWEgd29ya2luZyBwcm9wZXJseSwgZm9sbG93IHRoZXNlIHN0ZXBzIHRvIHN1Ym1pdCB5b3VyIGNoYW5nZXMuCgoxLiAqKlZhbGlkYXRlIHlvdXIgY2hhbmdlcyoqIGJ5IGRvdWJsZeKAkGNsaWNraW5nIGBWYWxpZGF0ZWAgaW4gdGhlIHJvb3QgZm9sZGVyLgoyLiAqKkNvbW1pdCB5b3VyIGNoYW5nZXMqKi4gYGdpdCBjb21taXQgLW0gIlNvbWUgZGVzY3JpcHRpb24gb2YgdGhlIGNoYW5nZXMuImAKMy4gKipQdXNoIHlvdXIgY2hhbmdlcyoqLiBgZ2l0IHB1c2hgCjQuICoqU3VibWl0IGEgcHVsbCByZXF1ZXN0KiogYnkgY2xpY2tpbmcg4oCcTmV3IFB1bGwgUmVxdWVzdOKAnSBpbiB0aGUgYnJhbmNoIGxpc3Qgb24gR2l0SHViLiBJbiB5b3VyIGRlc2NyaXB0aW9uLCBwbGVhc2U6CiAgICAtIExpbmsgdG8gdGhlIG9yaWdpbmFsIGlzc3VlIHdpdGggYCMwMDBgLgogICAgLSBTdGF0ZSB5b3VyIGFncmVlbWVudCB0byBsaWNlbnNpbmcgeW91ciBjb250cmlidXRpb25zIHVuZGVyIHRoZSBbcHJvamVjdCAjbGljZW5jZV0oTElDRU5TRS5tZCkuCjUuICoqV2FpdCBmb3IgY29udGludW91cyBpbnRlZ3JhdGlvbioqIHRvIGNvbXBsZXRlIGl0cyB2YWxpZGF0aW9uLgo2LiAqKlJlcXVlc3QgYSByZXZpZXcqKiBmcm9tICNhZG1pbmlzdHJhdG9ycyBieSBjbGlja2luZyB0aGUgZ2VhciBpbiB0aGUgdG9wIHJpZ2h0IG9mIHRoZSBwdWxsIHJlcXVlc3QgcGFnZS4K")!, encoding: String.Encoding.utf8)!
    static let pullRequestTemplate = String(data: Data(base64Encoded: "PCEtLSBSZW1pbmRlcjoKIEhhdmUgeW91IG9wZW5lZCBhbiBpc3N1ZSBhbmQgZ290dGVuIGEgcmVzcG9uc2UgZnJvbSBhbiBhZG1pbmlzdHJhdG9yPwogQWx3YXlzIGRvIHRoYXQgZmlyc3Q7IHNvbWV0aW1lcyBpdCB3aWxsIHNhdmUgeW91IHNvbWUgd29yay4KIC0tPgoKPCEtLSBGaWxsIGluIHRoZSBpc3N1ZSBudW1iZXIuIC0tPgpUaGlzIHdvcmsgd2FzIGNvbW1pc3Npb25lZCBieSBhbiBhZG1pbmlzdHJhdG9yIGluIGlzc3VlICMwMDAuCgo8IS0tIEtlZXAgb25seSBvbmUgb2YgdGhlIGZvbGxvd2luZyBsaW5lcy4gLS0+CkkgKiphbSBsaWNlbnNpbmcqKiB0aGlzIHVuZGVyIHRoZSBbcHJvamVjdCBsaWNlbmNlXSguLi9ibG9iL21hc3Rlci9MSUNFTlNFLm1kKS4KSSAqKnJlZnVzZSB0byBsaWNlbnNlKiogdGhpcyB1bmRlciB0aGUgW3Byb2plY3QgbGljZW5jZV0oLi4vYmxvYi9tYXN0ZXIvTElDRU5TRS5tZCkuCg==")!, encoding: String.Encoding.utf8)!

}
