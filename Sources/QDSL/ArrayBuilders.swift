import SwiftSyntax
#if canImport(SwiftSyntaxBuilder)
import SwiftSyntaxBuilder
#endif


// MARK: - Statement builders

@resultBuilder
public struct qarray_elements {

  @inlinable @inline(__always)
  public static func element(_ value: some ExprSyntaxProtocol) -> ArrayElementSyntax {
    .init(expression: value)
  }

  // collect: flatten nested arrays coming from subexpressions/branches
  @inlinable @inline(__always)
  public static func buildBlock(_ parts: [ArrayElementSyntax]...) -> [ArrayElementSyntax] {
    parts.flatMap { $0 }
  }

  // allow expressions as statements
  @inlinable @inline(__always)
  public static func buildExpression(_ element: ArrayElementSyntax) -> [ArrayElementSyntax] {
    [element]
  }

  @inlinable @inline(__always)
  public static func buildExpression<E: ExprSyntaxProtocol>(_ e: E) -> [ArrayElementSyntax] {
    [.init(expression: e)]
  }

  // control-flow sugar so `if`/`guard`/`for` inside builders just work
  @inlinable @inline(__always)
  public static func buildOptional(_ c: [ArrayElementSyntax]?) -> [ArrayElementSyntax] { c ?? [] }

  @inlinable @inline(__always)
  public static func buildEither(first c: [ArrayElementSyntax]) -> [ArrayElementSyntax] { c }

  @inlinable @inline(__always)
  public static func buildEither(second c: [ArrayElementSyntax]) -> [ArrayElementSyntax] { c }

  @inlinable @inline(__always)
  public static func buildArray(_ chunks: [[ArrayElementSyntax]]) -> [ArrayElementSyntax] {
    chunks.flatMap { $0 }
  }

  @inlinable @inline(__always)
  public static func buildFinalResult(_ components: [ArrayElementSyntax]) -> [ArrayElementSyntax] {
    components.enumerated().map { index, element in
      element
        .with(\.leadingTrivia, .newline)
        .with(\.trailingComma, components.trailingComma(forIndex: index))
        .with(\.trailingTrivia, index == components.count - 1 ? .newline : .space)
    }
  }

  // availability branches
  @inlinable @inline(__always)
  public static func buildLimitedAvailability(_ c: [ArrayElementSyntax]) -> [ArrayElementSyntax] { c }
}
