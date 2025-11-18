import SwiftSyntax
#if canImport(SwiftSyntaxBuilder)
import SwiftSyntaxBuilder
#endif


// MARK: - Fluent .call(...) (unlabeled or labeled), plus trailing-closure variants

public extension ExprSyntax {

  /// `callee(arg1, arg2, ...)`
  @inlinable @inline(__always)
  func call(_ exprs: ExprSyntax...) -> ExprSyntax {
    call(exprs.map { qarg($0) })
  }

  /// `callee("label" <- arg, ...)`
  @inlinable @inline(__always)
  func call(_ args: LabeledExprSyntax...) -> ExprSyntax {
    ExprSyntax(
      FunctionCallExprSyntax(
        calledExpression: self,
        leftParen: .leftParenToken(),
        arguments: LabeledExprListSyntax(
          args.enumerated().map { index, arg in
            arg.with(\.trailingComma, args.trailingComma(forIndex: index))
          }
        ),
        rightParen: .rightParenToken()
      )
    )
  }

  @inlinable @inline(__always)
  func call(_ args: [LabeledExprSyntax]) -> ExprSyntax {
    ExprSyntax(
      FunctionCallExprSyntax(
        calledExpression: self,
        leftParen: .leftParenToken(),
        arguments: LabeledExprListSyntax(
          args.enumerated().map { index, arg in
            arg.with(\.trailingComma, args.trailingComma(forIndex: index))
          }
        ),
        rightParen: .rightParenToken()
      )
    )
  }

  /// `callee { ... }` (no args, trailing closure)
  @inlinable @inline(__always)
  func call(trailingClosure: ClosureExprSyntax) -> ExprSyntax {
    ExprSyntax(
      FunctionCallExprSyntax(
        calledExpression: self,
        leftParen: nil,
        arguments: LabeledExprListSyntax([]),
        rightParen: nil,
        trailingClosure: trailingClosure
      )
    )
  }

  /// `callee(args...) { ... }`
  @inlinable @inline(__always)
  func call(_ args: [LabeledExprSyntax],
            trailingClosure: ClosureExprSyntax) -> ExprSyntax {
    ExprSyntax(
      FunctionCallExprSyntax(
        calledExpression: self,
        leftParen: .leftParenToken(),
        arguments: LabeledExprListSyntax(
          args.enumerated().map { index, arg in
            arg.with(\.trailingComma, args.trailingComma(forIndex: index))
          }
        ),
        rightParen: .rightParenToken(),
        trailingClosure: trailingClosure.with(\.leadingTrivia, .space)
      )
    )
  }

  // Disambiguate empty calls like `.getFirstName()`
  @inlinable @inline(__always)
  func call() -> ExprSyntax {
    ExprSyntax(
      FunctionCallExprSyntax(
        calledExpression: self,
        leftParen: .leftParenToken(),
        arguments: LabeledExprListSyntax([]),
        rightParen: .rightParenToken()
      )
    )
  }
}


extension ExprSyntax {

  /// `callee(arg1, arg2, ...)`
  public func dot(_ name: String) -> ExprSyntax {
    dot(_token(name))
  }

  /// `callee(arg1, arg2, ...)`
  public func dot(_ name: TokenSyntax) -> ExprSyntax {
    ExprSyntax(
      MemberAccessExprSyntax(
        base: self,
        period: .periodToken(),
        declName: DeclReferenceExprSyntax(baseName: name)
      )
    )
  }

  @inlinable @inline(__always)
  public func dotOptional(_ name: String) -> ExprSyntax {
    dotOptional(_token(name))
  }

  @inlinable @inline(__always)
  public func dotOptional(_ name: TokenSyntax) -> ExprSyntax {
    ExprSyntax(
      MemberAccessExprSyntax(
        base: self,
        period: .postfixQuestionMarkToken(),
        declName: DeclReferenceExprSyntax(baseName: name)
      )
    )
  }

  @inlinable @inline(__always)
  public var asForceTry: ExprSyntax {
    q.e.forceTry(self)
  }

  @inlinable @inline(__always)
  public func asForceTry(if condition: Bool) -> ExprSyntax {
    condition ? asForceTry : self
  }

  @inlinable @inline(__always)
  public var asForceUnwrapped: ExprSyntax {
    q.e.forceUnwrap(self)
  }

  @inlinable @inline(__always)
  public func asForceUnwrapped(if condition: Bool) -> ExprSyntax {
    condition ? asForceUnwrapped : self
  }

  @inlinable @inline(__always)
  public var asOptionalTry: ExprSyntax {
    q.e.optionalTry(self)
  }

  @inlinable @inline(__always)
  public func asTry(questionOrExclamationMark: TokenSyntax? = nil) -> ExprSyntax {
    q.e.try(questionOrExclamationMark: questionOrExclamationMark, self)
  }
}


public extension ExprSyntax {

  /// array[expr1, expr2, ...]
  @inlinable @inline(__always)
  func `subscript`(_ exprs: ExprSyntax...) -> ExprSyntax {
    ExprSyntax(
      SubscriptCallExprSyntax(
        calledExpression: self,
        leftSquare: .leftSquareToken(),
        arguments: LabeledExprListSyntax(exprs.map { qarg($0) }),
        rightSquare: .rightSquareToken()
      )
    )
  }

  /// dict[key: expr]
  @inlinable @inline(__always)
  func `subscript`(_ args: LabeledExprSyntax...) -> ExprSyntax {
    ExprSyntax(
      SubscriptCallExprSyntax(
        calledExpression: self,
        leftSquare: .leftSquareToken(),
        arguments: LabeledExprListSyntax(args),
        rightSquare: .rightSquareToken()
      )
    )
  }
}
