/*
 Unicode.swift

 This source file is part of the Workspace open source project.
 Diese Quelldatei ist Teil des quelloffenen Arbeitsbereich‐Projekt.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2018–2021 Jeremy David Giesbrecht and the Workspace project contributors.
 Urheberrecht ©2018–2021 Jeremy David Giesbrecht und die Mitwirkenden des Arbeitsbereich‐Projekts.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

#if !PLATFORM_NOT_SUPPORTED_BY_WORKSPACE_WORKSPACE
  import SDGLogic
  import SDGMathematics
  import SDGCollections

  import SDGCommandLine

  import SDGSwift
  #if !PLATFORM_NOT_SUPPORTED_BY_SWIFT_SYNTAX
    import SwiftSyntax
  #endif
  import SDGSwiftSource

  import WorkspaceLocalizations
  import WorkspaceConfiguration

  internal struct UnicodeRule: SyntaxRule {

    internal static let identifier = UserFacing<StrictString, InterfaceLocalization>(
      { localization in
        switch localization {
        case .englishUnitedKingdom, .englishUnitedStates, .englishCanada,
          .deutschDeutschland:
          return "unicode"
        }
      })

    #if !PLATFORM_NOT_SUPPORTED_BY_SWIFT_SYNTAX
      private enum EitherTokenKind {
        case syntax(TokenKind)
        case extended(ExtendedTokenKind)
      }

      internal static func check(
        _ node: Syntax,
        context: SyntaxContext,
        file: TextFile,
        setting: Setting,
        project: PackageRepository,
        status: ProofreadingStatus,
        output: Command.Output
      ) {
        if let token = node.as(TokenSyntax.self) {

          func isPrefix() -> Bool {
            if case .prefixOperator = token.tokenKind {
              return true
            } else {
              return false
            }
          }

          func isInfix() -> Bool {
            switch token.tokenKind {
            case .spacedBinaryOperator, .unspacedBinaryOperator:
              return true
            default:
              return false
            }
          }

          func isFloatLiteral() -> Bool {
            if case .floatingLiteral = token.tokenKind {
              return true
            } else {
              return false
            }
          }

          func isInAvailabilityDeclaration() -> Bool {
            return node.ancestors().contains(where: { $0.is(AvailabilityArgumentSyntax.self) })
          }

          check(
            token.text,
            range: token.syntaxRange(in: context),
            textFreedom: token.textFreedom,
            kind: .syntax(token.tokenKind),
            isPrefix: isPrefix(),
            isInfix: isInfix(),
            isFloatLiteral: isFloatLiteral(),
            isInAvailabilityDeclaration: isInAvailabilityDeclaration(),
            file: file,
            project: project,
            status: status,
            output: output
          )
        }
      }

      internal static func check(
        _ node: ExtendedSyntax,
        context: ExtendedSyntaxContext,
        file: TextFile,
        setting: Setting,
        project: PackageRepository,
        status: ProofreadingStatus,
        output: Command.Output
      ) {
        if let token = node as? ExtendedTokenSyntax {
          check(
            token.text,
            range: token.range(in: context),
            textFreedom: token.kind.textFreedom,
            kind: .extended(token.kind),
            isPrefix: false,
            isInfix: false,
            isFloatLiteral: false,
            isInAvailabilityDeclaration: false,  // @exempt(from: tests)
            // Exempt because all such cases are handled by “isInfix”.
            file: file,
            project: project,
            status: status,
            output: output
          )
        }
      }

      private static func check(
        _ node: String,
        range: @escaping @autoclosure () -> Range<String.ScalarOffset>,
        textFreedom: TextFreedom,
        kind: @escaping @autoclosure () -> EitherTokenKind,
        isPrefix: @escaping @autoclosure () -> Bool,
        isInfix: @escaping @autoclosure () -> Bool,
        isFloatLiteral: @escaping @autoclosure () -> Bool,
        isInAvailabilityDeclaration: @escaping @autoclosure () -> Bool,
        file: TextFile,
        project: PackageRepository,
        status: ProofreadingStatus,
        output: Command.Output
      ) {
        check(
          node,
          range: file.contents.indices(of: range()),
          textFreedom: textFreedom,
          kind: kind(),
          isPrefix: isPrefix(),
          isInfix: isInfix(),
          isFloatLiteral: isFloatLiteral(),
          isInAvailabilityDeclaration: isInAvailabilityDeclaration(),
          file: file,
          project: project,
          status: status,
          output: output
        )
      }
      private static func check(
        _ node: String,
        range: @escaping @autoclosure () -> Range<String.ScalarView.Index>,
        textFreedom: TextFreedom,
        kind: @escaping @autoclosure () -> EitherTokenKind,
        isPrefix: @escaping @autoclosure () -> Bool,
        isInfix: @escaping @autoclosure () -> Bool,
        isFloatLiteral: @escaping @autoclosure () -> Bool,
        isInAvailabilityDeclaration: @escaping @autoclosure () -> Bool,
        file: TextFile,
        project: PackageRepository,
        status: ProofreadingStatus,
        output: Command.Output
      ) {

        if textFreedom == .invariable {
          return
        }
        let scope: UnicodeRuleScope
        switch kind() {
        case .syntax(let kind):
          switch kind {
          case .eof, .associatedtypeKeyword, .classKeyword, .deinitKeyword, .enumKeyword,
            .extensionKeyword, .funcKeyword, .importKeyword, .initKeyword, .inoutKeyword,
            .letKeyword,
            .operatorKeyword, .precedencegroupKeyword, .protocolKeyword, .structKeyword,
            .subscriptKeyword, .typealiasKeyword, .varKeyword, .fileprivateKeyword,
            .internalKeyword,
            .privateKeyword, .publicKeyword, .staticKeyword, .deferKeyword, .ifKeyword,
            .guardKeyword,
            .doKeyword, .repeatKeyword, .elseKeyword, .forKeyword, .inKeyword, .whileKeyword,
            .returnKeyword, .breakKeyword, .continueKeyword, .fallthroughKeyword, .switchKeyword,
            .caseKeyword, .defaultKeyword, .whereKeyword, .catchKeyword, .throwKeyword, .asKeyword,
            .anyKeyword, .falseKeyword, .isKeyword, .nilKeyword, .rethrowsKeyword, .superKeyword,
            .selfKeyword, .capitalSelfKeyword, .trueKeyword, .tryKeyword, .throwsKeyword,
            .__file__Keyword, .__line__Keyword, .__column__Keyword, .__function__Keyword,
            .__dso_handle__Keyword, .wildcardKeyword, .leftParen, .rightParen, .leftBrace,
            .rightBrace, .leftSquareBracket, .rightSquareBracket, .leftAngle, .rightAngle, .period,
            .prefixPeriod, .comma, .colon, .semicolon, .equal, .atSign, .pound, .prefixAmpersand,
            .arrow, .backtick, .backslash, .exclamationMark, .postfixQuestionMark,
            .infixQuestionMark,
            .stringQuote, .multilineStringQuote, .poundKeyPathKeyword, .poundLineKeyword,
            .poundSelectorKeyword, .poundFileKeyword, .poundFilePathKeyword, .poundColumnKeyword,
            .poundFunctionKeyword, .poundDsohandleKeyword, .poundAssertKeyword,
            .poundSourceLocationKeyword, .poundWarningKeyword, .poundErrorKeyword, .poundIfKeyword,
            .poundElseKeyword, .poundElseifKeyword, .poundAvailableKeyword,
            .poundFileLiteralKeyword,
            .poundImageLiteralKeyword, .poundColorLiteralKeyword, .unknown, .identifier,
            .unspacedBinaryOperator, .spacedBinaryOperator, .postfixOperator, .prefixOperator,
            .dollarIdentifier, .contextualKeyword, .stringInterpolationAnchor, .yield,
            .poundEndifKeyword, .ellipsis, .singleQuote, .rawStringDelimiter, .poundFileIDKeyword:
            scope = .machineIdentifiers
          case .integerLiteral, .floatingLiteral:
            scope = .humanLanguage  // @exempt(from: tests) Probably unreachable.
          case .stringLiteral, .stringSegment:
            scope = .ambiguous  // @exempt(from: tests) Probably unreachable.
          }
        case .extended(let kind):
          switch kind {
          case .quotationMark,  // @exempt(from: tests) Probably unreachable.
            .lineCommentDelimiter,
            .openingBlockCommentDelimiter,
            .closingBlockCommentDelimiter,
            .commentURL,
            .mark,
            .lineDocumentationDelimiter,
            .openingBlockDocumentationDelimiter,
            .closingBlockDocumentationDelimiter,
            .bullet,
            .codeDelimiter,
            .language,
            .source,
            .headingDelimiter,
            .asterism,
            .fontModificationDelimiter,
            .linkDelimiter,
            .linkURL,
            .imageDelimiter,
            .quotationDelimiter,
            .callout,
            .parameter,
            .colon,
            .lineSeparator:
            scope = .machineIdentifiers
          case .string, .whitespace, .newlines:
            scope = .ambiguous
          case .commentText, .sourceHeadingText, .documentationText:
            scope = .humanLanguage
          }
        }
        let configuredScope = try? project.configuration(output: output).proofreading
          .unicodeRuleScope
        let applicableScope =
          configuredScope
          ?? Set(UnicodeRuleScope.allCases)  // @exempt(from: tests)
        // Exemption because reaching here required that the configuration has already been successfully loaded and cached.

        if scope ∉ applicableScope {
          return  // Skip.
        }

        func check(
          for obsolete: String,
          replacement: StrictString? = nil,
          onlyProhibitPrefixUse: Bool = false,
          onlyProhibitInfixUse: Bool = false,
          allowInFloatLiteral: Bool = false,
          allowAsConditionalCompilationOperator: Bool = false,
          allowInAvailabilityDeclaration: Bool = false,
          allowInToolsVersion: Bool = false,
          message: UserFacing<StrictString, InterfaceLocalization>,
          status: ProofreadingStatus,
          output: Command.Output
        ) {

          if onlyProhibitPrefixUse ∧ ¬isPrefix() {
            return
          }

          if onlyProhibitInfixUse ∧ ¬isInfix() {
            return
          }

          if allowInFloatLiteral ∧ isFloatLiteral() {
            return
          }

          if allowInAvailabilityDeclaration,
            isInAvailabilityDeclaration()
          {
            return
          }

          matchSearch: for match in node.scalars.matches(for: obsolete.scalars) {
            let resolvedRange = range()
            let startOffset = node.scalars.distance(
              from: node.scalars.startIndex,
              to: match.range.lowerBound
            )
            let length = node.scalars.distance(
              from: match.range.lowerBound,
              to: match.range.upperBound
            )
            let lowerBound = file.contents.scalars.index(
              resolvedRange.lowerBound,
              offsetBy: startOffset
            )
            let upperBound = file.contents.scalars.index(lowerBound, offsetBy: length)

            if allowInToolsVersion {
              if file.fileType == .swiftPackageManifest,
                let endOfFirstLine = file.contents.lines.first?.line.endIndex,
                endOfFirstLine ≥ upperBound
              {
                continue matchSearch
              }
            }
            reportViolation(
              in: file,
              at: lowerBound..<upperBound,
              replacementSuggestion: replacement,
              message:
                UserFacing<StrictString, InterfaceLocalization>({ localization in
                  let obsoleteMessage = UserFacing<StrictString, InterfaceLocalization>(
                    { localization in
                      let error: StrictString
                      switch String(match.contents) {
                      case "\u{2D}":
                        error = "U+002D"
                      case "\u{22}":
                        error = "U+0022"
                      case "\u{27}":
                        error = "U+0027"
                      default:
                        error = "“\(StrictString(match.contents))”"
                      }
                      switch localization {
                      case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                        if match.contents.count == 1 {
                          return "The character " + error + " is obsolete."
                        } else {
                          return "The character sequence " + error + " is obsolete."
                        }
                      case .deutschDeutschland:
                        if match.contents.count == 1 {
                          return "Das Schriftzeichen " + error + " ist überholt."
                        } else {
                          return "Die Schriftzeichenfolge " + error + " ist überholt."
                        }
                      }
                    })

                  let aliasMessage = UserFacing<StrictString, InterfaceLocalization>({
                    localization in
                    switch localization {
                    case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                      return "(Create an alias if necessary.)"
                    case .deutschDeutschland:
                      return "(Wenn nötig, ein Alias erstellen.)"
                    }
                  })

                  var result =
                    obsoleteMessage.resolved(for: localization) + " "
                    + message.resolved(for: localization)
                  if textFreedom == .aliasable {
                    result += " " + aliasMessage.resolved(for: localization)
                  }
                  return result
                }),
              status: status
            )
          }
        }

        check(
          for: "\u{2D}",
          allowInFloatLiteral: true,
          allowInToolsVersion: true,
          message: UserFacing<StrictString, InterfaceLocalization>({ localization in
            switch localization {
            // Note to localizers: Adapt the recommendations for the target localization.
            case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
              return
                "Use a hyphen (‐), minus sign (−), dash (—), bullet (•) or range symbol (–)."
            case .deutschDeutschland:
              return
                "Einen Bindestrich (‐), Minuszeichen (−), Gedankenstrich (–) oder Aufzählungszeichen (•) verwenden."
            }
          }),
          status: status,
          output: output
        )

        check(
          for: "\u{22}",
          message: UserFacing<StrictString, InterfaceLocalization>({ localization in
            switch localization {
            // Note to localizers: Adapt the recommendations for the target localization.
            case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
              return "Use quotation marks (“, ”) or double prime (′′)."
            case .deutschDeutschland:
              return "Anführungszeichen („, “) oder Doppelprime (′′) verwenden."
            }
          }),
          status: status,
          output: output
        )

        check(
          for: "\u{27}",
          message: UserFacing<StrictString, InterfaceLocalization>({ localization in
            switch localization {
            // Note to localizers: Adapt the recommendations for the target localization.
            case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
              return
                "Use an apostrophe (’), quotation marks (‘, ’), degrees (°) or prime (′)."
            case .deutschDeutschland:
              return
                "Einen Apostrophe (’), Anführungs‐ (‚, ‘), Grad‐ (°) oder Prime‐Zeichen (′) verwenden."
            }
          }),
          status: status,
          output: output
        )

        check(
          for: "\u{21}\u{3D}",
          replacement: "≠",
          message: UserFacing<StrictString, InterfaceLocalization>({ localization in
            switch localization {
            case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
              return "Use the not equal sign (≠)."
            case .deutschDeutschland:
              return "Ein Ungleichheitszeichen (≠) verwenden."
            }
          }),
          status: status,
          output: output
        )

        check(
          for: "!",
          replacement: "¬",
          onlyProhibitPrefixUse: true,
          allowAsConditionalCompilationOperator: true,
          message: UserFacing<StrictString, InterfaceLocalization>({ localization in
            switch localization {
            case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
              return "Use the not sign (¬)."
            case .deutschDeutschland:
              return "Ein Negationszeichen (¬) verwenden."
            }
          }),
          status: status,
          output: output
        )

        check(
          for: "&\u{26}",
          replacement: "∧",
          allowAsConditionalCompilationOperator: true,
          message: UserFacing<StrictString, InterfaceLocalization>({ localization in
            switch localization {
            case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
              return "Use the conjunction sign (∧)."
            case .deutschDeutschland:
              return "Ein Konjunktionszeichen (∧) verwenden."
            }
          }),
          status: status,
          output: output
        )

        check(
          for: "\u{7C}|",
          replacement: "∨",
          allowAsConditionalCompilationOperator: true,
          message: UserFacing<StrictString, InterfaceLocalization>({ localization in
            switch localization {
            case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
              return "Use the disjunction sign (∨)."
            case .deutschDeutschland:
              return "Ein Disjunktionszeichen (∨) verwenden."
            }
          }),
          status: status,
          output: output
        )

        check(
          for: "\u{3C}=",
          replacement: "≤",
          allowAsConditionalCompilationOperator: true,
          message: UserFacing<StrictString, InterfaceLocalization>({ localization in
            switch localization {
            case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
              return "Use the less‐than‐or‐equal sign (≤)."
            case .deutschDeutschland:
              return "Ein kleiner‐als‐oder‐gleich‐Zeichen (≤) verwenden."
            }
          }),
          status: status,
          output: output
        )

        check(
          for: "\u{3E}=",
          replacement: "≥",
          allowAsConditionalCompilationOperator: true,
          message: UserFacing<StrictString, InterfaceLocalization>({ localization in
            switch localization {
            case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
              return "Use the greater‐than‐or‐equal sign (≥)."
            case .deutschDeutschland:
              return "Ein größer‐als‐oder‐gleich‐Zeichen (≥) verwenden."
            }
          }),
          status: status,
          output: output
        )

        check(
          for: "\u{2A}",
          replacement: "×",
          onlyProhibitInfixUse: true,
          allowInAvailabilityDeclaration: true,
          message: UserFacing<StrictString, InterfaceLocalization>({ localization in
            switch localization {
            case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
              return "Use the multiplication sign (×)."
            case .deutschDeutschland:
              return "Ein Malzeichen (⋅) verwenden."
            }
          }),
          status: status,
          output: output
        )

        check(
          for: "\u{2A}=",
          replacement: "×=",
          message: UserFacing<StrictString, InterfaceLocalization>({ localization in
            switch localization {
            case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
              return "Use the multiplication sign (×)."
            case .deutschDeutschland:
              return "Ein Malzeichen (⋅) verwenden."
            }
          }),
          status: status,
          output: output
        )

        check(
          for: "\u{2F}",
          replacement: "÷",
          onlyProhibitInfixUse: true,
          message: UserFacing<StrictString, InterfaceLocalization>({ localization in
            switch localization {
            case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
              return "Use the division sign (÷)."
            case .deutschDeutschland:
              return "Ein Geteiltzeichen (∶) verwenden."
            }
          }),
          status: status,
          output: output
        )

        check(
          for: "\u{2F}=",
          replacement: "÷=",
          message: UserFacing<StrictString, InterfaceLocalization>({ localization in
            switch localization {
            case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
              return "Use the division sign (÷)."
            case .deutschDeutschland:
              return "Ein Geteiltzeichen (∶) verwenden."
            }
          }),
          status: status,
          output: output
        )
      }
    #endif
  }
#endif
