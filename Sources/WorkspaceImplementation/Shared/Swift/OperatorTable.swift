/*
 OperatorTable.swift

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

  import SwiftOperators
  import SwiftParser

  extension OperatorTable {

    internal static let baseOperators: OperatorTable = {
      var table = OperatorTable.standardOperators
      for entry in [

        // SDGCornerstone → SDGLogic
        "infix operator ≠: ComparisonPrecedence",
        "prefix operator ¬",
        "infix operator ∧: LogicalConjunctionPrecedence",
        "infix operator ∧=: AssignmentPrecedence",
        "infix operator ∨: LogicalDisjunctionPrecedence",
        "infix operator ∨=: AssignmentPrecedence",

        // SDGCornerstone → SDGMathematics
        "precedencegroup ExponentPrecedence { associativity: right higherThan: MultiplicationPrecedence }",
        "infix operator ≤: ComparisonPrecedence",
        "infix operator ≥: ComparisonPrecedence",
        "infix operator ≈: ComparisonPrecedence",
        "infix operator −: AdditionPrecedence",
        "prefix operator −",
        "infix operator −=: AssignmentPrecedence",
        "infix operator ±: AdditionPrecedence",
        "prefix operator |",
        "postfix operator |",
        "prefix operator ∑",
        "infix operator ×: MultiplicationPrecedence",
        "infix operator ×=: AssignmentPrecedence",
        "infix operator ÷: MultiplicationPrecedence",
        "infix operator ÷=: AssignmentPrecedence",
        "prefix operator ∏",
        "infix operator ↑: ExponentPrecedence",
        "infix operator ↑=: AssignmentPrecedence",
        "prefix operator √",
        "postfix operator √=",
        "postfix operator °",
        "postfix operator ′",
        "postfix operator ′′",

        // SDGCornerstone → SDGCollections
        "precedencegroup BinarySetOperationPrecedence { lowerThan: RangeFormationPrecedence higherThan: ComparisonPrecedence }",
        "infix operator ∈: ComparisonPrecedence",
        "infix operator ∉: ComparisonPrecedence",
        "infix operator ∋: ComparisonPrecedence",
        "infix operator ∌: ComparisonPrecedence",
        "infix operator ∩: BinarySetOperationPrecedence",
        "infix operator ∩=: AssignmentPrecedence",
        "infix operator ∪: BinarySetOperationPrecedence",
        "infix operator ∪=: AssignmentPrecedence",
        "postfix operator ′=",
        "infix operator ∖: BinarySetOperationPrecedence",
        "infix operator ∖=: AssignmentPrecedence",
        "infix operator ∆: BinarySetOperationPrecedence",
        "infix operator ∆=: AssignmentPrecedence",
        "infix operator ⊆: ComparisonPrecedence",
        "infix operator ⊈: ComparisonPrecedence",
        "infix operator ⊇: ComparisonPrecedence",
        "infix operator ⊉: ComparisonPrecedence",
        "infix operator ⊊: ComparisonPrecedence",
        "infix operator ⊋: ComparisonPrecedence",

        // SDGCornerstone → SDGCollation
        "precedencegroup TailoringRuleAnchoredToPreceding { associativity: left }",
        "precedencegroup TailoringRuleAnchoredToFollowing { associativity: right }",
        "infix operator ←=: TailoringRuleAnchoredToPreceding",
        "infix operator =→: TailoringRuleAnchoredToFollowing",
        "infix operator ←<: TailoringRuleAnchoredToPreceding",
        "infix operator <→: TailoringRuleAnchoredToFollowing",
        "infix operator ←<<: TailoringRuleAnchoredToPreceding",
        "infix operator <<→: TailoringRuleAnchoredToFollowing",
        "infix operator ←<<<: TailoringRuleAnchoredToPreceding",
        "infix operator <<<→: TailoringRuleAnchoredToFollowing",
        "infix operator ←<<<<: TailoringRuleAnchoredToPreceding",
        "infix operator <<<<→: TailoringRuleAnchoredToFollowing",
        "infix operator ←<<<<<: TailoringRuleAnchoredToPreceding",
        "infix operator <<<<<→: TailoringRuleAnchoredToFollowing",
        "infix operator ←<<<<<<: TailoringRuleAnchoredToPreceding",
        "infix operator <<<<<<→: TailoringRuleAnchoredToFollowing",

      ] as [String] {
        let source = Parser.parse(source: entry)
        try! table.addSourceFile(source)
      }
      return table
    }()
  }
#endif
