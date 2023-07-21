/*
 ParameterDocumentation.swift

 This source file is part of the Workspace open source project.
 Diese Quelldatei ist Teil des quelloffenen Arbeitsbereich‐Projekt.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2023 Jeremy David Giesbrecht and the Workspace project contributors.
 Urheberrecht ©2023 Jeremy David Giesbrecht und die Mitwirkenden des Arbeitsbereich‐Projekts.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

#if !PLATFORM_NOT_SUPPORTED_BY_WORKSPACE_WORKSPACE

import SDGLogic
import SDGText
import SDGLocalization

import SDGCommandLine

import SDGSwift
import SDGSwiftSource
import SwiftSyntax

import WorkspaceLocalizations

internal struct ParameterDocumentation: SyntaxRule {

  internal static let identifier = UserFacing<StrictString, InterfaceLocalization>(
    { localization in
      switch localization {
      case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
        return "parameterDocumentation"
      case .deutschDeutschland:
        return "übergabewertDokumentation"
      }
    })

  private static func message(parameter: String) -> UserFacing<StrictString, InterfaceLocalization> {
    return UserFacing({ localization in
      switch localization {
      case .englishUnitedKingdom:
        return "No parameter named ‘\(parameter)’ exists."
      case .englishUnitedStates, .englishCanada:
        return "No parameter named “\(parameter)” exists."
      case .deutschDeutschland:
        return "Kein Übergabewert namens „\(parameter)“ existiert."
      }
    })
  }

  internal static func check(
    _ node: SyntaxNode,
    context: ScanContext,
    file: TextFile,
    setting: Setting,
    project: PackageRepository,
    status: ProofreadingStatus,
    output: Command.Output
  ) {
    if let token = node as? Token,
      case .calloutParameter(let documentedName) = token.kind,
      let syntaxToken = context.globalAncestors.lazy.compactMap({ $0.node as? SwiftSyntaxNode }).last?.swiftSyntaxNode {

      var parameters: ParameterClauseSyntax?
      search: for ancestor in syntaxToken.ancestors {
        switch ancestor.kind {
        case .token, .attributeList, .attribute, .customAttribute, .declModifier, .ifConfigClause, .ifConfigClauseList, .ifConfigDecl, .modifierList:
          // May be start of larger relevant node
          continue search
        case .accessLevelModifier, .accessPathComponent, .accessPath, .accessorBlock, .accessorDecl, .accessorList, .accessorParameter, .arrayElementList, .arrayElement, .arrayExpr, .arrayType, .arrowExpr, .asExpr, .asTypePattern, .assignmentExpr, .attributedType, .availabilityArgument, .availabilityCondition, .availabilityEntry, .availabilityLabeledArgument, .availabilitySpecList, .availabilityVersionRestriction, .awaitExpr, .backDeployVersionArgument, .backDeployVersionList, .backDeployedAttributeSpecList, .binaryOperatorExpr, .booleanLiteralExpr, .breakStmt, .caseItemList, .caseItem, .catchClauseList, .catchClause, .catchItemList, .catchItem, .classRestrictionType, .closureCaptureItemList, .closureCaptureItem, .closureCaptureSignature, .closureExpr, .closureParamList, .closureParam, .closureSignature, .codeBlockItemList, .codeBlockItem, .codeBlock, .compositionTypeElementList, .compositionTypeElement, .compositionType, .conditionElementList, .conditionElement, .conformanceRequirement, .constrainedSugarType, .continueStmt, .conventionAttributeArguments, .conventionWitnessMethodAttributeArguments, .declModifierDetail, .declNameArgumentList, .declNameArgument, .declNameArguments, .declName, .declarationStmt, .deferStmt, .derivativeRegistrationAttributeArguments, .designatedTypeElement, .designatedTypeList, .dictionaryElementList, .dictionaryElement, .dictionaryExpr, .dictionaryType, .differentiabilityParamList, .differentiabilityParam, .differentiabilityParamsClause, .differentiabilityParams, .differentiableAttributeArguments, .discardAssignmentExpr, .doStmt, .editorPlaceholderExpr, .enumCaseElementList, .enumCaseElement, .enumCasePattern, .exprList, .expressionPattern, .expressionSegment, .expressionStmt, .fallthroughStmt, .floatLiteralExpr, .forInStmt, .forcedValueExpr, .functionCallExpr, .functionDeclName, .functionParameterList, .functionParameter, .functionSignature, .functionType, .genericArgumentClause, .genericArgumentList, .genericArgument, .genericParameterClause, .genericParameterList, .genericParameter, .genericRequirementList, .genericRequirement, .genericWhereClause, .guardStmt, .hasSymbolCondition, .identifierExpr, .identifierPattern, .ifStmt, .implementsAttributeArguments, .implicitlyUnwrappedOptionalType, .importDecl, .inOutExpr, .infixOperatorExpr, .inheritedTypeList, .inheritedType, .initializerClause, .integerLiteralExpr, .isExpr, .isTypePattern, .keyPathComponentList, .keyPathComponent, .keyPathExpr, .keyPathOptionalComponent, .keyPathPropertyComponent, .keyPathSubscriptComponent, .labeledSpecializeEntry, .labeledStmt, .layoutRequirement, .macroExpansionDecl, .macroExpansionExpr, .matchingPatternCondition, .memberAccessExpr, .memberDeclBlock, .memberDeclListItem, .memberDeclList, .memberTypeIdentifier, .metatypeType, .missingDecl, .missingExpr, .missingPattern, .missingStmt, .missing, .missingType, .moveExpr, .multipleTrailingClosureElementList, .multipleTrailingClosureElement, .namedAttributeStringArgument, .namedOpaqueReturnType, .nilLiteralExpr, .nonEmptyTokenList, .objCSelectorPiece, .objCSelector, .opaqueReturnTypeOfAttributeArguments, .operatorPrecedenceAndTypes, .optionalBindingCondition, .optionalChainingExpr, .optionalPattern, .optionalType, .packElementExpr, .packExpansionType, .packReferenceType, .parameterClause, .patternBindingList, .patternBinding, .postfixIfConfigExpr, .postfixUnaryExpr, .poundAssertStmt, .poundColumnExpr, .poundErrorDecl, .poundSourceLocationArgs, .poundSourceLocation, .poundWarningDecl, .precedenceGroupAssignment, .precedenceGroupAssociativity, .precedenceGroupAttributeList, .precedenceGroupNameElement, .precedenceGroupNameList, .precedenceGroupRelation, .prefixOperatorExpr, .primaryAssociatedTypeClause, .primaryAssociatedTypeList, .primaryAssociatedType, .qualifiedDeclName, .regexLiteralExpr, .repeatWhileStmt, .returnClause, .returnStmt, .sameTypeRequirement, .sequenceExpr, .simpleTypeIdentifier, .sourceFile, .specializeAttributeSpecList, .specializeExpr, .stringLiteralExpr, .stringLiteralSegments, .stringSegment, .subscriptExpr, .superRefExpr, .switchCaseLabel, .switchCaseList, .switchCase, .switchDefaultLabel, .switchStmt, .symbolicReferenceExpr, .targetFunctionEntry, .ternaryExpr, .throwStmt, .tokenList, .tryExpr, .tupleExprElementList, .tupleExprElement, .tupleExpr, .tuplePatternElementList, .tuplePatternElement, .tuplePattern, .tupleTypeElementList, .tupleTypeElement, .tupleType, .typeAnnotation, .typeExpr, .typeInheritanceClause, .typeInitializerClause, .unavailabilityCondition, .unexpectedNodes, .unresolvedAsExpr, .unresolvedIsExpr, .unresolvedPatternExpr, .unresolvedTernaryExpr, .valueBindingPattern, .versionTuple, .whereClause, .whileStmt, .wildcardPattern, .yieldExprListElement, .yieldExprList, .yieldList, .yieldStmt:
          // Missed relevant declaration and zoomed out too far
          return
        case .actorDecl, .associatedtypeDecl, .classDecl, .deinitializerDecl, .enumCaseDecl, .enumDecl, .extensionDecl, .operatorDecl, .precedenceGroupDecl, .protocolDecl, .structDecl, .typealiasDecl, .variableDecl:
          parameters = nil
        case .functionDecl:
          if let function = ancestor.as(FunctionDeclSyntax.self) {
            parameters = function.signature.input
          }
        case .initializerDecl:
          if let initializer = ancestor.as(InitializerDeclSyntax.self) {
            parameters = initializer.signature.input
          }
        case .macroDecl:
          if let macro = ancestor.as(MacroDeclSyntax.self) {
            switch macro.signature {
            case .functionLike(let signature):
              parameters = signature.input
            case .valueLike: // TypeAnnotationSyntax
              parameters = nil
            }
          }
        case .subscriptDecl:
          if let `subscript` = ancestor.as(SubscriptDeclSyntax.self) {
            parameters = `subscript`.indices
          }
        }
        break search
      }

      let invalid: Bool
      if let parameters = parameters {
        invalid = ¬parameters.parameterList.contains(where: { parameter in
          return parameter.internalName?.text == documentedName
        })
      } else {
        invalid = true
      }

      if invalid {
        reportViolation(
          in: file,
          at: context.location,
          message: message(parameter: documentedName),
          status: status
        )
      }
    }
  }
}

#endif
