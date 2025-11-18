import SwiftSyntax
#if canImport(SwiftSyntaxBuilder)
import SwiftSyntaxBuilder
#endif


// MARK: - switch (stmt + expression via IIFE) and patterns

public enum qswitch {
  
  /// case patternList: { body }
  @inlinable @inline(__always)
  public static func `case`(_ patterns: PatternSyntax...,
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

  /// default: { body }
  @inlinable @inline(__always)
  public static func `default`(@qstmts _ body: () -> [CodeBlockItemSyntax]) -> SwitchCaseSyntax {
    SwitchCaseSyntax(
      label: .default( SwitchDefaultLabelSyntax(defaultKeyword: .keyword(.default), colon: .colonToken()) ),
      statements:
        CodeBlockItemListSyntax(body()).with(\.leadingTrivia, .space)
    )
  }

  /// switch statement
  @inlinable @inline(__always)
  public static func expr(_ subject: ExprSyntax,
                          @qcases _ makeCases: () -> [SwitchCaseSyntax]) -> ExprSyntax {
    ExprSyntax(
      SwitchExprSyntax(
        switchKeyword: .keyword(.switch),
        subject: subject.with(\.leadingTrivia, .space).with(\.trailingTrivia, .space),
        leftBrace: .leftBraceToken(),
        cases: SwitchCaseListSyntax(makeCases().map { .switchCase($0) }),
        rightBrace: .rightBraceToken()
      )
    )
  }
}


public enum qpat {
  
  /// identifier pattern: `someName`
  @inlinable @inline(__always)
  public static func id(_ name: String) -> PatternSyntax {
    PatternSyntax( IdentifierPatternSyntax(identifier: q.tok.id(name)) )
  }

  /// wildcard pattern: `_`
  public static let wildcard = PatternSyntax( WildcardPatternSyntax(wildcard: _wildcard) )

  /// enum case (no associated values): `.caseName`
  @inlinable @inline(__always)
  public static func enumCase(_ caseName: String) -> PatternSyntax {
    enumCase(q.tok.id(caseName))
  }

  @inlinable @inline(__always)
  public static func enumCase(_ caseName: TokenSyntax) -> PatternSyntax {
    PatternSyntax( ExpressionPatternSyntax(expression: q.e.dot(caseName)) )
  }

  @inlinable @inline(__always)
  public static func enumCase(_ expr: ExprSyntax) -> PatternSyntax {
    PatternSyntax( ExpressionPatternSyntax(expression: expr) )
  }

  @inlinable @inline(__always)
  public static func `let`(_ expr: ExprSyntax) -> PatternSyntax {
    PatternSyntax(
      ValueBindingPatternSyntax(
        bindingSpecifier: .keyword(.let, trailingTrivia: .space),
        pattern: ExpressionPatternSyntax(expression: expr)
      )
    )
  }
  // Note: for associated values, compose a TuplePatternSyntax around subpatterns.
}


/// switch statement
@inlinable @inline(__always)
public func _switch(_ subject: ExprSyntax,
                    @qcases _ makeCases: () -> [SwitchCaseSyntax]) -> ExprSyntax {
  qswitch.expr(subject, makeCases)
}
