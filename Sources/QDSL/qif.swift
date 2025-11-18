import SwiftSyntax
#if canImport(SwiftSyntaxBuilder)
import SwiftSyntaxBuilder
#endif


public enum qif {

  /// case patternList: { body }
  @inlinable @inline(__always)
  public static func `case`(_ patterns: [PatternSyntax],
                            @qstmts then body: () -> [CodeBlockItemSyntax]) -> SwitchCaseSyntax {
    SwitchCaseSyntax(
      label: .case(
        SwitchCaseLabelSyntax(
          caseKeyword: .keyword(.case),
          caseItems: SwitchCaseItemListSyntax(
            patterns.enumerated().map { i, p in
              SwitchCaseItemSyntax(
                pattern: p,
                trailingComma: i < patterns.count - 1 ? .commaToken(trailingTrivia: .space) : nil
              )
            }
          ).with(\.leadingTrivia, .space),
          colon: .colonToken()
        )
      ),
      statements: CodeBlockItemListSyntax(body()).with(\.leadingTrivia, .space)
    )
  }

  /// case patternList: { body }
  @inlinable @inline(__always)
  public static func `case`(_ patterns: PatternSyntax...,
                            @qstmts then body: () -> [CodeBlockItemSyntax]) -> SwitchCaseSyntax {
    self.case(patterns, then: body)
  }

  /// default: { body }
  @inlinable @inline(__always)
  public static func `default`(@qstmts _ body: () -> [CodeBlockItemSyntax]) -> SwitchCaseSyntax {
    SwitchCaseSyntax(
      label: .default( SwitchDefaultLabelSyntax(defaultKeyword: .keyword(.default), colon: .colonToken()) ),
      statements:
        CodeBlockItemListSyntax(body()).with(\.leadingTrivia, .space)
    )
  }

  @inlinable @inline(__always)
  public static func expr(_ condition: [ConditionElementSyntax],
                          @qstmts makeBody: () -> [CodeBlockItemSyntax]) -> ExprSyntax {
    ExprSyntax(
      IfExprSyntax(
        conditions: .init(condition),
        body: qbody(makeBody)
      )
    )
  }

  @inlinable @inline(__always)
  public static func expr(_ condition: ConditionElementSyntax...,
                          @qstmts makeBody: () -> [CodeBlockItemSyntax]) -> ExprSyntax {
    expr(condition, makeBody: makeBody)
  }

  @inlinable @inline(__always)
  public static func guardStmt(_ condition: ConditionElementListSyntax,
                               @qstmts makeBody: () -> [CodeBlockItemSyntax]) -> StmtSyntax {
    StmtSyntax(
      GuardStmtSyntax(
        guardKeyword: .keyword(.guard, trailingTrivia: .space),
        conditions: condition,
        elseKeyword: .keyword(.else, leadingTrivia: .newline, trailingTrivia: .space),
        body: qbody(makeBody),
        trailingTrivia: .newline
      )
    )
  }
}


extension q {

  /// `if let ...` statement
  @inlinable @inline(__always)
  public static func ifLet(_ name: String,
                           _ value: ExprSyntax? = nil,
                           @qstmts makeBody: () -> [CodeBlockItemSyntax]) -> ExprSyntax {
    qif.expr(
      q.condition.letBind(name, value),
      makeBody: makeBody
    )
  }

  /// `if let ...` statement
  @inlinable @inline(__always)
  public static func ifLet(_ name: TokenSyntax,
                           _ value: ExprSyntax? = nil,
                           @qstmts makeBody: () -> [CodeBlockItemSyntax]) -> ExprSyntax {
    qif.expr(
      q.condition.letBind(name, value),
      makeBody: makeBody
    )
  }
}

/// `if let ...` statement
@inlinable @inline(__always)
public func _ifLet(_ name: String,
                   _ value: ExprSyntax? = nil,
                   @qstmts makeBody: () -> [CodeBlockItemSyntax]) -> ExprSyntax {
  q.ifLet(name, value, makeBody: makeBody)
}

/// `if let ...` statement
@inlinable @inline(__always)
public func _ifLet(_ name: TokenSyntax,
                   _ value: ExprSyntax? = nil,
                   @qstmts makeBody: () -> [CodeBlockItemSyntax]) -> ExprSyntax {
  q.ifLet(name, value, makeBody: makeBody)
}



@inlinable @inline(__always)
public func _if(_ condition: ConditionElementSyntax...,
                @qstmts makeBody: () -> [CodeBlockItemSyntax]) -> ExprSyntax {
  qif.expr(condition, makeBody: makeBody)
}



/// case patternList: { body }
@inlinable @inline(__always)
public func _case(_ patterns: PatternSyntax...,
                  @qstmts then body: () -> [CodeBlockItemSyntax]) -> SwitchCaseSyntax {
  qif.case(patterns, then: body)
}


/// default: { body }
@inlinable @inline(__always)
public func _default(@qstmts _ body: () -> [CodeBlockItemSyntax]) -> SwitchCaseSyntax {
  qif.default(body)
}


@inlinable @inline(__always)
public func _guard(_ condition: ConditionElementListSyntax,
                   @qstmts makeBody: () -> [CodeBlockItemSyntax]) -> StmtSyntax {
  qif.guardStmt(condition, makeBody: makeBody)
}


@inlinable @inline(__always)
public func _conditions(_ exprs: ExprSyntax...) -> ConditionElementListSyntax {
  .init(
    exprs.enumerated().map { index, expr in
        .init(
          condition: .expression(expr),
          trailingComma: exprs.trailingComma(forIndex: index)
        )
    }
  )
}
