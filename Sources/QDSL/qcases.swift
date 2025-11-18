import SwiftSyntax
#if canImport(SwiftSyntaxBuilder)
import SwiftSyntaxBuilder
#endif


// MARK: - Switch case builder (so cases live inside braces)

@resultBuilder
public struct qcases {

  @inlinable @inline(__always)
  public static func buildBlock(_ parts: [SwitchCaseSyntax]...) -> [SwitchCaseSyntax] {
    parts.flatMap { $0 }
  }

  @inlinable @inline(__always)
  public static func buildExpression(_ c: SwitchCaseSyntax) -> [SwitchCaseSyntax] { [c] }

  // control-flow support inside the builder
  @inlinable @inline(__always)
  public static func buildOptional(_ c: [SwitchCaseSyntax]?) -> [SwitchCaseSyntax] { c ?? [] }

  @inlinable @inline(__always)
  public static func buildEither(first c: [SwitchCaseSyntax]) -> [SwitchCaseSyntax] { c }

  @inlinable @inline(__always)
  public static func buildEither(second c: [SwitchCaseSyntax]) -> [SwitchCaseSyntax] { c }

  @inlinable @inline(__always)
  public static func buildArray(_ chunks: [[SwitchCaseSyntax]]) -> [SwitchCaseSyntax] {
    chunks.flatMap { $0 }
  }

  @inlinable @inline(__always)
  public static func buildFinalResult(_ components: [SwitchCaseSyntax]) -> [SwitchCaseSyntax] {
    components.enumerated().map { index, component in
      component
        .with(\.leadingTrivia, .newline)
        .with(\.trailingTrivia, index == components.count - 1 ? .newline : .space)
    }
  }
}
